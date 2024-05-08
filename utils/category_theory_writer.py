from typing import Any 
import copy
import jinja2

from flamapy.core.transformations import ModelToText
from flamapy.metamodels.fm_metamodel.models import FeatureModel, Feature
from utils import utils


CATEGORY_THEORY_TEMPLATE = 'category_theory_template_config_attr.cql'
NUMERICAL_FEATURE_ATTRIBUTE = 'NF'
NUMERICAL_FEATURE_DOMAIN = 'Int'


class CategoryTheoryWriter(ModelToText):
    """Transform a feature model to a category theory (CT) formalization.
    
    CT is specified in a .cql file that is the input of the CT solver.
    """

    @staticmethod
    def get_destination_extension() -> str:
        return 'cql'

    def __init__(self, path: str, source_model: FeatureModel, configurations_attr: list = None) -> None:
        self.path = path
        self.source_model = source_model
        self.configurations_attr = configurations_attr

    def transform(self) -> str:
        ct_str = fm_to_categories(self.source_model, self.configurations_attr)
        with open(self.path, 'w', encoding='utf-8') as file:
            file.write(ct_str)
        return ct_str


def fm_to_categories(feature_model: FeatureModel, c_attr: list) -> str:
    template_loader = jinja2.FileSystemLoader(searchpath='./')
    environment = jinja2.Environment(loader=template_loader)
    template = environment.get_template(CATEGORY_THEORY_TEMPLATE)
    maps = get_maps(feature_model, c_attr)
    content = template.render(maps)
    return content


def get_maps(feature_model: FeatureModel, c_attr: list=None) -> dict[str, str]:
    result = {}
    all_features_map = get_all_features_map(feature_model)
    feature_attributes_map = get_features_attributes_map(feature_model)
    result['features_list'] = ' '.join([f['id'] for f in all_features_map])
    result['boolean_features_dict'] = [d for d in all_features_map if not utils.is_numerical_feature(feature_model.get_feature_by_name(d['name']))]
    result['numerical_features_dict'] = [d for d in all_features_map if utils.is_numerical_feature(feature_model.get_feature_by_name(d['name']))]
    result['feature_attributes_dict'] = feature_attributes_map
    if not c_attr is None:
        id_dictionary = id_dict(c_attr)

        qn_map = get_qn_map(id_dictionary)
        result['qn_list'] = ' '.join([qn['id'] for qn in qn_map])

        qv_map = get_qv_map(id_dictionary)
        result['qv_list'] = ' '.join([qv['id'] for qv in qv_map])

        qd_map = get_qd_map(id_dictionary)
        result['qd_list'] = ' '.join([qd['id'] for qd in qd_map])

        qs_map = get_qs_map(id_dictionary, qn_map, qv_map, qd_map)
        result['qs_list'] = ' '.join([qs['id'] for qs in qs_map])

        qas_map = get_qas_map(c_attr, qn_map, qv_map, qd_map, qs_map)
        result['qas_list'] = ' '.join([qa['qa_id'] for qa in qas_map])

        ccs_map = get_ccs_map(all_features_map, c_attr)
        result['ccs_list'] = ' '.join([cc['cc_id'] for cc in ccs_map])

        qmc_map = get_qmc_map(qas_map, ccs_map)
        result['qmc_list'] = ' '.join([qmc['id'] for qmc in qmc_map])
    
        result['cc_virutal_linkages_dict'] = ccs_map
        result['quality_names_dict'] = qn_map
        result['quality_domains_dict'] = qd_map
        result['quality_values_dict'] = qv_map
        result['qualities_dict'] = qs_map
        result['quality_attributes_dict'] = qas_map
        result['quality_model_dict'] = qmc_map
    return result


def get_all_features_map(feature_model: FeatureModel) -> list[dict[str, Any]]:
    result = []
    count = 1
    nf_count = 1
    features = [(feature_model.root, None)]
    while features:
        feature, parent = features.pop()
        if not utils.is_numerical_feature(feature):
            feature_id = f'f{count}'
            count += 1
            # Create dictionary for feature
            feature_dict = {}
            feature_dict['id'] = feature_id
            feature_dict['name'] = feature.name
            feature_dict['cardinality'] = get_cardinality(feature)
            feature_dict['optionality'] = str(feature.is_optional()).lower()
            feature_dict['parent'] = parent if parent is not None else feature_id
            feature_dict['attributes'] = [{'name': a.name, 'value': utils.return_value_str(a.get_default_value())} 
                                            for a in feature.get_attributes() 
                                            if a.name != NUMERICAL_FEATURE_ATTRIBUTE]
            feature_dict['domain'] = utils.CTAttributeType.BOOL.value
            result.append(feature_dict)
        else:
            # It is numerical feature
            for v in utils.get_numerical_values(feature):
                feature_id = f'nf{nf_count}'
                nf_count += 1
                # Create dictionary for feature
                feature_dict = {}
                feature_dict['id'] = feature_id
                feature_dict['name'] = feature.name
                feature_dict['cardinality'] = get_cardinality(feature)
                feature_dict['optionality'] = str(feature.is_optional()).lower()
                feature_dict['parent'] = parent if parent is not None else feature_id
                feature_dict['attributes'] = [{'name': a.name, 'value': utils.return_value_str(a.get_default_value())} 
                                                for a in feature.get_attributes() 
                                                if a.name != NUMERICAL_FEATURE_ATTRIBUTE]
                feature_dict['domain'] = utils.CTAttributeType.INT.value
                feature_dict['nf_value'] = v
                result.append(feature_dict)
        # Process children
        for child in feature.get_children():
            features.append((child, feature_id))
    return result


def get_features_attributes_map(feature_model: FeatureModel) -> list[dict[str, Any]]:
    features = [feature_model.root]
    attributes_dict = {}
    while features:
        feature = features.pop()
        for attr in feature.get_attributes():
            if attr.name != NUMERICAL_FEATURE_ATTRIBUTE:
                attributes_dict[attr.name] = utils.parse_type_value(attr.get_default_value())  # string representando el tipo (string, int, float...)

        # Process children
        for child in feature.get_children():
            features.append(child)

    result = []
    for k, t in attributes_dict.items():
        result.append({'name': k, 'type': t})
    return result


def get_cardinality(feature: Feature) -> str:
    group_type = 'all'
    if feature.is_alternative_group():
        group_type = 'xor'
    elif feature.is_or_group():
        group_type = 'or'
    elif feature.is_leaf():
        group_type = 'leaf'
    elif feature.is_mutex_group():
        group_type = 'mux'
    return group_type

def get_parent_id(result: list[dict[str, str]], parent: Feature, feature_id: str) -> str:
    if parent is None:
        return feature_id
    return next((f['id'] for f in result if f['name'] == parent.name), None)


def get_qn_map(id_dict: dict[int, dict[str, Any]]) -> list[dict[str, Any]]:
    names = set()
    qns = []
    for dic in id_dict.values():
        name = dic['name']
        names.add(name)
    qn_count = 1
    for n in names:
        qn = {}
        qn_id = f'qn{qn_count}'
        qn_count += 1
        qn['id'] = qn_id
        qn['name'] = n
        qns.append(qn)
    return qns

def get_qv_map(id_dict: dict[int, dict[str, Any]]) -> list[dict[str, Any]]:
    values = set()
    qvs = []
    for dic in id_dict.values():
        value = dic['values']
        for val in value:
            values.add(val)
    qv_count = 1
    for v in values:
        qv = {}
        qv_id = f'qv{qv_count}'
        qv_count += 1
        qv['id'] = qv_id
        qv['value'] = v
        qvs.append(qv)
    return qvs

def get_qd_map(id_dict: dict[int, dict[str, Any]]) -> list[dict[str, Any]]:
    domains = set()
    qds = []
    for value in id_dict.values():
        domain = value['domain']
        domains.add(domain)
    qd_count = 1
    for dom in domains:
        qd = {}
        qd_id = f'qd{qd_count}'
        qd_count += 1
        qd['id'] = qd_id
        qd['domain'] = dom
        qds.append(qd)
    return qds

def get_qs_map(id_dict: dict[int, dict[str, Any]], qn: list[dict[str, Any]],
                                                   qv: list[dict[str, Any]],
                                                   qd: list[dict[str, Any]]) -> list[dict[str, Any]]:
    values_set = set()
    qs_map = []
    id_counter = 1
    for info in id_dict.values():
        for value in info['values']:
            qn_id = next((n['id'] for n in qn if n['name'] == info['name']), None)
            qv_id = next((v['id'] for v in qv if v['value'] == value), None)
            qd_id = next((d['id'] for d in qd if d['domain'] == info['domain']), None)
            values_for_set = qn_id, qv_id, qd_id
            values_set.add(values_for_set)
    for val in values_set:
        qs_dict = {}
        qs_id = f'qs{id_counter}'
        id_counter += 1
        qs_dict['id'] = qs_id
        qs_dict['qn'] = val[0]
        qs_dict['qv'] = val[1]
        qs_dict['qd'] = val[2]
        qs_map.append(qs_dict)
    return qs_map

def get_qas_map(c_attr: list[tuple[list, dict[int, dict[str, Any]]]], 
            qn_list: list[dict[str, Any]],
            qv_list: list[dict[str, Any]],
            qd_list: list[dict[str, Any]],
            qs_list: list[dict[str, Any]]) -> list[dict[str, Any]]:
    qa_map = []
    id_counter = 1
    qa_counter = 1
    for tup in c_attr:
        attr = tup[1]
        attributes_dict = next((attr for attr in attr.values()), None)
        for key, value in attributes_dict.items():
            qs_ids = {}
            qa_id = f'qa{qa_counter}'
            qa_counter += 1
            qn = next((n['id'] for n in qn_list if n['name'] == key), None)
            qv = next((v['id'] for v in qv_list if v['value'] == value), None)
            qd = next((d['id'] for d in qd_list if d['domain'] == utils.parse_type_value(value)), None)
            qs = next((s['id'] for s in qs_list if s['qn'] == qn and s['qv'] == qv and s['qd'] == qd), None)

            qs_ids['index'] = id_counter
            qs_ids['qa_id'] = qa_id
            qs_ids['qs_id'] = qs
            qa_map.append(qs_ids)
        id_counter += 1
    return qa_map

def get_ccs_map(features_map: list[dict[str, Any]],
                c_attr: list[tuple[list, dict[int, dict[str, Any]]]]):
    ccs_map = []
    ccs_id_counter = 1
    ccs_counter = 1
    for tup in c_attr:
        features_list = tup[0]
        for feature in features_list:
            ccs_dict = {}
            ccs_id = f'cc{ccs_counter}'
            ccs_counter += 1
            if utils.is_numerical_feature(feature):
                features_same_name = [f for f in features_map if feature.name == f['name']]
                numerical_value = utils.get_numerical_value_instance(feature)
                ccs_dict['index'] = ccs_id_counter
                ccs_dict['cc_id'] = ccs_id
                numerical_feature_id = next((f['id'] for f in features_same_name if numerical_value == f['nf_value']), None)
                ccs_dict['feature_id'] = next((f['id'] for f in features_same_name if 
                                          numerical_value == f['nf_value']), None)
                ccs_map.append(ccs_dict)
            else:
                ccs_dict['index'] = ccs_id_counter
                ccs_dict['cc_id'] = ccs_id
                ccs_dict['feature_id'] = next((f['id'] for f in features_map if feature.name == f['name']), None)
                ccs_map.append(ccs_dict)
        ccs_id_counter += 1
    return ccs_map

def get_qmc_map(qas: list[dict[str, Any]], ccs: list[dict[str, Any]]):
    qmc_set = set()
    qmc_map = []
    
    for ccs_item in ccs:
        for qas_item in qas:
            if ccs_item['index'] == qas_item['index']:
                ccs_tuple = ccs_item['index'], qas_item['index']
                qmc_set.add(ccs_tuple)
    qmc_counter = 1
    for item in qmc_set:
        qmc_dict = {}
        qmc_id = f'qmc{qmc_counter}'
        qmc_dict['id'] = qmc_id
        qmc_dict['cc_phi'] = item[0]
        qmc_dict['qa_psi'] = item[1]
        qmc_map.append(qmc_dict)
        qmc_counter += 1
    return qmc_map


def id_dict(c_attr: list[tuple[list, dict[int, dict[str, Any]]]]) -> dict[int, dict[str, Any]]:
    for tup in c_attr:
        id_dict = {}
        attributes_tuple = tup[1]
        attributes_dict = next((attr for attr in attributes_tuple.values()), None)
        qn_count = 0
        for attribute, values in attributes_dict.items():
            print(f'values: {values}')
            qn_dict = {}
            qn_dict['name'] = attribute
            qn_dict['domain'] = utils.parse_type_value(values)
            id_dict[qn_count] = qn_dict
            qn_count += 1
    
    qv_values = get_qv(c_attr, id_dict)
    for tup in c_attr:
        attr_dict = tup[1]
        attributes = next((attr for attr in attr_dict.values()), None)
        for attr in attributes.keys():
            for id in id_dict.keys():
                for tupl in c_attr:
                    id_dict_value = id_dict[id]
                    id_dict_value['values'] = qv_values[id]
    return id_dict

def get_qv(c_attr: list[tuple[list, dict[int, dict[str, Any]]]], qn_dict: dict[int, dict[str, Any]]) -> Any:
    copy_c_attr = copy.deepcopy(c_attr)
    values_dict = {}
    for id in qn_dict.keys():
        qv_set = []
        for tup in copy_c_attr:
            attr_dict = tup[1]
            attributes = next((attr for attr in attr_dict.values()), None)
            qv_set.append(next((attr for attr in attributes.values()), None))
            attributes.pop(next((attr for attr in attributes.keys()), None))
        values_dict[id] = qv_set
    return values_dict

def get_ids_from_dict(data: list[dict[str, Any]]) -> list[str]:
    result = []
    for d in data:
        item = d['data']
        for id in item:
            result.append(id)
    return result
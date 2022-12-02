import ast
from typing import Any 


import jinja2
import random

from flamapy.core.transformations import ModelToText
from flamapy.metamodels.fm_metamodel.models import FeatureModel, Feature, Relation, Constraint
import utils


CATEGORY_THEORY_TEMPLATE = 'category_theory_template.cql'
NUMERICAL_FEATURE_ATTRIBUTE = 'NF'
NUMERICAL_FEATURE_DOMAIN = 'Int'





class CategoryTheoryWriter(ModelToText):
    """Transform a feature model to a category theory (CT) formalization.
    
    CT is specified in a .cql file that is the input of the CT solver.
    """

    @staticmethod
    def get_destination_extension() -> str:
        return '.cql'

    def __init__(self, path: str, source_model: FeatureModel, configurations_attr: tuple) -> None:
        self.path = path
        self.source_model = source_model
        self.configurations_attr = configurations_attr

    def transform(self) -> str:
        ct_str = fm_to_categories(self.source_model, self.configurations_attr)
        with open(self.path, 'w', encoding='utf-8') as file:
            file.write(ct_str)
        return ct_str


def fm_to_categories(feature_model: FeatureModel, c_attr: tuple) -> str:
    template_loader = jinja2.FileSystemLoader(searchpath='./')
    environment = jinja2.Environment(loader=template_loader)
    template = environment.get_template(CATEGORY_THEORY_TEMPLATE)
    maps = get_maps(feature_model, c_attr)
    content = template.render(maps)
    return content


def get_maps(feature_model: FeatureModel, c_attr: tuple) -> dict[str, str]:
    result = {}
    all_features_map = get_all_features_map(feature_model)
    feature_attributes_map = get_features_attributes_map(feature_model)
    virtual_linkages = get_virtual_linkages(c_attr)
    qn_map = get_qn_map(feature_model)
    qv_map = get_qv_map(feature_model)
    qd_map = get_qd_map(feature_model)
    qs_map = get_qs_map(feature_model)
    qas_map = get_qas_map(feature_model)
    ccs_map = get_ccs_map(feature_model)
    qmc_map = get_qmc_map(feature_model)
    result['features_list'] = ' '.join([f['id'] for f in all_features_map])
    result['qn_list'] = ' '.join([qn['id'] for qn in qn_map])
    result['qv_list'] = ' '.join([qv['id'] for qv in qv_map])
    result['qd_list'] = ' '.join([qd['id'] for qd in qd_map])
    result['qs_list'] = ' '.join([qs['id'] for qs in qs_map])
    result['qas_list'] = ' '.join([qas['id'] for qas in qas_map])
    result['ccs_list'] = ' '.join([ccs['id'] for ccs in ccs_map])
    result['qmc_list'] = ' '.join([qmc['id'] for qmc in qmc_map])
    result['boolean_features_dict'] = [d for d in all_features_map if not is_numerical_feature(feature_model.get_feature_by_name(d['name']))]
    result['numerical_features_dict'] = [d for d in all_features_map if is_numerical_feature(feature_model.get_feature_by_name(d['name']))]
    result['feature_attributes_dict'] = feature_attributes_map
    result['cc_virutal_linkages_dict'] = virtual_linkages
    result['quality_names_dict'] = feature_attributes_map
    result['quality_domains_dict'] = feature_attributes_map
    result['quality_values_dict'] = feature_attributes_map
    result['quality_attributes_dict'] = feature_attributes_map
    result['quality_model_dict'] = feature_attributes_map
    return result


def get_all_features_map(feature_model: FeatureModel) -> list[dict[str, Any]]:
    result = []
    count = 1
    nf_count = 1
    features = [(feature_model.root, None)]
    while features:
        feature, parent = features.pop()
        if not is_numerical_feature(feature):
            feature_id = f'f{count}'
            count += 1
            # Create dictionary for feature
            feature_dict = {}
            feature_dict['id'] = feature_id
            feature_dict['name'] = feature.name
            feature_dict['cardinality'] = get_cardinality(feature)
            feature_dict['optionality'] = str(feature.is_optional()).lower()
            feature_dict['parent'] = parent if parent is not None else feature_id
            feature_dict['attributes'] = [{'name': a.name, 'value': a.get_default_value()} 
                                            for a in feature.get_attributes() 
                                            if a.name != NUMERICAL_FEATURE_ATTRIBUTE]
            result.append(feature_dict)
        else:
            # It is numerical feature
            for v in get_numerical_value(feature):
                feature_id = f'nf{nf_count}'
                nf_count += 1
                # Create dictionary for feature
                feature_dict = {}
                feature_dict['id'] = feature_id
                feature_dict['name'] = feature.name
                feature_dict['cardinality'] = get_cardinality(feature)
                feature_dict['optionality'] = str(feature.is_optional()).lower()
                feature_dict['parent'] = parent if parent is not None else feature_id
                feature_dict['attributes'] = [{'name': a.name, 'value': a.get_default_value()} 
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

def get_numerical_value(feature: Feature) -> list[Any]:
    values = []
    for attribute in feature.get_attributes():
        if attribute.name == NUMERICAL_FEATURE_ATTRIBUTE:
            values = ast.literal_eval(attribute.get_default_value())
            if len(values) == 2:
                values = range(values[0], values[1] + 1)
    return values



    # for i, feature in enumerate(features, 1):
    #     feature_dict = {}
    #     feature_dict['id'] = f'f{i}'
    #     feature_dict['name'] = feature.name
    #     feature_dict['cardinality'] = get_cardinality(feature)
    #     feature_dict['optionality'] = str(feature.is_optional()).lower()
    #     feature_dict['parent'] = feature.get_parent()
    #     result.append(feature_dict)

    # for feature_dict in result:
    #     feature_dict['parent'] = get_parent_id(result, feature_dict['parent'], feature_dict['id'])
    # return result

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


def is_numerical_feature(feature: Feature) -> bool:
    return any(attribute for attribute in feature.get_attributes() if attribute.get_name() == NUMERICAL_FEATURE_ATTRIBUTE)

def get_virtual_linkages(c_attr: list[tuple]):
    virtual_linkages_dict = {}
    for i, tuple in c_attr:
        virtual_linkages_dict['id'] = c_attr[i]
        features = tuple[0]
        for feature in features:
            virtual_linkages_dict['feature'] = 

def get_qn_map(feature_model: FeatureModel):
    pass

def get_qv_map(feature_model: FeatureModel):
    pass

def get_qd_map(feature_model: FeatureModel):
    pass

def get_qs_map(feature_model: FeatureModel):
    pass

def get_qas_map(feature_model: FeatureModel):
    pass

def get_ccs_map(feature_model: FeatureModel):
    pass

def get_qmc_map(feature_model: FeatureModel):
    pass
import jinja2

from famapy.core.transformations import ModelToText

from famapy.metamodels.fm_metamodel.models import FeatureModel, Feature, Relation, Constraint


CATEGORY_THEORY_TEMPLATE = 'category_theory_template.cql'


class CategoryTheoryWriter(ModelToText):
    """Transform a feature model to a category theory (CT) formalization.
    
    CT is specified in a .cql file that is the input of the CT solver.
    """

    @staticmethod
    def get_destination_extension() -> str:
        return '.cql'

    def __init__(self, path: str, source_model: FeatureModel) -> None:
        self.path = path
        self.source_model = source_model

    def transform(self) -> str:
        ct_str = fm_to_categories(self.source_model)
        with open(self.path, 'w', encoding='utf-8') as file:
            file.write(ct_str)
        return ct_str


def fm_to_categories(feature_model: FeatureModel) -> str:
    template_loader = jinja2.FileSystemLoader(searchpath='./')
    environment = jinja2.Environment(loader=template_loader)
    template = environment.get_template(CATEGORY_THEORY_TEMPLATE)
    maps = get_maps(feature_model)
    content = template.render(maps)
    return content


def get_maps(feature_model: FeatureModel) -> dict[str, str]:
    result = {}
    features_map = get_features_map(feature_model)
    result['features_list'] = ' '.join([f['id'] for f in features_map])
    result['features_dict'] = features_map
    return result

def get_features_map(feature_model: FeatureModel) -> list[dict[str, str]]:
    result = []
    features = [(feature_model.root, None)]
    count = 1
    while features:
        feature, parent = features.pop()
        feature_id = f'f{count}'
        count += 1
        # Create dictionary for feature
        feature_dict = {}
        feature_dict['id'] = feature_id
        feature_dict['name'] = feature.name
        feature_dict['cardinality'] = get_cardinality(feature)
        feature_dict['optionality'] = str(feature.is_optional()).lower()
        feature_dict['parent'] = parent if parent is not None else feature_id

        result.append(feature_dict)

        # Process children
        for child in feature.get_children():
            features.append((child, feature_id))
    return result

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







'''
name({{feature.id}}) = {{feature.name}}
cardinality({{feature.id}}) = {{feature.cardinality}}
optionality({{feature.id}}) = {{feature.optionality}}
parent({{feature.id}}) = {{feature.parent}}
'''




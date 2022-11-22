from flamapy.core.transformations import ModelToText
import os
from typing import Any
import random

from flamapy.metamodels.pysat_metamodel.transformations import FmToPysat
from flamapy.metamodels.pysat_metamodel.operations import (
    Glucose3ProductsNumber,
    Glucose3Products
)

from flamapy.metamodels.fm_metamodel.models import FeatureModel, Feature, Relation, Constraint

from rhea.refactorings import utils


class FeatureAttributeWriter(ModelToText):
    """Transform features attributes to a CSV format.
    
    Features Attributes is specified in a .csv file that is the input of the CT transformation.
    """

    @staticmethod
    def get_destination_extension() -> str:
        return '.csv'

    def __init__(self, path: str, source_model: FeatureModel) -> None:
        self.path = path
        self.source_model = source_model

    def set_attributes(self, attributes: Any) -> None:
        self.attributes = attributes

    def transform(self) -> str:
        fm_basename = os.path.basename(self.path)
        fm_name = fm_basename[:fm_basename.find('.')] 
        ca_str = features_attr_to_csv(self.source_model, fm_name)
        with open(self.path, 'w', encoding='utf-8') as file:
            file.write(ca_str)
        return ca_str


def features_attr_to_csv(feature_model: FeatureModel, fm_name: str) -> str:
    # Transform the feature attributes to csv
    features_list = []
    features_list = feature_model.get_features()

    attributes_list = {}
    for f in features_list:
        if fm_name == 'Pizzas_feature_attr':
            n_attr = 1
        elif fm_name == 'Truck_feature_attr':
            n_attr = 1
        elif fm_name == 'VNS_feature_attr':
            n_attr = 3
        else:
            n_attr = random.randint(0, 7)
        attributes_list[f] = n_attr
    
    header = 'FEATURE'

    header_attr = []
    if fm_name == 'Pizzas_feature_attr':
        header_attr.append('Cost($)')
    elif fm_name == 'Truck_feature_attr':
        header_attr.append('Size(metres^2)')
    elif fm_name == 'VNS_feature_attr':
        names_list = ['Dependency', 'Usability', 'Security']
        for n in names_list:
            header_attr.append(n)
    else:
        for i in range(max(attributes_list.values())):
            header_attr.append(utils.get_new_attr_name(header_attr, 'Attribute'))
    header_attr = ','.join(header_attr)
    if len(header_attr)>=1:
        header = header + ',' + header_attr

    result = f'{header}'
    for feature in features_list:
        row = feature.name
        if len(header_attr)>=1:
            if fm_name == 'Pizzas_feature_attr':
                row = row + ',' + ','.join([str(random.randint(5, 25)) for i in range(attributes_list[feature])])
            elif fm_name == 'Truck_feature_attr':
                row = row + ',' + ','.join([str(random.randint(1, 10)) for i in range(attributes_list[feature])])
            elif fm_name == 'VNS_feature_attr':
                attributes = []
                choice_list = ['L', 'M', 'H']
                chosen = random.randint(0, 2)
                attributes.append(choice_list[chosen])
                attributes.append(str(random.randint(1,10)))
                choice_list1 = ['L', 'M', 'H']
                chosen1 = random.randint(0, 2)
                attributes.append(choice_list1[chosen1])
                attributes.append
                row = row + ',' + ','.join(attributes)
            else:
                row = row + ',' + ','.join([str(random.randint(1, 100)) for i in range(attributes_list[feature])])
        result += f'\n{row}'
    return result




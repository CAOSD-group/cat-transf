import csv
from typing import Any

from flamapy.core.transformations import TextToModel
from flamapy.metamodels.configuration_metamodel.models import Configuration
from flamapy.metamodels.fm_metamodel.models import FeatureModel, Feature
from utils import utils


CSV_SEPARATOR = ','
LINE_SEPARATOR = '\n'
DOUBLE_PRECISION = 4
MIN_INT = 1
MAX_INT = 100


class ConfigurationsAttributesReader(TextToModel):
    """Transform CSV format to attributes configurations.
    
    Attribute Configurations is specified in a .csv file that is the input of the CT transformation.
    """

    @staticmethod
    def get_source_extension() -> str:
        return 'csv'

    def __init__(self, path: str, source_model: FeatureModel) -> None:
        self.path = path
        self.source_model = source_model

    def set_configurations(self, configurations: list[Configuration]):
        self.configurations = configurations

    def transform(self) -> str:
        with open(self.path, newline='', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile, delimiter=',', quotechar='"', skipinitialspace=True)

            content_list = []
            index = 1
            for row in reader:
                content_list.append(from_csv_to_configurations(self.source_model, row, index))
                index += 1
        return content_list


def from_csv_to_configurations(fm: FeatureModel, content: dict[str, str], index: int) -> tuple[list[Configuration], dict[int, dict[str, Any]]]:
    # content: CSV completo
    """
        Returns a tuple that consists in:
            - a list of configurations.
            - a dictionary (key -> value), where:
                - key is the index of the configuration.
                - value is a dictionary of attribtues' names -> attributes values.
    """
    configuration_list = []
    attributes_dict = {}
    index_attributes_dict = {}
    for key, value in content.items():
        feature = fm.get_feature_by_name(key)
        if not feature is None:
            if value.lower() == "true":
                configuration_list.append(feature)
        else:
            attr_type = utils.parse_type_value(value)
            attributes_dict[key] = utils.return_parsed_value(value, attr_type)
            index_attributes_dict[index] = attributes_dict

    configurations_tuple = [f.name for f in configuration_list], index_attributes_dict
    return configuration_list, index_attributes_dict



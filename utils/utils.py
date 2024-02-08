import random
import ast
from enum import Enum
from typing import Any

from flamapy.metamodels.fm_metamodel.models import FeatureModel, Feature, Relation, Constraint

NUMERICAL_FEATURE_ATTRIBUTE = 'NF'

class CTAttributeType(Enum):
    BOOL = 'Bool'
    STRING = 'String'
    INT = 'Integer'
    DOUBLE = 'Double'

def is_numerical_feature(feature: Feature) -> bool:
    return any(attribute for attribute in feature.get_attributes() if attribute.get_name() == NUMERICAL_FEATURE_ATTRIBUTE)

def get_numerical_values(feature: Feature) -> list[Any]:
    values = []
    for attribute in feature.get_attributes():
        if attribute.name == NUMERICAL_FEATURE_ATTRIBUTE:
            values = ast.literal_eval(attribute.get_default_value())
            if len(values) == 2:
                values = range(values[0], values[1] + 1)
    return values

def get_numerical_value_instance(feature: Feature) -> int:
    value = get_numerical_values(feature)
    for attribute in feature.get_attributes():
        if attribute.name == NUMERICAL_FEATURE_ATTRIBUTE:
            choice_list = ast.literal_eval(attribute.get_default_value())
            if len(value) == 2:
                choice_list = range(value[0], value[1] + 1)
            chosen = random.randint(0, len(choice_list) - 1)
            value = (choice_list[chosen])
    return value

def parse_type_value(value: Any) -> str:
    """Given a value represented in a string, returns the associated type in category theory."""
    if isinstance(value, bool):
        return CTAttributeType.BOOL.value
    if isinstance(value, int):
        return CTAttributeType.INT.value
    if isinstance(value, float):
        return CTAttributeType.DOUBLE.value
    if isinstance(value, str):
        return CTAttributeType.STRING.value
    

def return_parsed_value(value: str, type: str) -> Any:
    result = None
    if type == CTAttributeType.BOOL.value:
        if value.lower() == 'true':
            result = True
        else:
            result = False
    elif type == CTAttributeType.INT.value:
        result = int(value)
    elif type == CTAttributeType.DOUBLE.value:
        result = float(value)
    else:
        result = value
    return result
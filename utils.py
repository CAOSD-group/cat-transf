from enum import Enum
from typing import Any

class CTAttributeType(Enum):
    BOOL = 'Bool'
    STRING = 'String'
    INT = 'Integer'
    DOUBLE = 'Double'

def parse_type_value(value: str) -> str:
    """Given a value represented in a string, returns the associated type in category theory."""
    result = None
    if value.lower() in ['true', 'false']:
        result = CTAttributeType.BOOL
    else:
        try:
            int(value)
            result = CTAttributeType.INT
        except:
            pass
        if result is None:
            try:
                float(value)
                result = CTAttributeType.DOUBLE
            except:
                pass
        if result is None:
            result = CTAttributeType.STRING
    return result.value

def return_value_with_type(value: str, type: str) -> Any:
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
"""
This script generates all configurations of a feature model with feature attributes.
The attributes are randomly generated for X attributes.
"""

from inspect import Attribute
import os
import random
import string
from xml.dom.minidom import Attr
from flamapy.metamodels.fm_metamodel.transformations import UVLReader, UVLWriter, FeatureIDEReader, GlencoeReader
from flamapy.metamodels.fm_metamodel.transformations import FeatureIDEReader

from config_attr_writer import ConfigurationAttributeWriter

from flamapy.metamodels.pysat_metamodel.transformations import FmToPysat
from flamapy.metamodels.pysat_metamodel.operations import (
    Glucose3ProductsNumber,
    Glucose3Products
)

from flamapy.metamodels.fm_metamodel.models import FeatureModel

from rhea.refactorings import utils


MODEL_PATH = 'tests/models/general_models/Truck.uvl'
n_attr = random.randint(1, 5)


def main(fm_path: str, n_attributes: int):
    # Create path to the output file
    fm_basename = os.path.basename(fm_path)
    fm_dirname = os.path.dirname(fm_path)
    fm_name = fm_basename[:fm_basename.find('.')]  # Remove extension
    output_path = os.path.join('tests/config_output', fm_name + '_config_attr' + ConfigurationAttributeWriter.get_destination_extension())
    
    # Load the feature model
    if MODEL_PATH.endswith('.gfm.json'):
        fm = GlencoeReader(MODEL_PATH).transform()
    elif MODEL_PATH.endswith('.uvl'):
        fm = UVLReader(MODEL_PATH).transform()
    elif MODEL_PATH.endswith('.xml'):
        fm = FeatureIDEReader(MODEL_PATH).transform()
    else:
        raise Exception(f'Error, invalid model {MODEL_PATH}.')

    # ct_str = generate_configurations(fm, n_attributes)
    ct_str = ConfigurationAttributeWriter(path=output_path, source_model=fm).transform()

    # Print the result (optional)
    print(ct_str)

def generate_configurations(fm: FeatureModel, n_attr: int) -> str: 
    # Transform the configurations to csv
    sat_model = FmToPysat(fm).transform()
    configurations = Glucose3Products().execute(sat_model).get_result()

    features_list = []
    features_list = fm.get_features()
    header = ','.join((f.name for f in features_list))

    header_attr = []
    for i in range(n_attr):
        header_attr.append(utils.get_new_attr_name(header_attr, 'Config_Attribute'))
    header_attr = ','.join(header_attr)
    if len(header_attr)>=1:
        header = header + ',' + header_attr

    result = f'{header}'
    for c in configurations:
        row = ','.join((str(f.name in c) for f in features_list))
        if len(header_attr)>=1:
            row = row + ',' + ','.join([str(random.randint(0, 10)) for i in range(n_attr)])
        result += f'\n{row}'
    
    return result
    


if __name__ == '__main__':
    main(MODEL_PATH, n_attr)
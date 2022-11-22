"""
This script generates a CSV with all features with their respective attributes in a FM.
The attributes are randomly generated for X attributes.
"""

from inspect import Attribute
import os
import random
import string
from xml.dom.minidom import Attr
from flamapy.metamodels.fm_metamodel.transformations import UVLReader, UVLWriter, FeatureIDEReader, GlencoeReader
from flamapy.metamodels.fm_metamodel.transformations import FeatureIDEReader

from feature_attr_writer import FeatureAttributeWriter

from flamapy.metamodels.pysat_metamodel.transformations import FmToPysat
from flamapy.metamodels.pysat_metamodel.operations import (
    Glucose3ProductsNumber,
    Glucose3Products
)

from flamapy.metamodels.fm_metamodel.models import FeatureModel

from rhea.refactorings import utils


MODEL_PATH = 'tests/models/general_models/VNS.xml'


def main(fm_path: str):
    # Create path to the output file
    fm_basename = os.path.basename(fm_path)
    fm_dirname = os.path.dirname(fm_path)
    fm_name = fm_basename[:fm_basename.find('.')]  # Remove extension
    output_path = os.path.join('tests/feature_attr_output', fm_name + '_feature_attr' + FeatureAttributeWriter.get_destination_extension())
    
    # Load the feature model
    if MODEL_PATH.endswith('.gfm.json'):
        fm = GlencoeReader(MODEL_PATH).transform()
    elif MODEL_PATH.endswith('.uvl'):
        fm = UVLReader(MODEL_PATH).transform()
    elif MODEL_PATH.endswith('.xml'):
        fm = FeatureIDEReader(MODEL_PATH).transform()
    else:
        raise Exception(f'Error, invalid model {MODEL_PATH}.')

    # ct_str = generate_features_attr(fm, fm_name)
    ct_str = FeatureAttributeWriter(path=output_path, source_model=fm).transform()

    # Print the result (optional)
    print(ct_str)

def generate_features_attr(fm: FeatureModel, fm_name: str) -> str: 
    # Transform the feature attributes to csv

    features_list = []
    features_list = fm.get_features()


    attributes_list = {}
    for f in features_list:
        if fm_name == 'Pizzas':
            n_attr = random.randint(5, 25)
        elif fm_name == 'Truck':
            n_attr = random.randint(0, 10)
        else:
            n_attr = random.randint(0, 7)
        attributes_list[f] = n_attr
    
    header = 'FEATURE'

    header_attr = []
    for i in range(max(attributes_list.values())):
        header_attr.append(utils.get_new_attr_name(header_attr, 'Attribute'))
    header_attr = ','.join(header_attr)
    if len(header_attr)>=1:
        header = header + ',' + header_attr

    result = f'{header}'
    for feature in features_list:
        row = feature.name
        if len(header_attr)>=1:
            row = row + ',' + ','.join([str(random.randint(0, 10)) for i in range(attributes_list[feature])])
        result += f'\n{row}'
    
    return result
    


if __name__ == '__main__':
    main(MODEL_PATH)
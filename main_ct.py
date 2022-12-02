import os
import sys
import argparse

from flamapy.metamodels.fm_metamodel.transformations import UVLReader

from flamapy.metamodels.bdd_metamodel.transformations import FmToBDD
from flamapy.metamodels.bdd_metamodel.operations import BDDProductsNumber, BDDProducts, BDDSampling


from category_theory_writer import CategoryTheoryWriter
from configurations_attributes_writer import ConfigurationsAttributesWriter
from configurations_attributes_reader import ConfigurationsAttributesReader


ATTRIBUTES_TYPES = ['int', 'double', 'bool']


def main(fm_path: str, sample_size: int, attributes_types: list[str] = []):
    # Load the feature model
    fm = UVLReader(fm_path).transform()


    # Create path to the output file
    fm_basename = os.path.basename(fm_path)
    fm_dirname = os.path.dirname(fm_path)
    fm_name = fm_basename[:fm_basename.find('.')]  # Remove extension
    output_path = os.path.join(fm_dirname, fm_name + CategoryTheoryWriter.get_destination_extension())
    csv_path = os.path.join('config.csv')

    # Load de configurations with attribute
    configs = ConfigurationsAttributesReader(path=csv_path, source_model=fm).transform()

    # Transform the feature model to category theory
    # ct_str = CategoryTheoryWriter(path=output_path, source_model=fm, configurations_attr=configs).transform()

    # Obtain the sample using the BDD
    bdd_model = FmToBDD(fm).transform()
    if sample_size is None:
        products = BDDProducts().execute(bdd_model).get_result()
    else:
        products = BDDSampling(size=sample_size).execute(bdd_model).get_result()

    configs_attrs_writter = ConfigurationsAttributesWriter('config.csv', fm)
    configs_attrs_writter.set_configurations(products)
    configs_attrs_writter.set_attributes_types(attributes_types)
    configs_attrs_writter.transform()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Feature Model to Category Theory.')
    parser.add_argument('-fm', '--featuremodel', dest='feature_model', type=str, required=True, help='Input feature model in UVL format.')
    parser.add_argument('-s', '--size', dest='size', type=int, required=False, help='Sample size of the configurations (default: all configurations).')
    parser.add_argument('-a', '--attribute', dest='attribute', nargs='+', default=[], required=False, help=f'Attribute types for each attribute to be generated ({",".join(ATTRIBUTES_TYPES)}).')
    args = parser.parse_args()

    attributes_types = []
    if args.attribute:
        if any(a.lower() not in ATTRIBUTES_TYPES for a in args.attribute):
            print(f'Error: Attribute type not valid. Use: {({",".join(ATTRIBUTES_TYPES)})}.')
            parser.print_help()
            sys.exit()
        else:
            attributes_types = [a.lower() for a in args.attribute]
    
    main(args.feature_model, args.size, attributes_types)


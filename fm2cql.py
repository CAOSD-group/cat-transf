import os
import argparse

from alive_progress import alive_bar

from flamapy.metamodels.fm_metamodel.transformations import UVLReader

from utils.category_theory_writer import CategoryTheoryWriter
from utils.configurations_attributes_reader import ConfigurationsAttributesReader


ATTRIBUTES_TYPES = ['int', 'double', 'bool']


def main(fm_path: str, csv_path: str):
    with alive_bar(title=f'Reading FM {fm_path}...') as bar: 
        fm = UVLReader(fm_path).transform()
        bar()

    with alive_bar(title=f'Loading csv {csv_path}...') as bar: 
        configs = ConfigurationsAttributesReader(path=csv_path, source_model=fm).transform()
        bar()

    # Create path to the output file
    path, filename = os.path.split(fm_path)
    filename = '.'.join(filename.split('.')[:-1])
    output_path = os.path.join(path, f'{filename}.{CategoryTheoryWriter.get_destination_extension()}')
    with alive_bar(title=f'Transforming to category theory {output_path}...') as bar: 
        CategoryTheoryWriter(path=output_path, source_model=fm, configurations_attr=configs).transform()
        bar()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Feature Model to Category Theory.')
    parser.add_argument('-fm', '--featuremodel', dest='feature_model', type=str, required=True, help='Input feature model in UVL format.')
    parser.add_argument('-csv', dest='csv', type=str, required=False, help='Input csv with configurations and attributes information.')
    
    args = parser.parse_args()

    main(args.feature_model, args.csv)

import os
import argparse

from flamapy.metamodels.fm_metamodel.transformations import UVLReader

from category_theory_writer import CategoryTheoryWriter


def main(fm_path: str):
    # Load the feature model
    fm = UVLReader(fm_path).transform()

    # Create path to the output file
    fm_basename = os.path.basename(fm_path)
    fm_dirname = os.path.dirname(fm_path)
    fm_name = fm_basename[:fm_basename.find('.')]  # Remove extension
    output_path = os.path.join(fm_dirname, fm_name + CategoryTheoryWriter.get_destination_extension())

    # Transform the feature model to category theory
    ct_str = CategoryTheoryWriter(path=output_path, source_model=fm).transform()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Feature Model to Category Theory.')
    parser.add_argument('-fm', '--featuremodel', dest='feature_model', type=str, required=True, help='Input feature model in UVL format.')
    args = parser.parse_args()

    main(args.feature_model)


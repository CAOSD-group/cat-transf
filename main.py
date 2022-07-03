import os
from famapy.metamodels.fm_metamodel.transformations import UVLReader

from FMToCategories import FMToCategories


FM_PATH = 'models/Pizzas.uvl'


def main(fm_path: str):
    # Create path to the output file
    fm_basename = os.path.basename(fm_path)
    fm_dirname = os.path.dirname(fm_path)
    fm_name = fm_basename[:fm_basename.find('.')]  # Remove extension
    output_path = os.path.join(fm_dirname, fm_name + FMToCategories.get_destination_extension())
    
    # Load the feature model
    fm = UVLReader(fm_path).transform()

    # Transform the feature model to category theory
    ct_str = FMToCategories(path=output_path, source_model=fm).transform()

    # Print the result (optional)
    print(ct_str)


if __name__ == '__main__':
    main(FM_PATH)


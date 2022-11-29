import os
from flamapy.metamodels.fm_metamodel.transformations import UVLReader
from flamapy.metamodels.fm_metamodel.transformations import FeatureIDEReader

from category_theory_writer import CategoryTheoryWriter
from clafer_writer import ClaferWriter


FM_PATH = 'models/input/GPL.xml'


def main(fm_path: str):
    # Create path to the output file
    fm_basename = os.path.basename(fm_path)
    fm_dirname = os.path.dirname(fm_path)
    fm_name = fm_basename[:fm_basename.find('.')]  # Remove extension
    output_path = os.path.join('models/output/', fm_name + ClaferWriter.get_destination_extension())
    
    # Load the feature model
    fm = FeatureIDEReader(fm_path).transform()

    # Transform the feature model to category theory
    ct_str = ClaferWriter(path=output_path, source_model=fm).transform()

    # Print the result (optional)
    print(ct_str)


if __name__ == '__main__':
    main(FM_PATH)


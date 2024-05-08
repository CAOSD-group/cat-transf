import os
import argparse

from alive_progress import alive_bar

from flamapy.metamodels.fm_metamodel.transformations import UVLReader, ClaferWriter


def main(fm_path: str):
    with alive_bar(title=f'Reading FM {fm_path}...') as bar: 
        fm = UVLReader(fm_path).transform()
        bar()

    # Create path to the output file
    path, filename = os.path.split(fm_path)
    filename = '.'.join(filename.split('.')[:-1])
    output_path = os.path.join(path, f'{filename}.{ClaferWriter.get_destination_extension()}')
    with alive_bar(title=f'Transforming to Clafer {output_path}...') as bar: 
        ClaferWriter(path=output_path, source_model=fm).transform()
        bar()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Feature Model to Clafer.')
    parser.add_argument(metavar='fm', dest='fm_filepath', type=str, help='Input feature model (.uvl).')
    args = parser.parse_args()

    main(args.fm_filepath)

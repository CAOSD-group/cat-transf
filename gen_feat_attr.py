import argparse
import os
import json
from typing import Any

from alive_progress import alive_bar

from flamapy.metamodels.fm_metamodel.models import FeatureModel, Domain, Range
from flamapy.metamodels.fm_metamodel.transformations import UVLReader, UVLWriter
from flamapy.metamodels.fm_metamodel.operations import GenerateRandomAttribute


def parse_ranges(ranges: list[list[int|float]]) -> list[Range]:
    ranges_list = []
    for range in ranges:
        if len(range) != 2:
            raise Exception(f'Invalid range: {range}')
        if any(not isinstance(r, int) and not isinstance(r, float) for r in range):
            raise Exception(f'Invalid types for range {range}. Use int or float values.')
        ranges_list.append(Range(range[0], range[1]))
    return ranges_list


def generate_feature_attribute(fm: FeatureModel,
                               attribute_name: str,
                               domain: Domain,
                               only_leaf_features: bool) -> FeatureModel:
    gra_op = GenerateRandomAttribute()
    gra_op.set_name(attribute_name)
    gra_op.set_domain(domain)
    gra_op.set_only_leaf_features(only_leaf_features)
    return gra_op.execute(fm).get_result()


def main(fm_filepath: str, 
         attribute_name: str, 
         ranges: list[Range] = None, 
         elements: list[Any] = None,
         only_leaf_features: bool = False):
    path, filename = os.path.split(fm_filepath)
    filename = '.'.join(filename.split('.')[:-1])
    
    with alive_bar(title=f'Reading FM {fm_filepath}...') as bar: 
        fm = UVLReader(fm_filepath).transform()
        bar()

    with alive_bar(title=f'Generating random attribute...') as bar: 
        domain = Domain(ranges, elements)
        print(f'Feature Attribute')
        print(f'  |-name: {attribute_name}')
        print(f'  |-domain: {domain}')
        print(f'  |-only leaf features? {only_leaf_features}')
        fm = generate_feature_attribute(fm, attribute_name, domain, only_leaf_features)
        bar()

    fm_output = os.path.join(path, f'{filename}_{attribute_name}.uvl')
    with alive_bar(title=f'Serializing FM {fm_output}...') as bar: 
        UVLWriter(fm, fm_output).transform()
        bar()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate random feature attributes for a feature model.')
    parser.add_argument(metavar='fm', dest='fm_filepath', type=str, help='Input feature model (.uvl).')
    parser.add_argument(dest='attribute_name', type=str, help="Attribute's name.")
    parser.add_argument('-r', '--ranges', dest='ranges', type=json.loads, required=False,  help="Ranges of the domain. Example: '[[1,10], [20,50]'.")
    parser.add_argument('-e', '--elements', dest='elements', type=str, required=False,  help="Elements of the domain. Example: '[[1,10], [20,50]'.")
    parser.add_argument('-l', '--leafs', dest='leafs', action='store_true', required=False,  help="Generate attributes for only leaf features.")
    args = parser.parse_args()

    if not (args.ranges or args.elements):
        parser.error('No domain specified, use -r or -e')
    
    ranges = None
    if args.ranges:
        if not isinstance(args.ranges, list) and not all(isinstance(range, list) for range in args.ranges):
            parser.error(f"Invalid ranges format: {args.ranges}. Use this format '[[1,10], [20,50]'")        
        ranges = parse_ranges(args.ranges)
    elements  = None
    if args.elements:
        elements = eval(args.elements)

    main(args.fm_filepath, args.attribute_name, ranges, elements, args.leafs)

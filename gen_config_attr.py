import argparse
import json
import os
import csv
import random
from typing import Any

from alive_progress import alive_bar

from flamapy.metamodels.fm_metamodel.models import Domain, Range


CSV_SEPARATOR = ','
CSV_QUOTECHAR = '"'


def parse_ranges(ranges: list[list[int|float]]) -> list[Range]:
    ranges_list = []
    for range in ranges:
        if len(range) != 2:
            raise Exception(f'Invalid range: {range}')
        if any(not isinstance(r, int) and not isinstance(r, float) for r in range):
            raise Exception(f'Invalid types for range {range}. Use int or float values.')
        ranges_list.append(Range(range[0], range[1]))
    return ranges_list


def generate_random_attribute_values(n: int, domain: Domain) -> list[Any]:
    return [get_random_value_from_domain(domain) for _ in range(n)]
    

def get_random_value_from_domain(domain: Domain) -> Any:
    """Generate a random value from a domain.
    NOTE: This is not uniform if there are more than one range or a range and a list of elements.
    """
    elements_in_domain = domain.get_element_list()
    ranges = domain.get_range_list()
    if elements_in_domain and ranges:
        random_element = random.choice(elements_in_domain)
        random_range_value = get_random_value_from_ranges(ranges)
        random_value = random.choice([random_element, random_range_value])
    elif elements_in_domain:
        random_value = random.choice(elements_in_domain)
    elif ranges:
        random_value = get_random_value_from_ranges(ranges)
    else:
        random_value = None
    return random_value


def get_random_value_from_ranges(ranges: list[Range]) -> Any:
    """Generate a random value from a list of ranges.
    NOTE: This is not uniform if there are more than one range.
    """
    random_range = random.choice(ranges)
    if isinstance(random_range.min_value, float) or isinstance(random_range.max_value, float):
        min_digits = str(random_range.min_value)[::-1].find('.')
        max_digits = str(random_range.max_value)[::-1].find('.')
        digits = max(min_digits, max_digits)
        value = round(random.uniform(random_range.min_value, random_range.max_value), digits)
    elif isinstance(random_range.min_value, int) and isinstance(random_range.max_value, int):
        value = random.randint(random_range.min_value, random_range.max_value)
    else:
        raise Exception(f"Invalid range for attribute: {ranges}")
    return value


def serialize_csv(content: list[str],
                  attribute_name: str,
                  attributes_values: list[Any],
                  csv_filepath: str) -> None:
    with open(csv_filepath, 'w', newline='') as csv_file:
        writer = csv.writer(csv_file, delimiter=CSV_SEPARATOR, quotechar=CSV_QUOTECHAR, quoting=csv.QUOTE_MINIMAL)
        # Header
        features_names = content[0]
        features_names.append(attribute_name)
        writer.writerow(features_names)
        # Rows
        for i, row in enumerate(content[1:], 0):
            row.append(attributes_values[i])
            writer.writerow(row)


def main(csv_filepath: str, 
         attribute_name: str, 
         ranges: list[Range] = None, 
         elements: list[Any] = None):
    path, filename = os.path.split(csv_filepath)
    filename = '.'.join(filename.split('.')[:-1])
    
    with alive_bar(title=f'Reading csv {csv_filepath}...') as bar: 
        content = []
        with open(csv_filepath, newline='') as csv_file:
            reader = csv.reader(csv_file, delimiter=CSV_SEPARATOR, quotechar=CSV_QUOTECHAR)
            for row in reader:
                content.append(row)
        bar()

    with alive_bar(title=f'Generating random attribute...') as bar: 
        domain = Domain(ranges, elements)    
        print(f'Variant-wise attribute...')
        print(f'  |-name: {attribute_name}')
        print(f'  |-domain: {domain}')
        attributes_values = generate_random_attribute_values(len(content)-1, domain)
        bar()
    
    csv_output = os.path.join(path, f'{filename}_{attribute_name}.csv')
    with alive_bar(title=f'Serializing csv {csv_output}...') as bar: 
        serialize_csv(content, attribute_name, attributes_values, csv_output)
        bar()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate random attributes for configurations.')
    parser.add_argument(metavar='csv', dest='csv_filepath', type=str, help='Input csv file with the configurations.')
    parser.add_argument(dest='attribute_name', type=str, help="Attribute's name.")
    parser.add_argument('-r', '--ranges', dest='ranges', type=json.loads, required=False,  help="Ranges of the domain. Example: '[[1,10], [20,50]'.")
    parser.add_argument('-e', '--elements', dest='elements', type=str, required=False,  help="Elements of the domain. Example: '[[1,10], [20,50]'.")
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

    main(args.csv_filepath, args.attribute_name, ranges, elements)

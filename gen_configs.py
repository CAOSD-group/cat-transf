import argparse
import os
import csv

from alive_progress import alive_bar

from flamapy.metamodels.configuration_metamodel.models import Configuration
from flamapy.metamodels.fm_metamodel.models import FeatureModel
from flamapy.metamodels.fm_metamodel.transformations import UVLReader

from flamapy.metamodels.pysat_metamodel.transformations import FmToPysat
from flamapy.metamodels.pysat_metamodel.operations import PySATProducts

from flamapy.metamodels.bdd_metamodel.transformations import FmToBDD
from flamapy.metamodels.bdd_metamodel.operations import BDDProductsNumber, BDDSampling

from utils.pysat_sampling import PySATSampling


CSV_SEPARATOR = ','
CSV_QUOTECHAR = '"'


def configurations_to_csv(fm: FeatureModel, 
                          configurations: list[Configuration],
                          csv_filepath: str) -> None:
    with open(csv_filepath, 'w', newline='') as csv_file:
        writer = csv.writer(csv_file, delimiter=CSV_SEPARATOR, quotechar=CSV_QUOTECHAR, quoting=csv.QUOTE_MINIMAL)
        # Header
        features_names = [f.name for f in fm.get_features()]
        writer.writerow(features_names)
        # Rows
        for config in configurations:
            config_row = [str(f in config.get_selected_elements()) for f in features_names]
            writer.writerow(config_row)
    

def main(fm_filepath: str, 
         sample_size: int = None,
         uniform: bool = False):
    path, filename = os.path.split(fm_filepath)
    filename = '.'.join(filename.split('.')[:-1])
    
    with alive_bar(title=f'Reading FM {fm_filepath}...') as bar: 
        fm = UVLReader(fm_filepath).transform()
        bar()

    with alive_bar(title='Building the BDD model...') as bar:
        try:    
            bdd_model = FmToBDD(fm).transform()
            n_configs = BDDProductsNumber().execute(bdd_model).get_result()
            print(f'#Configurations: {n_configs}')
        except:
            raise Exception(f'Error: Cannot build the BDD model.')

    if uniform:
        print(f'#Sample size: {sample_size}')
        with alive_bar(title=f'Generating {sample_size} configurations with BDD solver...') as bar:
            configurations = BDDSampling(sample_size, with_replacement=False).execute(bdd_model).get_result()
            bar()
    else:
        if sample_size is None:
            sample_size = 'all'
        elif sample_size > n_configs:
            print(f'Warning! Sample size {sample_size} is larger than number of configurations {n_configs}. All configurations will be generated.')
    
        with alive_bar(title='Transform to SAT...') as bar:
            sat_model = FmToPysat(fm).transform()
            bar()
        
        if not isinstance(sample_size, str) and sample_size < n_configs:
            with alive_bar(title=f'Generating {sample_size} configurations with SAT solver...') as bar:
                sampling_op = PySATSampling()
                sampling_op.set_size(sample_size)
                configs = sampling_op.execute(sat_model).get_result()
                configurations = []
                for config in configs:
                    configurations.append(Configuration({e: True for e in config}))
                bar()
        else:
            with alive_bar(title=f'Generating {n_configs} configurations with SAT solver...') as bar:
                configs = PySATProducts().execute(sat_model).get_result()
                configurations = []
                for config in configs:
                    configurations.append(Configuration({e: True for e in config}))
                bar()
    
    csv_output = os.path.join(path, f'{filename}_{sample_size}.csv')
    with alive_bar(title=f'Serializing configuration to csv file {csv_output}...') as bar:
        configurations_to_csv(fm, configurations, csv_output)
        bar()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate configurations from a feature model.')
    parser.add_argument(metavar='fm', dest='fm_filepath', type=str, help='Input feature model (.uvl).')
    parser.add_argument('-s', '--sample_size', dest='sample_size', type=int, required=False,  help="Number of configurations (default all).")
    parser.add_argument('-u', '--uniform', dest='uniform', action='store_true', required=False,  help="Uniform random sampling (default False).")
    args = parser.parse_args()

    main(args.fm_filepath, args.sample_size, args.uniform)

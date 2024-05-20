import os
import argparse

from alive_progress import alive_bar
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
import seaborn as sns

from flamapy.metamodels.fm_metamodel.transformations import UVLReader
from flamapy.metamodels.bdd_metamodel.transformations import FmToBDD
from flamapy.metamodels.bdd_metamodel.operations import (
    BDDProductDistribution, 
    BDDFeatureInclusionProbability,
    BDDConfigurationsNumber
)


def plot_product_distribution(data: list[int]):
    # Generate an array of indices
    indices = range(len(data))
    
    # Create the plot
    plt.figure(figsize=(10, 6))
    
    # Plot the smooth histogram using seaborn's kdeplot
    sns.kdeplot(x=indices, weights=data, bw_adjust=0.5, fill=True)
    
    # Set labels and title
    plt.xlabel('#Features')
    plt.ylabel("Products' density")
    plt.title('Product distribution')
    # Set the x-axis minimum value if specified
    plt.xlim(left=0)

    # Show the plot
    plt.show()


def plot_feature_inclusion_probabilities(probabilities):
    # Create the plot
    plt.figure(figsize=(10, 6))
    
    # Create a dictionary to store counts for each unique probability
    probability_counts = {}
    for prob in probabilities:
        probability_counts[prob] = probability_counts.get(prob, 0) + 1
    
    # Plot the smooth histogram using seaborn's kdeplot
    percentages = [p/len(probabilities)*100 for p in probability_counts.values()]
    counts, bins, _ = plt.hist(x=probability_counts.keys(), weights=percentages, bins=10, edgecolor='black', alpha=0.7, )
    #sns.kdeplot(probabilities, bw_adjust=0.05, fill=True)
    
    # Highlight the area for each unique probability
    for prob, count in probability_counts.items():
        if prob == 0.5:
            plt.axvspan(prob - 0.025, prob + 0.025, color='yellow', alpha=0.1, label=f'Pure optional features (p=0.5): {count}')
        elif prob >= 0.95:
            plt.axvspan(prob - 0.025, prob + 0.025, color='green', alpha=0.1, label=f'Core features (p=1.0): {count}')
        elif prob <= 0.05:
            plt.axvspan(prob - 0.025, prob + 0.025, color='red', alpha=0.1, label=f'Dead features (p=0.0): {count}')

    # Add legend
    plt.legend()

    # Set labels and title
    plt.xlabel('Feature probability of being included in a valid configuration')
    plt.ylabel('%Features')
    plt.title('Feature probability distribution')
    
    # Set x-axis limits to ensure it ranges from 0 to 100
    plt.xlim(0, 1)

    # Set y-axis limits to ensure it ranges from 0 to 100
    max_y = max(percentages)
    max_y = max_y + (10 - max_y % 10)
    plt.ylim(0, min(100, max_y))
    
    # Show the plot
    plt.show()


def main(fm_path: str):
    path, filename = os.path.split(fm_path)
    filename = '.'.join(filename.split('.')[:-1])

    with alive_bar(title=f'Reading FM {fm_path}...') as bar: 
        fm = UVLReader(fm_path).transform()
        bar()

    with alive_bar(title=f'Transforming FM to BDD...') as bar: 
        bdd_model = FmToBDD(fm).transform()
        bar()

    with alive_bar(title=f'Calculating number of configurations...') as bar:     
        n_configs = BDDConfigurationsNumber().execute(bdd_model).get_result()
        bar()
    
    print(f'Number of features the SPL manages: {len(fm.get_features())}')
    print(f'Number of valid configurations that can be derived: {n_configs}')
    print(f'Homogeneity of configurations: ??')

    with alive_bar(title=f'Calculating Product distribution...') as bar: 
        prod_dist_op = BDDProductDistribution().execute(bdd_model)
        dist = prod_dist_op.product_distribution()
        dist_stats = prod_dist_op.descriptive_statistics()
        bar()
    
    print(f'Product distribution: {dist}')
    print('Descriptive analysis (number of features for a product):')
    for ds, dv in dist_stats.items():
        print(f' |-{ds}: {dv}')
    plot_product_distribution(dist)


    with alive_bar(title=f'Calculating Feature inclusion probabilities...') as bar:     
        fip = BDDFeatureInclusionProbability().execute(bdd_model).get_result()
        bar()

    print('Feature Inclusion Probabilities:')
    for feat, prob in fip.items():
        print(f'{feat}: {prob}')
    plot_feature_inclusion_probabilities(list(fip.values()))

    
    


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Characterize feature model complexity.')
    parser.add_argument(metavar='fm', dest='fm_filepath', type=str, help='Input feature model (.uvl).')
    args = parser.parse_args()

    main(args.fm_filepath)

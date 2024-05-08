# Table of Contents
- [Table of Contents](#table-of-contents)
- [Category Transformation](#category-transformation)
  - [How to use it](#how-to-use-it)
      - [Requirements](#requirements)
      - [Download and install](#download-and-install)
      - [Execution](#execution)

# Category Transformation
This repository provides support for transforming feature models (FM) into category theory.

It offers the following functionality:
- Generation of feature's attributes for an FM.
- Generation of sample of configurations from an FM.
- Generation of variant-wise attributes for configurations.
- Transformation from FM and configurations to category theory.

## How to use it

#### Requirements
- Linux
- [Python 3.9+](https://www.python.org/)
- [Flama](https://flamapy.github.io/)

#### Download and install
1. Install [Python 3.9+](https://www.python.org/)

2. Clone this repository:

    `git clone https://github.com/CAOSD-group/cat-transf.git`

3. Create a virtual environment and activate it: 
   
   `python -m venv env`

   `. env/bin/activate`

4. Install the dependencies: 
   
   `pip install -r requirements.txt`

#### Execution
1. Go to the project folder: `cd cat-transf`
   
2. Run the appropriate script according to the required functionality.
Normally, you should follow these steps:

- **Step 1: Generate feature attribute:** Given an FM, it generates an attribute for each feature in the model with random values in a domain.

  - Execution: `python gen_feat_attr.py fm attribute_name -r ranges -e elements (-l)`
  - Inputs: 
    - `fm` specifies the file path of the FM in UVL format (.uvl).
    - `attribute_name` is the name of the new attribute.
    - The domain can be specified with one or both of the following parameters:
      - `ranges` specifies the domain for the values as a list of ranges with the following format: `'[[1, 10], [90, 100]]'` generates values from 1 to 10 and from 90 to 100.
      - `elements` specifies the domain for the values as a list of elements with the following format: `'[True, False]'` for a Boolean attribute; `'["Low", "Medium", "High"]'` for a string enumeration; `'[1, 10.0, 100]'` for specific integer or real values.
    - `-l` is an optional parameters indicating that the attribute will be only generated for the leaf features in the model.
  - Outputs:
    - A FM file in UVL format with the new attribute created in each feature. The output file is named as the original one ending with `_X.uvl` where `X` is the new attribute name.
  - Example: `python gen_feat_attr.py Pizzas.uvl Price -r '[[1, 10]]' -l`
  - Note: If there is a feature with an already existing attribute with the same name, the attribute will not be created for that feature.


- **Step 2: Generate configurations:** Given an FM, it generates a sample of configurations.

  - Execution: `python gen_configs.py fm -s size`
  - Inputs: 
    - `fm` specifies the file path of the FM in UVL format (.uvl).
    - `size` is the number of configuration to be generated.
  - Outputs:
    - A csv file with the configurations. The output file is named as the original FM with `_S.csv` where `S` is the number of configurations.
  - Example: `python gen_configs.py Pizzas.uvl -s 10`

- **Step 3: Generate variant-wise attribute:** Given the configurations of an FM in a csv file, it generates an attribute for each configuration with random values in a domain.

  - Execution: `python gen_config_attr.py csv attribute_name -r ranges -e elements (-l)`
  - Inputs: 
    - `csv` specifies the file path of the csv with the configurations.
    - `attribute_name` is the name of the new attribute.
    - The domain can be specified with one or both of the following parameters:
      - `ranges` specifies the domain for the values as a list of ranges with the following format: `'[[1, 10], [90, 100]]'` generates values from 1 to 10 and from 90 to 100.
      - `elements` specifies the domain for the values as a list of elements with the following format: `'[True, False]'` for a Boolean attribute; `'["Low", "Medium", "High"]'` for a string enumeration; `'[1, 10.0, 100]'` for specific integer or real values.
  - Outputs:
    - A csv file with the configurations and a new attribute created for each configuration. The output file is named as the original one ending with `_X.csv` where `X` is the new attribute name.
  - Example: `python gen_config_attr.py Pizzas.csv Vegan -e '[True, False]'`

- **Step 4: Transform to category theory:** Given an FM and a sample of configurations, it generates the category theory model (.cql).

  - Execution: `python fm2cql.py fm csv`
  - Inputs: 
    - `fm` specifies the file path of the FM in UVL format (.uvl).
    - `csv` specifies the file path of the csv with the configurations.
  - Outputs:
    - A cql file with the category theory model. The output file is named as the original FM with with `.cql` extension.
  - Example: `python fm2cql.py Pizzas.uvl Pizzas.csv`
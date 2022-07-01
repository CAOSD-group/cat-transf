from famapy.metamodels.fm_metamodel.transformations import UVLReader


fm = UVLReader(path='models/Pizzas.uvl').transform()

for feature in fm.get_features():
    if feature.parent is not None:
        print(f'{feature.name} -> p: {feature.parent.name}')
        if feature.is_mandatory():
            print('is mandatory')
    else:
        print(f'Raíz: "{feature.name}"')







from unittest import result
from famapy.metamodels.fm_metamodel.models import (
    FeatureModel, 
    Feature,
    Relation,
    Constraint
)
from famapy.core.models.ast import AST, ASTOperation, Node


# Root + feature + 1 mutex group
def get_case1() -> FeatureModel:
    # Create features
    feature_root = Feature(name='Root')
    f = Feature(name='F', parent=feature_root)
    f1 = Feature(name='F1', parent=f)
    f2 = Feature(name='F2', parent=f)
    f3 = Feature(name='F3', parent=f)

    # Create relations
    r1 = Relation(feature_root, [f], 1, 1)  # mandatory
    r2 = Relation(f, [f1, f2, f3], 0, 1)  # mutex

    # Add relations to features
    feature_root.add_relation(r1)
    f.add_relation(r2)

    # Create the feature model
    fm = FeatureModel(root=feature_root)
    return fm


# Root + 1 mutex group
def get_case2() -> FeatureModel:
    # Create features
    feature_root = Feature(name='Root')
    f1 = Feature(name='F1', parent=feature_root)
    f2 = Feature(name='F2', parent=feature_root)
    f3 = Feature(name='F3', parent=feature_root)

    # Create relations
    rel = Relation(feature_root, [f1, f2, f3], 0, 1)  # mutex

    # Add relations to features
    feature_root.add_relation(rel)

    # Create the feature model
    fm = FeatureModel(root=feature_root)
    return fm




# Root + 2 mutex groups
def get_case3() -> FeatureModel:
    # Create features
    feature_root = Feature(name='Root')

    f1 = Feature(name='F1', parent=feature_root)
    f2 = Feature(name='F2', parent=feature_root)
    f3 = Feature(name='F3', parent=feature_root)

    f4 = Feature(name='F4', parent=f2)
    f5 = Feature(name='F5', parent=f2)

    # Create relations
    r1 = Relation(feature_root, [f1, f2, f3], 0, 1)  # mutex
    r2 = Relation(f2, [f4, f5], 0, 1)  # mutex

    # Add relations to features
    feature_root.add_relation(r1)
    f2.add_relation(r2)

    # Create the feature model
    fm = FeatureModel(root=feature_root)
    return fm




def get_case5() -> FeatureModel:
    # Create features
    feature_root = Feature(name='Root')
    f1 = Feature(name='F1', parent=feature_root)
    f2 = Feature(name='F2', parent=feature_root)
    f3 = Feature(name='F3', parent=feature_root)
    f4 = Feature(name='F4', parent=feature_root)

    # Create relations
    rel = Relation(feature_root, [f1, f2, f3, f4], 2, 4)  # cardinality

    # Add relations to features
    feature_root.add_relation(rel)

    # Create the feature model
    fm = FeatureModel(root=feature_root)
    return fm




def each_tree(feature: Feature, card_min: int, card_max: int) -> AST:
    for child in feature.get_children():
        left = feature.get_children()[feature.get_children().index(child)]
        right = AST.create_binary_operation(ASTOperation.AND, feature.get_children()[feature.get_children().index(child)+1], ASTOperation.AND).root
    return AST.create_binary_operation(ASTOperation.AND, left, right).root


def constraints_iteration(feature: Feature, card_min: int, card_max: int) -> Node:
    return AST.create_binary_operation(ASTOperation.OR,
                                        each_tree(feature, card_min, card_max),
                                        constraints_iteration(feature, card_min, card_max)).root


def get_constraints_from_card(feature: Feature, card_min: int, card_max: int) -> Constraint:
    return AST.create_binary_operation(ASTOperation.IMPLIES,
                                        feature.name,
                                        constraints_iteration(feature, card_min, card_max)).root





def get_new_feature_name(fm: FeatureModel, name: str) -> str:
    """Return a name for a new feature to be created based on the given feature name."""
    count = 1
    new_name = f'{name}_p'
    while fm.get_feature_by_name(new_name) is not None:
        new_name = f'{name}_p{count}'
        count += 1
    return new_name


def transform_mutex(fm: FeatureModel, feature_name: str) -> FeatureModel:
    """Given a feature model, refactor the mutex group specified by its name."""
    feature = fm.get_feature_by_name(feature_name)

    if feature is None:
        raise Exception(f'There is not feature with name "{feature_name}".')
    if not feature.is_mutex_group():
        raise Exception(f'Feature {feature_name} is not a mutex group.')
    
    new_name = get_new_feature_name(fm, feature_name)

    f_p = Feature(name=new_name, parent=feature)

    r_opt = Relation(feature, [f_p], 0, 1)  # optional

    r_mutex = next((r for r in feature.get_relations() if r.is_mutex()), None)
    r_mutex.parent = f_p
    r_mutex.card_min = 1
    
    for child in r_mutex.children:
        child.parent = f_p

    feature.get_relations().remove(r_mutex)

    # Add relations to features
    feature.add_relation(r_opt)
    f_p.add_relation(r_mutex)
    return fm




def transform_cardinality(fm: FeatureModel, feature_name: str) -> FeatureModel:
    """Given a feature model, refactor the cardinality group specified by its name."""
    feature = fm.get_feature_by_name(feature_name)

    if feature is None:
        raise Exception(f'There is not feature with name "{feature_name}".')
    if not feature.is_cardinality_group:
        raise Exception(f'Feature {feature_name} is not a cardinality group.')
    
    r_card = next((r for r in feature.get_relations() if r.is_cardinal()), None)

    for child in r_card.children:
        r_opt = Relation(feature, [child], 0, 1)
        feature.add_relation(r_opt)

    feature.get_relations().remove(r_card)
    constraints = get_constraints_from_card(feature, r_card.card_min, r_card.card_max)

    fm.ctcs = constraints

    return fm


def is_mult_group_decomposition() -> bool:
    pass

def transform_mult_group_decomposition() -> FeatureModel:
    pass

# se coge como en el next pero es uno que se llama sum para que me devuelva cuántos hay
# hacemos un método auxiliar para preguntar si es multiple group decomposition y ahí vamos comprobando






def main():
    fm = get_case1()
    fm2 = get_case2()
    fm3 = get_case3()
    fm4 = get_case3()
    fm5 = get_case5()

    print('CASE 1')
    print(fm)
    fm = transform_mutex(fm, 'F')
    print('----------------------------------------')
    print(fm)

    print('----------------------------------------------------------------')

    print('CASE 2')
    print(fm2)
    fm2 = transform_mutex(fm2, 'Root')
    print('----------------------------------------')
    print(fm2)

    print('----------------------------------------------------------------')

    print('CASE 3')
    print(fm3)
    fm3 = transform_mutex(fm3, 'Root')
    print('----------------------------------------')
    print(fm3)
    fm3 = transform_mutex(fm3, 'F2')
    print('----------------------------------------')
    print(fm3)

    print('CASE 4')
    print(fm4)
    fm4 = transform_mutex(fm4, 'F2')
    print('----------------------------------------')
    print(fm4)
    fm4 = transform_mutex(fm4, 'Root')
    print('----------------------------------------')
    print(fm4)

    print('----------------------------------------------------------------')

    print('CASE 5')
    print(fm5)
    fm5 = transform_cardinality(fm5, 'Root')
    print('----------------------------------------')
    print(fm5)



if __name__ == '__main__':
    main()



import itertools
import functools
from typing import List
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



def get_case6() -> FeatureModel:
    # Create features
    feature_root = Feature(name='Root')
    f1 = Feature(name='F1', parent=feature_root)
    f2 = Feature(name='F2', parent=feature_root)
    f3 = Feature(name='F3', parent=feature_root)
    f4 = Feature(name='F4', parent=feature_root)
    f5 = Feature(name='F5', parent=feature_root)
    f6 = Feature(name='F6', parent=feature_root)

    # Create relations
    r1 = Relation(feature_root, [f1, f2, f3], 1, 3)  # or
    r2 = Relation(feature_root, [f4, f5, f6], 1, 1)  # xor

    # Add relations to features
    feature_root.add_relation(r1)
    feature_root.add_relation(r2)

    # Create the feature model
    fm = FeatureModel(root=feature_root)
    return fm



def factorial(n: int) -> int:
    if n<0:
        raise Exception(f'"{n}" must be greater than 0.')
    return 1 if (n==1 or n==0) else n*factorial(n-1)

def combinatorics(card_min: int, card_max: int) -> int:
    return factorial(card_max)/(factorial(card_max - card_min)*factorial(card_min))

def iter_combinations(n: int, card_max: int) -> int:
    if n < card_max:
        n += 1
    return n

def set_combinations(m: int, card_min: int, card_max: int) -> int:
    if m < combinatorics(card_min, card_max):
        m += 1
    return m


def lists(l: List, n: int, m: int, card_min:int, card_max: int) -> List:
    result =[]
    positives = list(itertools.combinations(l, iter_combinations(n, card_max)))  # n va desde card_min hasta card_max
    negatives = set(l) - set(positives[set_combinations(m, card_min, card_max)])  # m va recorriendo los índices desde cero hasta combinatorics(card_min, card_max)
    for node in l:
        if node in positives:
            result.append(Node(node))
        elif node in negatives:
            result.append(AST.create_unary_operation(ASTOperation.NOT, node).root)
    return result


def create_and_constraint_for_cardinality_group(positives: list[Feature], negatives: list[Feature]) -> AST:
    elements = [Node(f.name) for f in positives]
    elements += [AST.create_unary_operation(ASTOperation.NOT, Node(f.name)).root for f in negatives]
    functools.reduce()
    left = next((child for child in l), None)
    l.pop(l.index(left))
    right = each_tree(l, card_min, card_max)
    return AST.create_binary_operation(ASTOperation.AND, left, right).root


def get_or_constraints_for_cardinality_group(feature: Feature, relation: Relation) -> Node:
    card_min = relation.card_min
    card_max = relation.card_max
    children = set(relation.children)
    for k in range(card_min, card_max + 1):
        combi_k = list(itertools.combinations(relation.children, k))
        for positives in combi_k:
            negatives = children - set(positives)
            and_ctc = create_and_constraint_for_cardinality_group(positives, negatives)

    return AST.create_binary_operation(ASTOperation.OR,
                                        create_and_constraint_for_cardinality_group(lists(feature.get_children(), card_min, card_max), card_min, card_max),
                                        get_or_constraints_for_cardinality_group(feature, card_min, card_max)).root


def get_constraint_for_cardinality_group(feature: Feature, relation: Relation) -> Constraint:
    

    or_ctc = get_or_constraints_for_cardinality_group(feature, relation)
    return AST.create_binary_operation(ASTOperation.IMPLIES,
                                        feature.name,
                                        or_ctc).root





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
    r_mutex.card_min = 1  # xor
    
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
        r_opt = Relation(feature, [child], 0, 1)  # optional
        feature.add_relation(r_opt)

    feature.get_relations().remove(r_card)

    constraint = get_constraint_for_cardinality_group(feature, r_card)

    fm.ctcs = constraints

    return fm




def is_mult_group_decomposition(feature: Feature) -> bool:
    is_mgd = False
    suma = [r for r in feature.get_children() if feature.is_group()]
    if len(suma)>1:
        is_mgd = True
    return is_mgd


def new_decomposition(fm: FeatureModel, feature: Feature, r_group: Relation) -> FeatureModel:
    new_name = get_new_feature_name(fm, feature.name)
    f_p = Feature(name=new_name, parent=feature, is_abstract=True)
    r_mand = Relation(feature, [f_p], 1, 1)  # mandatory
    feature.add_relation(r_mand)
    
    r_group.parent = f_p

    for child in r_group.children:
        child.parent = f_p

    # Add relations to features
    f_p.add_relation(r_group)

    feature.get_relations().remove(r_group)

    return fm


def transform_mult_group_decomposition(fm: FeatureModel, feature_name: str) -> FeatureModel:
    """Given a feature model, refactor the multiple group decomposition specified by its name."""
    feature = fm.get_feature_by_name(feature_name)

    if feature is None:
        raise Exception(f'There is not feature with name "{feature_name}".')
    if not is_mult_group_decomposition(feature):
        raise Exception(f'Feature {feature_name} is not a multiple group decomposition.')


    relations = [r for r in feature.get_relations()]
    for r in relations:
        if r.is_group():
            fm = new_decomposition(fm, feature, r)


    return fm




def main():
    fm = get_case1()
    fm2 = get_case2()
    fm3 = get_case3()
    fm4 = get_case3()
    fm5 = get_case5()
    fm6 = get_case6()

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

    print('----------------------------------------------------------------')

    print('CASE 6')
    print(fm6)
    fm6 = transform_mult_group_decomposition(fm6, 'Root')
    print('----------------------------------------')
    print(fm6)



if __name__ == '__main__':
    main()


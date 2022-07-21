
import itertools
import functools
from logging import root
from typing import List
from xmlrpc.client import Boolean
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

    # Create relations
    rel = Relation(feature_root, [f1, f2, f3], 2, 3)  # cardinality

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



def get_case7() -> FeatureModel:  #Complex prop. log. cross-tree constraint
    # Create features
    feature_root = Feature(name='Root')

    # Create constraints
    left = AST.create_binary_operation(ASTOperation.OR, Node('Format1'), Node('Routing')).root
    ctc = AST.create_binary_operation(ASTOperation.IMPLIES, left, Node('5G')).root

    # Add relations to features


    # Create the feature model
    fm = FeatureModel(root=feature_root)
    return fm



# OR + Mandatory
def get_case8() -> FeatureModel:
    # Create features
    feature_root = Feature(name='Root')
    f1 = Feature(name='F1', parent=feature_root)
    f2 = Feature(name='F2', parent=feature_root)
    f3 = Feature(name='F3', parent=feature_root)
    # Create relations
    r1 = Relation(feature_root, [f1, f2, f3], 1, 3)  # or
    r2 = Relation(feature_root, [f3], 1, 1)  # mandatory

    # Add relations to features
    feature_root.add_relation(r1)
    feature_root.add_relation(r2)

    # Create the feature model
    fm = FeatureModel(root=feature_root)
    return fm



# XOR + Mandatory
def get_case9() -> FeatureModel:
    # Create features
    feature_root = Feature(name='Root')
    f1 = Feature(name='F1', parent=feature_root)
    f2 = Feature(name='F2', parent=feature_root)
    f3 = Feature(name='F3', parent=feature_root)
    # Create relations
    r1 = Relation(feature_root, [f1, f2, f3], 1, 1)  # xor
    r2 = Relation(feature_root, [f3], 1, 1)  # mandatory

    # Add relations to features
    feature_root.add_relation(r1)
    feature_root.add_relation(r2)

    # Create the feature model
    fm = FeatureModel(root=feature_root)
    return fm




# OR + Mandatory
def get_case10() -> FeatureModel:
    # Create features
    feature_root = Feature(name='Root')
    f1 = Feature(name='F1', parent=feature_root)
    f2 = Feature(name='F2', parent=feature_root)
    f3 = Feature(name='F3', parent=feature_root)
    # Create relations
    r1 = Relation(feature_root, [f1, f2, f3], 1, 3)  # or
    r2 = Relation(feature_root, [f2], 1, 1)  # mandatory
    r3 = Relation(feature_root, [f3], 1, 1)  # mandatory

    # Add relations to features
    feature_root.add_relation(r1)
    feature_root.add_relation(r2)
    feature_root.add_relation(r3)

    # Create the feature model
    fm = FeatureModel(root=feature_root)
    return fm



# XOR + Mandatory
def get_case11() -> FeatureModel:
    # Create features
    feature_root = Feature(name='Root')
    f1 = Feature(name='F1', parent=feature_root)
    f2 = Feature(name='F2', parent=feature_root)
    f3 = Feature(name='F3', parent=feature_root)
    # Create relations
    r1 = Relation(feature_root, [f1, f2, f3], 1, 1)  # xor
    r2 = Relation(feature_root, [f2], 1, 1)  # mandatory
    r3 = Relation(feature_root, [f3], 1, 1)  # mandatory

    # Add relations to features
    feature_root.add_relation(r1)
    feature_root.add_relation(r2)
    feature_root.add_relation(r3)

    # Create the feature model
    fm = FeatureModel(root=feature_root)
    return fm



# XOR + Mandatory
def get_case12() -> FeatureModel:
    # Create features
    feature_root = Feature(name='Root')
    f1 = Feature(name='F1', parent=feature_root)
    f2 = Feature(name='F2', parent=feature_root)
    # Create relations
    r1 = Relation(feature_root, [f1, f2], 1, 1)  # xor
    r2 = Relation(feature_root, [f2], 1, 1)  # mandatory

    # Add relations to features
    feature_root.add_relation(r1)
    feature_root.add_relation(r2)

    # Create the feature model
    fm = FeatureModel(root=feature_root)
    return fm



# XOR + Mandatory
def get_caseBC4() -> FeatureModel:
    # Create features
    feature_root = Feature(name='Root')
    f1 = Feature(name='F1', parent=feature_root)
    f2 = Feature(name='F2', parent=feature_root)
    f3 = Feature(name='F3', parent=feature_root)
    f1a = Feature(name='F1a', parent=f1)
    f1b = Feature(name='F1b', parent=f1)
    f1c = Feature(name='F1c', parent=f1)
    f2a = Feature(name='F2a', parent=f2)
    f2a1 = Feature(name='F2a1', parent=f2a)
    f2a2 = Feature(name='F2a2', parent=f2a)
    f2a3 = Feature(name='F2a3', parent=f2a)
    # Create relations
    r1 = Relation(feature_root, [f1], 0, 1)  # optional
    r2 = Relation(feature_root, [f2], 1, 1)  # mandatory
    r3 = Relation(feature_root, [f3], 1, 1)  # mandatory
    r11 = Relation(f1, [f1a, f1b, f1c], 1, 1)  # xor
    r11mand = Relation(f1, [f1c], 1, 1)  # mandatory
    r2mand = Relation(f2, [f2a], 1, 1)  # mandatory
    r2xor = Relation(f2a, [f2a1, f2a2, f2a3], 1, 1)  # xor
    r21mand = Relation(f2a, [f2a3], 1, 1)  # mandatory

    # Add relations to features
    feature_root.add_relation(r1)
    feature_root.add_relation(r2)
    feature_root.add_relation(r3)
    feature_root.add_relation(r11)
    feature_root.add_relation(r11mand)
    feature_root.add_relation(r2mand)
    feature_root.add_relation(r2xor)
    feature_root.add_relation(r21mand)

    # Create the feature model
    fm = FeatureModel(root=feature_root)
    return fm






















# def factorial(n: int) -> int:
#     if n<0:
#         raise Exception(f'"{n}" must be greater than 0.')
#     return 1 if (n==1 or n==0) else n*factorial(n-1)

# def combinatorics(card_min: int, card_max: int) -> int:
#     return factorial(card_max)/(factorial(card_max - card_min)*factorial(card_min))

# def iter_combinations(n: int, card_max: int) -> int:
#     if n < card_max:
#         n += 1
#     return n

# def set_combinations(m: int, card_min: int, card_max: int) -> int:
#     if m < combinatorics(card_min, card_max):
#         m += 1
#     return m


# def lists(l: List, n: int, m: int, card_min:int, card_max: int) -> List:
#     result =[]
#     positives = list(itertools.combinations(l, iter_combinations(n, card_max)))  # n va desde card_min hasta card_max
#     negatives = set(l) - set(positives[set_combinations(m, card_min, card_max)])  # m va recorriendo los índices desde cero hasta combinatorics(card_min, card_max)
#     for node in l:
#         if node in positives:
#             result.append(Node(node))
#         elif node in negatives:
#             result.append(AST.create_unary_operation(ASTOperation.NOT, node).root)
#     return result


def create_and_constraint_for_cardinality_group(positives: list[Feature], negatives: list[Feature]) -> Node:
    elements = [Node(f.name) for f in positives]
    elements += [AST.create_unary_operation(ASTOperation.NOT, Node(f.name)).root for f in negatives]
    return functools.reduce(lambda left, right: Node(ASTOperation.AND, left, right), elements)


def get_or_constraints_for_cardinality_group(feature: Feature, relation: Relation) -> Node:
    card_min = relation.card_min
    card_max = relation.card_max
    children = set(relation.children)
    and_nodes = []
    for k in range(card_min, card_max + 1):
        print(f'K: {k}')
        combi_k = list(itertools.combinations(relation.children, k))
        print(f'combi_k: {[str(f) for f in combi_k]}')
        for positives in combi_k:
            print(f'Posities: {[str(f) for f in positives]}')
            negatives = children - set(positives)
            print(f'Negatives: {[str(f) for f in negatives]}')
            and_ctc = create_and_constraint_for_cardinality_group(positives, negatives)
            print(f'Node: {and_ctc}')
            and_nodes.append(and_ctc)
            print('---')
        print(f'Fin K {k}')
    return functools.reduce(lambda left, right: Node(ASTOperation.OR, left, right), and_nodes)

def get_constraint_for_cardinality_group(feature: Feature, relation: Relation) -> Constraint:
    ast = AST.create_binary_operation(ASTOperation.IMPLIES,
                                      Node(feature.name),
                                      get_or_constraints_for_cardinality_group(feature, relation))
    print(f'AST: {ast.pretty_str()}')
    return Constraint('CG', ast)


def get_new_feature_name(fm: FeatureModel, name: str) -> str:
    """Return a name for a new feature to be created based on the given feature name."""
    count = 1
    new_name = f'{name}_p'
    while fm.get_feature_by_name(new_name) is not None:
        new_name = f'{name}_p{count}'
        count += 1
    return new_name








def transform_complex_crosstree_constraint(fm: FeatureModel, feature_name: str, ctc: Constraint) -> FeatureModel:
    """Given a feature model, refactor the complex prop. log. cress-tree constraint."""
    feature = fm.get_feature_by_name(feature_name)

    if feature is None:
        raise Exception(f'There is not feature with name "{feature_name}".')
    if not feature.is_mutex_group():
        raise Exception(f'Feature {feature_name} is not a mutex group.')
    
    new_name = get_new_feature_name(fm, feature_name)

    f_p = Feature(name=new_name, parent=feature)

    ctc_nodes = ctc.get_features()

    r_mand = Relation(feature, [f_p], 1, 1)  # mandatory
    r_or = Relation(f_p, [c for c in ctc_nodes], 1, len(ctc_nodes))  #or

    ctc_nodes = ctc.get_features()
    
    for node in ctc_nodes:
        node.parent = f_p

    # Add relations to features
    feature.add_relation(r_mand)
    f_p.add_relation(r_or)
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
    print(f'Constraint: {constraint}')
    fm.ctcs.append(constraint)

    return fm




def is_there_mandatory(relations: List) -> bool:
    mandatory = False
    for rel in relations:
        if rel.is_mandatory:
            mandatory = True
    return mandatory


def transform_or_mandatory(fm: FeatureModel, feature_name: str) -> FeatureModel:
    """Given a feature model, refactor the or group with mandatory child specified by its name."""
    feature = fm.get_feature_by_name(feature_name)

    if feature is None:
        raise Exception(f'There is not feature with name "{feature_name}".')
    if not feature.is_or_group:
        raise Exception(f'Feature {feature_name} is not an or group.')
    if not is_there_mandatory(feature.get_relations()):
        raise Exception(f'Feature {feature_name} has no mandatory child.')

    r_or = next((r for r in feature.get_relations() if r.is_or()), None)

    for child in r_or.children:
        r_opt = Relation(feature, [child], 0, 1)  # optional
        feature.add_relation(r_opt)
        if child.is_mandatory():
            r_mand = next((r for r in feature.get_relations() if r.is_mandatory()), None)
            feature.get_relations().remove(r_opt)
            feature.get_relations().remove(r_mand)
            r_new_mand = Relation(feature, [child], 1, 1)  # mandatory
            feature.add_relation(r_new_mand)

    feature.get_relations().remove(r_or)

    return fm


def transform_xor_mandatory(fm: FeatureModel, feature_name: str) -> FeatureModel:
    """Given a feature model, refactor the xor group with mandatory child specified by its name."""
    feature = fm.get_feature_by_name(feature_name)

    if feature is None:
        raise Exception(f'There is not feature with name "{feature_name}".')
    if not feature.is_alternative_group:
        raise Exception(f'Feature {feature_name} is not a cardinality group.')
    
    r_alt = next((r for r in feature.get_relations() if r.is_alternative()), None)
    r_alt.card_min = 0
    r_alt.card_max = 0
    

    children_list = []
    count = 0
    for child in r_alt.children:
        if child.is_mandatory():
            count += 1
            r_mand = next((r for r in feature.get_relations() if r.is_mandatory()), None)
            feature.get_relations().remove(r_mand)
            r_new_mand = Relation(feature, [child], 1, 1)  # mandatory
            feature.add_relation(r_new_mand)
        else:
            children_list.append(child)

    if count>1:
         raise Exception(f'More mandatory children than expected.')

    feature.get_relations().remove(r_alt)

    if len(children_list)<=1:
        r_opt = Relation(feature, children_list, 0, 1)  # optional
        constraint = AST.create_unary_operation(ASTOperation.NOT, children_list[0]).root
        fm.ctcs.append(constraint)
    else:
        r_opt = Relation(feature, children_list, 0, 0)  # dead

    # Add relations to features
    feature.add_relation(r_opt)

    return fm















def main():
    fm = get_case1()
    fm2 = get_case2()
    fm3 = get_case3()
    fm4 = get_case3()
    fm5 = get_case5()
    fm6 = get_case6()
    fm7 = get_case7()
    fm8 = get_case8()
    fm9 = get_case9()
    fm10 = get_case10()
    fm11 = get_case11()
    fm12 = get_case12()
    fmBC4 = get_caseBC4()

    print('CASE 1: MUTEX')
    print(fm)
    fm = transform_mutex(fm, 'F')
    print('RESULT: ----------------------------------------')
    print(fm)

    print('----------------------------------------------------------------')

    print('CASE 2: MUTEX')
    print(fm2)
    fm2 = transform_mutex(fm2, 'Root')
    print('RESULT: ----------------------------------------')
    print(fm2)

    print('----------------------------------------------------------------')

    print('CASE 3: MUTEX')
    print(fm3)
    fm3 = transform_mutex(fm3, 'Root')
    print('RESULT: ----------------------------------------')
    print(fm3)
    fm3 = transform_mutex(fm3, 'F2')
    print('RESULT: ----------------------------------------')
    print(fm3)

    print('CASE 4: MUTEX')
    print(fm4)
    fm4 = transform_mutex(fm4, 'F2')
    print('----------------------------------------')
    print(fm4)
    fm4 = transform_mutex(fm4, 'Root')
    print('RESULT: ----------------------------------------')
    print(fm4)

    print('----------------------------------------------------------------')

    # print('CASE 5: CARDINALITY')
    # print(fm5)
    # fm5 = transform_cardinality(fm5, 'Root')
    # print('RESULT: ----------------------------------------')
    # print(fm5)

    # print('----------------------------------------------------------------')

    print('CASE 6: MULT. GROUP DECOMPOSITION')
    print(fm6)
    fm6 = transform_mult_group_decomposition(fm6, 'Root')
    print('RESULT: ----------------------------------------')
    print(fm6)

    print('----------------------------------------------------------------')

    # print('CASE 7: COMPLEX PROP. LOG. CROSS-TREE CONSTRAINT')
    # print(fm7)
    # fm7 = transform_complex_crosstree_constraint(fm7, 'Root')
    # print('RESULT: ----------------------------------------')
    # print(fm7)

    print('----------------------------------------------------------------')

    print('CASE 8: OR + MANDATORY')
    print(fm8)
    fm8 = transform_or_mandatory(fm8, 'Root')
    print('RESULT: ----------------------------------------')
    print(fm8)

    print('----------------------------------------------------------------')

    print('CASE 9: XOR + MANDATORY')
    print(fm9)
    fm9 = transform_xor_mandatory(fm9, 'Root')
    print('RESULT: ----------------------------------------')
    print(fm9)

    print('----------------------------------------------------------------')

    print('CASE 10: OR + MANDATORY')
    print(fm10)
    fm10 = transform_or_mandatory(fm10, 'Root')
    print('RESULT: ----------------------------------------')
    print(fm10)

    # print('----------------------------------------------------------------')

    # print('CASE 11: XOR + MANDATORY')
    # print(fm11)
    # fm11 = transform_xor_mandatory(fm11, 'Root')
    # print('RESULT: ----------------------------------------')
    # print(fm11)

    print('----------------------------------------------------------------')

    print('CASE 12: XOR + MANDATORY')
    print(fm12)
    fm12 = transform_xor_mandatory(fm12, 'Root')
    print('RESULT: ----------------------------------------')
    print(fm12)

    print('----------------------------------------------------------------')

    print('CASE BC4: XOR + MANDATORY')
    print(fmBC4)
    fmBC4 = transform_xor_mandatory(fmBC4, 'Root')
    print('RESULT: ----------------------------------------')
    print(fmBC4)






if __name__ == '__main__':
    main()


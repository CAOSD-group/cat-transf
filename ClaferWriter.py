from pyexpat import features, model
import re
from typing import List
from famapy.core.transformations import ModelToText
from famapy.core.models.ast import ASTOperation
from famapy.metamodels.fm_metamodel.models import FeatureModel, Feature, Relation, Constraint

class ClaferWriter(ModelToText):
    """Transform a feature model to a Clafer format."""

    @staticmethod
    def get_destination_extension() -> str:
        return '.txt'

    def __init__(self, path: str, source_model: FeatureModel) -> None:
        self.path = path
        self.source_model = source_model

    def transform(self) -> str:
        clafer_str = fm_to_clafer(self.source_model)
        with open(self.path, 'w', encoding='utf-8') as file:
            file.write(clafer_str)
        return clafer_str


def fm_to_clafer(feature_model: FeatureModel) -> str:

    #result = read_features(feature_model.root, '', -1)
    result = read_features2(feature_model.root, None, 0)
    for ctc in feature_model.get_constraints():
       result += read_constraints(ctc)
    return result

def read_features2(feature: Feature, parent: Feature, tab_count: int) -> str:
    result = ''
    group_type = ''

    # Parse group types
    if feature.is_alternative_group():
        group_type = 'xor'
    elif feature.is_or_group():
        group_type = 'or'
    elif feature.is_cardinality_group():
        rel = next((r for r in feature.get_relations() if r.is_cardinal()), None)
        group_type = str(rel.card_min) + ".." + str(rel.card_max)
    elif feature.is_mutex_group():
        group_type = 'mux'

    # Indentation
    tabs = '\t' * tab_count
    result += tabs

    if group_type:
        result += f'{group_type} '

    result += feature.name

    if feature.is_optional():
        result += ' ?'

    result += '\n'
    tab_count += 1
    for child in feature.get_children():
        result += read_features2(child, feature, tab_count)
    return result

def read_constraints(const: Constraint) -> str:
    result = ""
    constraint_text = serialize_constraint(const)
    result = "\n" + constraint_text
    return result

def serialize_constraint(ctc: Constraint) -> str:
    ctc = ctc.ast.pretty_str()
    ctc = re.sub(fr'\b{ASTOperation.NOT.value}\ \b', 'not', ctc)
    ctc = re.sub(fr'\b{ASTOperation.AND.value}\b', '&&', ctc)
    ctc = re.sub(fr'\b{ASTOperation.OR.value}\b', '||', ctc)
    ctc = re.sub(fr'\b{ASTOperation.IMPLIES.value}\b', '=>', ctc)
    ctc = re.sub(fr'\b{ASTOperation.EQUIVALENCE.value}\b', '<=>', ctc)
    ctc = re.sub(fr'\b{ASTOperation.REQUIRES.value}\b', '=>', ctc)
    ctc = re.sub(fr'\b{ASTOperation.EXCLUDES.value}\b', '=> not', ctc)
    return f'[{ctc}]'
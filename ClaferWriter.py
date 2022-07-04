from pyexpat import features
import re
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

    if group_type: #nos devuelve true si hay algo dentro y false si está vacío
        result += f'{group_type} '

    result += feature.name

    if feature.is_optional():
        result += ' ?'

    result += '\n'
    
    #result = f'{tabs} {group_type} {feature.name} {opt}\n' #hemos dado formato de string a una variable con f-string LO QUITAMOS
    tab_count += 1

    for child in feature.get_children():
        result += read_features2(child, feature, tab_count)
    return result


def serialize_relation(rel: Relation) -> str:
    result = ""

    if rel.is_alternative():
        result = "xor "
    elif rel.is_optional():
        result = str(rel.card_min) + ".." + str(rel.card_max) + " "
    elif rel.is_or():
        result = "or "
    return result

def read_constraints(self) -> str:
    result = "constraints"
    constraints = self.model.ctcs
    for constraint in constraints:
        constraint_text = self.serialize_constraint(constraint)
        result = result + "\n\t" + constraint_text

    return result

def serialize_constraint(ctc: Constraint) -> str:
    ctc = ctc.ast.pretty_str()
    ctc = re.sub(fr'\b{ASTOperation.NOT.value}\ \b', 'not', ctc)
    ctc = re.sub(fr'\b{ASTOperation.AND.value}\b', '&', ctc)
    ctc = re.sub(fr'\b{ASTOperation.OR.value}\b', '|', ctc)
    ctc = re.sub(fr'\b{ASTOperation.IMPLIES.value}\b', '=>', ctc)
    ctc = re.sub(fr'\b{ASTOperation.EQUIVALENCE.value}\b', '<=>', ctc)
    ctc = re.sub(fr'\b{ASTOperation.REQUIRES.value}\b', 'requires', ctc)
    ctc = re.sub(fr'\b{ASTOperation.EXCLUDES.value}\b', 'excludes', ctc)
    return f'[{ctc}]'













'''
def read_features(feature: Feature, result: str, tab_count: int) -> str:
    tab_count = tab_count + 1
    result = result + "\n" + tab_count * "\t" + feature.name
    tab_count = tab_count + 1
    for relation in feature.relations:
        relation_name = serialize_relation(relation)
        result = result + "\n" + tab_count * "\t" + relation_name
        for feature_node in relation.children:
            result = read_features(feature_node, result, tab_count)
    return result

def serialize_relation(rel: Relation) -> str:
    result = ""

    if rel.is_alternative():
        result = "alternative"
    elif rel.is_mandatory():
        result = "mandatory"
    elif rel.is_optional():
        result = "optional"
    elif rel.is_or():
        result = "or"
    else:
        min_value = rel.card_min
        max_value = rel.card_max
        if min_value == max_value:
            result = "[" + str(min) + "]"
        else:
            result = "[" + str(min) + ".." + str(max) + "]"

    return result

def read_constraints(self) -> str:
    result = "constraints"
    constraints = self.model.ctcs
    for constraint in constraints:
        constraint_text = self.serialize_constraint(constraint)
        result = result + "\n\t" + constraint_text

    return result

def serialize_constraint(ctc: Constraint) -> str:
    ctc = ctc.ast.pretty_str()
    ctc = re.sub(fr'\b{ASTOperation.NOT.value}\ \b', '!', ctc)
    ctc = re.sub(fr'\b{ASTOperation.AND.value}\b', '&', ctc)
    ctc = re.sub(fr'\b{ASTOperation.OR.value}\b', '|', ctc)
    ctc = re.sub(fr'\b{ASTOperation.IMPLIES.value}\b', '=>', ctc)
    ctc = re.sub(fr'\b{ASTOperation.EQUIVALENCE.value}\b', '<=>', ctc)
    ctc = re.sub(fr'\b{ASTOperation.REQUIRES.value}\b', 'requires', ctc)
    ctc = re.sub(fr'\b{ASTOperation.EXCLUDES.value}\b', 'excludes', ctc)
    return ctc


'''




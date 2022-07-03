from famapy.core.transformations import ModelToText

from famapy.metamodels.fm_metamodel.models import FeatureModel


class FMToCategories(ModelToText):
    """Transform a feature model to a category theory (CT) formalization.
    
    CT is specified in a .cql file that is the input of the CT solver.
    """

    @staticmethod
    def get_destination_extension() -> str:
        return '.cql'

    def __init__(self, path: str, source_model: FeatureModel) -> None:
        self.path = path
        self.source_model = source_model

    def transform(self) -> str:
        ct_str = fm_to_categories(self.source_model)
        with open(self.path, 'w', encoding='utf-8') as file:
            file.write(ct_str)


def fm_to_categories(feature_model: FeatureModel) -> str:
    pass
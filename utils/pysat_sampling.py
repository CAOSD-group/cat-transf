from typing import Any, cast, Optional

from pysat.solvers import Solver

from flamapy.core.models import VariabilityModel
from flamapy.core.operations import Sampling
from flamapy.metamodels.configuration_metamodel.models.configuration import Configuration
from flamapy.metamodels.pysat_metamodel.models.pysat_model import PySATModel


class PySATSampling(Sampling):

    def __init__(self) -> None:
        self.products: list[list[Any]] = []
        self.solver = Solver(name='glucose3')

    def sample(self, size: int, with_replacement: bool = False,
              partial_configuration: Optional[Configuration] = None) -> list[list[Any]]:
        return sample(self.solver, self.sat_model, size)

    def set_size(self, size: int) -> None:
        self.sample_size = size

    def get_result(self) -> list[list[Any]]:
        return self.result

    def execute(self, model: VariabilityModel) -> 'PySATSampling':
        self.sat_model = model
        self.result = sample(self.solver, self.sat_model, self.sample_size)
        return self


def sample(solver: Solver,
           sat_model: PySATModel, 
           size: int, 
           with_replacement: bool = False,
           partial_configuration: Optional[Configuration] = None) -> list[list[Any]]:
    model = cast(PySATModel, sat_model)

    for clause in model.get_all_clauses():  # AC es conjunto de conjuntos
        solver.add_clause(clause)  # añadimos la constraint

    products = []
    for solutions in solver.enum_models():
        product = []
        for variable in solutions:
            if variable > 0:
                product.append(model.features.get(variable))
        products.append(product)
        if len(products) == size:
            solver.delete()
            return products
    solver.delete()
    return products
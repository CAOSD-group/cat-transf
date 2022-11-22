# File name: VNS.cql
# (Copyright) Author: anonymousresearxer
# Date created: 25/04/2022
# Version: CQL IDE 5/2021 + Java JDK 18.0.1
# Description: Virtual Network System SPL modelled in CQL

# IDE options, we activate aggregation although is not functorial, it is needed when merging tree traces
options
	allow_aggregation_unsafe = true

# Basic datatype objects and reusable functorial arrows
typeside Ty = literal {
  external_types
    String -> "java.lang.String"
    Bool -> "java.lang.Boolean"
    Integer -> "java.lang.Integer"
  external_parsers
    String -> "x => x"
    Bool -> "x => java.lang.Boolean.parseBoolean(x)"
    Integer -> "parseInt"
  external_functions
    # Variability comparisons
    eq : String, String -> Bool = "(x, y) => (x == y)"
    not : String, String -> Bool = "(x, y) => (x != y)"

    # Boolean operators
    and : Bool, Bool -> Bool = "(x, y) => (x && y)"
    or : Bool, Bool -> Bool = "(x, y) => (x || y)"
    diff : Bool, Bool -> Bool = "(x, y) => (x != y)"

    # Integer operators
    ieq : Integer, Integer -> Bool = "(x, y) => (x == y)"  
    ge : Integer, Integer -> Bool = "(x, y) => (x > y)"
    geq : Integer, Integer -> Bool = "(x, y) => (x >= y)"
    le : Integer, Integer -> Bool = "(x, y) => (x < y)"
    leq : Integer, Integer -> Bool = "(x, y) => (x <= y)"
}

# Category 
schema VariabilityModelCategory = literal : Ty {
  #Objects
  entities
    Feature    # Olog of the Variability Model
  
  #Functorial Relation Arrows
  foreign_keys
    parent       : Feature -> Feature # Hierarchichal Feature Relation
  
  #Non-Functional Relation and Elements Arrows
  attributes
    # Traditional Boolean Variability Model Arrows
    name          : Feature -> String     # Feature Name
    cardinality  : Feature -> String # Children cardinality ([x..y] OR leaf)
    optionality  : Feature -> Bool

    # Numerical Variability Model Arrows
    domain       : Feature -> String      # Feature Domain (Boolean by default, else Bytes, Metres or whatever)
    value        : Feature -> Integer     # Numerical Feature Value

    # Attributed Variability Model Arrow
    {% for attribute in feature_attributes_dict %}
    {{attribute.name}}: Feature -> {{attribute.type}}
    {% endfor %}
}


# Variability Model Data
instance VariabilityModelData = literal : VariabilityModelCategory {
  #Individual instances
  generators 
    {{features_list}} : Feature

  equations
  # Boolean features
    {% for feature in features_dict %}
    name({{feature.id}}) = {{feature.name}} cardinality({{feature.id}}) = {{feature.cardinality}} optionality({{feature.id}}) = {{feature.optionality}} parent({{feature.id}}) = {{feature.parent}}
    {% for attribute in feature.attributes %}
      {{attribute.name}}({{feature.id}}) = {{attribute.value}}
    {% endfor %}
    {% endfor %}

  # Numerical features
    {% for feature in numerical_features_dict %}
      {% for value in feature.values %}
    name({{feature.id}}) = {{feature.name}} cardinality({{feature.id}}) = {{feature.cardinality}} optionality({{feature.id}}) = {{feature.optionality}} parent({{feature.id}}) = {{feature.parent}} domain({{feature.id}}) = {{feature.domain}} value({{feature.id}}) = {{value}}
      {% for attribute in feature.attributes %}
        {{attribute.name}}({{feature.id}}) = {{attribute.value}}
      {% endfor %}
      {% endfor %}
    {% endfor %}
}
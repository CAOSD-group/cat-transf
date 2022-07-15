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
 external_parsers
  String -> "x => x"
  Bool -> "x => java.lang.Boolean.parseBoolean(x)"
 external_functions
  eq : String, String -> Bool = "(x, y) => (x == y)"
  not : String, String -> Bool = "(x, y) => (x != y)"

  and : Bool, Bool -> Bool = "(x, y) => (x && y)"
  or : Bool, Bool -> Bool = "(x, y) => (x || y)"
  diff : Bool, Bool -> Bool = "(x, y) => (x != y)"
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
  #Extended Numerical Variability Model Arrows
  name          : Feature -> String     # Feature Name
  #domain       : Feature -> String      # Feature Domain (Boolean by default, else Bytes, Metres or whatever)
  #value        : Feature -> Integer      # Numerical Feature Value
  cardinality  : Feature -> String # Children cardinality ([x..y] OR leaf)
  optionality  : Feature -> Bool
}

# Variability Model Data
instance VariabilityModelData = literal : VariabilityModelCategory {
 #Individual instances
 generators 
  {{features_list}} : Feature

 equations
  # Populate instances
  {% for feature in features_dict %}
  name({{feature.id}}) = {{feature.name}} cardinality({{feature.id}}) = {{feature.cardinality}} optionality({{feature.id}}) = {{feature.optionality}} parent({{feature.id}}) = {{feature.parent}}
  {% endfor %}
}
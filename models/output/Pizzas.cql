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
  f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 : Feature

 equations
  # Populate instances
  
  name(f1) = Pizza cardinality(f1) = all optionality(f1) = false parent(f1) = f1
  
  name(f2) = CheesyCrust cardinality(f2) = leaf optionality(f2) = true parent(f2) = f1
  
  name(f3) = Dough cardinality(f3) = xor optionality(f3) = false parent(f3) = f1
  
  name(f4) = Sicilian cardinality(f4) = leaf optionality(f4) = false parent(f4) = f3
  
  name(f5) = Neapolitan cardinality(f5) = leaf optionality(f5) = false parent(f5) = f3
  
  name(f6) = Size cardinality(f6) = xor optionality(f6) = false parent(f6) = f1
  
  name(f7) = Big cardinality(f7) = leaf optionality(f7) = false parent(f7) = f6
  
  name(f8) = Normal cardinality(f8) = leaf optionality(f8) = false parent(f8) = f6
  
  name(f9) = Topping cardinality(f9) = or optionality(f9) = false parent(f9) = f1
  
  name(f10) = Mozzarella cardinality(f10) = leaf optionality(f10) = false parent(f10) = f9
  
  name(f11) = Ham cardinality(f11) = leaf optionality(f11) = false parent(f11) = f9
  
  name(f12) = Salami cardinality(f12) = leaf optionality(f12) = false parent(f12) = f9
  
}
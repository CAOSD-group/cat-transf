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
  # Classic Variability Model Arrows
  name          : Feature -> String     # Feature Name
  cardinality  : Feature -> String      # Children cardinality ([x..y] OR leaf)
  optionality  : Feature -> Bool
  # Numerical Variability Model Arrows
  domain       : Feature -> String      # Feature Domain (Boolean by default, else Bytes, Metres or whatever)
  value        : Feature -> Integer     # Numerical Feature Value
  # Attributed Variability Model Arrow
  cost         : Feature -> Integer     # Integer Feature Attribute
  vegan        : Feature -> Bool     # Boolean Feature Attribute
  provider     : Feature -> String      # String Feature Attribute
}

# Variability Model Data
instance VariabilityModelData = literal : VariabilityModelCategory {
 #Individual instances
 generators 
  f1 f2 f3 f4 f5 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15: Feature

 equations
  # Populate instances
  name(f1) = Pizza cardinality(f1) = all optionality(f1) = false parent(f1) = f1
  name(f2) = Topping cardinality(f2) = or optionality(f2) = false parent(f2) = f2
  name(f3) = Size cardinality(f3) = xor optionality(f3) = false parent(f3) = f3
  name(f4) = Dough cardinality(f4) = xor optionality(f4) = false parent(f4) = f4
  name(f5) = CheesyCrust cardinality(f5) = leaf optionality(f5) = true parent(f5) = f5 cost(f5) = 10 vegan(f5) = true provider(f5) = Amazon
  name(f6) = Salami cardinality(f6) = leaf optionality(f6) = false parent(f6) = f2 cost(f6) = 20 vegan(f6) = false provider(f6) = Amazon
  name(f7) = Ham cardinality(f7) = leaf optionality(f7) = false parent(f7) = f2 cost(f7) = 5 vegan(f7) = false provider(f7) = Dia
  name(f8) = Mozzarella cardinality(f8) = leaf optionality(f8) = false parent(f8) = f2 cost(f8) = 9 vegan(f8) = true provider(f8) = Mercadona
  name(f9) = Normal cardinality(f9) = leaf optionality(f9) = false parent(f9) = f3 cost(f9) = 40 vegan(f9) = true provider(f9) = Carrefour
  name(f10) = Big cardinality(f10) = lef optionality(f10) = false parent(f10) = f3 cost(f10) = 100 vegan(f10) = true provider(f10) = Amazon
  name(f11) = Neapolitan cardinality(f11) = leaf optionality(f11) = false parent(f11) = f4 cost(f11) = 90 vegan(f11) = true provider(f11) = Eroski
  name(f12) = Sicilian cardinality(f12) = leaf optionality(f12) = false parent(f12) = f4 cost(f12) = 1 vegan(f12) = true provider(f12) = Amazon

  # Numerical Feature Example
  name(f13) = Salt cardinality(f13) = leaf domain(f13) = Drops value(f13) = 1 optionality(f13) = false parent(f13) = f1 cost(f13) = 0 vegan(f13) = true provider(f13) = Josemi
  name(f14) = Salt cardinality(f14) = leaf domain(f14) = Drops value(f14) = 2 optionality(f14) = false parent(f14) = f1 cost(f14) = 0 vegan(f14) = true provider(f14) = Josemi
  name(f15) = Salt cardinality(f15) = leaf domain(f15) = Drops value(f15) = 3 optionality(f15) = false parent(f15) = f1 cost(f15) = 0 vegan(f15) = true provider(f15) = Josemi
}

# Result Category for reasoning operations that generate configurations
schema ConfigurationSpaceCategory = literal : Ty {
 entities
  Product 
 attributes
  r1 r2 r3: Product -> String
}

# Reasoning Operation Definition
query ListAll = literal : VariabilityModelCategory -> ConfigurationSpaceCategory {
 entity 
  Product -> {
   from
    f1 f2 f3 : Feature
   where
    f1.cardinality = leaf
    f2.cardinality = leaf
    f3.cardinality = leaf
    not(f1.name, f2.name) = true not(f2.name, f3.name) = true not(f1.name, f3.name) = true
   attributes
    r1 -> f1.name
    r2 -> f2.name
    r3 -> f3.name
  }
}

# Reasoning Execution (Populate Category B based on manipulating Category A data)
instance ListAllData = eval ListAll VariabilityModelData

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
    cost: Feature -> Double
    vegan: Feature -> Bool
    provider: Feature -> String
    
}


# Variability Model Data
instance VariabilityModelData = literal : VariabilityModelCategory {
  #Individual instances
  generators 
    f1 nf1 nf2 nf3 nf4 nf5 nf6 nf7 nf8 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 : Feature

  equations
  # Boolean features
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
      cost(f10) = 1.25
      vegan(f10) = true
      provider(f10) = Lidl
    
     name(f11) = Ham cardinality(f11) = leaf optionality(f11) = false parent(f11) = f9
      cost(f11) = 1.0
      vegan(f11) = false
      provider(f11) = Aldi
    
     name(f12) = Salami cardinality(f12) = leaf optionality(f12) = false parent(f12) = f9
      cost(f12) = 1.5
      vegan(f12) = false
      provider(f12) = Aldi
    
    

  # Numerical features
  
  name(nf1) = Pepper cardinality(nf1) = leaf optionality(nf1) = true parent(nf1) = f1 domain(nf1) = Integer value(nf1) = 1
   cost(nf1) = 0
   vegan(nf1) = true
   provider(nf1) = Mercadona
  
  
  name(nf2) = Pepper cardinality(nf2) = leaf optionality(nf2) = true parent(nf2) = f1 domain(nf2) = Integer value(nf2) = 2
   cost(nf2) = 0
   vegan(nf2) = true
   provider(nf2) = Mercadona
  
  
  name(nf3) = Pepper cardinality(nf3) = leaf optionality(nf3) = true parent(nf3) = f1 domain(nf3) = Integer value(nf3) = 3
   cost(nf3) = 0
   vegan(nf3) = true
   provider(nf3) = Mercadona
  
  
  name(nf4) = Pepper cardinality(nf4) = leaf optionality(nf4) = true parent(nf4) = f1 domain(nf4) = Integer value(nf4) = 4
   cost(nf4) = 0
   vegan(nf4) = true
   provider(nf4) = Mercadona
  
  
  name(nf5) = Pepper cardinality(nf5) = leaf optionality(nf5) = true parent(nf5) = f1 domain(nf5) = Integer value(nf5) = 5
   cost(nf5) = 0
   vegan(nf5) = true
   provider(nf5) = Mercadona
  
  
  name(nf6) = Salt cardinality(nf6) = leaf optionality(nf6) = true parent(nf6) = f1 domain(nf6) = Integer value(nf6) = 1
   cost(nf6) = 0
   vegan(nf6) = true
   provider(nf6) = Mercadona
  
  
  name(nf7) = Salt cardinality(nf7) = leaf optionality(nf7) = true parent(nf7) = f1 domain(nf7) = Integer value(nf7) = 3
   cost(nf7) = 0
   vegan(nf7) = true
   provider(nf7) = Mercadona
  
  
  name(nf8) = Salt cardinality(nf8) = leaf optionality(nf8) = true parent(nf8) = f1 domain(nf8) = Integer value(nf8) = 5
   cost(nf8) = 0
   vegan(nf8) = true
   provider(nf8) = Mercadona
  
  
}
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

    concat : String, Integer, String -> String = "(x, y, z) => (x + ' = ' + y.toString() + ' ' + z)"
    regconcat : String, String -> String = "(x, y) => (x + ' & ' + y)"
    ifi : Bool, String, String -> String = "(x,a,b) => x ? a : b"
  
    trace2 : String, String, String, String, String -> String = "(a, b, c, d, e) => (a + ' -->(' + b + ') ' + c + ' -->(' + d + ') ' + e)"
    itrace2 : String, String, String, String, String, Integer, String -> String = "(a, b, c, d, e, f, g) => (a + ' -->(' + b + ') ' + c + ' -->(' + d + ') ' + e + ' = ' + f.toString() + ' ' + g)"
  
}

# Category 
schema VariabilityModelCategory = literal : Ty {
  #Objects
  entities
    Feature    # Olog of the Variability Model

  # Variant-wise Entities
  Qn # Quality Name
  Qv # Quality Value
  Qd # Quality Domain
  Qs # (Qn,Qv,Qd) Quality Model
  
  # VM-QM Linkage entities
  CCs # Features forming a complete configuration
  QAs # Sets of QAs
  QMC # Span relating CCs with a set of QAs
  
  #Functorial Relation Arrows
  foreign_keys
    parent       : Feature -> Feature # Hierarchichal Feature Relation
  
  # Quality Model
  #parent : Qs -> Qs
  name        : Qs -> Qn
  value       : Qs -> Qv
  domain      : Qs -> Qd

  # VM-QM Linkages 
  feature     : CCs -> Feature # Features belonging to a Complete Configuration
  qualities   : QAs -> Qs # Sets of valued Quality Attributes.
  
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
    
  
  # Quality Model Arrows
  name        : Qn -> String  # Quality Name
  value       : Qv -> String # Quality Numerical Value
  domain      : Qd -> String  # Quality Domain
  
  # IDs for one to many relationship
  id          : CCs -> Integer #Identify each Complete Configuration
  id          : QAs -> Integer #Identify each set of Valued Qualities
  
  # QMC SPAN (binary relation between CCs and sets of QAs)
  phi         : QMC -> Integer # "Points" to a Complete Configuration
  psi         : QMC -> Integer # "Points" to a set of Valued Quality Attributes
}


# Variability Model Data
instance VariabilityModelData = literal : VariabilityModelCategory {
  #Individual instances
  generators 
    f1 nf1 nf2 nf3 nf4 nf5 nf6 nf7 nf8 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 : Feature
  
  # Quality Model
    qn1 qn2 qn3 : Qn # Unique instances
    qv1 qv2 qv3 qv4 qv5 qv6 qv7 qv8 qv9 qv10 qv11 qv12 : Qv # Unique instances
    qd1 qd2 qd3 : Qd # Unique instances
    qs1 qs2 qs3 qs4 qs5 qs6 qs7 qs8 qs9 qs10 qs11 qs12 : Qs # Unique instances

  # Virtual arrows instances
    qa1 qa2 qa3 qa4 qa5 qa6 qa7 qa8 qa9 qa10 qa11 qa12 qa13 qa14 qa15 : QAs 
    cc1 cc2 cc3 cc4 cc5 cc6 cc7 cc8 cc9 cc10 cc11 cc12 cc13 cc14 cc15 cc16 cc17 cc18 cc19 cc20 cc21 cc22 cc23 cc24 cc25 cc26 cc27 cc28 cc29 cc30 cc31 cc32 cc33 cc34 cc35 cc36 cc37 cc38 cc39 cc40 cc41 : CCs 
    qmc1 qmc2 qmc3 qmc4 qmc5 : QMC


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
   name(f10) = Mozzarella cardinality(f10) = leaf optionality(f10) = false parent(f10) = f9  cost(f10) = 1.25
   vegan(f10) = true
   provider(f10) = Lidl
  
   name(f11) = Ham cardinality(f11) = leaf optionality(f11) = false parent(f11) = f9  cost(f11) = 1.0
   vegan(f11) = false
   provider(f11) = Aldi
  
   name(f12) = Salami cardinality(f12) = leaf optionality(f12) = false parent(f12) = f9  cost(f12) = 1.5
   vegan(f12) = false
   provider(f12) = Aldi
  
  

  # Numerical features
   name(nf1) = Pepper cardinality(nf1) = leaf optionality(nf1) = true parent(nf1) = f1 domain(nf1) = Integer value(nf1) = 1  cost(nf1) = 0
   vegan(nf1) = true
   provider(nf1) = Mercadona
  
   name(nf2) = Pepper cardinality(nf2) = leaf optionality(nf2) = true parent(nf2) = f1 domain(nf2) = Integer value(nf2) = 2  cost(nf2) = 0
   vegan(nf2) = true
   provider(nf2) = Mercadona
  
   name(nf3) = Pepper cardinality(nf3) = leaf optionality(nf3) = true parent(nf3) = f1 domain(nf3) = Integer value(nf3) = 3  cost(nf3) = 0
   vegan(nf3) = true
   provider(nf3) = Mercadona
  
   name(nf4) = Pepper cardinality(nf4) = leaf optionality(nf4) = true parent(nf4) = f1 domain(nf4) = Integer value(nf4) = 4  cost(nf4) = 0
   vegan(nf4) = true
   provider(nf4) = Mercadona
  
   name(nf5) = Pepper cardinality(nf5) = leaf optionality(nf5) = true parent(nf5) = f1 domain(nf5) = Integer value(nf5) = 5  cost(nf5) = 0
   vegan(nf5) = true
   provider(nf5) = Mercadona
  
   name(nf6) = Salt cardinality(nf6) = leaf optionality(nf6) = true parent(nf6) = f1 domain(nf6) = Integer value(nf6) = 1  cost(nf6) = 0
   vegan(nf6) = true
   provider(nf6) = Mercadona
  
   name(nf7) = Salt cardinality(nf7) = leaf optionality(nf7) = true parent(nf7) = f1 domain(nf7) = Integer value(nf7) = 3  cost(nf7) = 0
   vegan(nf7) = true
   provider(nf7) = Mercadona
  
   name(nf8) = Salt cardinality(nf8) = leaf optionality(nf8) = true parent(nf8) = f1 domain(nf8) = Integer value(nf8) = 5  cost(nf8) = 0
   vegan(nf8) = true
   provider(nf8) = Mercadona
  
  

  # CC Virtual Linkages
   id(cc1) = 1 feature(cc1) = f1
   id(cc2) = 1 feature(cc2) = f9
   id(cc3) = 1 feature(cc3) = f12
   id(cc4) = 1 feature(cc4) = f6
   id(cc5) = 1 feature(cc5) = f7
   id(cc6) = 1 feature(cc6) = f3
   id(cc7) = 1 feature(cc7) = f4
   id(cc8) = 1 feature(cc8) = nf7
   id(cc9) = 2 feature(cc9) = f1
   id(cc10) = 2 feature(cc10) = f9
   id(cc11) = 2 feature(cc11) = f11
   id(cc12) = 2 feature(cc12) = f10
   id(cc13) = 2 feature(cc13) = f6
   id(cc14) = 2 feature(cc14) = f7
   id(cc15) = 2 feature(cc15) = f3
   id(cc16) = 2 feature(cc16) = f5
   id(cc17) = 3 feature(cc17) = f1
   id(cc18) = 3 feature(cc18) = f9
   id(cc19) = 3 feature(cc19) = f11
   id(cc20) = 3 feature(cc20) = f6
   id(cc21) = 3 feature(cc21) = f7
   id(cc22) = 3 feature(cc22) = f3
   id(cc23) = 3 feature(cc23) = f5
   id(cc24) = 4 feature(cc24) = f1
   id(cc25) = 4 feature(cc25) = f9
   id(cc26) = 4 feature(cc26) = f12
   id(cc27) = 4 feature(cc27) = f6
   id(cc28) = 4 feature(cc28) = f7
   id(cc29) = 4 feature(cc29) = f3
   id(cc30) = 4 feature(cc30) = f4
   id(cc31) = 4 feature(cc31) = f2
   id(cc32) = 5 feature(cc32) = f1
   id(cc33) = 5 feature(cc33) = f9
   id(cc34) = 5 feature(cc34) = f12
   id(cc35) = 5 feature(cc35) = f11
   id(cc36) = 5 feature(cc36) = f6
   id(cc37) = 5 feature(cc37) = f8
   id(cc38) = 5 feature(cc38) = f3
   id(cc39) = 5 feature(cc39) = f5
   id(cc40) = 5 feature(cc40) = nf7
   id(cc41) = 5 feature(cc41) = nf1
  


  # Variant-wise Quality Names and Domains
   name(qn1) = Attribute2
   name(qn2) = Attribute1
   name(qn3) = Attribute3
  
   domain(qd1) = Double
   domain(qd2) = Bool
   domain(qd3) = Integer
  

  # Quality Values
   value(qv1) = False
   value(qv2) = True
   value(qv3) = 0.1107
   value(qv4) = 0.0451
   value(qv5) = 0.837
   value(qv6) = 0.2532
   value(qv7) = 0.3663
   value(qv8) = 44
   value(qv9) = 18
   value(qv10) = 55
   value(qv11) = 62
   value(qv12) = 31
  

  # Qualities
   name(qs1) = qn3 value(qs1) = qv5 domain(qs1) = qd1
   name(qs2) = qn3 value(qs2) = qv4 domain(qs2) = qd1
   name(qs3) = qn2 value(qs3) = qv11 domain(qs3) = qd3
   name(qs4) = qn2 value(qs4) = qv8 domain(qs4) = qd3
   name(qs5) = qn1 value(qs5) = qv2 domain(qs5) = qd2
   name(qs6) = qn2 value(qs6) = qv12 domain(qs6) = qd3
   name(qs7) = qn1 value(qs7) = qv1 domain(qs7) = qd2
   name(qs8) = qn2 value(qs8) = qv9 domain(qs8) = qd3
   name(qs9) = qn2 value(qs9) = qv10 domain(qs9) = qd3
   name(qs10) = qn3 value(qs10) = qv3 domain(qs10) = qd1
   name(qs11) = qn3 value(qs11) = qv7 domain(qs11) = qd1
   name(qs12) = qn3 value(qs12) = qv6 domain(qs12) = qd1
  

  # QAs Sets
   id(qa1) = 1 qualities(qa1) = qs9
   id(qa2) = 1 qualities(qa2) = qs5
   id(qa3) = 1 qualities(qa3) = qs10
   id(qa4) = 2 qualities(qa4) = qs8
   id(qa5) = 2 qualities(qa5) = qs7
   id(qa6) = 2 qualities(qa6) = qs2
   id(qa7) = 3 qualities(qa7) = qs6
   id(qa8) = 3 qualities(qa8) = qs5
   id(qa9) = 3 qualities(qa9) = qs1
   id(qa10) = 4 qualities(qa10) = qs4
   id(qa11) = 4 qualities(qa11) = qs5
   id(qa12) = 4 qualities(qa12) = qs12
   id(qa13) = 5 qualities(qa13) = qs3
   id(qa14) = 5 qualities(qa14) = qs7
   id(qa15) = 5 qualities(qa15) = qs11
  

  # CC/QAs Linkage
   phi(qmc1) = 4 psi(qmc1) = 4
   phi(qmc2) = 5 psi(qmc2) = 5
   phi(qmc3) = 1 psi(qmc3) = 1
   phi(qmc4) = 3 psi(qmc4) = 3
   phi(qmc5) = 2 psi(qmc5) = 2
  
}
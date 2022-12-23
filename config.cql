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

    concat : String, String, String -> String = "(x, y, z) => (x + ' = ' + y.toString() + ' ' + z)"
    regconcat : String, String -> String = "(x, y) => (x + ' & ' + y)"
    ifi : Bool, String, String -> String = "(x,a,b) => x ? a : b"
  
    trace2 : String, String, String, String, String -> String = "(a, b, c, d, e) => (a + ' -->(' + b + ') ' + c + ' -->(' + d + ') ' + e)"
    itrace2 : String, String, String, String, String, Integer, String -> String = "(a, b, c, d, e, f, g) => (a + ' -->(' + b + ') ' + c + ' -->(' + d + ') ' + e + ' = ' + f.toString() + ' ' + g)"
  
    add  : Integer, Integer -> Integer = "(x, y) => (x + y)"
    sub  : Integer, Integer -> Integer = "(x, y) => (x - y)"
    mult : Integer, Integer -> Integer = "(x, y) => (x * y)"
    div  : Integer, Integer -> Integer = "(x, y) => (x / y)"
    mod  : Integer, Integer -> Integer = "(x, y) => (x % y)"


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
    cost: Feature -> Integer
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
    qn1 qn2 qn3 qn4 qn5 : Qn # Unique instances
    qv1 qv2 qv3 qv4 qv5 qv6 qv7 qv8 qv9 qv10 qv11 qv12 qv13 qv14 qv15 qv16 qv17 qv18 qv19 qv20 qv21 qv22 qv23 qv24 : Qv # Unique instances
    qd1 : Qd # Unique instances
    qs1 qs2 qs3 qs4 qs5 qs6 qs7 qs8 qs9 qs10 qs11 qs12 qs13 qs14 qs15 qs16 qs17 qs18 qs19 qs20 qs21 qs22 qs23 qs24 : Qs # Unique instances

  # Virtual arrows instances
    qa1 qa2 qa3 qa4 qa5 qa6 qa7 qa8 qa9 qa10 qa11 qa12 qa13 qa14 qa15 qa16 qa17 qa18 qa19 qa20 qa21 qa22 qa23 qa24 qa25 : QAs 
    cc1 cc2 cc3 cc4 cc5 cc6 cc7 cc8 cc9 cc10 cc11 cc12 cc13 cc14 cc15 cc16 cc17 cc18 cc19 cc20 cc21 cc22 cc23 cc24 cc25 cc26 cc27 cc28 cc29 cc30 cc31 cc32 cc33 cc34 cc35 cc36 cc37 cc38 cc39 cc40 cc41 cc42 cc43 cc44 cc45 cc46 cc47 cc48 cc49 : CCs 
    qmc1 qmc2 qmc3 qmc4 qmc5 : QMC


  equations
  # Boolean features
   name(f1) = Pizza cardinality(f1) = all optionality(f1) = false parent(f1) = f1 domain(f1) = Bool 
   name(f2) = CheesyCrust cardinality(f2) = leaf optionality(f2) = true parent(f2) = f1 domain(f2) = Bool 
   name(f3) = Dough cardinality(f3) = xor optionality(f3) = false parent(f3) = f1 domain(f3) = Bool 
   name(f4) = Sicilian cardinality(f4) = leaf optionality(f4) = false parent(f4) = f3 domain(f4) = Bool 
   name(f5) = Neapolitan cardinality(f5) = leaf optionality(f5) = false parent(f5) = f3 domain(f5) = Bool 
   name(f6) = Size cardinality(f6) = xor optionality(f6) = false parent(f6) = f1 domain(f6) = Bool 
   name(f7) = Big cardinality(f7) = leaf optionality(f7) = false parent(f7) = f6 domain(f7) = Bool 
   name(f8) = Normal cardinality(f8) = leaf optionality(f8) = false parent(f8) = f6 domain(f8) = Bool 
   name(f9) = Topping cardinality(f9) = or optionality(f9) = false parent(f9) = f1 domain(f9) = Bool 
   name(f10) = Mozzarella cardinality(f10) = leaf optionality(f10) = false parent(f10) = f9 domain(f10) = Bool  cost(f10) = 1
   vegan(f10) = true
   provider(f10) = Lidl
  
   name(f11) = Ham cardinality(f11) = leaf optionality(f11) = false parent(f11) = f9 domain(f11) = Bool  cost(f11) = 3
   vegan(f11) = false
   provider(f11) = Aldi
  
   name(f12) = Salami cardinality(f12) = leaf optionality(f12) = false parent(f12) = f9 domain(f12) = Bool  cost(f12) = 2
   vegan(f12) = false
   provider(f12) = Aldi
  
  

  # Numerical features
   name(nf1) = Pepper cardinality(nf1) = leaf optionality(nf1) = true parent(nf1) = f1 domain(nf1) = Integer value(nf1) = 1  cost(nf1) = 5
   vegan(nf1) = true
   provider(nf1) = Mercadona
  
   name(nf2) = Pepper cardinality(nf2) = leaf optionality(nf2) = true parent(nf2) = f1 domain(nf2) = Integer value(nf2) = 2  cost(nf2) = 5
   vegan(nf2) = true
   provider(nf2) = Mercadona
  
   name(nf3) = Pepper cardinality(nf3) = leaf optionality(nf3) = true parent(nf3) = f1 domain(nf3) = Integer value(nf3) = 3  cost(nf3) = 5
   vegan(nf3) = true
   provider(nf3) = Mercadona
  
   name(nf4) = Pepper cardinality(nf4) = leaf optionality(nf4) = true parent(nf4) = f1 domain(nf4) = Integer value(nf4) = 4  cost(nf4) = 5
   vegan(nf4) = true
   provider(nf4) = Mercadona
  
   name(nf5) = Pepper cardinality(nf5) = leaf optionality(nf5) = true parent(nf5) = f1 domain(nf5) = Integer value(nf5) = 5  cost(nf5) = 5
   vegan(nf5) = true
   provider(nf5) = Mercadona
  
   name(nf6) = Salt cardinality(nf6) = leaf optionality(nf6) = true parent(nf6) = f1 domain(nf6) = Integer value(nf6) = 1  cost(nf6) = 5
   vegan(nf6) = true
   provider(nf6) = Mercadona
  
   name(nf7) = Salt cardinality(nf7) = leaf optionality(nf7) = true parent(nf7) = f1 domain(nf7) = Integer value(nf7) = 3  cost(nf7) = 5
   vegan(nf7) = true
   provider(nf7) = Mercadona
  
   name(nf8) = Salt cardinality(nf8) = leaf optionality(nf8) = true parent(nf8) = f1 domain(nf8) = Integer value(nf8) = 5  cost(nf8) = 5
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
   id(cc8) = 1 feature(cc8) = f2
   id(cc9) = 1 feature(cc9) = nf8
   id(cc10) = 1 feature(cc10) = nf5
   id(cc11) = 2 feature(cc11) = f1
   id(cc12) = 2 feature(cc12) = f9
   id(cc13) = 2 feature(cc13) = f12
   id(cc14) = 2 feature(cc14) = f11
   id(cc15) = 2 feature(cc15) = f10
   id(cc16) = 2 feature(cc16) = f6
   id(cc17) = 2 feature(cc17) = f7
   id(cc18) = 2 feature(cc18) = f3
   id(cc19) = 2 feature(cc19) = f5
   id(cc20) = 2 feature(cc20) = nf6
   id(cc21) = 2 feature(cc21) = nf5
   id(cc22) = 3 feature(cc22) = f1
   id(cc23) = 3 feature(cc23) = f9
   id(cc24) = 3 feature(cc24) = f10
   id(cc25) = 3 feature(cc25) = f6
   id(cc26) = 3 feature(cc26) = f7
   id(cc27) = 3 feature(cc27) = f3
   id(cc28) = 3 feature(cc28) = f4
   id(cc29) = 3 feature(cc29) = f2
   id(cc30) = 3 feature(cc30) = nf5
   id(cc31) = 4 feature(cc31) = f1
   id(cc32) = 4 feature(cc32) = f9
   id(cc33) = 4 feature(cc33) = f11
   id(cc34) = 4 feature(cc34) = f10
   id(cc35) = 4 feature(cc35) = f6
   id(cc36) = 4 feature(cc36) = f7
   id(cc37) = 4 feature(cc37) = f3
   id(cc38) = 4 feature(cc38) = f4
   id(cc39) = 4 feature(cc39) = f2
   id(cc40) = 5 feature(cc40) = f1
   id(cc41) = 5 feature(cc41) = f9
   id(cc42) = 5 feature(cc42) = f12
   id(cc43) = 5 feature(cc43) = f11
   id(cc44) = 5 feature(cc44) = f6
   id(cc45) = 5 feature(cc45) = f8
   id(cc46) = 5 feature(cc46) = f3
   id(cc47) = 5 feature(cc47) = f5
   id(cc48) = 5 feature(cc48) = nf8
   id(cc49) = 5 feature(cc49) = nf1
  


  # Variant-wise Quality Names and Domains
   name(qn1) = Attribute2
   name(qn2) = Attribute1
   name(qn3) = Attribute4
   name(qn4) = Attribute3
   name(qn5) = Attribute5
  
   domain(qd1) = Integer
  

  # Quality Values
   value(qv1) = 1
   value(qv2) = 10
   value(qv3) = 15
   value(qv4) = 25
   value(qv5) = 29
   value(qv6) = 30
   value(qv7) = 34
   value(qv8) = 35
   value(qv9) = 36
   value(qv10) = 37
   value(qv11) = 43
   value(qv12) = 48
   value(qv13) = 49
   value(qv14) = 50
   value(qv15) = 56
   value(qv16) = 71
   value(qv17) = 72
   value(qv18) = 78
   value(qv19) = 79
   value(qv20) = 81
   value(qv21) = 84
   value(qv22) = 86
   value(qv23) = 91
   value(qv24) = 96
  

  # Qualities
   name(qs1) = qn4 value(qs1) = qv18 domain(qs1) = qd1
   name(qs2) = qn2 value(qs2) = qv16 domain(qs2) = qd1
   name(qs3) = qn2 value(qs3) = qv17 domain(qs3) = qd1
   name(qs4) = qn4 value(qs4) = qv13 domain(qs4) = qd1
   name(qs5) = qn5 value(qs5) = qv12 domain(qs5) = qd1
   name(qs6) = qn3 value(qs6) = qv23 domain(qs6) = qd1
   name(qs7) = qn4 value(qs7) = qv8 domain(qs7) = qd1
   name(qs8) = qn5 value(qs8) = qv14 domain(qs8) = qd1
   name(qs9) = qn1 value(qs9) = qv2 domain(qs9) = qd1
   name(qs10) = qn5 value(qs10) = qv20 domain(qs10) = qd1
   name(qs11) = qn3 value(qs11) = qv5 domain(qs11) = qd1
   name(qs12) = qn1 value(qs12) = qv6 domain(qs12) = qd1
   name(qs13) = qn2 value(qs13) = qv19 domain(qs13) = qd1
   name(qs14) = qn1 value(qs14) = qv22 domain(qs14) = qd1
   name(qs15) = qn2 value(qs15) = qv1 domain(qs15) = qd1
   name(qs16) = qn4 value(qs16) = qv3 domain(qs16) = qd1
   name(qs17) = qn2 value(qs17) = qv24 domain(qs17) = qd1
   name(qs18) = qn3 value(qs18) = qv9 domain(qs18) = qd1
   name(qs19) = qn3 value(qs19) = qv15 domain(qs19) = qd1
   name(qs20) = qn5 value(qs20) = qv4 domain(qs20) = qd1
   name(qs21) = qn3 value(qs21) = qv7 domain(qs21) = qd1
   name(qs22) = qn5 value(qs22) = qv11 domain(qs22) = qd1
   name(qs23) = qn1 value(qs23) = qv21 domain(qs23) = qd1
   name(qs24) = qn4 value(qs24) = qv10 domain(qs24) = qd1
  

  # QAs Sets
   id(qa1) = 1 qualities(qa1) = qs13
   id(qa2) = 1 qualities(qa2) = qs14
   id(qa3) = 1 qualities(qa3) = qs1
   id(qa4) = 1 qualities(qa4) = qs6
   id(qa5) = 1 qualities(qa5) = qs8
   id(qa6) = 2 qualities(qa6) = qs2
   id(qa7) = 2 qualities(qa7) = qs12
   id(qa8) = 2 qualities(qa8) = qs4
   id(qa9) = 2 qualities(qa9) = qs21
   id(qa10) = 2 qualities(qa10) = qs10
   id(qa11) = 3 qualities(qa11) = qs3
   id(qa12) = 3 qualities(qa12) = qs9
   id(qa13) = 3 qualities(qa13) = qs7
   id(qa14) = 3 qualities(qa14) = qs18
   id(qa15) = 3 qualities(qa15) = qs5
   id(qa16) = 4 qualities(qa16) = qs17
   id(qa17) = 4 qualities(qa17) = qs14
   id(qa18) = 4 qualities(qa18) = qs24
   id(qa19) = 4 qualities(qa19) = qs19
   id(qa20) = 4 qualities(qa20) = qs20
   id(qa21) = 5 qualities(qa21) = qs15
   id(qa22) = 5 qualities(qa22) = qs23
   id(qa23) = 5 qualities(qa23) = qs16
   id(qa24) = 5 qualities(qa24) = qs11
   id(qa25) = 5 qualities(qa25) = qs22
  

  # CC/QAs Linkage
   phi(qmc1) = 4 psi(qmc1) = 4
   phi(qmc2) = 5 psi(qmc2) = 5
   phi(qmc3) = 1 psi(qmc3) = 1
   phi(qmc4) = 3 psi(qmc4) = 3
   phi(qmc5) = 2 psi(qmc5) = 2
  
}
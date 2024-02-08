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
    vegan: Feature -> Bool
    Coste: Feature -> Integer
    Precio: Feature -> Double
    
  
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
    f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 : Feature
  
  # Quality Model
    qn1 qn2 qn3 : Qn # Unique instances
    qv1 qv2 qv3 qv4 qv5 qv6 qv7 qv8 qv9 qv10 qv11 qv12 qv13 qv14 qv15 qv16 qv17 qv18 qv19 qv20 qv21 qv22 : Qv # Unique instances
    qd1 : Qd # Unique instances
    qs1 qs2 qs3 qs4 qs5 qs6 qs7 qs8 qs9 qs10 qs11 qs12 qs13 qs14 qs15 qs16 qs17 qs18 qs19 qs20 qs21 qs22 : Qs # Unique instances

  # Virtual arrows instances
    qa1 qa2 qa3 qa4 qa5 qa6 qa7 qa8 qa9 qa10 qa11 qa12 qa13 qa14 qa15 qa16 qa17 qa18 qa19 qa20 qa21 qa22 qa23 qa24 qa25 qa26 qa27 qa28 qa29 qa30 : QAs 
    cc1 cc2 cc3 cc4 cc5 cc6 cc7 cc8 cc9 cc10 cc11 cc12 cc13 cc14 cc15 cc16 cc17 cc18 cc19 cc20 cc21 cc22 cc23 cc24 cc25 cc26 cc27 cc28 cc29 cc30 cc31 cc32 cc33 cc34 cc35 cc36 cc37 cc38 cc39 cc40 cc41 cc42 cc43 cc44 cc45 cc46 cc47 cc48 cc49 cc50 cc51 cc52 cc53 cc54 cc55 cc56 cc57 cc58 cc59 cc60 cc61 cc62 cc63 cc64 cc65 cc66 cc67 cc68 cc69 cc70 cc71 cc72 cc73 cc74 cc75 cc76 cc77 cc78 cc79 cc80 cc81 cc82 cc83 : CCs 
    qmc1 qmc2 qmc3 qmc4 qmc5 qmc6 qmc7 qmc8 qmc9 qmc10 : QMC


  equations
  # Boolean features
   name(f1) = Pizza cardinality(f1) = all optionality(f1) = false parent(f1) = f1 domain(f1) = Bool 
   name(f2) = CheesyCrust cardinality(f2) = leaf optionality(f2) = true parent(f2) = f1 domain(f2) = Bool  vegan(f2) = False
  
   name(f3) = Dough cardinality(f3) = xor optionality(f3) = false parent(f3) = f1 domain(f3) = Bool 
   name(f4) = Sicilian cardinality(f4) = leaf optionality(f4) = false parent(f4) = f3 domain(f4) = Bool 
   name(f5) = Neapolitan cardinality(f5) = leaf optionality(f5) = false parent(f5) = f3 domain(f5) = Bool 
   name(f6) = Size cardinality(f6) = xor optionality(f6) = false parent(f6) = f1 domain(f6) = Bool 
   name(f7) = Big cardinality(f7) = leaf optionality(f7) = false parent(f7) = f6 domain(f7) = Bool 
   name(f8) = Normal cardinality(f8) = leaf optionality(f8) = false parent(f8) = f6 domain(f8) = Bool 
   name(f9) = Topping cardinality(f9) = or optionality(f9) = false parent(f9) = f1 domain(f9) = Bool 
   name(f10) = Mozzarella cardinality(f10) = leaf optionality(f10) = false parent(f10) = f9 domain(f10) = Bool  Coste(f10) = 1
  
   name(f11) = Ham cardinality(f11) = leaf optionality(f11) = false parent(f11) = f9 domain(f11) = Bool 
   name(f12) = Salami cardinality(f12) = leaf optionality(f12) = false parent(f12) = f9 domain(f12) = Bool  Precio(f12) = 2.1
  
  

  # Numerical features
  

  # CC Virtual Linkages
   id(cc1) = 1 feature(cc1) = f1
   id(cc2) = 1 feature(cc2) = f9
   id(cc3) = 1 feature(cc3) = f12
   id(cc4) = 1 feature(cc4) = f6
   id(cc5) = 1 feature(cc5) = f7
   id(cc6) = 1 feature(cc6) = f3
   id(cc7) = 1 feature(cc7) = f5
   id(cc8) = 1 feature(cc8) = f2
   id(cc9) = 2 feature(cc9) = f1
   id(cc10) = 2 feature(cc10) = f9
   id(cc11) = 2 feature(cc11) = f11
   id(cc12) = 2 feature(cc12) = f10
   id(cc13) = 2 feature(cc13) = f6
   id(cc14) = 2 feature(cc14) = f7
   id(cc15) = 2 feature(cc15) = f3
   id(cc16) = 2 feature(cc16) = f5
   id(cc17) = 2 feature(cc17) = f2
   id(cc18) = 3 feature(cc18) = f1
   id(cc19) = 3 feature(cc19) = f9
   id(cc20) = 3 feature(cc20) = f12
   id(cc21) = 3 feature(cc21) = f10
   id(cc22) = 3 feature(cc22) = f6
   id(cc23) = 3 feature(cc23) = f7
   id(cc24) = 3 feature(cc24) = f3
   id(cc25) = 3 feature(cc25) = f4
   id(cc26) = 4 feature(cc26) = f1
   id(cc27) = 4 feature(cc27) = f9
   id(cc28) = 4 feature(cc28) = f12
   id(cc29) = 4 feature(cc29) = f10
   id(cc30) = 4 feature(cc30) = f6
   id(cc31) = 4 feature(cc31) = f7
   id(cc32) = 4 feature(cc32) = f3
   id(cc33) = 4 feature(cc33) = f4
   id(cc34) = 4 feature(cc34) = f2
   id(cc35) = 5 feature(cc35) = f1
   id(cc36) = 5 feature(cc36) = f9
   id(cc37) = 5 feature(cc37) = f11
   id(cc38) = 5 feature(cc38) = f6
   id(cc39) = 5 feature(cc39) = f7
   id(cc40) = 5 feature(cc40) = f3
   id(cc41) = 5 feature(cc41) = f4
   id(cc42) = 6 feature(cc42) = f1
   id(cc43) = 6 feature(cc43) = f9
   id(cc44) = 6 feature(cc44) = f12
   id(cc45) = 6 feature(cc45) = f11
   id(cc46) = 6 feature(cc46) = f10
   id(cc47) = 6 feature(cc47) = f6
   id(cc48) = 6 feature(cc48) = f8
   id(cc49) = 6 feature(cc49) = f3
   id(cc50) = 6 feature(cc50) = f5
   id(cc51) = 7 feature(cc51) = f1
   id(cc52) = 7 feature(cc52) = f9
   id(cc53) = 7 feature(cc53) = f12
   id(cc54) = 7 feature(cc54) = f11
   id(cc55) = 7 feature(cc55) = f6
   id(cc56) = 7 feature(cc56) = f8
   id(cc57) = 7 feature(cc57) = f3
   id(cc58) = 7 feature(cc58) = f5
   id(cc59) = 8 feature(cc59) = f1
   id(cc60) = 8 feature(cc60) = f9
   id(cc61) = 8 feature(cc61) = f12
   id(cc62) = 8 feature(cc62) = f6
   id(cc63) = 8 feature(cc63) = f8
   id(cc64) = 8 feature(cc64) = f3
   id(cc65) = 8 feature(cc65) = f5
   id(cc66) = 9 feature(cc66) = f1
   id(cc67) = 9 feature(cc67) = f9
   id(cc68) = 9 feature(cc68) = f11
   id(cc69) = 9 feature(cc69) = f10
   id(cc70) = 9 feature(cc70) = f6
   id(cc71) = 9 feature(cc71) = f7
   id(cc72) = 9 feature(cc72) = f3
   id(cc73) = 9 feature(cc73) = f4
   id(cc74) = 9 feature(cc74) = f2
   id(cc75) = 10 feature(cc75) = f1
   id(cc76) = 10 feature(cc76) = f9
   id(cc77) = 10 feature(cc77) = f12
   id(cc78) = 10 feature(cc78) = f11
   id(cc79) = 10 feature(cc79) = f10
   id(cc80) = 10 feature(cc80) = f6
   id(cc81) = 10 feature(cc81) = f8
   id(cc82) = 10 feature(cc82) = f3
   id(cc83) = 10 feature(cc83) = f4
  


  # Variant-wise Quality Names and Domains
   name(qn1) = Attribute3
   name(qn2) = Attribute2
   name(qn3) = Attribute1
  
   domain(qd1) = String
  

  # Quality Values
   value(qv1) = 87
   value(qv2) = 0.8984
   value(qv3) = 81
   value(qv4) = 76
   value(qv5) = 71
   value(qv6) = 46
   value(qv7) = 0.874
   value(qv8) = 57
   value(qv9) = 0.7069
   value(qv10) = 0.621
   value(qv11) = 28
   value(qv12) = 0.1473
   value(qv13) = 0.179
   value(qv14) = 29
   value(qv15) = 0.8813
   value(qv16) = 0.0015
   value(qv17) = 54
   value(qv18) = 0.3685
   value(qv19) = true
   value(qv20) = false
   value(qv21) = 0.6922
   value(qv22) = 60
  

  # Qualities
   name(qs1) = qn2 value(qs1) = qv15 domain(qs1) = qd1
   name(qs2) = qn2 value(qs2) = qv18 domain(qs2) = qd1
   name(qs3) = qn3 value(qs3) = qv1 domain(qs3) = qd1
   name(qs4) = qn2 value(qs4) = qv13 domain(qs4) = qd1
   name(qs5) = qn3 value(qs5) = qv11 domain(qs5) = qd1
   name(qs6) = qn3 value(qs6) = qv6 domain(qs6) = qd1
   name(qs7) = qn3 value(qs7) = qv14 domain(qs7) = qd1
   name(qs8) = qn3 value(qs8) = qv17 domain(qs8) = qd1
   name(qs9) = qn2 value(qs9) = qv16 domain(qs9) = qd1
   name(qs10) = qn3 value(qs10) = qv4 domain(qs10) = qd1
   name(qs11) = qn3 value(qs11) = qv3 domain(qs11) = qd1
   name(qs12) = qn1 value(qs12) = qv20 domain(qs12) = qd1
   name(qs13) = qn2 value(qs13) = qv2 domain(qs13) = qd1
   name(qs14) = qn2 value(qs14) = qv12 domain(qs14) = qd1
   name(qs15) = qn1 value(qs15) = qv19 domain(qs15) = qd1
   name(qs16) = qn3 value(qs16) = qv8 domain(qs16) = qd1
   name(qs17) = qn2 value(qs17) = qv9 domain(qs17) = qd1
   name(qs18) = qn2 value(qs18) = qv21 domain(qs18) = qd1
   name(qs19) = qn2 value(qs19) = qv10 domain(qs19) = qd1
   name(qs20) = qn3 value(qs20) = qv5 domain(qs20) = qd1
   name(qs21) = qn3 value(qs21) = qv22 domain(qs21) = qd1
   name(qs22) = qn2 value(qs22) = qv7 domain(qs22) = qd1
  

  # QAs Sets
   id(qa1) = 1 qualities(qa1) = qs11
   id(qa2) = 1 qualities(qa2) = qs22
   id(qa3) = 1 qualities(qa3) = qs15
   id(qa4) = 2 qualities(qa4) = qs21
   id(qa5) = 2 qualities(qa5) = qs19
   id(qa6) = 2 qualities(qa6) = qs15
   id(qa7) = 3 qualities(qa7) = qs10
   id(qa8) = 3 qualities(qa8) = qs4
   id(qa9) = 3 qualities(qa9) = qs15
   id(qa10) = 4 qualities(qa10) = qs7
   id(qa11) = 4 qualities(qa11) = qs18
   id(qa12) = 4 qualities(qa12) = qs15
   id(qa13) = 5 qualities(qa13) = qs3
   id(qa14) = 5 qualities(qa14) = qs13
   id(qa15) = 5 qualities(qa15) = qs12
   id(qa16) = 6 qualities(qa16) = qs20
   id(qa17) = 6 qualities(qa17) = qs2
   id(qa18) = 6 qualities(qa18) = qs15
   id(qa19) = 7 qualities(qa19) = qs6
   id(qa20) = 7 qualities(qa20) = qs1
   id(qa21) = 7 qualities(qa21) = qs15
   id(qa22) = 8 qualities(qa22) = qs16
   id(qa23) = 8 qualities(qa23) = qs17
   id(qa24) = 8 qualities(qa24) = qs15
   id(qa25) = 9 qualities(qa25) = qs8
   id(qa26) = 9 qualities(qa26) = qs14
   id(qa27) = 9 qualities(qa27) = qs15
   id(qa28) = 10 qualities(qa28) = qs5
   id(qa29) = 10 qualities(qa29) = qs9
   id(qa30) = 10 qualities(qa30) = qs12
  

  # CC/QAs Linkage
   phi(qmc1) = 4 psi(qmc1) = 4
   phi(qmc2) = 8 psi(qmc2) = 8
   phi(qmc3) = 5 psi(qmc3) = 5
   phi(qmc4) = 7 psi(qmc4) = 7
   phi(qmc5) = 9 psi(qmc5) = 9
   phi(qmc6) = 1 psi(qmc6) = 1
   phi(qmc7) = 10 psi(qmc7) = 10
   phi(qmc8) = 3 psi(qmc8) = 3
   phi(qmc9) = 2 psi(qmc9) = 2
   phi(qmc10) = 6 psi(qmc10) = 6
  
}
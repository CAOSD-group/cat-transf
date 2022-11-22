# File name: Pizza.cql
# (Copyright) Author: Daniel-Jesus Munoz
# Date created: 12/06/2022
# Version: CQL IDE 5/2021 + Java JDK 18.0.2
# Description: Italian vendor machine SPL modelled in CQL

# IDE options, we activate aggregation although is not functorial, it is needed when merging tree traces
options
	allow_aggregation_unsafe = true

# Basic datatype objects and reusable functorial arrows
typeside Ty = literal {
 external_types
  String -> "java.lang.String"
  Bool -> "java.lang.Boolean"
  Integer -> "java.lang.Integer"
  Double -> "java.lang.Double"
  List -> "java.util.List"
 external_parsers
  String -> "x => x"
  Bool -> "x => java.lang.Boolean.parseBoolean(x)"
  List -> "x => java.util.Arrays.asList(x.split(','))"
  Integer -> "parseInt"
  Double -> "parseDouble"
 external_functions
  trace : String, String -> String = "(a, b) => (a + b + ' ')"
  card : String, String -> String = "(a, b) => (a + ' -->(' + b + ') ')"
  trace2 : String, String, String, String, String -> String = "(a, b, c, d, e) => (a + ' -->(' + b + ') ' + c + ' -->(' + d + ') ' + e)"
  itrace2 : String, String, String, String, String, Integer, String -> String = "(a, b, c, d, e, f, g) => (a + ' -->(' + b + ') ' + c + ' -->(' + d + ') ' + e + ' = ' + f.toString() + ' ' + g)"
  concat : String, Integer, String -> String = "(x, y, z) => (x + ' = ' + y.toString() + ' ' + z)"
  regconcat : String, String -> String = "(x, y) => (x + ' & ' + y)"
  
  eq : String, String -> Bool = "(x, y) => (x == y)"
  and : Bool, Bool -> Bool = "(x, y) => (x && y)"
  or : Bool, Bool -> Bool = "(x, y) => (x || y)"
  diff : Bool, Bool -> Bool = "(x, y) => (x != y)"
  
  ieq : Integer, Integer -> Bool = "(x, y) => (x == y)"
  
  ge : Integer, Integer -> Bool = "(x, y) => (x > y)"
  geq : Integer, Integer -> Bool = "(x, y) => (x >= y)"
  le : Integer, Integer -> Bool = "(x, y) => (x < y)"
  leq : Integer, Integer -> Bool = "(x, y) => (x <= y)"

  add  : Integer, Integer -> Integer = "(x, y) => (x + y)"
  sub  : Integer, Integer -> Integer = "(x, y) => (x - y)"
  mult : Integer, Integer -> Integer = "(x, y) => (x * y)"
  div  : Integer, Integer -> Integer = "(x, y) => (x / y)"
  mod  : Integer, Integer -> Integer = "(x, y) => (x % y)"
  addfp  : Double, Double -> Double = "(x, y) => (x + y)"
  subfp  : Double, Double -> Double = "(x, y) => (x - y)"
  multfp : Double, Double -> Double = "(x, y) => (x * y)"
  divfp  : Double, Double -> Double = "(x, y) => (x / y)"
  modfp  : Double, Double -> Double = "(x, y) => (x % y)"

  ran  : Integer, Integer  -> Integer = " (x, y) => (java.lang.Math.round(java.lang.Math.random() * (y-x)+x))"
  
  if : Bool, Bool, Bool -> Bool = "(x,a,b) => x ? a : b"
  ifi : Bool, String, String -> String = "(x,a,b) => x ? a : b"
}

# SPLC'22 Proo-of-Concept Pizza Category 
schema PizzaCategory = literal : Ty {
 #Objects
 entities
  Pizza    # Olog of the Variability Model
  
  Qn # Quality Name
  Qv # Quality Value
  Qd # Quality Domain
  Qs # (Qn,Qv,Qd) Quality Model
  
  # VM-QM Linkage entities
  CCs # Features forming a complete configuration
  QAs # Sets of QAs
  QMC # SPAN relating CCs with a set of QAs.
 
 #Functorial Relation Arrows
 foreign_keys
  #Variability Model
  selfParent : Pizza -> Pizza # Hierarchichal Feature Relation
  #Quality Model
  #selfParent : Qs -> Qs
  name : Qs -> Qn
  value : Qs -> Qv
  domain : Qs -> Qd
  # VM-QM Linkage entities
  feature : CCs -> Pizza # Features belonging to a Complete Configuration
  qualities : QAs -> Qs # Sets of valued Quality Attributes.

 #Non-Functional Relation and Elements Arrows
 attributes
  #Extended Numerical Variability Model Arrows
  feature : Pizza -> String     # Feature Name
  value : Pizza -> Integer      # Numerical Feature Value
  domain : Pizza -> String      # Feature Domain (Boolean by default)
  cardinality : Pizza -> String # Children cardinality ([x..y])
  cost_USD : Pizza -> Integer   # Feature-wise Quality Attribute Cost
  
  # Quality Model Arrows
  name : Qn -> String   # Quality Name
  value : Qv -> Integer # Quality Numerical Value
  domain : Qd -> String # Quality Domain
  
  # IDs for one to many relationship
  id : CCs -> Integer #Identify each Complete Configuration
  # id : Qs -> Integer  #Identify each valued Quality
  id : QAs -> Integer #Identify each set of Valued Qualities
  
  # QMC SPAN (binary relation between CCs and sets of QAs)
  phi : QMC -> Integer # "Point" to a Complete Configuration
  psi : QMC -> Integer # "Point" to a set of Valued Quality Attributes

}

# SPLC'22 Proo-of-Concept Pizza Data
instance PizzaData = literal : PizzaCategory {
#63 instances
 generators 
  Pizza1 Pizza2 Pizza3 Pizza4 Pizza5 Pizza6 Pizza7 Pizza8 Pizza9 Pizza10 Pizza11 Pizza12 Pizza13 Pizza14 Pizza15 Pizza16 Pizza17 Pizza18 Pizza19 Pizza20 Pizza21: Pizza
  qn1 qn2 : Qn
  qv1 qv2 qv3 qv4 qv5 qv6 qv7 qv8 qv9 qv10 qv11 qv12 qv13 qv14 qv15 : Qv
  qd1 qd2 : Qd
  qs1 qs2 qs3 qs4 qs5 qs6 qs7 qs8 qs9 qs10 qs11 qs12 qs13 qs14 qs15 : Qs
  qa1 qa2 qa3 qa4 qa5 qa6 qa7 qa8 qa9 qa10 qa11 qa12 qa13 qa14 qa15 qa16 qa17 qa18 qa19 qa20 qa21 qa22 qa23 qa24 qa25 qa26 qa27 qa28 qa29 qa30 qa31 qa32 : QAs
  
  cc1 cc2 cc3 cc4 cc5 cc6 cc7 cc8 cc9 cc10 cc11 cc12 cc13 cc14 cc15 cc16 cc17 cc18 cc19 cc20 cc21 cc22 cc23 cc24 : CCs
  cc25 cc26 cc27 cc28 cc29 cc30 cc31 cc32 cc33 cc34 cc35 cc36 cc37 cc38 cc39 cc40 cc41 cc42 cc43 cc44 cc45 cc46 cc47 cc48 cc49 : CCs
  cc50 cc51 cc52 cc53 cc54 cc55 cc56 cc57 cc58 cc59 cc60 cc61 cc62 cc63 cc64 cc65 cc66 cc67 cc68 cc69 cc70 cc71 cc72 cc73 cc74 cc75 cc76 cc77 cc78 cc79 : CCs
  cc80 cc81 cc82 cc83 cc84 cc85 cc86 cc87 cc88 cc89 cc90 cc91 cc92 cc93 cc94 cc95 cc96 cc97 cc98 cc99 cc100 cc101 cc102 cc103 cc104 cc105 cc106 cc107 cc108 cc109 : CCs
  cc110 cc111 cc112 cc112 cc113 cc114 cc115 cc116 cc117 cc118 cc119 cc120 cc121 cc122 cc122 cc123 cc124 cc125 cc126 cc127 cc128 cc129 cc130 cc131 cc132 cc132 cc133 cc134 cc135 cc136 cc137 cc138 cc139 : CCs  
  cc140 cc141 cc142 cc142 cc143 cc144 cc145 cc146 cc147 cc148 cc149 cc150 cc151 cc152 cc152 cc153 cc154 cc155 cc156 cc157 cc158 cc159 cc160 cc161 cc162 cc162 cc163 cc164 cc165 cc166 cc167 cc168 cc169 : CCs  
  cc170 cc171 cc172 cc172 cc173 cc174 cc175 cc176 cc177 cc178 cc179 cc180 : CCs
  
  qmc1 qmc2 qmc3 qmc4 qmc5 qmc6 qmc7 qmc8 qmc9 qmc10 qmc11 qmc12 qmc13 qmc14 qmc15 qmc16 qmc17 qmc18 qmc19 qmc20 qmc21 qmc22 qmc23 qmc24 qmc25 qmc26 qmc27 qmc28 qmc29 qmc30 qmc31 qmc32 qmc33 qmc34 qmc35 qmc36 qmc37 qmc38 qmc39 qmc40 qmc41 qmc42 qmc43 qmc44 qmc45 qmc46 qmc47 qmc48 qmc49 qmc50 qmc51 qmc52 qmc53 qmc54 qmc55 qmc56 qmc57 qmc58 qmc59 qmc60 qmc61 qmc62 qmc63: QMC

 equations
  # Extended Numerical Variability Model Data
  feature(Pizza1) = Pizza domain(Pizza1) = Bool value(Pizza1) = 1 cardinality(Pizza1) = N selfParent(Pizza1) = Pizza1
  feature(Pizza2) = Interface domain(Pizza2) = Bool value(Pizza2) = 1 cardinality(Pizza2) = XOR selfParent(Pizza2) = Pizza1
  feature(Pizza3) = Wifi domain(Pizza3) = Bool value(Pizza3) = 1 cardinality(Pizza3) = XOR selfParent(Pizza3) = Pizza2
  feature(Pizza4) = GHz_24 domain(Pizza4) = Bool value(Pizza4) = 1 cardinality(Pizza4) = leaf selfParent(Pizza4) = Pizza3 cost_USD(Pizza4) = 30
  feature(Pizza5) = GHz_5 domain(Pizza5) = Bool value(Pizza5) = 1 cardinality(Pizza5) = leaf selfParent(Pizza5) = Pizza3 cost_USD(Pizza5) = 50
  feature(Pizza6) = Ethernet domain(Pizza6) = Integer value(Pizza6) = 10 cardinality(Pizza6) = leaf selfParent(Pizza6) = Pizza2 cost_USD(Pizza6) = 15
  feature(Pizza7) = Ethernet domain(Pizza7) = Integer value(Pizza7) = 100 cardinality(Pizza7) = leaf selfParent(Pizza7) = Pizza2 cost_USD(Pizza7) = 15
  feature(Pizza8) = Ethernet domain(Pizza8) = Integer value(Pizza8) = 1000 cardinality(Pizza8) = leaf selfParent(Pizza8) = Pizza2 cost_USD(Pizza8) = 15

  feature(Pizza9) = Mobile domain(Pizza9) = Bool value(Pizza9) = 1 cardinality(Pizza9) = XOR  selfParent(Pizza9) = Pizza2  
  feature(Pizza10) = G_3 domain(Pizza10) = Bool value(Pizza10) = 1 cardinality(Pizza10) = leaf selfParent(Pizza10) = Pizza9 cost_USD(Pizza10) = 30
  feature(Pizza11) = G_4 domain(Pizza11) = Bool value(Pizza11) = 1 cardinality(Pizza11) = leaf selfParent(Pizza11) = Pizza9 cost_USD(Pizza11) = 40
  feature(Pizza12) = G_5 domain(Pizza12) = Bool value(Pizza12) = 1 cardinality(Pizza12) = leaf selfParent(Pizza12) = Pizza9 cost_USD(Pizza12) = 75
  feature(Pizza13) = G_5p domain(Pizza13) = Bool value(Pizza13) = 1 cardinality(Pizza13) = leaf selfParent(Pizza13) = Pizza9 cost_USD(Pizza13) = 3000
  
  feature(Pizza14) = Antenna domain(Pizza14) = Bool value(Pizza14) = 1 cardinality(Pizza14) = XOR selfParent(Pizza14) = Pizza1
  feature(Pizza15) = Small domain(Pizza15) = Bool value(Pizza15) = 1 cost_USD(Pizza15) = 3 cardinality(Pizza15) = leaf selfParent(Pizza15) = Pizza14
  feature(Pizza16) = Medium domain(Pizza16) = Bool value(Pizza16) = 1 cost_USD(Pizza16) = 4 cardinality(Pizza16) = leaf selfParent(Pizza16) = Pizza14
  feature(Pizza17) = Large domain(Pizza17) = Bool value(Pizza17) = 1 cost_USD(Pizza17) = 5 cardinality(Pizza17) = leaf selfParent(Pizza17) = Pizza14

  feature(Pizza18) = VirtualNetworkFunctions domain(Pizza18) = Bool value(Pizza18) = 1 cardinality(Pizza18) = XOR  selfParent(Pizza18) = Pizza2  
  feature(Pizza19) = Monitor domain(Pizza19) = Bool value(Pizza19) = 1 cardinality(Pizza19) = leaf selfParent(Pizza19) = Pizza18 cost_USD(Pizza19) = 0
  feature(Pizza20) = Firewall domain(Pizza20) = Bool value(Pizza20) = 1 cardinality(Pizza20) = leaf selfParent(Pizza20) = Pizza18 cost_USD(Pizza20) = 0
  feature(Pizza21) = Encryption domain(Pizza21) = Bool value(Pizza21) = 1 cardinality(Pizza21) = leaf selfParent(Pizza21) = Pizza18 cost_USD(Pizza21) = 0
  
  # 63 Measured Configurations

  # Monitor op
  id(cc1) = 1 feature(cc1) = Pizza4
  id(cc2) = 1 feature(cc2) = Pizza15
  id(cc3) = 1 feature(cc3) = Pizza19

  id(cc4) = 2 feature(cc4) = Pizza5
  id(cc5) = 2 feature(cc5) = Pizza15
  id(cc6) = 2 feature(cc6) = Pizza19

  id(cc7) = 3 feature(cc7) = Pizza6
  id(cc8) = 3 feature(cc8) = Pizza19

  id(cc9) = 4 feature(cc9) = Pizza7
  id(cc10) = 4 feature(cc10) = Pizza19
  
  id(cc11) = 5 feature(cc11) = Pizza8
  id(cc12) = 5 feature(cc12) = Pizza19

  id(cc13) = 6 feature(cc13) = Pizza10
  id(cc14) = 6 feature(cc14) = Pizza15
  id(cc15) = 6 feature(cc15) = Pizza19
  
  id(cc16) = 7 feature(cc16) = Pizza11
  id(cc17) = 7 feature(cc17) = Pizza15
  id(cc18) = 7 feature(cc18) = Pizza19

  id(cc19) = 8 feature(cc19) = Pizza12
  id(cc20) = 8 feature(cc20) = Pizza15
  id(cc21) = 8 feature(cc21) = Pizza19
 
  id(cc22) = 9 feature(cc22) = Pizza13
  id(cc23) = 9 feature(cc23) = Pizza15
  id(cc24) = 9 feature(cc24) = Pizza19

  id(cc25) = 10 feature(cc25) = Pizza4
  id(cc26) = 10 feature(cc26) = Pizza16
  id(cc27) = 10 feature(cc27) = Pizza19

  id(cc28) = 11 feature(cc28) = Pizza5
  id(cc29) = 11 feature(cc29) = Pizza16
  id(cc30) = 11 feature(cc30) = Pizza19

  id(cc31) = 12 feature(cc31) = Pizza10
  id(cc32) = 12 feature(cc32) = Pizza16
  id(cc33) = 12 feature(cc33) = Pizza19
  
  id(cc34) = 13 feature(cc34) = Pizza11
  id(cc35) = 13 feature(cc35) = Pizza16
  id(cc36) = 13 feature(cc36) = Pizza19

  id(cc37) = 14 feature(cc37) = Pizza12
  id(cc38) = 14 feature(cc38) = Pizza16
  id(cc39) = 14 feature(cc39) = Pizza19
 
  id(cc40) = 15 feature(cc40) = Pizza13
  id(cc41) = 15 feature(cc41) = Pizza16
  id(cc42) = 15 feature(cc42) = Pizza19

  id(cc43) = 16 feature(cc43) = Pizza4
  id(cc44) = 16 feature(cc44) = Pizza17
  id(cc45) = 16 feature(cc45) = Pizza19

  id(cc46) = 17 feature(cc46) = Pizza5
  id(cc47) = 17 feature(cc47) = Pizza17
  id(cc48) = 17 feature(cc48) = Pizza19

  id(cc49) = 18 feature(cc49) = Pizza10
  id(cc50) = 18 feature(cc50) = Pizza17
  id(cc51) = 18 feature(cc51) = Pizza19
  
  id(cc52) = 19 feature(cc52) = Pizza11
  id(cc53) = 19 feature(cc53) = Pizza17
  id(cc54) = 19 feature(cc54) = Pizza19

  id(cc55) = 20 feature(cc55) = Pizza12
  id(cc56) = 20 feature(cc56) = Pizza17
  id(cc57) = 20 feature(cc57) = Pizza19
 
  id(cc58) = 21 feature(cc58) = Pizza13
  id(cc59) = 21 feature(cc59) = Pizza17
  id(cc60) = 21 feature(cc60) = Pizza19

  # Firewall op
  id(cc61) = 22 feature(cc61) = Pizza4
  id(cc62) = 22 feature(cc62) = Pizza15
  id(cc63) = 22 feature(cc63) = Pizza20

  id(cc64) = 23 feature(cc64) = Pizza5
  id(cc65) = 23 feature(cc65) = Pizza15
  id(cc66) = 23 feature(cc66) = Pizza20

  id(cc67) = 24 feature(cc67) = Pizza6
  id(cc68) = 24 feature(cc68) = Pizza20

  id(cc69) = 25 feature(cc69) = Pizza7
  id(cc70) = 25 feature(cc70) = Pizza20
  
  id(cc71) = 26 feature(cc71) = Pizza8
  id(cc72) = 26 feature(cc72) = Pizza20

  id(cc73) = 27 feature(cc73) = Pizza10
  id(cc74) = 27 feature(cc74) = Pizza15
  id(cc75) = 27 feature(cc75) = Pizza20
  
  id(cc76) = 28 feature(cc76) = Pizza11
  id(cc77) = 28 feature(cc77) = Pizza15
  id(cc78) = 28 feature(cc78) = Pizza20

  id(cc79) = 29 feature(cc79) = Pizza12
  id(cc80) = 29 feature(cc80) = Pizza15
  id(cc81) = 29 feature(cc81) = Pizza20
 
  id(cc82) = 30 feature(cc82) = Pizza13
  id(cc83) = 30 feature(cc83) = Pizza15
  id(cc84) = 30 feature(cc84) = Pizza20

  id(cc85) = 31 feature(cc85) = Pizza4
  id(cc86) = 31 feature(cc86) = Pizza16
  id(cc87) = 31 feature(cc87) = Pizza20

  id(cc88) = 32 feature(cc88) = Pizza5
  id(cc89) = 32 feature(cc89) = Pizza16
  id(cc90) = 32 feature(cc90) = Pizza20

  id(cc91) = 33 feature(cc91) = Pizza10
  id(cc92) = 33 feature(cc92) = Pizza16
  id(cc93) = 33 feature(cc93) = Pizza20
  
  id(cc94) = 34 feature(cc94) = Pizza11
  id(cc95) = 34 feature(cc95) = Pizza16
  id(cc96) = 34 feature(cc96) = Pizza20

  id(cc97) = 35 feature(cc97) = Pizza12
  id(cc98) = 35 feature(cc98) = Pizza16
  id(cc99) = 35 feature(cc99) = Pizza20
 
  id(cc100) = 36 feature(cc100) = Pizza13
  id(cc101) = 36 feature(cc101) = Pizza16
  id(cc102) = 36 feature(cc102) = Pizza20

  id(cc103) = 37 feature(cc103) = Pizza4
  id(cc104) = 37 feature(cc104) = Pizza17
  id(cc105) = 37 feature(cc105) = Pizza20

  id(cc106) = 38 feature(cc106) = Pizza5
  id(cc107) = 38 feature(cc107) = Pizza17
  id(cc108) = 38 feature(cc108) = Pizza20

  id(cc109) = 39 feature(cc109) = Pizza10
  id(cc110) = 39 feature(cc110) = Pizza17
  id(cc111) = 39 feature(cc111) = Pizza20
  
  id(cc112) = 40 feature(cc112) = Pizza11
  id(cc113) = 40 feature(cc113) = Pizza17
  id(cc114) = 40 feature(cc114) = Pizza20

  id(cc115) = 41 feature(cc115) = Pizza12
  id(cc116) = 41 feature(cc116) = Pizza17
  id(cc117) = 41 feature(cc117) = Pizza20
 
  id(cc118) = 42 feature(cc118) = Pizza13
  id(cc119) = 42 feature(cc119) = Pizza17
  id(cc120) = 42 feature(cc120) = Pizza20

  # Encryption op
  id(cc121) = 43 feature(cc121) = Pizza4
  id(cc122) = 43 feature(cc122) = Pizza15
  id(cc123) = 43 feature(cc123) = Pizza21

  id(cc124) = 44 feature(cc124) = Pizza5
  id(cc125) = 44 feature(cc125) = Pizza15
  id(cc126) = 44 feature(cc126) = Pizza21

  id(cc127) = 45 feature(cc127) = Pizza6
  id(cc128) = 45 feature(cc128) = Pizza21

  id(cc129) = 46 feature(cc129) = Pizza7
  id(cc130) = 46 feature(cc130) = Pizza21
  
  id(cc131) = 47 feature(cc131) = Pizza8
  id(cc132) = 47 feature(cc132) = Pizza21

  id(cc133) = 48 feature(cc133) = Pizza10
  id(cc134) = 48 feature(cc134) = Pizza15
  id(cc135) = 48 feature(cc135) = Pizza21
  
  id(cc136) = 49 feature(cc136) = Pizza11
  id(cc137) = 49 feature(cc137) = Pizza15
  id(cc138) = 49 feature(cc138) = Pizza21

  id(cc139) = 50 feature(cc139) = Pizza12
  id(cc140) = 50 feature(cc140) = Pizza15
  id(cc141) = 50 feature(cc141) = Pizza21
 
  id(cc142) = 51 feature(cc142) = Pizza13
  id(cc143) = 51 feature(cc143) = Pizza15
  id(cc144) = 51 feature(cc144) = Pizza21

  id(cc145) = 52 feature(cc145) = Pizza4
  id(cc146) = 52 feature(cc146) = Pizza16
  id(cc147) = 52 feature(cc147) = Pizza21

  id(cc148) = 53 feature(cc148) = Pizza5
  id(cc149) = 53 feature(cc149) = Pizza16
  id(cc150) = 53 feature(cc150) = Pizza21

  id(cc151) = 54 feature(cc151) = Pizza10
  id(cc152) = 54 feature(cc152) = Pizza16
  id(cc153) = 54 feature(cc153) = Pizza21
  
  id(cc154) = 55 feature(cc154) = Pizza11
  id(cc155) = 55 feature(cc155) = Pizza16
  id(cc156) = 55 feature(cc156) = Pizza21

  id(cc157) = 56 feature(cc157) = Pizza12
  id(cc158) = 56 feature(cc158) = Pizza16
  id(cc159) = 56 feature(cc159) = Pizza21
 
  id(cc160) = 57 feature(cc160) = Pizza13
  id(cc161) = 57 feature(cc161) = Pizza16
  id(cc162) = 57 feature(cc162) = Pizza21

  id(cc163) = 58 feature(cc163) = Pizza4
  id(cc164) = 58 feature(cc164) = Pizza17
  id(cc165) = 58 feature(cc165) = Pizza21

  id(cc166) = 59 feature(cc166) = Pizza5
  id(cc167) = 59 feature(cc167) = Pizza17
  id(cc168) = 59 feature(cc168) = Pizza21

  id(cc169) = 60 feature(cc169) = Pizza10
  id(cc170) = 60 feature(cc170) = Pizza17
  id(cc171) = 60 feature(cc171) = Pizza21
  
  id(cc172) = 61 feature(cc172) = Pizza11
  id(cc173) = 61 feature(cc173) = Pizza17
  id(cc174) = 61 feature(cc174) = Pizza21

  id(cc175) = 62 feature(cc175) = Pizza12
  id(cc176) = 62 feature(cc176) = Pizza17
  id(cc177) = 62 feature(cc177) = Pizza21

  id(cc178) = 63 feature(cc178) = Pizza13
  id(cc179) = 63 feature(cc179) = Pizza17
  id(cc180) = 63 feature(cc180) = Pizza21

  name(qn1) = Runtime
  name(qn2) = EnergyRate
  domain(qd1) = Seconds
  domain(qd2) = Watts
  
  # Runtime
  value(qv1) = 1
  value(qv2) = 2
  value(qv3) = 3
  value(qv4) = 4
  value(qv5) = 5
  value(qv6) = 6
  
  # Energy
  value(qv7) = 13
  value(qv8) = 14
  value(qv9) = 15
  value(qv10) = 16
  value(qv11) = 17
  value(qv12) = 18
  value(qv13) = 19
  value(qv14) = 20
  value(qv15) = 22
  
  # Runtime = X seconds
  name(qs1) = qn1 value(qs1) = qv1 domain(qs1) = qd1
  name(qs2) = qn1 value(qs2) = qv2 domain(qs2) = qd1
  name(qs3) = qn1 value(qs3) = qv3 domain(qs3) = qd1
  name(qs4) = qn1 value(qs4) = qv4 domain(qs4) = qd1
  name(qs5) = qn1 value(qs5) = qv5 domain(qs5) = qd1
  name(qs6) = qn1 value(qs6) = qv6 domain(qs6) = qd1

  # Energy = Y watts
  name(qs7) = qn2 value(qs7) = qv7 domain(qs7) = qd2
  name(qs8) = qn2 value(qs8) = qv8 domain(qs8) = qd2
  name(qs9) = qn2 value(qs9) = qv9 domain(qs9) = qd2
  name(qs10) = qn2 value(qs10) = qv10 domain(qs10) = qd2
  name(qs11) = qn2 value(qs11) = qv11 domain(qs11) = qd2
  name(qs12) = qn2 value(qs12) = qv12 domain(qs12) = qd2
  name(qs13) = qn2 value(qs13) = qv13 domain(qs13) = qd2
  name(qs14) = qn2 value(qs14) = qv14 domain(qs14) = qd2
  name(qs15) = qn2 value(qs15) = qv15 domain(qs15) = qd2

  # Sets of Measurements (63 or less if some CCs behave equally)

  # 1, 10, 16 (1,22)
  id(qa1) = 1 qualities(qa1) = qs1
  id(qa2) = 1 qualities(qa2) = qs15	

  # 2, 3, 11, 17 (1,20)
  id(qa3) = 2 qualities(qa3) = qs1
  id(qa4) = 2 qualities(qa4) = qs14	

  # 4 (1,19)
  id(qa5) = 3 qualities(qa5) = qs1
  id(qa6) = 3 qualities(qa6) = qs13
  
  # 5 (1,18)
  id(qa7) = 4 qualities(qa7) = qs1
  id(qa8) = 4 qualities(qa8) = qs12

  # 6, 12 (2,14)
  id(qa9) = 5 qualities(qa9) = qs2
  id(qa10) = 5 qualities(qa10) = qs8

  # 7, 8 , 9, 13, 14, 15 (2,13)
  id(qa11) = 6 qualities(qa11) = qs2
  id(qa12) = 6 qualities(qa12) = qs7
  
  # 18 (1,14)
  id(qa13) = 7 qualities(qa13) = qs1
  id(qa14) = 7 qualities(qa14) = qs8

  # 19, 20, 21 (1,13)
  id(qa15) = 8 qualities(qa15) = qs1
  id(qa16) = 8 qualities(qa16) = qs7

  # 22, 31, 37, 43, 51, 57 (3,17)
  id(qa17) = 9 qualities(qa17) = qs3
  id(qa18) = 9 qualities(qa18) = qs11

  # 23, 30, 32, 36, 38, 42, 44, 52, 56, 58, 62 (3,15)
  id(qa19) = 10 qualities(qa19) = qs3
  id(qa20) = 10 qualities(qa20) = qs9

  # 24, 45 (4,15)
  id(qa21) = 11 qualities(qa21) = qs4
  id(qa22) = 11 qualities(qa22) = qs9

  # 25, 46 (4,14)
  id(qa23) = 12 qualities(qa23) = qs4
  id(qa24) = 12 qualities(qa24) = qs8

  # 26, 47 (3,13)
  id(qa25) = 13 qualities(qa25) = qs3
  id(qa26) = 13 qualities(qa26) = qs7

  # 27, 33, 39, 48, 53, 59 (6,18)
  id(qa27) = 14 qualities(qa27) = qs6
  id(qa28) = 14 qualities(qa28) = qs12

  # 28, 34, 40, 49, 54, 60 (5,17)
  id(qa29) = 15 qualities(qa29) = qs5
  id(qa30) = 15 qualities(qa30) = qs11

  # 29, 35, 41, 50, 55, 61 (4,16)
  id(qa31) = 16 qualities(qa31) = qs4
  id(qa32) = 16 qualities(qa32) = qs10
  
  phi(qmc1) = 1 psi(qmc1) = 1
  phi(qmc2) = 10 psi(qmc2) = 1  
  phi(qmc3) = 16 psi(qmc3) = 1  
  phi(qmc4) = 2 psi(qmc4) = 2
  phi(qmc5) = 3 psi(qmc5) = 2
  phi(qmc6) = 11 psi(qmc6) = 2
  phi(qmc7) = 17 psi(qmc7) = 2
  phi(qmc8) = 4 psi(qmc8) = 3
  phi(qmc9) = 5 psi(qmc9) = 4
  phi(qmc10) = 6 psi(qmc10) = 5
  phi(qmc11) = 12 psi(qmc11) = 5
  phi(qmc12) = 7 psi(qmc12) = 6
  phi(qmc13) = 8 psi(qmc13) = 6  
  phi(qmc14) = 9 psi(qmc14) = 6
  phi(qmc15) = 13 psi(qmc15) = 6
  phi(qmc16) = 14 psi(qmc16) = 6
  phi(qmc17) = 15 psi(qmc17) = 6
  phi(qmc18) = 18 psi(qmc18) = 7
  phi(qmc19) = 19 psi(qmc19) = 8
  phi(qmc20) = 20 psi(qmc20) = 8
  phi(qmc21) = 21 psi(qmc21) = 8
  phi(qmc22) = 22 psi(qmc22) = 9
  phi(qmc23) = 31 psi(qmc23) = 9  
  phi(qmc24) = 37 psi(qmc24) = 9
  phi(qmc25) = 43 psi(qmc25) = 9
  phi(qmc26) = 52 psi(qmc26) = 9
  phi(qmc27) = 58 psi(qmc27) = 9
  phi(qmc28) = 23 psi(qmc28) = 10
  phi(qmc29) = 30 psi(qmc29) = 10
  phi(qmc30) = 32 psi(qmc30) = 10
  phi(qmc31) = 36 psi(qmc31) = 10
  phi(qmc32) = 38 psi(qmc32) = 10
  phi(qmc33) = 42 psi(qmc33) = 10 
  phi(qmc34) = 44 psi(qmc34) = 10
  phi(qmc35) = 51 psi(qmc35) = 10
  phi(qmc36) = 53 psi(qmc36) = 10
  phi(qmc37) = 57 psi(qmc37) = 10
  phi(qmc38) = 59 psi(qmc38) = 10
  phi(qmc39) = 63 psi(qmc39) = 10
  phi(qmc40) = 24 psi(qmc40) = 11	
  phi(qmc41) = 45 psi(qmc41) = 11
  phi(qmc42) = 25 psi(qmc42) = 12
  phi(qmc43) = 46 psi(qmc43) = 12 
  phi(qmc44) = 26 psi(qmc44) = 13
  phi(qmc45) = 47 psi(qmc45) = 13
  phi(qmc46) = 27 psi(qmc46) = 14
  phi(qmc47) = 33 psi(qmc47) = 14
  phi(qmc48) = 39 psi(qmc48) = 14
  phi(qmc49) = 48 psi(qmc49) = 14
  phi(qmc50) = 54 psi(qmc50) = 14
  phi(qmc51) = 60 psi(qmc51) = 14
  phi(qmc52) = 28 psi(qmc52) = 15
  phi(qmc53) = 34 psi(qmc53) = 15
  phi(qmc54) = 40 psi(qmc54) = 15
  phi(qmc55) = 49 psi(qmc55) = 15
  phi(qmc56) = 55 psi(qmc56) = 15
  phi(qmc57) = 60 psi(qmc57) = 15
  phi(qmc58) = 29 psi(qmc58) = 16
  phi(qmc59) = 35 psi(qmc59) = 16
  phi(qmc60) = 41 psi(qmc60) = 16
  phi(qmc61) = 50 psi(qmc61) = 16
  phi(qmc62) = 56 psi(qmc62) = 16
  phi(qmc63) = 62 psi(qmc63) = 16 
}

# RES Category for SATISFY reasoning operation
schema RESSATISFY = literal : Ty {
 entities
  SAT
 attributes
  "IS_SAT?": SAT -> Bool
  
}

query SATISFY = literal : PizzaCategory -> RESSATISFY {
 entity 
  SAT -> {
   attributes
    "IS_SAT?" ->  from CCID : QMC
   						where
						   and(ge(CCID.phi, 0), ge(CCID.psi, 0)) = True
  	    		 		return
  	    		 			True
  	    		    		aggregate False lambda arg1 arg2. arg2
    }
}

instance SATSolver = eval SATISFY PizzaData

# RES Category for COUNT reasoning operation
schema RESCOUNT = literal : Ty {
 entities
  COUNT 
 attributes
  "# Measured Configurations": COUNT -> Integer

}

query COUNT = literal : PizzaCategory -> RESCOUNT {
 entity 
  COUNT -> {
   attributes
    "# Measured Configurations" -> from CCID : QMC
   						where
						   and(ge(CCID.phi, 0), ge(CCID.psi, 0)) = True
  	    		 		return
  	    		 			1
  	    		    		aggregate 0 lambda arg1 arg2. add(arg1,1)
  }
}

instance COUNTSolver = eval COUNT PizzaData

# RES Category for reasoning operations that generate configurations
schema RES = literal : Ty {
 entities
  CONFS 
 attributes
  cc_traces qas: CONFS -> String
}

query FILTER = literal : PizzaCategory -> RES {
 entity 
  CONFS -> {
   from
    QMC : QMC
    CC:CCs
   where 
	CC.id = QMC.phi
	CC.feature.cardinality = leaf
	CC.feature.selfParent.feature = Mobile 
   attributes
    cc_traces -> from cc:CCs
				 		where 
							cc.id = CC.id
  	    		 		return
  	    					ifi(eq(cc.feature.domain, Bool),trace2(cc.feature.selfParent.selfParent.feature, cc.feature.selfParent.selfParent.cardinality, cc.feature.selfParent.feature, cc.feature.selfParent.cardinality, cc.feature.feature)
  	    		    		,itrace2(cc.feature.selfParent.selfParent.feature, cc.feature.selfParent.selfParent.cardinality, cc.feature.selfParent.feature, cc.feature.selfParent.cardinality, cc.feature.feature, cc.feature.value, cc.feature.domain))
  	    					aggregate "" lambda arg1 arg2. regconcat(arg1,arg2)

    qas -> from qa:QAs
				 		where 
							qa.id = QMC.psi
  	    		 		return
  	    		 			concat(qa.qualities.name.name, qa.qualities.value.value, qa.qualities.domain.domain)  	    					
  	    		    		aggregate "" lambda arg1 arg2. regconcat(arg1,arg2)
  }
}

instance FILTERSolver = eval FILTER PizzaData

query BOUND = literal : PizzaCategory -> RES {
 entity 
  CONFS -> {
   from
    QMC : QMC
   attributes
    cc_traces -> from cc:CCs
				 		where 
							cc.id = QMC.phi
							cc.feature.cardinality = leaf
  	    		 		return
  	    					ifi(eq(cc.feature.domain, Bool),trace2(cc.feature.selfParent.selfParent.feature, cc.feature.selfParent.selfParent.cardinality, cc.feature.selfParent.feature, cc.feature.selfParent.cardinality, cc.feature.feature)
  	    		    		,itrace2(cc.feature.selfParent.selfParent.feature, cc.feature.selfParent.selfParent.cardinality, cc.feature.selfParent.feature, cc.feature.selfParent.cardinality, cc.feature.feature, cc.feature.value, cc.feature.domain))
  	    					aggregate "" lambda arg1 arg2. regconcat(arg1,arg2)

    qas -> from qa:QAs
				 		where 
							qa.id = QMC.psi
  	    		 		return
  	    		 			concat(qa.qualities.name.name, qa.qualities.value.value, qa.qualities.domain.domain)  	    					
  	    		    		aggregate "" lambda arg1 arg2. regconcat(arg1,arg2)
  }
}

# Set 'Row Limit' to 1 in the resulting GUI to limit the scope to the desired number of instances
instance BOUNDSolver = eval BOUND PizzaData

query RANDOM = literal : PizzaCategory -> RES {
 entity 
  CONFS -> {
   from
    QMC : QMC
   attributes
    cc_traces -> from cc:CCs
				 		where 
							cc.id = QMC.phi
							cc.feature.cardinality = leaf
  	    		 		return
  	    					ifi(eq(cc.feature.domain, Bool),trace2(cc.feature.selfParent.selfParent.feature, cc.feature.selfParent.selfParent.cardinality, cc.feature.selfParent.feature, cc.feature.selfParent.cardinality, cc.feature.feature)
  	    		    		,itrace2(cc.feature.selfParent.selfParent.feature, cc.feature.selfParent.selfParent.cardinality, cc.feature.selfParent.feature, cc.feature.selfParent.cardinality, cc.feature.feature, cc.feature.value, cc.feature.domain))
  	    					aggregate "" lambda arg1 arg2. regconcat(arg1,arg2)

    qas -> from qa:QAs
				 		where 
							qa.id = QMC.psi
  	    		 		return
  	    		 			concat(qa.qualities.name.name, qa.qualities.value.value, qa.qualities.domain.domain)  	    					
  	    		    		aggregate "" lambda arg1 arg2. regconcat(arg1,arg2)
    #tes -> ran(1, 100)
  }
}

# Shuffled
instance PizzaDataRandom1 = literal : PizzaCategory {
#63 instances
 generators 
  Pizza1 Pizza2 Pizza3 Pizza4 Pizza5 Pizza6 Pizza7 Pizza8 Pizza9 Pizza10 Pizza11 Pizza12 Pizza13 Pizza14 Pizza15 Pizza16 Pizza17 Pizza18 Pizza19 Pizza20 Pizza21: Pizza
  qn1 qn2 : Qn
  qv1 qv2 qv3 qv4 qv5 qv6 qv7 qv8 qv9 qv10 qv11 qv12 qv13 qv14 qv15 : Qv
  qd1 qd2 : Qd
  qs1 qs2 qs3 qs4 qs5 qs6 qs7 qs8 qs9 qs10 qs11 qs12 qs13 qs14 qs15 : Qs
  qa1 qa2 qa3 qa4 qa5 qa6 qa7 qa8 qa9 qa10 qa11 qa12 qa13 qa14 qa15 qa16 qa17 qa18 qa19 qa20 qa21 qa22 qa23 qa24 qa25 qa26 qa27 qa28 qa29 qa30 qa31 qa32 : QAs
  
  cc1 cc2 cc3 cc4 cc5 cc6 cc7 cc8 cc9 cc10 cc11 cc12 cc13 cc14 cc15 cc16 cc17 cc18 cc19 cc20 cc21 cc22 cc23 cc24 : CCs
  cc25 cc26 cc27 cc28 cc29 cc30 cc31 cc32 cc33 cc34 cc35 cc36 cc37 cc38 cc39 cc40 cc41 cc42 cc43 cc44 cc45 cc46 cc47 cc48 cc49 : CCs
  cc50 cc51 cc52 cc53 cc54 cc55 cc56 cc57 cc58 cc59 cc60 cc61 cc62 cc63 cc64 cc65 cc66 cc67 cc68 cc69 cc70 cc71 cc72 cc73 cc74 cc75 cc76 cc77 cc78 cc79 : CCs
  cc80 cc81 cc82 cc83 cc84 cc85 cc86 cc87 cc88 cc89 cc90 cc91 cc92 cc93 cc94 cc95 cc96 cc97 cc98 cc99 cc100 cc101 cc102 cc103 cc104 cc105 cc106 cc107 cc108 cc109 : CCs
  cc110 cc111 cc112 cc112 cc113 cc114 cc115 cc116 cc117 cc118 cc119 cc120 cc121 cc122 cc122 cc123 cc124 cc125 cc126 cc127 cc128 cc129 cc130 cc131 cc132 cc132 cc133 cc134 cc135 cc136 cc137 cc138 cc139 : CCs  
  cc140 cc141 cc142 cc142 cc143 cc144 cc145 cc146 cc147 cc148 cc149 cc150 cc151 cc152 cc152 cc153 cc154 cc155 cc156 cc157 cc158 cc159 cc160 cc161 cc162 cc162 cc163 cc164 cc165 cc166 cc167 cc168 cc169 : CCs  
  cc170 cc171 cc172 cc172 cc173 cc174 cc175 cc176 cc177 cc178 cc179 cc180 : CCs
  
  qmc1 qmc2 qmc3 qmc4 qmc5 qmc6 qmc7 qmc8 qmc9 qmc10 qmc11 qmc12 qmc13 qmc14 qmc15 qmc16 qmc17 qmc18 qmc19 qmc20 qmc21 qmc22 qmc23 qmc24 qmc25 qmc26 qmc27 qmc28 qmc29 qmc30 qmc31 qmc32 qmc33 qmc34 qmc35 qmc36 qmc37 qmc38 qmc39 qmc40 qmc41 qmc42 qmc43 qmc44 qmc45 qmc46 qmc47 qmc48 qmc49 qmc50 qmc51 qmc52 qmc53 qmc54 qmc55 qmc56 qmc57 qmc58 qmc59 qmc60 qmc61 qmc62 qmc63: QMC

 equations
  # Extended Numerical Variability Model Data
  feature(Pizza1) = Pizza domain(Pizza1) = Bool value(Pizza1) = 1 cardinality(Pizza1) = N selfParent(Pizza1) = Pizza1
  feature(Pizza2) = Interface domain(Pizza2) = Bool value(Pizza2) = 1 cardinality(Pizza2) = XOR selfParent(Pizza2) = Pizza1
  feature(Pizza3) = Wifi domain(Pizza3) = Bool value(Pizza3) = 1 cardinality(Pizza3) = XOR selfParent(Pizza3) = Pizza2
  feature(Pizza4) = GHz_24 domain(Pizza4) = Bool value(Pizza4) = 1 cardinality(Pizza4) = leaf selfParent(Pizza4) = Pizza3 cost_USD(Pizza4) = 30
  feature(Pizza5) = GHz_5 domain(Pizza5) = Bool value(Pizza5) = 1 cardinality(Pizza5) = leaf selfParent(Pizza5) = Pizza3 cost_USD(Pizza5) = 50
  feature(Pizza6) = Ethernet domain(Pizza6) = Integer value(Pizza6) = 10 cardinality(Pizza6) = leaf selfParent(Pizza6) = Pizza2 cost_USD(Pizza6) = 15
  feature(Pizza7) = Ethernet domain(Pizza7) = Integer value(Pizza7) = 100 cardinality(Pizza7) = leaf selfParent(Pizza7) = Pizza2 cost_USD(Pizza7) = 15
  feature(Pizza8) = Ethernet domain(Pizza8) = Integer value(Pizza8) = 1000 cardinality(Pizza8) = leaf selfParent(Pizza8) = Pizza2 cost_USD(Pizza8) = 15

  feature(Pizza9) = Mobile domain(Pizza9) = Bool value(Pizza9) = 1 cardinality(Pizza9) = XOR  selfParent(Pizza9) = Pizza2  
  feature(Pizza10) = G_3 domain(Pizza10) = Bool value(Pizza10) = 1 cardinality(Pizza10) = leaf selfParent(Pizza10) = Pizza9 cost_USD(Pizza10) = 30
  feature(Pizza11) = G_4 domain(Pizza11) = Bool value(Pizza11) = 1 cardinality(Pizza11) = leaf selfParent(Pizza11) = Pizza9 cost_USD(Pizza11) = 40
  feature(Pizza12) = G_5 domain(Pizza12) = Bool value(Pizza12) = 1 cardinality(Pizza12) = leaf selfParent(Pizza12) = Pizza9 cost_USD(Pizza12) = 75
  feature(Pizza13) = G_5p domain(Pizza13) = Bool value(Pizza13) = 1 cardinality(Pizza13) = leaf selfParent(Pizza13) = Pizza9 cost_USD(Pizza13) = 3000
  
  feature(Pizza14) = Antenna domain(Pizza14) = Bool value(Pizza14) = 1 cardinality(Pizza14) = XOR selfParent(Pizza14) = Pizza1
  feature(Pizza15) = Small domain(Pizza15) = Bool value(Pizza15) = 1 cost_USD(Pizza15) = 3 cardinality(Pizza15) = leaf selfParent(Pizza15) = Pizza14
  feature(Pizza16) = Medium domain(Pizza16) = Bool value(Pizza16) = 1 cost_USD(Pizza16) = 4 cardinality(Pizza16) = leaf selfParent(Pizza16) = Pizza14
  feature(Pizza17) = Large domain(Pizza17) = Bool value(Pizza17) = 1 cost_USD(Pizza17) = 5 cardinality(Pizza17) = leaf selfParent(Pizza17) = Pizza14

  feature(Pizza18) = VirtualNetworkFunctions domain(Pizza18) = Bool value(Pizza18) = 1 cardinality(Pizza18) = XOR  selfParent(Pizza18) = Pizza2  
  feature(Pizza19) = Monitor domain(Pizza19) = Bool value(Pizza19) = 1 cardinality(Pizza19) = leaf selfParent(Pizza19) = Pizza18 cost_USD(Pizza19) = 0
  feature(Pizza20) = Firewall domain(Pizza20) = Bool value(Pizza20) = 1 cardinality(Pizza20) = leaf selfParent(Pizza20) = Pizza18 cost_USD(Pizza20) = 0
  feature(Pizza21) = Encryption domain(Pizza21) = Bool value(Pizza21) = 1 cardinality(Pizza21) = leaf selfParent(Pizza21) = Pizza18 cost_USD(Pizza21) = 0
  
  # 63 Measured Configurations

  # Monitor op
  id(cc1) = 1 feature(cc1) = Pizza4
  id(cc2) = 1 feature(cc2) = Pizza15
  id(cc3) = 1 feature(cc3) = Pizza19

  id(cc4) = 2 feature(cc4) = Pizza5
  id(cc5) = 2 feature(cc5) = Pizza15
  id(cc6) = 2 feature(cc6) = Pizza19

  id(cc7) = 3 feature(cc7) = Pizza6
  id(cc8) = 3 feature(cc8) = Pizza19

  id(cc9) = 4 feature(cc9) = Pizza7
  id(cc10) = 4 feature(cc10) = Pizza19
  
  id(cc11) = 5 feature(cc11) = Pizza8
  id(cc12) = 5 feature(cc12) = Pizza19

  id(cc13) = 6 feature(cc13) = Pizza10
  id(cc14) = 6 feature(cc14) = Pizza15
  id(cc15) = 6 feature(cc15) = Pizza19
  
  id(cc16) = 7 feature(cc16) = Pizza11
  id(cc17) = 7 feature(cc17) = Pizza15
  id(cc18) = 7 feature(cc18) = Pizza19

  id(cc19) = 8 feature(cc19) = Pizza12
  id(cc20) = 8 feature(cc20) = Pizza15
  id(cc21) = 8 feature(cc21) = Pizza19
 
  id(cc22) = 9 feature(cc22) = Pizza13
  id(cc23) = 9 feature(cc23) = Pizza15
  id(cc24) = 9 feature(cc24) = Pizza19

  id(cc25) = 10 feature(cc25) = Pizza4
  id(cc26) = 10 feature(cc26) = Pizza16
  id(cc27) = 10 feature(cc27) = Pizza19

  id(cc28) = 11 feature(cc28) = Pizza5
  id(cc29) = 11 feature(cc29) = Pizza16
  id(cc30) = 11 feature(cc30) = Pizza19

  id(cc31) = 12 feature(cc31) = Pizza10
  id(cc32) = 12 feature(cc32) = Pizza16
  id(cc33) = 12 feature(cc33) = Pizza19
  
  id(cc34) = 13 feature(cc34) = Pizza11
  id(cc35) = 13 feature(cc35) = Pizza16
  id(cc36) = 13 feature(cc36) = Pizza19

  id(cc37) = 14 feature(cc37) = Pizza12
  id(cc38) = 14 feature(cc38) = Pizza16
  id(cc39) = 14 feature(cc39) = Pizza19
 
  id(cc40) = 15 feature(cc40) = Pizza13
  id(cc41) = 15 feature(cc41) = Pizza16
  id(cc42) = 15 feature(cc42) = Pizza19

  id(cc43) = 16 feature(cc43) = Pizza4
  id(cc44) = 16 feature(cc44) = Pizza17
  id(cc45) = 16 feature(cc45) = Pizza19

  id(cc46) = 17 feature(cc46) = Pizza5
  id(cc47) = 17 feature(cc47) = Pizza17
  id(cc48) = 17 feature(cc48) = Pizza19

  id(cc49) = 18 feature(cc49) = Pizza10
  id(cc50) = 18 feature(cc50) = Pizza17
  id(cc51) = 18 feature(cc51) = Pizza19
  
  id(cc52) = 19 feature(cc52) = Pizza11
  id(cc53) = 19 feature(cc53) = Pizza17
  id(cc54) = 19 feature(cc54) = Pizza19

  id(cc55) = 20 feature(cc55) = Pizza12
  id(cc56) = 20 feature(cc56) = Pizza17
  id(cc57) = 20 feature(cc57) = Pizza19
 
  id(cc58) = 21 feature(cc58) = Pizza13
  id(cc59) = 21 feature(cc59) = Pizza17
  id(cc60) = 21 feature(cc60) = Pizza19

  # Firewall op
  id(cc61) = 22 feature(cc61) = Pizza4
  id(cc62) = 22 feature(cc62) = Pizza15
  id(cc63) = 22 feature(cc63) = Pizza20

  id(cc64) = 23 feature(cc64) = Pizza5
  id(cc65) = 23 feature(cc65) = Pizza15
  id(cc66) = 23 feature(cc66) = Pizza20

  id(cc67) = 24 feature(cc67) = Pizza6
  id(cc68) = 24 feature(cc68) = Pizza20

  id(cc69) = 25 feature(cc69) = Pizza7
  id(cc70) = 25 feature(cc70) = Pizza20
  
  id(cc71) = 26 feature(cc71) = Pizza8
  id(cc72) = 26 feature(cc72) = Pizza20

  id(cc73) = 27 feature(cc73) = Pizza10
  id(cc74) = 27 feature(cc74) = Pizza15
  id(cc75) = 27 feature(cc75) = Pizza20
  
  id(cc76) = 28 feature(cc76) = Pizza11
  id(cc77) = 28 feature(cc77) = Pizza15
  id(cc78) = 28 feature(cc78) = Pizza20

  id(cc79) = 29 feature(cc79) = Pizza12
  id(cc80) = 29 feature(cc80) = Pizza15
  id(cc81) = 29 feature(cc81) = Pizza20
 
  id(cc82) = 30 feature(cc82) = Pizza13
  id(cc83) = 30 feature(cc83) = Pizza15
  id(cc84) = 30 feature(cc84) = Pizza20

  id(cc85) = 31 feature(cc85) = Pizza4
  id(cc86) = 31 feature(cc86) = Pizza16
  id(cc87) = 31 feature(cc87) = Pizza20

  id(cc88) = 32 feature(cc88) = Pizza5
  id(cc89) = 32 feature(cc89) = Pizza16
  id(cc90) = 32 feature(cc90) = Pizza20

  id(cc91) = 33 feature(cc91) = Pizza10
  id(cc92) = 33 feature(cc92) = Pizza16
  id(cc93) = 33 feature(cc93) = Pizza20
  
  id(cc94) = 34 feature(cc94) = Pizza11
  id(cc95) = 34 feature(cc95) = Pizza16
  id(cc96) = 34 feature(cc96) = Pizza20

  id(cc97) = 35 feature(cc97) = Pizza12
  id(cc98) = 35 feature(cc98) = Pizza16
  id(cc99) = 35 feature(cc99) = Pizza20
 
  id(cc100) = 36 feature(cc100) = Pizza13
  id(cc101) = 36 feature(cc101) = Pizza16
  id(cc102) = 36 feature(cc102) = Pizza20

  id(cc103) = 37 feature(cc103) = Pizza4
  id(cc104) = 37 feature(cc104) = Pizza17
  id(cc105) = 37 feature(cc105) = Pizza20

  id(cc106) = 38 feature(cc106) = Pizza5
  id(cc107) = 38 feature(cc107) = Pizza17
  id(cc108) = 38 feature(cc108) = Pizza20

  id(cc109) = 39 feature(cc109) = Pizza10
  id(cc110) = 39 feature(cc110) = Pizza17
  id(cc111) = 39 feature(cc111) = Pizza20
  
  id(cc112) = 40 feature(cc112) = Pizza11
  id(cc113) = 40 feature(cc113) = Pizza17
  id(cc114) = 40 feature(cc114) = Pizza20

  id(cc115) = 41 feature(cc115) = Pizza12
  id(cc116) = 41 feature(cc116) = Pizza17
  id(cc117) = 41 feature(cc117) = Pizza20
 
  id(cc118) = 42 feature(cc118) = Pizza13
  id(cc119) = 42 feature(cc119) = Pizza17
  id(cc120) = 42 feature(cc120) = Pizza20

  # Encryption op
  id(cc121) = 43 feature(cc121) = Pizza4
  id(cc122) = 43 feature(cc122) = Pizza15
  id(cc123) = 43 feature(cc123) = Pizza21

  id(cc124) = 44 feature(cc124) = Pizza5
  id(cc125) = 44 feature(cc125) = Pizza15
  id(cc126) = 44 feature(cc126) = Pizza21

  id(cc127) = 45 feature(cc127) = Pizza6
  id(cc128) = 45 feature(cc128) = Pizza21

  id(cc129) = 46 feature(cc129) = Pizza7
  id(cc130) = 46 feature(cc130) = Pizza21
  
  id(cc131) = 47 feature(cc131) = Pizza8
  id(cc132) = 47 feature(cc132) = Pizza21

  id(cc133) = 48 feature(cc133) = Pizza10
  id(cc134) = 48 feature(cc134) = Pizza15
  id(cc135) = 48 feature(cc135) = Pizza21
  
  id(cc136) = 49 feature(cc136) = Pizza11
  id(cc137) = 49 feature(cc137) = Pizza15
  id(cc138) = 49 feature(cc138) = Pizza21

  id(cc139) = 50 feature(cc139) = Pizza12
  id(cc140) = 50 feature(cc140) = Pizza15
  id(cc141) = 50 feature(cc141) = Pizza21
 
  id(cc142) = 51 feature(cc142) = Pizza13
  id(cc143) = 51 feature(cc143) = Pizza15
  id(cc144) = 51 feature(cc144) = Pizza21

  id(cc145) = 52 feature(cc145) = Pizza4
  id(cc146) = 52 feature(cc146) = Pizza16
  id(cc147) = 52 feature(cc147) = Pizza21

  id(cc148) = 53 feature(cc148) = Pizza5
  id(cc149) = 53 feature(cc149) = Pizza16
  id(cc150) = 53 feature(cc150) = Pizza21

  id(cc151) = 54 feature(cc151) = Pizza10
  id(cc152) = 54 feature(cc152) = Pizza16
  id(cc153) = 54 feature(cc153) = Pizza21
  
  id(cc154) = 55 feature(cc154) = Pizza11
  id(cc155) = 55 feature(cc155) = Pizza16
  id(cc156) = 55 feature(cc156) = Pizza21

  id(cc157) = 56 feature(cc157) = Pizza12
  id(cc158) = 56 feature(cc158) = Pizza16
  id(cc159) = 56 feature(cc159) = Pizza21
 
  id(cc160) = 57 feature(cc160) = Pizza13
  id(cc161) = 57 feature(cc161) = Pizza16
  id(cc162) = 57 feature(cc162) = Pizza21

  id(cc163) = 58 feature(cc163) = Pizza4
  id(cc164) = 58 feature(cc164) = Pizza17
  id(cc165) = 58 feature(cc165) = Pizza21

  id(cc166) = 59 feature(cc166) = Pizza5
  id(cc167) = 59 feature(cc167) = Pizza17
  id(cc168) = 59 feature(cc168) = Pizza21

  id(cc169) = 60 feature(cc169) = Pizza10
  id(cc170) = 60 feature(cc170) = Pizza17
  id(cc171) = 60 feature(cc171) = Pizza21
  
  id(cc172) = 61 feature(cc172) = Pizza11
  id(cc173) = 61 feature(cc173) = Pizza17
  id(cc174) = 61 feature(cc174) = Pizza21

  id(cc175) = 62 feature(cc175) = Pizza12
  id(cc176) = 62 feature(cc176) = Pizza17
  id(cc177) = 62 feature(cc177) = Pizza21

  id(cc178) = 63 feature(cc178) = Pizza13
  id(cc179) = 63 feature(cc179) = Pizza17
  id(cc180) = 63 feature(cc180) = Pizza21

  name(qn1) = Runtime
  name(qn2) = EnergyRate
  domain(qd1) = Seconds
  domain(qd2) = Watts
  
  # Runtime
  value(qv1) = 1
  value(qv2) = 2
  value(qv3) = 3
  value(qv4) = 4
  value(qv5) = 5
  value(qv6) = 6
  
  # Energy
  value(qv7) = 13
  value(qv8) = 14
  value(qv9) = 15
  value(qv10) = 16
  value(qv11) = 17
  value(qv12) = 18
  value(qv13) = 19
  value(qv14) = 20
  value(qv15) = 22
  
  # Runtime = X seconds
  name(qs1) = qn1 value(qs1) = qv1 domain(qs1) = qd1
  name(qs2) = qn1 value(qs2) = qv2 domain(qs2) = qd1
  name(qs3) = qn1 value(qs3) = qv3 domain(qs3) = qd1
  name(qs4) = qn1 value(qs4) = qv4 domain(qs4) = qd1
  name(qs5) = qn1 value(qs5) = qv5 domain(qs5) = qd1
  name(qs6) = qn1 value(qs6) = qv6 domain(qs6) = qd1

  # Energy = Y watts
  name(qs7) = qn2 value(qs7) = qv7 domain(qs7) = qd2
  name(qs8) = qn2 value(qs8) = qv8 domain(qs8) = qd2
  name(qs9) = qn2 value(qs9) = qv9 domain(qs9) = qd2
  name(qs10) = qn2 value(qs10) = qv10 domain(qs10) = qd2
  name(qs11) = qn2 value(qs11) = qv11 domain(qs11) = qd2
  name(qs12) = qn2 value(qs12) = qv12 domain(qs12) = qd2
  name(qs13) = qn2 value(qs13) = qv13 domain(qs13) = qd2
  name(qs14) = qn2 value(qs14) = qv14 domain(qs14) = qd2
  name(qs15) = qn2 value(qs15) = qv15 domain(qs15) = qd2

  # Sets of Measurements (63 or less if some CCs behave equally)

  # 1, 10, 16 (1,22)
  id(qa1) = 1 qualities(qa1) = qs1
  id(qa2) = 1 qualities(qa2) = qs15	

  # 2, 3, 11, 17 (1,20)
  id(qa3) = 2 qualities(qa3) = qs1
  id(qa4) = 2 qualities(qa4) = qs14	

  # 4 (1,19)
  id(qa5) = 3 qualities(qa5) = qs1
  id(qa6) = 3 qualities(qa6) = qs13
  
  # 5 (1,18)
  id(qa7) = 4 qualities(qa7) = qs1
  id(qa8) = 4 qualities(qa8) = qs12

  # 6, 12 (2,14)
  id(qa9) = 5 qualities(qa9) = qs2
  id(qa10) = 5 qualities(qa10) = qs8

  # 7, 8 , 9, 13, 14, 15 (2,13)
  id(qa11) = 6 qualities(qa11) = qs2
  id(qa12) = 6 qualities(qa12) = qs7
  
  # 18 (1,14)
  id(qa13) = 7 qualities(qa13) = qs1
  id(qa14) = 7 qualities(qa14) = qs8

  # 19, 20, 21 (1,13)
  id(qa15) = 8 qualities(qa15) = qs1
  id(qa16) = 8 qualities(qa16) = qs7

  # 22, 31, 37, 43, 51, 57 (3,17)
  id(qa17) = 9 qualities(qa17) = qs3
  id(qa18) = 9 qualities(qa18) = qs11

  # 23, 30, 32, 36, 38, 42, 44, 52, 56, 58, 62 (3,15)
  id(qa19) = 10 qualities(qa19) = qs3
  id(qa20) = 10 qualities(qa20) = qs9

  # 24, 45 (4,15)
  id(qa21) = 11 qualities(qa21) = qs4
  id(qa22) = 11 qualities(qa22) = qs9

  # 25, 46 (4,14)
  id(qa23) = 12 qualities(qa23) = qs4
  id(qa24) = 12 qualities(qa24) = qs8

  # 26, 47 (3,13)
  id(qa25) = 13 qualities(qa25) = qs3
  id(qa26) = 13 qualities(qa26) = qs7

  # 27, 33, 39, 48, 53, 59 (6,18)
  id(qa27) = 14 qualities(qa27) = qs6
  id(qa28) = 14 qualities(qa28) = qs12

  # 28, 34, 40, 49, 54, 60 (5,17)
  id(qa29) = 15 qualities(qa29) = qs5
  id(qa30) = 15 qualities(qa30) = qs11

  # 29, 35, 41, 50, 55, 61 (4,16)
  id(qa31) = 16 qualities(qa31) = qs4
  id(qa32) = 16 qualities(qa32) = qs10
  
  phi(qmc63) = 1 psi(qmc1) = 1
  phi(qmc60) = 10 psi(qmc2) = 1  
  phi(qmc10) = 16 psi(qmc3) = 1  
  phi(qmc28) = 2 psi(qmc4) = 2
  phi(qmc53) = 3 psi(qmc5) = 2
  phi(qmc58) = 11 psi(qmc6) = 2
  phi(qmc41) = 17 psi(qmc7) = 2
  phi(qmc55) = 4 psi(qmc8) = 3
  phi(qmc43) = 5 psi(qmc9) = 4
  phi(qmc12) = 6 psi(qmc10) = 5
  phi(qmc26) = 12 psi(qmc11) = 5
  phi(qmc17) = 7 psi(qmc12) = 6
  phi(qmc33) = 8 psi(qmc13) = 6  
  phi(qmc32) = 9 psi(qmc14) = 6
  phi(qmc11) = 13 psi(qmc15) = 6
  phi(qmc18) = 14 psi(qmc16) = 6
  phi(qmc13) = 15 psi(qmc17) = 6
  phi(qmc45) = 18 psi(qmc18) = 7
  phi(qmc40) = 19 psi(qmc19) = 8
  phi(qmc29) = 20 psi(qmc20) = 8
  phi(qmc2) = 21 psi(qmc21) = 8
  phi(qmc22) = 22 psi(qmc22) = 9
  phi(qmc3) = 31 psi(qmc23) = 9  
  phi(qmc38) = 37 psi(qmc24) = 9
  phi(qmc23) = 43 psi(qmc25) = 9
  phi(qmc51) = 52 psi(qmc26) = 9
  phi(qmc54) = 58 psi(qmc27) = 9
  phi(qmc57) = 23 psi(qmc28) = 10
  phi(qmc20) = 30 psi(qmc29) = 10
  phi(qmc39) = 32 psi(qmc30) = 10
  phi(qmc49) = 36 psi(qmc31) = 10
  phi(qmc59) = 38 psi(qmc32) = 10
  phi(qmc25) = 42 psi(qmc33) = 10 
  phi(qmc4) = 44 psi(qmc34) = 10
  phi(qmc5) = 51 psi(qmc35) = 10
  phi(qmc27) = 53 psi(qmc36) = 10
  phi(qmc16) = 57 psi(qmc37) = 10
  phi(qmc46) = 59 psi(qmc38) = 10
  phi(qmc7) = 63 psi(qmc39) = 10
  phi(qmc42) = 24 psi(qmc40) = 11	
  phi(qmc31) = 45 psi(qmc41) = 11
  phi(qmc8) = 25 psi(qmc42) = 12
  phi(qmc14) = 46 psi(qmc43) = 12 
  phi(qmc44) = 26 psi(qmc44) = 13
  phi(qmc19) = 47 psi(qmc45) = 13
  phi(qmc21) = 27 psi(qmc46) = 14
  phi(qmc61) = 33 psi(qmc47) = 14
  phi(qmc37) = 39 psi(qmc48) = 14
  phi(qmc9) = 48 psi(qmc49) = 14
  phi(qmc62) = 54 psi(qmc50) = 14
  phi(qmc1) = 60 psi(qmc51) = 14
  phi(qmc6) = 28 psi(qmc52) = 15
  phi(qmc15) = 34 psi(qmc53) = 15
  phi(qmc48) = 40 psi(qmc54) = 15
  phi(qmc47) = 49 psi(qmc55) = 15
  phi(qmc50) = 55 psi(qmc56) = 15
  phi(qmc34) = 60 psi(qmc57) = 15
  phi(qmc35) = 29 psi(qmc58) = 16
  phi(qmc56) = 35 psi(qmc59) = 16
  phi(qmc36) = 41 psi(qmc60) = 16
  phi(qmc24) = 50 psi(qmc61) = 16
  phi(qmc52) = 56 psi(qmc62) = 16
  phi(qmc30) = 62 psi(qmc63) = 16 
}

instance RANDOMSolver = eval RANDOM PizzaDataRandom1

# RES Category for AGGREGATE reasoning operation
schema RESAGGREGATE = literal : Ty {
 entities
  CONFS 
 attributes
  cc_traces qas: CONFS -> String
  cost_USD : CONFS -> Integer
}

query AGGREGATE = literal : PizzaCategory -> RESAGGREGATE {
 entity 
  CONFS -> {
   from
    QMC : QMC
   attributes
    cc_traces -> from cc:CCs
				 		where 
							cc.id = QMC.phi
							cc.feature.cardinality = leaf
  	    		 		return
  	    					ifi(eq(cc.feature.domain, Bool),trace2(cc.feature.selfParent.selfParent.feature, cc.feature.selfParent.selfParent.cardinality, cc.feature.selfParent.feature, cc.feature.selfParent.cardinality, cc.feature.feature)
  	    		    		,itrace2(cc.feature.selfParent.selfParent.feature, cc.feature.selfParent.selfParent.cardinality, cc.feature.selfParent.feature, cc.feature.selfParent.cardinality, cc.feature.feature, cc.feature.value, cc.feature.domain))
  	    					aggregate "" lambda arg1 arg2. regconcat(arg1,arg2)

    qas -> from qa:QAs
				 		where 
							qa.id = QMC.psi
  	    		 		return
  	    		 			concat(qa.qualities.name.name, qa.qualities.value.value, qa.qualities.domain.domain)  	    					
  	    		    		aggregate "" lambda arg1 arg2. regconcat(arg1,arg2)
    
    cost_USD -> from cc:CCs
				 where 
					cc.id = QMC.phi
					cc.feature.cardinality = leaf
  	    		 return
  	    			cc.feature.cost_USD
  	    		    aggregate 0 lambda arg1 arg2. add(arg1,arg2)
 }
}

instance AGGREGATESolver = eval AGGREGATE PizzaData

query FILTERAGGREGATE = literal : PizzaCategory -> RESAGGREGATE {
 entity 
  CONFS -> {
   from
    QMC : QMC
    CC:CCs
    QA:QAs
   where 
	CC.id = QMC.phi
	QA.id = QMC.psi
	CC.feature.cardinality = leaf
    if(ge(CC.feature.cost_USD, 40), and(if(and(eq(QA.qualities.name.name, EnergyRate), eq(QA.qualities.domain.domain, Watts)), leq(QA.qualities.value.value, 18), False), if(and(eq(QA.qualities.name.name, Runtime), eq(QA.qualities.domain.domain, Seconds)), leq(QA.qualities.value.value, 10), False)), False) = True
   attributes
    cc_traces -> from cc:CCs
				 		where 
							cc.id = CC.id
							cc.feature.cardinality = leaf
  	    		 		return
  	    					ifi(eq(cc.feature.domain, Bool),trace2(cc.feature.selfParent.selfParent.feature, cc.feature.selfParent.selfParent.cardinality, cc.feature.selfParent.feature, cc.feature.selfParent.cardinality, cc.feature.feature)
  	    		    		,itrace2(cc.feature.selfParent.selfParent.feature, cc.feature.selfParent.selfParent.cardinality, cc.feature.selfParent.feature, cc.feature.selfParent.cardinality, cc.feature.feature, cc.feature.value, cc.feature.domain))
  	    					aggregate "" lambda arg1 arg2. regconcat(arg1,arg2)

    qas -> from qa:QAs
				 		where 
							qa.id = QA.id
  	    		 		return
  	    		 			concat(qa.qualities.name.name, qa.qualities.value.value, qa.qualities.domain.domain)  	    					
  	    		    		aggregate "" lambda arg1 arg2. regconcat(arg1,arg2)
    
    cost_USD -> from cc:CCs
				 where 
					cc.id = CC.id
					cc.feature.cardinality = leaf
  	    		 return
  	    			cc.feature.cost_USD
  	    		    aggregate 0 lambda arg1 arg2. add(arg1,arg2)
  }
}

instance FILTERAGGREGATESolver = eval FILTERAGGREGATE PizzaData

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
  
 # (Mandatory) Functorial Relation Arrows
 foreign_keys
  parent      : Feature -> Feature # Hierarchichal Feature Relation
  
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
  # Classic Variability Model Arrows
  name        : Feature -> String # Feature Name
  cardinality : Feature -> String # Children cardinality ([x..y] OR leaf)
  optionality : Feature -> Bool
  # Numerical Variability Model Arrows
  domain      : Feature -> String  # Feature Domain (Boolean by default, else Bytes, Metres or whatever)
  value       : Feature -> Integer # Numerical Feature Value
  # Attributed Variability Model Arrow
  cost        : Feature -> Integer # Integer Feature Attribute
  vegan       : Feature -> Bool    # Boolean Feature Attribute
  provider    : Feature -> String  # String Feature Attribute

   # Quality Model Arrows
  name        : Qn -> String  # Quality Name
  value       : Qv -> Integer # Quality Numerical Value
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
  f1 f2 f3 f4 f5 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15: Feature # Unique instances

  #Quality Model
  qn1 qn2 : Qn # Unique instances
  qv1 qv2 qv3 qv4 : Qv # Unique instances
  qd1 qd2 : Qd # Unique instances
  qs1 qs2 qs3 qs4 : Qs # Unique instances

  # Virtual arrows instances
  qa1 qa2 qa3 qa4 : QAs 
  cc1 cc2 cc3 cc4 cc5 cc6 cc7 cc8 cc9 cc10 cc11 cc12 cc13 cc14 cc15 cc16 cc17 : CCs 
  qmc1 qmc2 qmc3: QMC

 equations
  # Populate instances

  # Features
  name(f1) = Pizza cardinality(f1) = all domain(f1) = Bool value(f1) = 1 optionality(f1) = false parent(f1) = f1
  name(f2) = Topping cardinality(f2) = or domain(f2) = Bool value(f2) = 2 optionality(f2) = false parent(f2) = f2
  name(f3) = Size cardinality(f3) = xor domain(f3) = Bool value(f3) = 3 optionality(f3) = false parent(f3) = f3
  name(f4) = Dough cardinality(f4) = xor domain(f4) = Bool value(f4) = 4 optionality(f4) = false parent(f4) = f4
  name(f5) = CheesyCrust cardinality(f5) = leaf domain(f5) = Bool value(f5) = 5 optionality(f5) = true parent(f5) = f5 cost(f5) = 10 vegan(f5) = true provider(f5) = Amazon
  name(f6) = Salami cardinality(f6) = leaf domain(f6) = Bool value(f6) = 6 optionality(f6) = false parent(f6) = f2 cost(f6) = 20 vegan(f6) = false provider(f6) = Amazon
  name(f7) = Ham cardinality(f7) = leaf domain(f7) = Bool value(f7) = 7 optionality(f7) = false parent(f7) = f2 cost(f7) = 5 vegan(f7) = false provider(f7) = Dia
  name(f8) = Mozzarella cardinality(f8) = leaf domain(f8) = Bool value(f8) = 8 optionality(f8) = false parent(f8) = f2 cost(f8) = 9 vegan(f8) = true provider(f8) = Mercadona
  name(f9) = Normal cardinality(f9) = leaf domain(f9) = Bool value(f9) = 9 optionality(f9) = false parent(f9) = f3 cost(f9) = 40 vegan(f9) = true provider(f9) = Carrefour
  name(f10) = Big cardinality(f10) = lef domain(f10) = Bool value(f10) = 10 optionality(f10) = false parent(f10) = f3 cost(f10) = 100 vegan(f10) = true provider(f10) = Amazon
  name(f11) = Neapolitan cardinality(f11) = leaf domain(f11) = Bool value(f11) = 11 optionality(f11) = false parent(f11) = f4 cost(f11) = 90 vegan(f11) = true provider(f11) = Eroski
  name(f12) = Sicilian cardinality(f12) = leaf domain(f12) = Bool value(f12) = 12 optionality(f12) = false parent(f12) = f4 cost(f12) = 1 vegan(f12) = true provider(f12) = Amazon

  # Numerical Features
  name(f13) = Salt cardinality(f13) = leaf domain(f13) = Drops value(f13) = 1 optionality(f13) = false parent(f13) = f1 cost(f13) = 0 vegan(f13) = true provider(f13) = Josemi
  name(f14) = Salt cardinality(f14) = leaf domain(f14) = Drops value(f14) = 2 optionality(f14) = false parent(f14) = f1 cost(f14) = 0 vegan(f14) = true provider(f14) = Josemi
  name(f15) = Salt cardinality(f15) = leaf domain(f15) = Drops value(f15) = 3 optionality(f15) = false parent(f15) = f1 cost(f15) = 0 vegan(f15) = true provider(f15) = Josemi

  # CC Virtual Linkages
  id(cc1) = 1 feature(cc1) = f6
  id(cc2) = 1 feature(cc2) = f7
  id(cc3) = 1 feature(cc3) = f8
  id(cc4) = 1 feature(cc4) = f9
  id(cc5) = 1 feature(cc5) = f11
  id(cc6) = 1 feature(cc6) = f13

  id(cc7) = 2 feature(cc7) = f6
  id(cc8) = 2 feature(cc8) = f7
  id(cc9) = 2 feature(cc9) = f9
  id(cc10) = 2 feature(cc10) = f12
  id(cc11) = 2 feature(cc11) = f13
  
  id(cc12) = 3 feature(cc12) = f6
  id(cc13) = 3 feature(cc13) = f7
  id(cc14) = 3 feature(cc14) = f8
  id(cc15) = 3 feature(cc15) = f9
  id(cc16) = 3 feature(cc16) = f12
  id(cc17) = 3 feature(cc17) = f13

  # Variant-wise Quality Names and Domains
  name(qn1) = Time
  name(qn2) = Energy
  domain(qd1) = Seconds
  domain(qd2) = Joules

  # Time
  value(qv1) = 2
  value(qv2) = 4

  # Energy
  value(qv3) = 10
  value(qv4) = 20

  # Time = X seconds
  name(qs1) = qn1 value(qs1) = qv1 domain(qs1) = qd1
  name(qs2) = qn1 value(qs2) = qv2 domain(qs2) = qd1
  
  # Energy = X joules
  name(qs3) = qn2 value(qs3) = qv3 domain(qs3) = qd2
  name(qs4) = qn2 value(qs4) = qv4 domain(qs4) = qd2

  # QAs Sets
  id(qa1) = 1 qualities(qa1) = qs1
  id(qa2) = 1 qualities(qa2) = qs3	

  id(qa3) = 2 qualities(qa3) = qs2
  id(qa4) = 2 qualities(qa4) = qs4	

  # CC/QAs Linkage
  phi(qmc1) = 1 psi(qmc1) = 1
  phi(qmc2) = 2 psi(qmc2) = 2  
  phi(qmc3) = 3 psi(qmc3) = 1  

}

# Result Category for reasoning operations that generate configurations
schema ConfigurationSpaceCategory = literal : Ty {
 entities
  Product 
 attributes
  cc_traces qas: Product -> String
}

query ListAll = literal : VariabilityModelCategory -> ConfigurationSpaceCategory {
 entity 
  Product -> {
   from
    QMC : QMC
   attributes
    cc_traces -> from cc:CCs
				 		where 
							cc.id = QMC.phi
							cc.feature.cardinality = leaf
  	    		 		return
  	    					ifi(eq(cc.feature.domain, Bool),trace2(cc.feature.parent.parent.name, cc.feature.parent.parent.cardinality, cc.feature.parent.name, cc.feature.parent.cardinality, cc.feature.name)
  	    		    	    ,itrace2(cc.feature.parent.parent.name, cc.feature.parent.parent.cardinality, cc.feature.parent.name, cc.feature.parent.cardinality, cc.feature.name, cc.feature.value, cc.feature.domain))
  	    				    #ifi(eq(cc.feature.domain, Bool), concat(cc.feature.name, cc.feature.value, cc.feature.domain), cc.feature.name)
  	    					aggregate "" lambda arg1 arg2. regconcat(arg1,arg2)

    qas -> from qa:QAs
				 		where 
							qa.id = QMC.psi
  	    		 		return
  	    		 			concat(qa.qualities.name.name, qa.qualities.value.value, qa.qualities.domain.domain)  	    					
  	    		    		aggregate "" lambda arg1 arg2. regconcat(arg1,arg2)
    
   }
}

# Reasoning Execution (Populate Category B based on manipulating Category A data)
instance ListAllData = eval ListAll VariabilityModelData
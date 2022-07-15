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
  f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27 f28 f29 f30 f31 f32 f33 f34 f35 f36 f37 f38 f39 f40 f41 f42 f43 f44 f45 : Feature

 equations
  # Populate instances
  
  name(f1) = JHipster cardinality(f1) = all optionality(f1) = false parent(f1) = f1
  
  name(f2) = TestingFrameworks cardinality(f2) = all optionality(f2) = false parent(f2) = f1
  
  name(f3) = Cucumber cardinality(f3) = leaf optionality(f3) = false parent(f3) = f2
  
  name(f4) = Gatling cardinality(f4) = leaf optionality(f4) = false parent(f4) = f2
  
  name(f5) = Protractor cardinality(f5) = leaf optionality(f5) = true parent(f5) = f2
  
  name(f6) = Docker cardinality(f6) = leaf optionality(f6) = true parent(f6) = f1
  
  name(f7) = InternationalizationSupport cardinality(f7) = leaf optionality(f7) = true parent(f7) = f1
  
  name(f8) = BackEnd cardinality(f8) = xor optionality(f8) = false parent(f8) = f1
  
  name(f9) = Maven cardinality(f9) = leaf optionality(f9) = false parent(f9) = f8
  
  name(f10) = Gradle cardinality(f10) = leaf optionality(f10) = false parent(f10) = f8
  
  name(f11) = ClusteredSession cardinality(f11) = leaf optionality(f11) = true parent(f11) = f1
  
  name(f12) = Libsass cardinality(f12) = leaf optionality(f12) = true parent(f12) = f1
  
  name(f13) = SpringWebSockets cardinality(f13) = leaf optionality(f13) = true parent(f13) = f1
  
  name(f14) = Database cardinality(f14) = xor optionality(f14) = true parent(f14) = f1
  
  name(f15) = MongoDB cardinality(f15) = leaf optionality(f15) = false parent(f15) = f14
  
  name(f16) = Cassandra cardinality(f16) = leaf optionality(f16) = false parent(f16) = f14
  
  name(f17) = SQL cardinality(f17) = all optionality(f17) = false parent(f17) = f14
  
  name(f18) = ElasticSearch cardinality(f18) = leaf optionality(f18) = true parent(f18) = f17
  
  name(f19) = Production cardinality(f19) = xor optionality(f19) = false parent(f19) = f17
  
  name(f20) = PostgreSQL cardinality(f20) = leaf optionality(f20) = false parent(f20) = f19
  
  name(f21) = MariaDB cardinality(f21) = leaf optionality(f21) = false parent(f21) = f19
  
  name(f22) = MySQL cardinality(f22) = leaf optionality(f22) = false parent(f22) = f19
  
  name(f23) = Development cardinality(f23) = xor optionality(f23) = false parent(f23) = f17
  
  name(f24) = MySql cardinality(f24) = leaf optionality(f24) = false parent(f24) = f23
  
  name(f25) = MariaDBDev cardinality(f25) = leaf optionality(f25) = false parent(f25) = f23
  
  name(f26) = PostgreSQLDev cardinality(f26) = leaf optionality(f26) = false parent(f26) = f23
  
  name(f27) = H2 cardinality(f27) = xor optionality(f27) = false parent(f27) = f23
  
  name(f28) = InMemory cardinality(f28) = leaf optionality(f28) = false parent(f28) = f27
  
  name(f29) = DiskBased cardinality(f29) = leaf optionality(f29) = false parent(f29) = f27
  
  name(f30) = Hibernate2ndLvlCache cardinality(f30) = xor optionality(f30) = true parent(f30) = f17
  
  name(f31) = EhCache cardinality(f31) = leaf optionality(f31) = false parent(f31) = f30
  
  name(f32) = HazelCast cardinality(f32) = leaf optionality(f32) = false parent(f32) = f30
  
  name(f33) = SocialLogin cardinality(f33) = leaf optionality(f33) = true parent(f33) = f1
  
  name(f34) = Authentication cardinality(f34) = xor optionality(f34) = false parent(f34) = f1
  
  name(f35) = JWT cardinality(f35) = leaf optionality(f35) = false parent(f35) = f34
  
  name(f36) = Uaa cardinality(f36) = leaf optionality(f36) = false parent(f36) = f34
  
  name(f37) = OAuth2 cardinality(f37) = leaf optionality(f37) = false parent(f37) = f34
  
  name(f38) = HTTPSession cardinality(f38) = leaf optionality(f38) = false parent(f38) = f34
  
  name(f39) = Generator cardinality(f39) = xor optionality(f39) = false parent(f39) = f1
  
  name(f40) = Application cardinality(f40) = xor optionality(f40) = false parent(f40) = f39
  
  name(f41) = Monolithic cardinality(f41) = leaf optionality(f41) = false parent(f41) = f40
  
  name(f42) = MicroserviceGateway cardinality(f42) = leaf optionality(f42) = false parent(f42) = f40
  
  name(f43) = Server cardinality(f43) = xor optionality(f43) = false parent(f43) = f39
  
  name(f44) = UaaServer cardinality(f44) = leaf optionality(f44) = false parent(f44) = f43
  
  name(f45) = MicroserviceApplication cardinality(f45) = leaf optionality(f45) = false parent(f45) = f43
  
}
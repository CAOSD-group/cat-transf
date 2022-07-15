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
  f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27 f28 f29 f30 f31 f32 f33 : Feature

 equations
  # Populate instances
  
  name(f1) = Truck cardinality(f1) = all optionality(f1) = false parent(f1) = f1
  
  name(f2) = Axles cardinality(f2) = all optionality(f2) = false parent(f2) = f1
  
  name(f3) = Drivetrain cardinality(f3) = xor optionality(f3) = false parent(f3) = f2
  
  name(f4) = DrivenAxles3 cardinality(f4) = leaf optionality(f4) = false parent(f4) = f3
  
  name(f5) = DrivenAxles2 cardinality(f5) = leaf optionality(f5) = false parent(f5) = f3
  
  name(f6) = DrivenAxle1 cardinality(f6) = leaf optionality(f6) = false parent(f6) = f3
  
  name(f7) = AdditionalSteeringAxle cardinality(f7) = leaf optionality(f7) = true parent(f7) = f2
  
  name(f8) = Count cardinality(f8) = xor optionality(f8) = false parent(f8) = f2
  
  name(f9) = MultipleRearAxles cardinality(f9) = xor optionality(f9) = false parent(f9) = f8
  
  name(f10) = Axles4 cardinality(f10) = leaf optionality(f10) = false parent(f10) = f9
  
  name(f11) = Axles3 cardinality(f11) = leaf optionality(f11) = false parent(f11) = f9
  
  name(f12) = Axles2 cardinality(f12) = leaf optionality(f12) = false parent(f12) = f8
  
  name(f13) = Cabin cardinality(f13) = all optionality(f13) = false parent(f13) = f1
  
  name(f14) = SleeperCabin cardinality(f14) = xor optionality(f14) = true parent(f14) = f13
  
  name(f15) = Beds2 cardinality(f15) = leaf optionality(f15) = false parent(f15) = f14
  
  name(f16) = Bed1 cardinality(f16) = leaf optionality(f16) = false parent(f16) = f14
  
  name(f17) = HighRoof cardinality(f17) = leaf optionality(f17) = true parent(f17) = f13
  
  name(f18) = Engine cardinality(f18) = xor optionality(f18) = false parent(f18) = f1
  
  name(f19) = KW400 cardinality(f19) = leaf optionality(f19) = false parent(f19) = f18
  
  name(f20) = KW280 cardinality(f20) = leaf optionality(f20) = false parent(f20) = f18
  
  name(f21) = KW160 cardinality(f21) = leaf optionality(f21) = false parent(f21) = f18
  
  name(f22) = Type cardinality(f22) = xor optionality(f22) = false parent(f22) = f1
  
  name(f23) = Flatbed cardinality(f23) = all optionality(f23) = false parent(f23) = f22
  
  name(f24) = Dumper cardinality(f24) = leaf optionality(f24) = false parent(f24) = f23
  
  name(f25) = Tank cardinality(f25) = leaf optionality(f25) = false parent(f25) = f22
  
  name(f26) = Semitrailer cardinality(f26) = leaf optionality(f26) = false parent(f26) = f22
  
  name(f27) = Weight cardinality(f27) = xor optionality(f27) = false parent(f27) = f1
  
  name(f28) = Heavyweight cardinality(f28) = xor optionality(f28) = false parent(f28) = f27
  
  name(f29) = Tons40 cardinality(f29) = leaf optionality(f29) = false parent(f29) = f28
  
  name(f30) = Tons23 cardinality(f30) = leaf optionality(f30) = false parent(f30) = f28
  
  name(f31) = Lightweight cardinality(f31) = xor optionality(f31) = false parent(f31) = f27
  
  name(f32) = Tons18 cardinality(f32) = leaf optionality(f32) = false parent(f32) = f31
  
  name(f33) = Tons12 cardinality(f33) = leaf optionality(f33) = false parent(f33) = f31
  
}
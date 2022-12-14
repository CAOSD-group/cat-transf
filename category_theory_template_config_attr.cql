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
    {% for attribute in feature_attributes_dict %}{{attribute.name}}: Feature -> {{attribute.type}}
    {% endfor %}
  
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
    {{features_list}} : Feature
  
  # Quality Model
    {{qn_list}} : Qn # Unique instances
    {{qv_list}} : Qv # Unique instances
    {{qd_list}} : Qd # Unique instances
    {{qs_list}} : Qs # Unique instances

  # Virtual arrows instances
    {{qas_list}} : QAs 
    {{ccs_list}} : CCs 
    {{qmc_list}} : QMC


  equations
  # Boolean features
    {% for feature in boolean_features_dict %} name({{feature.id}}) = {{feature.name}} cardinality({{feature.id}}) = {{feature.cardinality}} optionality({{feature.id}}) = {{feature.optionality}} parent({{feature.id}}) = {{feature.parent}}
    {% for attribute in feature.attributes %}  {{attribute.name}}({{feature.id}}) = {{attribute.value}}
    {% endfor %}
    {% endfor %}

  # Numerical features
  {% for feature in numerical_features_dict %}
  name({{feature.id}}) = {{feature.name}} cardinality({{feature.id}}) = {{feature.cardinality}} optionality({{feature.id}}) = {{feature.optionality}} parent({{feature.id}}) = {{feature.parent}} domain({{feature.id}}) = {{feature.domain}} value({{feature.id}}) = {{feature.nf_value}}
  {% for attribute in feature.attributes %} {{attribute.name}}({{feature.id}}) = {{attribute.value}}
  {% endfor %}
  {% endfor %}

  # CC Virtual Linkages
  {% for cc in cc_virutal_linkages_dict %}
  id({{cc.id}}) = {{cc.id}} feature({{cc.id}}) = {{feature.id}}
  {% endfor %}


  # Variant-wise Quality Names and Domains
  {% for qn in quality_names_dict %}
  name({{qn.id}}) = {{qn.name}}
  {% endfor %}
  {% for qd in quality_domains_dict %}
  domain({{qd.id}}) = {{qd.domain}}
  {% endfor %}

  # Quality Values
  {% for qv in quality_values_dict %}
  domain({{qv.id}}) = {{qv.value}}
  {% endfor %}

  # Qualities
  {% for qs in qualities_dict %}
  name({{qs.id}}) = {{sq.value.qn}} value({{qs.id}}) = {{sq.value.qv}} domain({{qs.id}}) = {{sq.value.qd}}
  {% endfor %}

  # QAs Sets
  {% for qa in quality_attributes_dict %}
  id({{qa}}) = {{qa.index}} qualities({{qa}}) = {{qa.data.}}  # TODO
  {% endfor %}

  # CC/QAs Linkage
  {% for qan in quality_model_dict %}
  phi({{qmcn}}) = {{TODO}} psi({{qmcn}}) = {{TODO}}  # TODO
  {% endfor %}
}
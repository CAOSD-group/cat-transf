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
  f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27 f28 f29 f30 f31 f32 f33 f34 f35 f36 f37 f38 f39 f40 f41 f42 f43 f44 f45 f46 f47 f48 f49 f50 f51 f52 f53 f54 f55 f56 f57 f58 f59 f60 f61 f62 f63 f64 f65 f66 f67 f68 f69 f70 f71 f72 f73 f74 f75 f76 f77 f78 f79 f80 f81 f82 f83 f84 f85 f86 f87 f88 f89 f90 f91 f92 f93 f94 f95 f96 f97 f98 f99 f100 f101 f102 f103 f104 f105 f106 f107 f108 f109 f110 f111 f112 f113 f114 f115 f116 f117 f118 f119 f120 f121 f122 f123 f124 f125 f126 f127 f128 f129 f130 f131 f132 f133 f134 f135 f136 f137 f138 f139 f140 f141 f142 f143 f144 f145 f146 f147 f148 f149 f150 f151 f152 f153 f154 f155 f156 f157 f158 f159 f160 f161 f162 f163 f164 f165 f166 f167 f168 f169 f170 f171 f172 f173 f174 f175 f176 f177 f178 f179 : Feature

 equations
  # Populate instances
  
  name(f1) = FQAs cardinality(f1) = or optionality(f1) = false parent(f1) = f1
  
  name(f2) = Performance cardinality(f2) = all optionality(f2) = false parent(f2) = f1
  
  name(f3) = Caching cardinality(f3) = all optionality(f3) = false parent(f3) = f2
  
  name(f4) = EternalObjects cardinality(f4) = leaf optionality(f4) = true parent(f4) = f3
  
  name(f5) = MaxLifeSeconds cardinality(f5) = leaf optionality(f5) = true parent(f5) = f3
  
  name(f6) = CacheType cardinality(f6) = xor optionality(f6) = false parent(f6) = f3
  
  name(f7) = RemoteCache cardinality(f7) = leaf optionality(f7) = false parent(f7) = f6
  
  name(f8) = LocalCache cardinality(f8) = leaf optionality(f8) = false parent(f8) = f6
  
  name(f9) = MaxSizeCache cardinality(f9) = leaf optionality(f9) = false parent(f9) = f3
  
  name(f10) = CachingImplementations cardinality(f10) = xor optionality(f10) = false parent(f10) = f3
  
  name(f11) = Caffeine cardinality(f11) = leaf optionality(f11) = false parent(f11) = f10
  
  name(f12) = JavaCachingSystem cardinality(f12) = leaf optionality(f12) = false parent(f12) = f10
  
  name(f13) = CachingOperations cardinality(f13) = xor optionality(f13) = false parent(f13) = f3
  
  name(f14) = CacheUpdate cardinality(f14) = leaf optionality(f14) = false parent(f14) = f13
  
  name(f15) = CacheQuery cardinality(f15) = leaf optionality(f15) = false parent(f15) = f13
  
  name(f16) = CacheStore cardinality(f16) = leaf optionality(f16) = false parent(f16) = f13
  
  name(f17) = ContextAwareness cardinality(f17) = or optionality(f17) = false parent(f17) = f1
  
  name(f18) = EnvironmentAware cardinality(f18) = leaf optionality(f18) = false parent(f18) = f17
  
  name(f19) = UserAware cardinality(f19) = leaf optionality(f19) = false parent(f19) = f17
  
  name(f20) = DeviceAware cardinality(f20) = or optionality(f20) = false parent(f20) = f17
  
  name(f21) = IRSensor cardinality(f21) = leaf optionality(f21) = false parent(f21) = f20
  
  name(f22) = BatteryStatus cardinality(f22) = leaf optionality(f22) = false parent(f22) = f20
  
  name(f23) = TimeAware cardinality(f23) = leaf optionality(f23) = false parent(f23) = f17
  
  name(f24) = LocationAware cardinality(f24) = or optionality(f24) = false parent(f24) = f17
  
  name(f25) = WiFiLocation cardinality(f25) = leaf optionality(f25) = false parent(f25) = f24
  
  name(f26) = GPS cardinality(f26) = leaf optionality(f26) = false parent(f26) = f24
  
  name(f27) = Persistence cardinality(f27) = or optionality(f27) = false parent(f27) = f1
  
  name(f28) = DatabaseStorage cardinality(f28) = all optionality(f28) = false parent(f28) = f27
  
  name(f29) = SecureDatabase cardinality(f29) = leaf optionality(f29) = true parent(f29) = f28
  
  name(f30) = DataType cardinality(f30) = or optionality(f30) = false parent(f30) = f28
  
  name(f31) = Objects cardinality(f31) = leaf optionality(f31) = false parent(f31) = f30
  
  name(f32) = Floats cardinality(f32) = leaf optionality(f32) = false parent(f32) = f30
  
  name(f33) = Strings cardinality(f33) = leaf optionality(f33) = false parent(f33) = f30
  
  name(f34) = Integers cardinality(f34) = leaf optionality(f34) = false parent(f34) = f30
  
  name(f35) = DatabaseType cardinality(f35) = xor optionality(f35) = false parent(f35) = f28
  
  name(f36) = NoSQL cardinality(f36) = leaf optionality(f36) = false parent(f36) = f35
  
  name(f37) = Relational cardinality(f37) = leaf optionality(f37) = false parent(f37) = f35
  
  name(f38) = DatabaseStorageImplementations cardinality(f38) = xor optionality(f38) = false parent(f38) = f28
  
  name(f39) = OracleDB cardinality(f39) = leaf optionality(f39) = false parent(f39) = f38
  
  name(f40) = MongoDB cardinality(f40) = leaf optionality(f40) = false parent(f40) = f38
  
  name(f41) = MySQL cardinality(f41) = leaf optionality(f41) = false parent(f41) = f38
  
  name(f42) = DatabaseStorageOperations cardinality(f42) = xor optionality(f42) = false parent(f42) = f28
  
  name(f43) = Query cardinality(f43) = leaf optionality(f43) = false parent(f43) = f42
  
  name(f44) = Store cardinality(f44) = leaf optionality(f44) = false parent(f44) = f42
  
  name(f45) = FileStorage cardinality(f45) = all optionality(f45) = false parent(f45) = f27
  
  name(f46) = TemporalFile cardinality(f46) = leaf optionality(f46) = true parent(f46) = f45
  
  name(f47) = FileStorageImplementations cardinality(f47) = all optionality(f47) = false parent(f47) = f45
  
  name(f48) = JavaIO cardinality(f48) = leaf optionality(f48) = false parent(f48) = f47
  
  name(f49) = FileType cardinality(f49) = xor optionality(f49) = false parent(f49) = f45
  
  name(f50) = JSONFile cardinality(f50) = leaf optionality(f50) = false parent(f50) = f49
  
  name(f51) = XMLFile cardinality(f51) = leaf optionality(f51) = false parent(f51) = f49
  
  name(f52) = TXTFile cardinality(f52) = leaf optionality(f52) = false parent(f52) = f49
  
  name(f53) = Binary cardinality(f53) = leaf optionality(f53) = false parent(f53) = f49
  
  name(f54) = FileStorageOperations cardinality(f54) = xor optionality(f54) = false parent(f54) = f45
  
  name(f55) = DeleteFile cardinality(f55) = leaf optionality(f55) = false parent(f55) = f54
  
  name(f56) = ModifyFile cardinality(f56) = leaf optionality(f56) = false parent(f56) = f54
  
  name(f57) = CreateFile cardinality(f57) = leaf optionality(f57) = false parent(f57) = f54
  
  name(f58) = Usability cardinality(f58) = or optionality(f58) = false parent(f58) = f1
  
  name(f59) = Feedback cardinality(f59) = or optionality(f59) = false parent(f59) = f58
  
  name(f60) = Alerts cardinality(f60) = leaf optionality(f60) = false parent(f60) = f59
  
  name(f61) = SystemStatusDisplay cardinality(f61) = leaf optionality(f61) = false parent(f61) = f59
  
  name(f62) = ProgressFeedback cardinality(f62) = leaf optionality(f62) = false parent(f62) = f59
  
  name(f63) = InteractionFeedback cardinality(f63) = leaf optionality(f63) = false parent(f63) = f59
  
  name(f64) = Internationalization cardinality(f64) = all optionality(f64) = false parent(f64) = f58
  
  name(f65) = Locale cardinality(f65) = leaf optionality(f65) = false parent(f65) = f64
  
  name(f66) = ExecutionControl cardinality(f66) = all optionality(f66) = false parent(f66) = f58
  
  name(f67) = Shortcuts cardinality(f67) = leaf optionality(f67) = true parent(f67) = f66
  
  name(f68) = ExecutionControl_1 cardinality(f68) = or optionality(f68) = false parent(f68) = f66
  
  name(f69) = GoBack cardinality(f69) = leaf optionality(f69) = false parent(f69) = f68
  
  name(f70) = Cancel cardinality(f70) = leaf optionality(f70) = false parent(f70) = f68
  
  name(f71) = Redo cardinality(f71) = leaf optionality(f71) = false parent(f71) = f68
  
  name(f72) = Undo cardinality(f72) = leaf optionality(f72) = false parent(f72) = f68
  
  name(f73) = ContextualHelp cardinality(f73) = all optionality(f73) = false parent(f73) = f58
  
  name(f74) = AuthenticatedUser cardinality(f74) = leaf optionality(f74) = true parent(f74) = f73
  
  name(f75) = UserType cardinality(f75) = or optionality(f75) = false parent(f75) = f73
  
  name(f76) = Expert cardinality(f76) = leaf optionality(f76) = false parent(f76) = f75
  
  name(f77) = Advanced cardinality(f77) = leaf optionality(f77) = false parent(f77) = f75
  
  name(f78) = Intermediate cardinality(f78) = leaf optionality(f78) = false parent(f78) = f75
  
  name(f79) = Beginner cardinality(f79) = leaf optionality(f79) = false parent(f79) = f75
  
  name(f80) = HelpType cardinality(f80) = or optionality(f80) = false parent(f80) = f73
  
  name(f81) = Wizard cardinality(f81) = leaf optionality(f81) = false parent(f81) = f80
  
  name(f82) = Tutorial cardinality(f82) = leaf optionality(f82) = false parent(f82) = f80
  
  name(f83) = ContextualHelpImplementations cardinality(f83) = all optionality(f83) = false parent(f83) = f73
  
  name(f84) = JavaWizardAPI cardinality(f84) = leaf optionality(f84) = false parent(f84) = f83
  
  name(f85) = ContextualHelpOperations cardinality(f85) = all optionality(f85) = false parent(f85) = f73
  
  name(f86) = ShowHelp cardinality(f86) = leaf optionality(f86) = false parent(f86) = f85
  
  name(f87) = Logging cardinality(f87) = all optionality(f87) = false parent(f87) = f58
  
  name(f88) = ErrorLog cardinality(f88) = all optionality(f88) = true parent(f88) = f87
  
  name(f89) = TraceFile cardinality(f89) = leaf optionality(f89) = true parent(f89) = f88
  
  name(f90) = HistoryLog cardinality(f90) = leaf optionality(f90) = true parent(f90) = f87
  
  name(f91) = CypheredMessages cardinality(f91) = leaf optionality(f91) = true parent(f91) = f87
  
  name(f92) = Level cardinality(f92) = or optionality(f92) = false parent(f92) = f87
  
  name(f93) = Error cardinality(f93) = leaf optionality(f93) = false parent(f93) = f92
  
  name(f94) = Warning cardinality(f94) = leaf optionality(f94) = false parent(f94) = f92
  
  name(f95) = Info cardinality(f95) = leaf optionality(f95) = false parent(f95) = f92
  
  name(f96) = Debug cardinality(f96) = leaf optionality(f96) = false parent(f96) = f92
  
  name(f97) = Trace cardinality(f97) = leaf optionality(f97) = false parent(f97) = f92
  
  name(f98) = Format cardinality(f98) = xor optionality(f98) = false parent(f98) = f87
  
  name(f99) = JSON cardinality(f99) = leaf optionality(f99) = false parent(f99) = f98
  
  name(f100) = HTML cardinality(f100) = leaf optionality(f100) = false parent(f100) = f98
  
  name(f101) = XML cardinality(f101) = leaf optionality(f101) = false parent(f101) = f98
  
  name(f102) = TXT cardinality(f102) = leaf optionality(f102) = false parent(f102) = f98
  
  name(f103) = Handler cardinality(f103) = xor optionality(f103) = false parent(f103) = f87
  
  name(f104) = DatabaseLog cardinality(f104) = leaf optionality(f104) = false parent(f104) = f103
  
  name(f105) = FileLog cardinality(f105) = leaf optionality(f105) = false parent(f105) = f103
  
  name(f106) = ConsoleLog cardinality(f106) = leaf optionality(f106) = false parent(f106) = f103
  
  name(f107) = LoggingImplementations cardinality(f107) = xor optionality(f107) = false parent(f107) = f87
  
  name(f108) = SimpleImplementationSLF4J cardinality(f108) = leaf optionality(f108) = false parent(f108) = f107
  
  name(f109) = JavaUtilLogging cardinality(f109) = leaf optionality(f109) = false parent(f109) = f107
  
  name(f110) = LogBack cardinality(f110) = leaf optionality(f110) = false parent(f110) = f107
  
  name(f111) = Log4J cardinality(f111) = leaf optionality(f111) = false parent(f111) = f107
  
  name(f112) = LoggingOperations cardinality(f112) = all optionality(f112) = false parent(f112) = f87
  
  name(f113) = Log cardinality(f113) = leaf optionality(f113) = false parent(f113) = f112
  
  name(f114) = Security cardinality(f114) = or optionality(f114) = false parent(f114) = f1
  
  name(f115) = Non_Repudiation cardinality(f115) = leaf optionality(f115) = false parent(f115) = f114
  
  name(f116) = Integrity cardinality(f116) = leaf optionality(f116) = false parent(f116) = f114
  
  name(f117) = Privacy cardinality(f117) = leaf optionality(f117) = false parent(f117) = f114
  
  name(f118) = Confidentiality cardinality(f118) = leaf optionality(f118) = false parent(f118) = f114
  
  name(f119) = Hashing cardinality(f119) = all optionality(f119) = false parent(f119) = f114
  
  name(f120) = HashingAlgorithms cardinality(f120) = xor optionality(f120) = false parent(f120) = f119
  
  name(f121) = SHA512 cardinality(f121) = leaf optionality(f121) = false parent(f121) = f120
  
  name(f122) = SHA256 cardinality(f122) = leaf optionality(f122) = false parent(f122) = f120
  
  name(f123) = SHA1 cardinality(f123) = leaf optionality(f123) = false parent(f123) = f120
  
  name(f124) = MD5 cardinality(f124) = leaf optionality(f124) = false parent(f124) = f120
  
  name(f125) = HashingOperations cardinality(f125) = all optionality(f125) = false parent(f125) = f119
  
  name(f126) = Hash cardinality(f126) = leaf optionality(f126) = false parent(f126) = f125
  
  name(f127) = HashingImplementations cardinality(f127) = xor optionality(f127) = false parent(f127) = f119
  
  name(f128) = Guava cardinality(f128) = leaf optionality(f128) = false parent(f128) = f127
  
  name(f129) = JavaSecurityMessageDigest cardinality(f129) = leaf optionality(f129) = false parent(f129) = f127
  
  name(f130) = Authentication cardinality(f130) = all optionality(f130) = false parent(f130) = f114
  
  name(f131) = AnonymousUser cardinality(f131) = leaf optionality(f131) = true parent(f131) = f130
  
  name(f132) = AuthenticationLogging cardinality(f132) = leaf optionality(f132) = true parent(f132) = f130
  
  name(f133) = LimitedSession cardinality(f133) = leaf optionality(f133) = true parent(f133) = f130
  
  name(f134) = PasswordType cardinality(f134) = xor optionality(f134) = true parent(f134) = f130
  
  name(f135) = SpecialChars cardinality(f135) = leaf optionality(f135) = false parent(f135) = f134
  
  name(f136) = Alphanumeric cardinality(f136) = leaf optionality(f136) = false parent(f136) = f134
  
  name(f137) = Numeric cardinality(f137) = leaf optionality(f137) = false parent(f137) = f134
  
  name(f138) = PasswordLength cardinality(f138) = leaf optionality(f138) = true parent(f138) = f130
  
  name(f139) = AuthenticationMechanism cardinality(f139) = xor optionality(f139) = false parent(f139) = f130
  
  name(f140) = MatrixCode cardinality(f140) = leaf optionality(f140) = false parent(f140) = f139
  
  name(f141) = Pin cardinality(f141) = leaf optionality(f141) = false parent(f141) = f139
  
  name(f142) = SocialID cardinality(f142) = leaf optionality(f142) = false parent(f142) = f139
  
  name(f143) = Biometric cardinality(f143) = leaf optionality(f143) = false parent(f143) = f139
  
  name(f144) = DigitalCertificate cardinality(f144) = all optionality(f144) = false parent(f144) = f139
  
  name(f145) = PseudonymousCertificate cardinality(f145) = leaf optionality(f145) = true parent(f145) = f144
  
  name(f146) = UserPassword cardinality(f146) = leaf optionality(f146) = false parent(f146) = f139
  
  name(f147) = AuthenticationOperations cardinality(f147) = all optionality(f147) = false parent(f147) = f130
  
  name(f148) = Authenticate cardinality(f148) = leaf optionality(f148) = false parent(f148) = f147
  
  name(f149) = AuthenticationImplementations cardinality(f149) = xor optionality(f149) = false parent(f149) = f130
  
  name(f150) = SpringSecurity cardinality(f150) = leaf optionality(f150) = false parent(f150) = f149
  
  name(f151) = JAAS cardinality(f151) = leaf optionality(f151) = false parent(f151) = f149
  
  name(f152) = Encryption cardinality(f152) = all optionality(f152) = false parent(f152) = f114
  
  name(f153) = Padding cardinality(f153) = xor optionality(f153) = false parent(f153) = f152
  
  name(f154) = OAEP cardinality(f154) = leaf optionality(f154) = false parent(f154) = f153
  
  name(f155) = PKCS1 cardinality(f155) = leaf optionality(f155) = false parent(f155) = f153
  
  name(f156) = PKCS5 cardinality(f156) = leaf optionality(f156) = false parent(f156) = f153
  
  name(f157) = Mode cardinality(f157) = xor optionality(f157) = false parent(f157) = f152
  
  name(f158) = CTS cardinality(f158) = leaf optionality(f158) = false parent(f158) = f157
  
  name(f159) = CTR cardinality(f159) = leaf optionality(f159) = false parent(f159) = f157
  
  name(f160) = CFB cardinality(f160) = leaf optionality(f160) = false parent(f160) = f157
  
  name(f161) = ECB cardinality(f161) = leaf optionality(f161) = false parent(f161) = f157
  
  name(f162) = CBC cardinality(f162) = leaf optionality(f162) = false parent(f162) = f157
  
  name(f163) = EncryptionOperations cardinality(f163) = xor optionality(f163) = false parent(f163) = f152
  
  name(f164) = Decrypt cardinality(f164) = leaf optionality(f164) = false parent(f164) = f163
  
  name(f165) = Encrypt cardinality(f165) = leaf optionality(f165) = false parent(f165) = f163
  
  name(f166) = EncryptionImplementations cardinality(f166) = xor optionality(f166) = false parent(f166) = f152
  
  name(f167) = BouncyCastle cardinality(f167) = leaf optionality(f167) = false parent(f167) = f166
  
  name(f168) = JavaxCrypto cardinality(f168) = leaf optionality(f168) = false parent(f168) = f166
  
  name(f169) = KeySize cardinality(f169) = leaf optionality(f169) = true parent(f169) = f152
  
  name(f170) = EncryptionAlgorithms cardinality(f170) = xor optionality(f170) = false parent(f170) = f152
  
  name(f171) = Symmetric cardinality(f171) = xor optionality(f171) = false parent(f171) = f170
  
  name(f172) = DES cardinality(f172) = leaf optionality(f172) = false parent(f172) = f171
  
  name(f173) = Blowfish cardinality(f173) = leaf optionality(f173) = false parent(f173) = f171
  
  name(f174) = DESede cardinality(f174) = leaf optionality(f174) = false parent(f174) = f171
  
  name(f175) = AES cardinality(f175) = leaf optionality(f175) = false parent(f175) = f171
  
  name(f176) = Asymmetric cardinality(f176) = xor optionality(f176) = false parent(f176) = f170
  
  name(f177) = ECDSA cardinality(f177) = leaf optionality(f177) = false parent(f177) = f176
  
  name(f178) = DSA cardinality(f178) = leaf optionality(f178) = false parent(f178) = f176
  
  name(f179) = RSA cardinality(f179) = leaf optionality(f179) = false parent(f179) = f176
  
}
module OpenLDAP
  module Constants

    LDAP_DEREF_NEVER      = 0x00
    LDAP_DEREF_SEARCHING  = 0x01
    LDAP_DEREF_FINDING    = 0x02
    LDAP_DEREF_ALWAYS     = 0x03

    LDAP_NO_LIMIT         = 0

    # /* how many messages to retrieve results for */
    LDAP_MSG_ONE          = 0x00
    LDAP_MSG_ALL          = 0x01
    LDAP_MSG_RECEIVED     = 0x02


    # ldap_result stuff
    #
    # LDAP Request Messages 
    LDAP_REQ_BIND               =   0x60 # application + constructed 
    LDAP_REQ_UNBIND             =   0x42 # application + primitive   
    LDAP_REQ_SEARCH             =   0x63 # application + constructed 
    LDAP_REQ_MODIFY             =   0x66 # application + constructed 
    LDAP_REQ_ADD                =   0x68 # application + constructed 
    LDAP_REQ_DELETE             =   0x4a # application + primitive   
    LDAP_REQ_MODDN              =   0x6c # application + constructed 
    LDAP_REQ_MODRDN             =  LDAP_REQ_MODDN
    LDAP_REQ_RENAME             =  LDAP_REQ_MODDN
    LDAP_REQ_COMPARE            =  0x6e # application + constructed 
    LDAP_REQ_ABANDON            =  0x50 # application + primitive   
    LDAP_REQ_EXTENDED           =  0x77 # application + constructed 

    # LDAP Response Messages 
    LDAP_RES_BIND               =   0x61 # application + constructed 
    LDAP_RES_SEARCH_ENTRY       =  0x64 # application + constructed 
    LDAP_RES_SEARCH_REFERENCE   =  0x73 # V3: application + constructed 
    LDAP_RES_SEARCH_RESULT      =  0x65 # application + constructed 
    LDAP_RES_MODIFY             =   0x67 # application + constructed 
    LDAP_RES_ADD                =   0x69 # application + constructed 
    LDAP_RES_DELETE             =   0x6b # application + constructed 
    LDAP_RES_MODDN              =   0x6d # application + constructed 
    LDAP_RES_MODRDN             =  LDAP_RES_MODDN # application + constructed 
    LDAP_RES_RENAME             =  LDAP_RES_MODDN # application + constructed 
    LDAP_RES_COMPARE            =  0x6f # application + constructed 
    LDAP_RES_EXTENDED           =  0x78 # V3: application + constructed 
    LDAP_RES_INTERMEDIATE       =  0x79 # V3+: application + constructed 

    LDAP_RES_ANY          = -1
    LDAP_RES_UNSOLICITED  = 0

    #### CONTROL ####
    LDAP_CONTROL_MANAGEDSAIT = "2.16.840.1.113730.3.4.2"  #  RFC 3296 
    LDAP_CONTROL_PROXY_AUTHZ = "2.16.840.1.113730.3.4.18" #  RFC 4370 
    LDAP_CONTROL_SUBENTRIES = 	"1.3.6.1.4.1.4203.1.10.1"  #  RFC 3672 

    LDAP_CONTROL_VALUESRETURNFILTER = "1.2.826.0.1.3344810.2.3"#  RFC 3876 

    LDAP_CONTROL_ASSERT = 			"1.3.6.1.1.12"			#  RFC 4528 
    LDAP_CONTROL_PRE_READ = 		"1.3.6.1.1.13.1"		#  RFC 4527 
    LDAP_CONTROL_POST_READ = 		"1.3.6.1.1.13.2"		#  RFC 4527 

    LDAP_CONTROL_SORTREQUEST =    "1.2.840.113556.1.4.473" #  RFC 2891 
    LDAP_CONTROL_SORTRESPONSE = "1.2.840.113556.1.4.474" #  RFC 2891 

    # 	non-standard track controls 
    LDAP_CONTROL_PAGEDRESULTS = "1.2.840.113556.1.4.319"   #  RFC 2696 


    #### SCOPE ####
    LDAP_SCOPE_BASE         = 0
    LDAP_SCOPE_ONELEVEL     = 1
    LDAP_SCOPE_SUBTREE      = 2
    LDAP_SCOPE_SUBORDINATE  = 3  # /* OpenLDAP extension */
    LDAP_SCOPE_DEFAULT      = -1 # /* OpenLDAP extension */

    LDAP_SCOPE_MAP = {
      base: LDAP_SCOPE_BASE,
      onelevel: LDAP_SCOPE_ONELEVEL,
      subtree: LDAP_SCOPE_SUBTREE,
      subordinate: LDAP_SCOPE_SUBORDINATE,
      default: LDAP_SCOPE_DEFAULT
    }


    #### RESULT CODES #####
    LDAP_SUCCESS =    0x00
    LDAP_OPERATIONS_ERROR =  0x01
    LDAP_PROTOCOL_ERROR =   0x02
    LDAP_TIMELIMIT_EXCEEDED =  0x03
    LDAP_SIZELIMIT_EXCEEDED =  0x04
    LDAP_COMPARE_FALSE =   0x05
    LDAP_COMPARE_TRUE =   0x06
    LDAP_AUTH_METHOD_NOT_SUPPORTED = 0x07
    LDAP_STRONG_AUTH_NOT_SUPPORTED = LDAP_AUTH_METHOD_NOT_SUPPORTED
    LDAP_STRONG_AUTH_REQUIRED = 0x08
    LDAP_STRONGER_AUTH_REQUIRED = LDAP_STRONG_AUTH_REQUIRED
    LDAP_PARTIAL_RESULTS =  0x09 ##  LDAPv2+ (not LDAPv3) 

    LDAP_REFERRAL =    0x0a   ##  LDAPv3 
    LDAP_ADMINLIMIT_EXCEEDED = 0x0b ##  LDAPv3 
    LDAP_UNAVAILABLE_CRITICAL_EXTENSION = 0x0c ##  LDAPv3 
    LDAP_CONFIDENTIALITY_REQUIRED = 0x0d ##  LDAPv3 
    LDAP_SASL_BIND_IN_PROGRESS = 0x0e # #  LDAPv3 

    #LDAP_ATTR_ERROR(n) LDAP_RANGE((n),0x10,0x15) ##  16-21 
    LDAP_NO_SUCH_ATTRIBUTE =  0x10
    LDAP_UNDEFINED_TYPE =   0x11
    LDAP_INAPPROPRIATE_MATCHING = 0x12
    LDAP_CONSTRAINT_VIOLATION = 0x13
    LDAP_TYPE_OR_VALUE_EXISTS = 0x14
    LDAP_INVALID_SYNTAX =   0x15

    #LDAP_NAME_ERROR(n) LDAP_RANGE((n),0x20,0x24) ##  32-34,36 
    LDAP_NO_SUCH_OBJECT =   0x20
    LDAP_ALIAS_PROBLEM =   0x21
    LDAP_INVALID_DN_SYNTAX =  0x22
    LDAP_IS_LEAF =    0x23 ##  not LDAPv3 
    LDAP_ALIAS_DEREF_PROBLEM = 0x24

    #LDAP_SECURITY_ERROR(n) LDAP_RANGE((n),0x2F,0x32) ##  47-50 
    LDAP_X_PROXY_AUTHZ_FAILURE = 0x2F ##  LDAPv3 proxy authorization 
    LDAP_INAPPROPRIATE_AUTH =  0x30
    LDAP_INVALID_CREDENTIALS = 0x31
    LDAP_INSUFFICIENT_ACCESS = 0x32

    #LDAP_SERVICE_ERROR(n) LDAP_RANGE((n),0x33,0x36) ##  51-54 
    LDAP_BUSY =     0x33
    LDAP_UNAVAILABLE =   0x34
    LDAP_UNWILLING_TO_PERFORM = 0x35
    LDAP_LOOP_DETECT =   0x36

    #LDAP_UPDATE_ERROR(n) LDAP_RANGE((n),0x40,0x47) ##  64-69,71 
    LDAP_NAMING_VIOLATION =  0x40
    LDAP_OBJECT_CLASS_VIOLATION = 0x41
    LDAP_NOT_ALLOWED_ON_NONLEAF = 0x42
    LDAP_NOT_ALLOWED_ON_RDN =  0x43
    LDAP_ALREADY_EXISTS =   0x44
    LDAP_NO_OBJECT_CLASS_MODS = 0x45
    LDAP_RESULTS_TOO_LARGE =  0x46 ##  CLDAP 
    LDAP_AFFECTS_MULTIPLE_DSAS = 0x47

    LDAP_VLV_ERROR =    0x4C

    LDAP_OTHER =     0x50

    ##  LCUP operation codes (113-117) - not implemented 
    LDAP_CUP_RESOURCES_EXHAUSTED = 0x71
    LDAP_CUP_SECURITY_VIOLATION =  0x72
    LDAP_CUP_INVALID_DATA =   0x73
    LDAP_CUP_UNSUPPORTED_SCHEME =  0x74
    LDAP_CUP_RELOAD_REQUIRED =  0x75

    ##  Cancel operation codes (118-121) 
    LDAP_CANCELLED =    0x76
    LDAP_NO_SUCH_OPERATION =  0x77
    LDAP_TOO_LATE =    0x78
    LDAP_CANNOT_CANCEL =   0x79

    ##  Assertion control (122)  
    LDAP_ASSERTION_FAILED =  0x7A

    ##  Proxied Authorization Denied (123)  
    LDAP_PROXIED_AUTHORIZATION_DENIED =  0x7B

    ##  Experimental result codes 
    #LDAP_E_ERROR(n) LDAP_RANGE((n),0x1000,0x3FFF)
    ##  LDAP Sync (4096) 
    LDAP_SYNC_REFRESH_REQUIRED =  0x1000


    ##  Private Use result codes 
    #LDAP_X_ERROR(n) LDAP_RANGE((n),0x4000,0xFFFF)
    LDAP_X_SYNC_REFRESH_REQUIRED = 0x4100 ##  defunct 
    LDAP_X_ASSERTION_FAILED =   0x410f ##  defunct 

    ##  for the LDAP No-Op control 
    LDAP_X_NO_OPERATION =    0x410e

    # for the Chaining Behavior control consecutive result codes requested;
    #                                       see <draft-sermersheim-ldap-chaining> 
    LDAP_X_NO_REFERRALS_FOUND =  0x4110
    LDAP_X_CANNOT_CHAIN =   0x4111
    LDAP_X_INVALIDREFERENCE =   0x4112
    LDAP_X_TXN_SPECIFY_OKAY =  0x4120
    LDAP_X_TXN_ID_INVALID =  0x4121


    #
    # LDAP_OPTions
    # 	0x0000 - 0x0fff reserved for api options
    # 	0x1000 - 0x3fff reserved for api extended options
    #	0x4000 - 0x7fff reserved for private and experimental options

    LDAP_OPT_API_INFO = 		0x0000
    LDAP_OPT_DESC = 			0x0001 # historic 
    LDAP_OPT_DEREF = 			0x0002
    LDAP_OPT_SIZELIMIT = 		0x0003
    LDAP_OPT_TIMELIMIT = 		0x0004
    # 0x05 - 0x07 not defined 
    LDAP_OPT_REFERRALS = 		0x0008
    LDAP_OPT_RESTART = 		0x0009
    # 0x0a - 0x10 not defined 
    LDAP_OPT_PROTOCOL_VERSION = 	0x0011
    LDAP_OPT_SERVER_CONTROLS = 	0x0012
    LDAP_OPT_CLIENT_CONTROLS = 	0x0013
    # 0x14 not defined 
    LDAP_OPT_API_FEATURE_INFO = 	0x0015
    # 0x16 - 0x2f not defined 
    LDAP_OPT_HOST_NAME = 		0x0030
    LDAP_OPT_RESULT_CODE = 		0x0031
    LDAP_OPT_ERROR_NUMBER = 		LDAP_OPT_RESULT_CODE
    LDAP_OPT_DIAGNOSTIC_MESSAGE = 	0x0032
    LDAP_OPT_ERROR_STRING = 		LDAP_OPT_DIAGNOSTIC_MESSAGE
    LDAP_OPT_MATCHED_DN = 		0x0033
    # 0x0034 - 0x3fff not defined 
    # 0x0091 used by Microsoft for LDAP_OPT_AUTO_RECONNECT = 
    LDAP_OPT_SSPI_FLAGS = 		0x0092
    # 0x0093 used by Microsoft for LDAP_OPT_SSL_INFO = 
    # 0x0094 used by Microsoft for LDAP_OPT_REF_DEREF_CONN_PER_MSG = 
    LDAP_OPT_SIGN = 			0x0095
    LDAP_OPT_ENCRYPT = 		0x0096
    LDAP_OPT_SASL_METHOD = 		0x0097
    # 0x0098 used by Microsoft for LDAP_OPT_AREC_EXCLUSIVE = 
    LDAP_OPT_SECURITY_CONTEXT = 	0x0099
    # 0x009A used by Microsoft for LDAP_OPT_ROOTDSE_CACHE = 
    # 0x009B - 0x3fff not defined 

    # API Extensions 
    LDAP_OPT_API_EXTENSION_BASE = 0x4000  # API extensions 

    # private and experimental options 
    # OpenLDAP specific options 
    LDAP_OPT_DEBUG_LEVEL = 	0x5001	# debug level 
    LDAP_OPT_TIMEOUT = 		0x5002	# default timeout 
    LDAP_OPT_REFHOPLIMIT = 	0x5003	# ref hop limit 
    LDAP_OPT_NETWORK_TIMEOUT = 0x5005	# socket level timeout 
    LDAP_OPT_URI = 			0x5006
    LDAP_OPT_REFERRAL_URLS =      0x5007  # Referral URLs 
    LDAP_OPT_SOCKBUF =            0x5008  # sockbuf 
    LDAP_OPT_DEFBASE = 	0x5009	# searchbase 
    #define	LDAP_OPT_CONNECT_ASYNC = 	0x5010	# create connections asynchronously 
    #define	LDAP_OPT_CONNECT_CB = 		0x5011	# connection callbacks 
    #define	LDAP_OPT_SESSION_REFCNT = 	0x5012	# session reference count 

    # OpenLDAP TLS options 
    LDAP_OPT_X_TLS = 			0x6000
    LDAP_OPT_X_TLS_CTX = 		0x6001	# OpenSSL CTX* 
    LDAP_OPT_X_TLS_CACERTFILE = 0x6002
    LDAP_OPT_X_TLS_CACERTDIR = 0x6003
    LDAP_OPT_X_TLS_CERTFILE = 	0x6004
    LDAP_OPT_X_TLS_KEYFILE = 	0x6005
    LDAP_OPT_X_TLS_REQUIRE_CERT = 0x6006
    LDAP_OPT_X_TLS_PROTOCOL_MIN = 0x6007
    LDAP_OPT_X_TLS_CIPHER_SUITE = 0x6008
    LDAP_OPT_X_TLS_RANDOM_FILE = 0x6009
    LDAP_OPT_X_TLS_SSL_CTX = 	0x600a	# OpenSSL SSL* 
    LDAP_OPT_X_TLS_CRLCHECK = 	0x600b
    LDAP_OPT_X_TLS_CONNECT_CB = 0x600c
    LDAP_OPT_X_TLS_CONNECT_ARG = 0x600d
    LDAP_OPT_X_TLS_DHFILE = 	0x600e
    LDAP_OPT_X_TLS_NEWCTX = 	0x600f
    LDAP_OPT_X_TLS_CRLFILE = 	0x6010	# GNUtls only 
    LDAP_OPT_X_TLS_PACKAGE = 	0x6011

    LDAP_OPT_X_TLS_NEVER = 0
    LDAP_OPT_X_TLS_HARD = 	1
    LDAP_OPT_X_TLS_DEMAND = 2
    LDAP_OPT_X_TLS_ALLOW = 3
    LDAP_OPT_X_TLS_TRY = 	4

    LDAP_OPT_X_TLS_REQUIRE_CERT_MAP = {
      never: LDAP_OPT_X_TLS_NEVER,
      hard: LDAP_OPT_X_TLS_HARD,
      demand: LDAP_OPT_X_TLS_DEMAND,
      allow: LDAP_OPT_X_TLS_ALLOW,
      try: LDAP_OPT_X_TLS_TRY
    }

    LDAP_OPT_X_TLS_CRL_NONE = 0
    LDAP_OPT_X_TLS_CRL_PEER = 1
    LDAP_OPT_X_TLS_CRL_ALL = 2

    # for LDAP_OPT_X_TLS_PROTOCOL_MIN = 
    #LDAP_OPT_X_TLS_PROTOCOL(maj,min)	(((maj) << 8) + (min))
    LDAP_OPT_X_TLS_PROTOCOL_SSL2	=	(2 << 8)
    LDAP_OPT_X_TLS_PROTOCOL_SSL3	=	(3 << 8)
    LDAP_OPT_X_TLS_PROTOCOL_TLS1_0 =		((3 << 8) + 1)
    LDAP_OPT_X_TLS_PROTOCOL_TLS1_1 =		((3 << 8) + 2)
    LDAP_OPT_X_TLS_PROTOCOL_TLS1_2 =		((3 << 8) + 3)

    # OpenLDAP SASL options 
    LDAP_OPT_X_SASL_MECH = 		0x6100
    LDAP_OPT_X_SASL_REALM = 		0x6101
    LDAP_OPT_X_SASL_AUTHCID = 		0x6102
    LDAP_OPT_X_SASL_AUTHZID = 		0x6103
    LDAP_OPT_X_SASL_SSF = 			0x6104 # read-only 
    LDAP_OPT_X_SASL_SSF_EXTERNAL = 0x6105 # write-only 
    LDAP_OPT_X_SASL_SECPROPS = 	0x6106 # write-only 
    LDAP_OPT_X_SASL_SSF_MIN = 		0x6107
    LDAP_OPT_X_SASL_SSF_MAX = 		0x6108
    LDAP_OPT_X_SASL_MAXBUFSIZE = 	0x6109
    LDAP_OPT_X_SASL_MECHLIST = 	0x610a # read-only 
    LDAP_OPT_X_SASL_NOCANON = 		0x610b
    LDAP_OPT_X_SASL_USERNAME = 	0x610c # read-only 
    LDAP_OPT_X_SASL_GSS_CREDS = 	0x610d

    # OpenLDAP GSSAPI options 
    LDAP_OPT_X_GSSAPI_DO_NOT_FREE_CONTEXT =      0x6200
    LDAP_OPT_X_GSSAPI_ALLOW_REMOTE_PRINCIPAL =   0x6201

    #
    # OpenLDAP per connection tcp-keepalive settings
    # (Linux only, ignored where unsupported)

    LDAP_OPT_X_KEEPALIVE_IDLE = 	0x6300
    LDAP_OPT_X_KEEPALIVE_PROBES = 	0x6301
    LDAP_OPT_X_KEEPALIVE_INTERVAL = 0x6302

    # Private API Extensions -- reserved for application use 
    LDAP_OPT_PRIVATE_EXTENSION_BASE = 0x7000  # Private API inclusive 

    #
    # ldap_get_option() and ldap_set_option() return values.
    # As later versions may return other values indicating
    # failure, current applications should only compare returned
    # value against LDAP_OPT_SUCCESS.

    LDAP_OPT_SUCCESS = 0
    #define	LDAP_OPT_ERROR = 	(-1)

    # option on/off values 
    #LDAP_OPT_ON = 	((void *) &ber_pvt_opt_on)
    #LDAP_OPT_OFF = ((void *) 0)





  end
end

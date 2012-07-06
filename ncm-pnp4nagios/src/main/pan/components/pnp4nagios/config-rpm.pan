# ${license-info}
# ${developer-info}
# ${author-info}

################################################################################
# This is 'TPL/config.tpl', a ncm-pnp4nagios's file
################################################################################
#
#
################################################################################
unique template components/pnp4nagios/config-rpm;
include {'components/pnp4nagios/schema'};


# Package to install
"/software/packages"=pkg_repl("ncm-pnp4nagios","2.1.0-1","noarch");
"/software/components/pnp4nagios/dependencies/pre" ?=  if (exists("/software/components/icinga")) {
		list ("icinga");
	} else if (exists("/software/components/nagios")) {
		list("nagios");
	} else {
		list("spma");
	};

"/software/components/pnp4nagios/active" ?= true;
"/software/components/pnp4nagios/dispatch" ?= true;

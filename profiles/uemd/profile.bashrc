[[ $(basename $(readlink -f $PORTAGE_CONFIGROOT/etc/make.profile)) == "embedded" ]] && . ${PORTDIR}/profiles/base/profile.bashrc

post_src_install() {
	[[ -d ${D} ]] || return 0        
	[[ ${E_MACHINE} == "" ]] && return 0
	cmdline=""        
	for EM in $E_MACHINE; do
		cmdline+=" -e ^${EM}[[:space:]]";        
	done
	output="$( cd ${D} && scanelf -RmyBF%a . | grep -v ${cmdline} )"
	[[ $output != "" ]] && { echo; echo "* Wrong EM_TYPE. Expected ${E_MACHINE}"; echo -e "${output}"; echo; exit 1; }
}

# We dont functionize this to avoid sandboxing.
if [[ $EBUILD_PHASE == "postinst" ]]; then
	case $EMERGE_FROM in 
		binary) ;;
		*)
			einfo "Calling cross-fix-root ${CHOST}"
			cross-fix-root ${CHOST}
			;;
	esac
fi

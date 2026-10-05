#!/usr/bin/env bash

onlyswitch() {
	local OK_HOME="$HOME/.gnupg/onlykey"
	local action="${1:-toggle}"

	if [ "$action" = toggle ] || [ "$action" = t ]; then
		if [ "$GNUPGHOME" = "$OK_HOME" ]; then action=system; else action=onlykey; fi
	fi
	
	case "$action" in
	  onlykey|ok)
	    export GNUPGHOME="$OK_HOME"

		  gpgconf --homedir "$OK_HOME" --kill gpg-agent 2>/dev/null
		  pgrep -f onlykey-gpg-agent >/dev/null 2>&1 || ("$OK_HOME/run-agent.sh" >/dev/null 2>&1 & )
		  echo "gpg -> OnlyKey ring (GNUPGHOME=$GNUPGHOME)"
		  ;;
	  system|sys|sw)
	    unset GNUPGHOME
		  echo "gpg -> system ring  (GNUPGHOME=$GNUPGHOME - should be ~/.gnupg)"
		  ;;
	  status)
	    if [ -n "$GNUPGHOME" ]; then
		    echo "active: OnlyKey ring (GNUPGHOME=$GNUPGHOME)"
		  else
		    echo "active: system ring (~/.gnupg)"
		  fi
		  ;;
	  *)
	    echo "usage: onlyswitch {onlykey|system|status}" >&2
	    return 1
	    ;;
	esac
}

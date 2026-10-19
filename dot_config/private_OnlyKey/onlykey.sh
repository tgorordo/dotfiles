#!/usr/bin/env bash
# Source from your shell rc.  Provides:
#   ok_agent_up   start onlykey-gpg-agent for the OnlyKey ring if it isn't running
#   onlyswitch    point this shell's gpg at the OnlyKey ring or the system ring
#
# Fix vs. the old version: it ran `gpgconf --kill gpg-agent` on every switch.
# The OnlyKey ring's agent socket belongs to onlykey-gpg-agent, so that could
# kill the OnlyKey agent itself; the pgrep right after then raced the dying
# process and often skipped the restart.  Now a stray real gpg-agent is only
# killed when the OnlyKey agent is NOT running, and startup waits for the socket.

OK_HOME="$HOME/.gnupg/onlykey"

OK_LOG="${XDG_STATE_HOME:-$HOME/.local/state}/onlykey-gpg-agent.log"

ok_agent_up() {
	# GnuPG puts this homedir's socket under /run/user/UID/gnupg/d.<hash>/, not
	# in the homedir itself, so ask gpgconf where it is.
	local sock i
	sock=$(gpgconf --homedir "$OK_HOME" --list-dirs agent-socket)
	if pgrep -u "$(id -u)" -f "onlykey-gpg-agent.*--homedir $OK_HOME" >/dev/null 2>&1 && [ -S "$sock" ]; then
		return 0
	fi
	# clear a dead agent or a real gpg-agent that grabbed the socket
	pkill -u "$(id -u)" -f onlykey-gpg-agent 2>/dev/null
	gpgconf --homedir "$OK_HOME" --kill gpg-agent 2>/dev/null
	rm -f "$sock"
	mkdir -p "$(dirname "$OK_LOG")"
	(nohup "$OK_HOME/run-agent.sh" --homedir "$OK_HOME" >>"$OK_LOG" 2>&1 &)
	for i in $(seq 50); do [ -S "$sock" ] && return 0; sleep 0.1; done
	echo "onlykey-gpg-agent did not come up; see $OK_LOG" >&2
	return 1
}

ok_agent_down() {
	pkill -u "$(id -u)" -f onlykey-gpg-agent 2>/dev/null
	rm -f "$(gpgconf --homedir "$OK_HOME" --list-dirs agent-socket)"
}

onlyswitch() {
	local action="${1:-toggle}"
	if [ "$action" = toggle ] || [ "$action" = t ]; then
		if [ "$GNUPGHOME" = "$OK_HOME" ]; then action=system; else action=onlykey; fi
	fi
	case "$action" in
	onlykey | ok)
		ok_agent_up || return 1
		export GNUPGHOME="$OK_HOME"
		echo "gpg -> OnlyKey ring (GNUPGHOME=$GNUPGHOME)"
		;;
	system | sys | sw)
		unset GNUPGHOME
		echo "gpg -> system ring (~/.gnupg)"
		;;
	status)
		if [ "$GNUPGHOME" = "$OK_HOME" ]; then
			echo "active: OnlyKey ring"
		else
			echo "active: system ring (${GNUPGHOME:-~/.gnupg})"
		fi
		pgrep -u "$(id -u)" -f onlykey-gpg-agent >/dev/null && echo "onlykey agent: running" || echo "onlykey agent: stopped"
		;;
	*)
		echo "usage: onlyswitch {onlykey|system|status|toggle}" >&2
		return 1
		;;
	esac
}

#!/bin/sh
    export PATH="/home/tgorordo/.juliaup/bin:/home/tgorordo/.local/bin:/home/tgorordo/.cargo/bin:/home/tgorordo/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/jvm/default-jdk/bin:/usr/lib/jvm/default-jre/bin:/opt/texlive/2026/bin/x86_64-linux:/home/tgorordo/.cabal/bin:/home/tgorordo/.ghcup/bin:/home/tgorordo/.local/bin"
    /home/tgorordo/.local/bin/onlykey-gpg-agent \
    --skey-slot=101 \
    --dkey-slot=102 \
    $*
    

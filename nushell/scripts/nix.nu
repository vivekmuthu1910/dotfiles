use std log
use std/util "path add"

def check_env [env_var] {
    mut env_len = 0
    if $env_var in $env {
        if ($env | get $env_var | describe) == "string" {
            $env_len = ($env | get $env_var | str length)
        } else {
            $env_len = ($env | get $env_var | length)
        }
    }

    if $env_len > 0 {
        true
    } else {
        false
    }
}

if (check_env "HOME") and (check_env "USER") {
    mut NIX_LINK = ""

    if (check_env "NIX_STATE_HOME") {
        $NIX_LINK = $"($env.NIX_STATE_HOME)/profile"
    } else {
        $NIX_LINK = $"($env.HOME)/.nix-profile"
        mut NIX_LINK_NEW = ""
        if (check_env "XDG_STATE_HOME") {
            $NIX_LINK_NEW = $"($env.XDG_STATE_HOME)/nix/profile"
        } else {
            $NIX_LINK_NEW = $"($env.HOME)/.local/state/nix/profile"
        }

        if ( $NIX_LINK_NEW | path exists ) {
            if ($NIX_LINK | path exists) {
                log warning $"Both ($NIX_LINK_NEW) and legacy ($NIX_LINK)
 exist; using the former"
                if ( ( $NIX_LINK_NEW | path expand ) == ( $NIX_LINK | path expand ) ) {
                    log info "Since the profiles match, you can safely delete either of them." 
                } else {
                    log warning $"Profiles do not match. You should manually migrate from ($NIX_LINK) to ($NIX_LINK_NEW)."
                }
            }
            $NIX_LINK = $NIX_LINK_NEW
        }
    }

    $env.NIX_PROFILES = $"/nix/var/nix/profiles/default ($NIX_LINK)"

    if ( check_env "XDG_DATA_DIRS" ) {
       $env.XDG_DATA_DIRS = $env.XDG_DATA_DIRS | append [ ($NIX_LINK | path join share) /nix/var/nix/profiles/default/share ] 
    } else {
        $env.XDG_DATA_DIRS = [/usr/local/share /usr/share ($NIX_LINK | path join share) /nix/var/nix/profiles/default/share ]
    } 

    if ( "/etc/ssl/certs/ca-certificates.crt" | path exists ) { # NixOS, Ubuntu, Debian, Gentoo, Arch
        $env.NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"
    } else if ( "/etc/ssl/ca-bundle.pem" | path exists ) { # openSUSE Tumbleweed
        $env.NIX_SSL_CERT_FILE = "/etc/ssl/ca-bundle.pem"
    } else if ( "/etc/ssl/certs/ca-bundle.crt" | path exists ) { # Old NixOS
        $env.NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt"
    } else if ( "/etc/pki/tls/certs/ca-bundle.crt" | path exists ) { # Fedora, CentOS
        $env.NIX_SSL_CERT_FILE = "/etc/pki/tls/certs/ca-bundle.crt"
    } else if ( $"($NIX_LINK)/etc/ssl/certs/ca-bundle.crt" | path exists ) { # fall back to cacert in Nix profile
        $env.NIX_SSL_CERT_FILE = $"($NIX_LINK)/etc/ssl/certs/ca-bundle.crt"
    } else if ( $"($NIX_LINK)/etc/ca-bundle.crt" | path exists ) { # old cacert in Nix profile
        $env.NIX_SSL_CERT_FILE = $"($NIX_LINK)/etc/ca-bundle.crt"
    }
    
    if ( check_env "MANPATH" ) {
        $env.MANPATH = $"($NIX_LINK)/share/manpath:($env.MANPATH)" 
    }

    path add ($NIX_LINK | path join bin )

}

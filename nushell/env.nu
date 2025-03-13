$env.ENV_CONVERSIONS = $env.ENV_CONVERSIONS | merge {
        "PATH" : {
                from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
                to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
        }
        "XDG_DATA_DIRS" : {
                from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
                to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
        }
        "XDG_CONFIG_DIRS" : {
                from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
                to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
        }
        "NIX_PATH" : {
                from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
                to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
        }
}

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

mkdir ~/.cache/zoxide
zoxide init nushell | save -f ~/.cache/zoxide/.zoxide.nu

mkdir ~/.cache/atuin
atuin init --disable-up-arrow nu | save -f ~/.cache/atuin/init.nu

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

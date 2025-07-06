$env.config.show_banner = false # true or false to enable or disable the welcome banner at startup
$env.config.history = {
    max_size: 100_000 # Session has to be reloaded for this to take effect
    sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format: "sqlite" # "sqlite" or "plaintext"
    isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
}
$env.config.buffer_editor = "hx" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
$env.config.edit_mode = "vi" # emacs, vi


$env.config = ($env.config | update hooks ($env.config.hooks | default {} env_change))
$env.config.hooks.env_change = ($env.config.hooks.env_change | default [] PWD)
$env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD | append  [{|before, after| 
    if (which direnv | is-empty) { return }
    direnv export json | from json | default {} | load-env
    $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
    $env.XDG_DATA_DIRS = do $env.ENV_CONVERSIONS.XDG_DATA_DIRS.from_string $env.XDG_DATA_DIRS
    $env.XDG_CONFIG_DIRS = do $env.ENV_CONVERSIONS.XDG_CONFIG_DIRS.from_string $env.XDG_CONFIG_DIRS
    $env.NIX_PATH = do $env.ENV_CONVERSIONS.NIX_PATH.from_string $env.NIX_PATH
    # $env.__zoxide_hooked = do $env.ENV_CONVERSIONS.__zoxide_hooked.from_string $env.__zoxide_hooked
}, {|_, dir| zoxide add -- $dir }])

alias lvim = with-env {NVIM_APPNAME: lazy_nvim} { nvim }
alias ":q" = exit
alias ":qa" = exit
alias ":wq" = exit
alias ":wqa" = exit

use ~/.cache/starship/init.nu
source ~/.cache/zoxide/.zoxide.nu
source ~/.cache/atuin/init.nu
source ~/.cache/carapace/init.nu

use ./yazi.nu *
use ./ya.nu *

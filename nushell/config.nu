$env.config.buffer_editor = "nvim"
$env.config.shell_integration.osc133 = false
$env.config.show_banner = false

# Conditionally enable the right OS overlay
match $nu.os-info.name {
  'windows' => { use ./windows.nu * },
  'macos' => { use ./macos.nu * },
  _ => { }
}

use ./keys.nu

if $nu.os-info.name == "windows" {
  alias cat = open
}

# alias
def nvc [] {
  cd ~/.dotfiles/nvim
  nvim .
}

def nvd [] {
  cd ~/.dotfiles
  nvim .
}

alias vim = nvim .
alias .. = cd ..
alias e = exit

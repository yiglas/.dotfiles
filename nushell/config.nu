$env.config.buffer_editor = "nvim"
$env.config.shell_integration.osc133 = false
$env.config.show_banner = false

def randomize-background [] {
  let backgroundsPath = "C:\\Users\\Devin\\.dotfiles\\backgrounds"

  let images = (
    ls $backgroundsPath
    | where type == 'file'
    | where {|f| ($f.name | str ends-with '.jpg') or ($f.name | str ends-with '.png') }
  )

  let randomImage = $images | shuffle | first
  let imagePath = $randomImage.name

  let settingsPath = $"($env.LOCALAPPDATA)\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\settings.json"
  let json = open $settingsPath

  let updatedDefaults = $json.profiles.defaults | upsert backgroundImage $imagePath
  let updatedJson = $json | upsert profiles.defaults $updatedDefaults

  $updatedJson | to json -r | save -f $settingsPath
}

if ($nu.os-info.name == "windows") {
  def ld [] {
    cd ~/code/filevine/lead-docket
    nvim .
  }

  alias cat = open
}

if ($nu.os-info.name == "macos") {
  $env.PATH = ($env.PATH | split row (char esep) | prepend "/opt/homebrew/sbin")
  $env.PATH = ($env.PATH | split row (char esep) | prepend "/opt/homebrew/bin")
  $env.PATH = ($env.PATH | split row (char esep) | prepend "/Users/devinsackett/Library/pnpm")
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

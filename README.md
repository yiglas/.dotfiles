# Machine Configuration

## Mac config changes

### Install

#### 1. [Homebrew](https://brew.sh/)

#### 2. Install

```bash
# DisplayLink
brew install --cask displaylink

# Dotfiles
git clone https://github.com/yiglas/.dotfiles.git

# Tmux
brew install tmux
cd ~/.config
mkdir tmux
ln -sf ~/.dotfiles/tmux.conf ~/.config/tmux/tmux.conf

# Kitty (then: Kitty menu → Reload Preferences)
brew install --cask kitty
ln -sf ~/.dotfiles/kitty ~/.config/kitty

# Font
brew install --cask font-jetbrains-mono-nerd-font

# Starship
brew install starship
echo 'eval "$(starship init zsh)"' >> ~/.zprofile
ln -sf ~/.dotfiles/starship/starship.toml ~/.config/starship.toml

# Windows tiling manager
brew install asmvik/formulae/yabai
brew install asmvik/formulae/skhd
ln -sf ~/.dotfiles/yabai ~/.config/yabai
ln -sf ~/.dotfiles/skhd ~/.config/skhd
yabai --start-service
skhd --start-service


# Developer Tools
brew install go
brew install ripgrep
brew install neovim
ln -sf ~/.dotfiles/nvim ~/.config/nvim

# Key Repeat
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# Browsers
brew install --cask arc

# Apps
brew install --cask itsycal
brew install --cask logi-options+
brew install --cask meetingbar
brew install --cask raycast

# Zshrc
ln -sf ~/.dotfiles/.zshrc ~/.zshrc

# Claude & Productivity
brew install --cask claude-code
brew install --cask claude
brew install --cask linear-linear
brew install glab
```

#### Finder Configuration

Open Finder → View menu:

- Show Path Bar
- Show Status Bar

#### Open at Login

Open System Settings → Search: **Open at Login** → Add:

- DisplayLink Manager
- Itsycal
- MeetingBar
- Raycast

#### Keyboard Shortcuts

Open System Settings → Search: **Keyboard Shortcuts**

- **Spotlight**: uncheck "Show Spotlight search"
- **Spotlight**: Show Apps = `F4`
- **Mission Control**: Mission Control = `F3`
- **Mission Control**: Show Desktop = `Ctrl+F11`
- **Function Keys**: check "Use F1, F2, etc. keys as standard function keys"
- **Modifier Keys**: Caps Lock Key = `Control`

#### Setup react-native environment

<https://www.youtube.com/watch?v=MJEcookWYUI>

<https://medium.com/@davidjasonharding/developing-a-react-native-app-on-an-m1-mac-without-rosetta-29fcc7314d70>

## Windows config changes

1. installed chocolatey
2. installed logi+

- configured logi+
- mouse -> point and scroll -> scroll wheel -> scroll direction inverted

2. add windows feature windows hypervisor platform & virtual machine platform
3. installed wsl

4. in wsl

- sudo apt update
- sudo apt install build-essential
- sudo apt install zsh
  - chsh -s $(which zsh)
- install oh-my-zsh: sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
- git clone my .dotfiles
- ln -sf ~/.dotfiles/.oh-my-zsh/themes/robbyrussell.zsh-theme ~/.oh-my-zsh/themes/robbyrussell.zsh-theme

- install brew
- eval shellevn temp to load brew into current path
- brew install gcc
- brew install unzip
- brew install ripgrep
- brew install node
- sudo apt install gcc
- brew install --cask font-meslo-lg-nerd-font
- ~/.install-fonts.sh
- brew install neovim
- mkdir ~/.config
- ln -sf ~/.dotfiles/nvim ~/.config/nvim

5. outside of wsl

-choco instal sqlcmd

- choco install git
- git clone my .dotfiles
- choco install nerd-fonts-meslo
- ~/.install-fonts.ps1
- choco install powershell-core
- choco install oh-my-posh
- choco install which
- choco install grep
- choco install wezterm
  cmd /c mklink /d c:\users\{}\.config\wezterm c:\users\{}\.dotfiles\wezterm
  mkdir ~\Documents\PowerShell
  cmd /c mklink ~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 ~\.dotfiles\PowerShell\Microsoft.PowerShell_profile.ps1
  cmd /c mklink ~\Documents\PowerShell\Microsoft.VSCode_profile.ps1 ~\.dotfiles\PowerShell\Microsoft.PowerShell_profile.ps1
  cmd /c mklink ~\Documents\PowerShell\robbyrussel.omp.json ~\.dotfiles\PowerShell\robbyrussel.omp.json

- choco install docker-desktop
- choco install flow-launcher
- install arc browser

- choco instal nu
  TODO: soft link to nu config folder
- choco install python3
- choco install starship
  TODO: soft link to startship.toml file
- choco install microsoftazurestorageexplorer
- pip install sqlfluff

Troubleshooting: e
if cert error go here: blog.tymek.dev/fixing-wsl-certificates when install brew

### Install

#### [Chocolatey](https://chocolatey.org/)

#### Without WSL

##### DisplayLink

```bash
choco install displaylink
```

##### Fonts

```bash
choco install nerd-fonts-meslo

./install-fonts.ps1
```

##### Terminal

```bash
choco install powershell-core
choco install oh-my-posh
choco install which
choco install grep
choco install wezterm

cmd /c mklink ~\.config\wezterm ~\.dotfiles\wezterm
mkdir ~\Documents\PowerShell
cmd /c mklink ~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 ~\.dotfiles\PowerShell\Microsoft.PowerShell_profile.ps1
cmd /c mklink ~\Documents\PowerShell\Microsoft.VSCode_profile.ps1 ~\.dotfiles\PowerShell\Microsoft.PowerShell_profile.ps1
cmd /c mklink ~\Documents\PowerShell\robbyrussel.omp.json ~\.dotfiles\PowerShell\robbyrussel.omp.json

git config --global alias.ignore 'update-index --skip-worktree'
git config --global alias.uningnore 'update-index --no-skip-worktree'
git config --global alais.ignored 'ls-files -v | grep "^S"'
```

##### Developer Tools

```bash
choco install ripgrep
choco install neovim
choco install mingw
cmd /c mklink /D ~\AppData\Local\nvim ~\.dotfiles\nvim

choco install vscode
choco install docker-desktop
choco install dotnet
choco install nodejs

choco install sqlpackage
```

##### Browsers

```bash
choco install googlechrome
# arc browser https://arc.net/
```

##### Extras

```bash
choco install slack
choco install logioptionsplus
choco install zoom
choco install chatgpt
choco install flow-launcher
```

##### Legacy installs

```bash
choco install brave
choco install azure-data-studio
choco install microsoftazurestorageexplorer
choco install awscli
choco install powertoys
choco install flow-launcher
choco install rainmeter
choco install startallback
choco install sqlpackage
```

#### With WSL

##### Install WSL

```bash
wsl --install
```

##### WSL

###### Apt update

```bash
sudo apt update
```

###### [Homebrew](https://brew.sh/)

###### Fonts

```bash
brew install --cask font-meslo-lg-nerd-font

~/install-fonts.sh
```

#### Developer Tools

```bash
brew install ripgrep
brew install neovim
ln -sf ~/.dotfiles/nvim ~/.config/nvim

brew install dotnet
brew install node
```

##### Outside of WSL

###### Browsers

```bash
choco install googlechrome
# arc browser https://arc.net/
```

###### Extras

```bash
choco install slack
choco install logioptionsplus
choco install zoom
choco install chatgpt
choco install flow-launcher
```

#### Make windows 11 look more like Mac

- **Invert Mouse**:
  Settings / Bluetooth & devices / Mouse
  change Scrolling Direction to `Down motion scrolls up`

- Enable sudo mode by going to Settings / System / For developers toggle `Enable sudo mode`

#### Proxy: mitmproxy

```bash
choco install -y mitmproxy
```

- install mitm.it cert
- start mitmproxy

```bash
mitmproxy
```

#### Disable clipboard history

```powershell
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System\ /v AllowClipboardHistory /t REG_DWORD /d 0
```

## SSH

<https://www.youtube.com/watch?v=Wx7WPDnwcDg>

### Windows: Set `pwsh` as default PowerShell Command

```bash
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Program Files\PowerShell\7\pwsh.exe" -PropertyType String -Force

Restart-Service sshd
```

### Troubleshooting

#### WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED

```bash
ssh-keygen -R <Windows IP or hostname>
```

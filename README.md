# Machine Configuration

## MacOS config changes

### Install

#### [Homebrew](https://brew.sh/)

#### DisplayLink Manager

```bash
brew install --cask displaylink
```

#### Fonts

```bash
brew install --cask font-meslo-lg-nerd-font

~/install-fonts.sh
```

#### Terminal

```bash
brew install --cask wezterm
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ln -sf ~/.dotfiles/.oh-my-zsh/themes/robbyrussell.zsh-theme ~/.oh-my-zsh/themes/robbyrussell.zsh-theme
ln -sf ~/.dotfiles/wezterm ~/.config/wezterm
```

#### Developer Tools

```bash
brew install ripgrep
brew install neovim
ln -sf ~/.dotfiles/nvim ~/.config/nvim

brew install --cask visual-studio-code

defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

brew install --cask docker

brew install dotnet
brew install node
```

#### Browsers

```bash
brew install --cask google-chrome
brew install --cask arc
brew install --cask finicky
ln -sf ~/.dotfiles/.finicky.js ~/.finicky.js
```

#### Extras

```bash
brew install --cask windows-app # remote desktop
brew install --cask slack
brew install --cask itsycal # [itsycal](https://www.mowglii.com/itsycal)
brew install --cask logi-options+
brew install --cask meetingbar
brew install --cask zoom
brew install --cask cleanmymac
brew install --cask chatgpt
brew install --cask raycast
```

#### Legacy installs

```bash
# Terminal
brew install --cask ghostty
brew install --cask iterm2
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/.dotfiles/iTerm" # Specify the preferences directory
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true # Tell iTerm2 to use the custom preferences in the directory

# Browsers
brew install --cask brave-browser
brew install --cask zen-browser
brew install --cask microsoft-edge

# Development
brew install --cask azure-data-studio
brew install node
brew install pnpm
brew install watchman
brew install ruby
gem install -n /usr/local/bin ffi
brew install awscli
brew install cocoapods
npm install -g @aws-amplify/cli

# Extras
brew install --cask miro
brew install --cask figma
brew install --cask handbrake
brew install --cask alt-tab
brew install --cask nordvpn
brew install --cask folx # [Folx](https://mac.eltima.com/download-manager.html)
brew install --cask hiddenbar
brew install --cask notion
brew install --cask obsidian
```

#### Finder Configuration

1. Open Finder
2. Under the View menu
   - Show Path Bar
   - Show Status Bar

#### Open at Login

1. Open `System Settings`
2. Search: `Open at Login`
3. Add `DisplayLink Manager` Application to the list
4. Add `Finicky` Application to the list
5. Add `Itsycal` Application to the list
6. Add `MeetingBar` Application to the list
7. Add `Raycast` Application to the list

#### Keyboard changes

1. Open `System Settings`
2. Search: `Keyboard shortcuts`
3. Under `Launchpad & Dock`

   - Set `Show Launchpad` = **F4**

4. Under `Mission Control`

   - Set `Mission Control` = **F3**
   - Set `Show Desktop` = **Ctrl + F11**

5. Under `Function Keys`

   - Enable `Use F1, F2, etc. keys as standard function keys`

#### Setup react-native environment

<https://www.youtube.com/watch?v=MJEcookWYUI>

<https://medium.com/@davidjasonharding/developing-a-react-native-app-on-an-m1-mac-without-rosetta-29fcc7314d70>

## Windows config changes

### Install

#### Without WSL

##### [Chocolatey](https://chocolatey.org/)

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
```

##### Developer Tools

```bash
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

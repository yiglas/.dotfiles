# MacOS config changes

## Keyboard changes:

## Install

### [DisplayLink Manager](https://www.synaptics.com/products/displaylink-graphics)

### [Homebrew](https://brew.sh/)

### Fonts

```bash
brew install --cask font-meslo-lg-nerd-font

~/install-fonts.sh
```

### Terminal

```bash
brew install --cask ghostty
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ln -sf ~/.dotfiles/.oh-my-zsh/themes/robbyrussell.zsh-theme ~/.oh-my-zsh/themes/robbyrussell.zsh-theme
```

### Developer Tools

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
```

### Browsers

```bash
brew install --cask google-chrome
brew install --cask arc
brew install --cask finicky
ln -sf ~/.dotfiles/.finicky.js ~/.finicky.js
```

### Extras

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
brew install --cask zoom
```

### Legacy installs:

```bash
# Terminal
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

## Finder Configuration

1. Open Finder
2. Under the View menu
   - Show Path Bar
   - Show Status Bar

## Open at Login

1. Open `System Settings`
2. Search: `Open at Login`
3. Add `DisplayLink Manager` Application to the list
4. Add `Finicky` Application to the list
5. Add `Itsycal` Application to the list
6. Add `MeetingBar` Application to the list
7. Add `Raycast` Application to the list

## Keyboard changes

1. Open `System Settings`
2. Search: `Keyboard shortcuts`
3. Under `Launchpad & Dock`

- Set `Show Launchpad` = **F4**

4. Under `Mission Control`

- Set `Mission Control` = **F3**
- Set `Show Desktop` = **Ctrl + F11**

5. Under `Function Keys`

- Enable `Use F1, F2, etc. keys as standard function keys`

## SSH

1. Generate ssh key:

   ```base
   ssh-keygen -t rsa
   ```

2. Copy the contents of the id_rsa.pub file.
3. Add the pub fingerprint to the `.ssh/authorized_keys` file on the host machine.

### Enable OpenSSH Server

```bash
sudo -E vi /etc/ssh/sshd_config

#update sshd_config with the following
# PermitUserEnvironment yes

vi ~/.ssh/environment

# PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/Users/dsac/.oh-my-zsh/custom/plugins
```

Restart OpenSSH:

1. Go to _System Preferences_ → _Sharing_.
2. uncheck & recheck _Remote Login_

## Setup react-native environment

<https://www.youtube.com/watch?v=MJEcookWYUI>

<https://medium.com/@davidjasonharding/developing-a-react-native-app-on-an-m1-mac-without-rosetta-29fcc7314d70>

# Windows config changes

## Tools

- choco: <https://chocolatey.org/install>

- git

  ```powershell
  choco install -y git
  ```

- vscode

  ```powershell
  choco install -y vscode
  ```

- powershell core

  ```powershell
  choco install -y powershell-core
  ```

- docker cli

  ```powershell
  choco install -y docker-machine
  ```

  remove docker from starting up on windows startup
  set **DOCKER_HOST** environment variable = `ssh://{user}@{server}`

- .net

  ```powershell
  choco install -y dotnetcore-sdk --version=3.1.414
  choco install -y dotnet
  ```

- azure cli

  ```powershell
  choco install -y azure-cli
  ```

- vim

  ```powershell
  choco install -y vim
  ```

- which

  ```powershell
  choco install -y which
  ```

- sudo

  ```powershell
  choco install -y gsudo
  ```

- oh-my-posh

  ```powershell
  choco install -y oh-my-posh
  ```

  When in Parallels:

  1. Edit `This PC` / `Documents` properties
  2. Set the location to the mapped drive instead of the UNC path i.e.:
     **Z:\Documents** instead of **\\\\Mac\Home\Documents**

  From Mac run:

  ```bash
  mkdir ~/Documents/PowerShell
  cp ~/.dotfiles/PowerShell/Microsoft.PowerShell_profile.ps1 ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1
  cp ~/.dotfiles/PowerShell/robbyrussel.omp.json ~/Documents/PowerShell/robbyrussel.omp.json
  ```

  From Windows VM:

  - Make directory C:\PowerShell
  - Copy the PowerShell directory into the new directory made

  In Windows VM run:

  ```powershell
  . $PROFILE
  ```

- lsd

  ```powershell
  choco install -y lsd
  ```

- mitmproxy

  ```powershell
  choco install -y mitmproxy
  ```

  - install mitm.it cert
  - start mitmproxy

  ```powershell
  mitmproxy
  ```

## Create symbolic links use the following statements

## Install custom fonts

```bash
./install-fonts.ps1
```

## SSH

1. Generate ssh key:

   ```base
   ssh-keygen -t rsa
   ```

2. Copy the contents of the id_rsa.pub file.
3. Add the pub fingerprint to the `.ssh/authorized_keys` file on the host machine.

### Enable OpenSSH Server

1. admin powershell terminal

   ```powershell
   $OpenSSHServer = Get-WindowsCapability -Online | ? Name -like 'OpenSSH.Server*'
   Add-WindowsCapability -Online -Name $OpenSSHServer.Name
   $SSHDaemonSvc = Get-Service -Name 'sshd'
   Set-Service -Name $SSHDaemonSvc.Name -StartupType Automatic

   Start-Service -Name $SSHDaemonSvc.Name
   Stop-Service -Name $SSHDaemonSvc.Name
   notepad $env:PROGRAMDATA\ssh\sshd_config

   #update sshd_config with the following
   #
   # PubkeyAuthentication yes
   # PasswordAuthentication no
   # PermitEmptyPasswords no
   # #Match Group administrators
   # #       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys

   mkdir "$HOME\.ssh"

   $authorizedKeyFilePath = "$HOME\.ssh\authorized_keys"
   New-Item $authorizedKeyFilePath
   notepad.exe $authorizedKeyFilePath

   #add the SSH keys

   icacls.exe $authorizedKeyFilePath /remove "NT AUTHORITY\Authenticated Users"
   icacls.exe $authorizedKeyFilePath /inheritance:r
   Get-Acl "$env:ProgramData\ssh\ssh_host_dsa_key" | Set-Acl $authorizedKeyFilePath

   Start-Service -Name $SSHDaemonSvc.Name
   ```

## disable clipboard history

```powershell
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System\ /v AllowClipboardHistory /t REG_DWORD /d 0
```

# Parallel settings

1. to remove Mac application inside of Windows' Parallels VM

_Parallel_ → _Configuration_ → _Options_ → _Application_ → uncheck `Share Mac application with Windows`

2. to hide Parallels' applications from spotlight search

   1. Go to _System Preferences_ → _Spotlight_.
   2. Switch to the _Privacy_ tab
   3. Add
      - Applications (Parallels)
      - Parallels

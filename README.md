# MacOS config changes

## Tools:

- homebrew: https://brew.sh/

- brave

  ```bash
  brew install --cask brave-browser
  ```

- node

  ```bash
  brew install node
  ```

- watchman

  ```bash
  brew install watchman
  ```

- ruby

  ```bash
  brew install ruby
  ```

- ffi

  ```bash
  gem install -n /usr/local/bin ffi
  ```

- cocoapods

  ```bash
  brew install cocoapods
  ```

- yarn

  ```bash
  brew install yarn
  ```

- finicky

  ```bash
  brew install --cask finicky
  ```

- zsh - https://ohmyz.sh/

- docker

  ```bash
  brew install --cask docker
  ```

- remote desktop

  ```bash
  brew install --cask microsoft-remote-desktop
  ```

- vscode - https://code.visualstudio.com/

  ```bash
  brew install --cask visual-studio-code
  ```

- itsycal - https://www.mowglii.com/itsycal/

  ```bash
  brew install --cask itsycal
  ```

- displaylink - https://www.synaptics.com/products/displaylink-graphics

- xcode (app store)

- slack

  ```bash
  brew install --cask slack
  ```

- miro

  ```bash
  brew install --cask miro
  ```

- figma

  ```figma
  brew install --cask figma
  ```

- zoom

  ```bash
  brew install --cask zoom
  ```

- azure data studio

  ```bash
  brew install --cask azure-data-studio
  ```

- meeting bar

  ```bash
  brew install --cask meetingbar
  ```

- microsoft edge

  ```bash
  brew install --cask microsoft-edge
  ```

- flipper

  ```bash
  brew install --cask flipper
  ```

- react-native debugger

  ```bash
  brew install --cask react-native-debugger
  ```

- clean my mac

  ```bash
  brew install --cask cleanmymac
  ```

- aws amplify cli

  ```bash
  npm install -g @aws-amplify/cli
  ```

- things3 (app store)

- emacs
- doom emacs - https://github.com/hlissner/doom-emacs

## Create symbolic links use the following statements:

```bash
ln -sf ~/.dotfiles/.doom.d ~/.doom.d
ln -sf ~/.dotfiles/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/.npmrc ~/.npmrc
ln -sf ~/.dotfiles/.zprofile ~/.zprofile
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.oh-my-zsh/themes/robbyrussell.zsh-theme ~/.oh-my-zsh/themes/robbyrussell.zsh-theme
ln -sf ~/.dotfiles/.finicky.js ~/.finicky.js
```

## Add VSCode's `code` to the path:

1. inside vscode
2. open command palette
3. run: `Shell Command: Install ‘code’ command in PATH`

## Install custom fonts:

```bash
./install-fonts.sh
```

## Enable function keys

1. Go to _System Preferences_ → _Keyboard_.
2. Select: _Touch Bar shows_ **F1, F2, etc. Keys**
3. Check: _Use F1, F2, etc..._
4. Switch to the _Shortcuts_ tab
   - Set: **Shortcuts** → **Launchpad & Dock** → **Show Launchpad** → **F4**
   - Set: **Shortcuts** → **Mission Control** → **Mission Control** → **F3**

## Fix Keychron K1 keyboard keys

1. Go to _System Preferences_ → _Keyboard_.
2. Click on _Modifier Keys_ button
3. Select keyboard: **K1-Keyboard**
   - Set: **Option Key** → **Command**
   - Set: **Command Key** → **Option**

## Add startup items

1. Go to _System Preferences_ → _Users & Groups_.
2. Switch to the _Login Items_ tab
3. Add
   - Itsycal
   - DisplayLink Manager
   - Finicky

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

## Setup react-native environment:

https://www.youtube.com/watch?v=MJEcookWYUI

https://medium.com/@davidjasonharding/developing-a-react-native-app-on-an-m1-mac-without-rosetta-29fcc7314d70

# Windows config changes

## Tools:

- choco: https://chocolatey.org/install

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
  choco install -y docker-cli
  ```

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
  choco install -y sudo
  ```

- oh-my-posh

  ```powershell
  choco install -y oh-my-posh
  ```

## Create symbolic links use the following statements:

For Parallels

```bash
ln -sf ~/.dotfiles/PowerShell/Microsoft.PowerShell_profile.ps1 ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1
ln -sf ~/.dotfiles/PowerShell/robbyrussel.omp.json ~/Documents/PowerShell/robbyrussel.omp.json
```

```powershell

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

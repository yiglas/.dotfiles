# MacOS config changes

## Tools

- homebrew: <https://brew.sh/>

- iterm2

  ```bash
  brew install --cask iterm2
  # Specify the preferences directory
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/.dotfiles/iTerm"
  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
  ```

- ghostty

  ```bash
  brew install --cask ghostty
  ```

- brave

  ```bash
  brew install --cask brave-browser
  ```

- arc

  ```bash
  brew install --cask arc
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
  yarn set version stable
  ```

- finicky

  ```bash
  brew install --cask finicky
  ```

- zsh - <https://ohmyz.sh/>

- docker

  ```bash
  brew install --cask docker
  ```

- vscode - <https://code.visualstudio.com/>

  ```bash
  brew install --cask visual-studio-code

  defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
  defaults write -g InitialKeyRepeat -int 10
  defaults write -g KeyRepeat -int 1
  ```

- itsycal - <https://www.mowglii.com/itsycal/>

  ```bash
  brew install --cask itsycal
  ```

- displaylink - <https://www.synaptics.com/products/displaylink-graphics>

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

- aws cli

  ```bash
  brew install awscli
  ```

- nordvpn

  ```bash
  brew install --cask nordvpn
  ```

- [folx](https://mac.eltima.com/download-manager.html)

  ```bash
  brew install --cask folx
  ```

- handbrake

  ```bash
  brew install --cask handbrake
  ```

- alt-tab

  ```bash
  brew install --cask alt-tab
  ```

  Configuration:

  **Peferences...** -> **Controls** -> change the hold key to **Command**

- [hiddenbar](https://github.com/dwarvesf/hidden/)

  ```bash
  brew install --cask hiddenbar
  ```

- things3 (app store)

- emacs

  ```bash
  brew tap d12frosted/emacs-plus
  brew install emacs-plus@29 --with-native-comp --with-no-frame-refocus --with-modern-sexy-v1-icon

  # To link the application to default Homebrew App location:
  ln -s /opt/homebrew/opt/emacs-plus@29/Emacs.app /Applications

  # To start d12frosted/emacs-plus/emacs-plus@29 now and restart at login:
  brew services start d12frosted/emacs-plus/emacs-plus@29
  ```

- doom emacs - <https://github.com/hlissner/doom-emacs>

- raycast

  ```bash
  brew install --cask raycast
  ```

- notion

  ```bash
  brew install --cask notion
  ```

- obsidian

  ```bash
  brew install --cask obsidian

  # setup Execute Code:
  npm install typescript -g
  npm install -g ts-node
  ```

- neovim

  ```bash
  brew install ripgrep
  brew install neovim
  brew install tmux
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ```

- chrome

  ```bash
  brew install --cask google-chrome
  ```

- babashka

  ```bash
  brew install borkdude/brew/babashka
  npm install nbb -g
  ```

- localstack

  ```bash
  brew install localstack/tap/localstack-cli
  npm install -g amplify-localstack
  amplify plugin add amplify-localstack
  ```

- Fonts

  ```bash
  brew tap homebrew/cask-fonts
  brew install font-meslo-lg-nerd-font
  ```

- Yo

  ```bash
  brew install yo
  npm install generator-code
  ```

## Create symbolic links use the following statements

```bash
ln -sf ~/.dotfiles/.doom.d ~/.doom.d
ln -sf ~/.dotfiles/.emacs.d ~/.emacs.d
ln -sf ~/.dotfiles/.vimrc ~/.vimrc
ln -sf ~/.dotfiles/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/.npmrc ~/.npmrc
ln -sf ~/.dotfiles/.zprofile ~/.zprofile
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.oh-my-zsh/themes/robbyrussell.zsh-theme ~/.oh-my-zsh/themes/robbyrussell.zsh-theme
ln -sf ~/.dotfiles/.finicky.js ~/.finicky.js
ln -sf ~/.dotfiles/nvim ~/.config/nvim
ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
```

## Add VSCode's `code` to the path

1. inside vscode
2. open command palette
3. run: `Shell Command: Install ‘code’ command in PATH`

## Install custom fonts

```bash
./install-fonts.sh
```

## Finder

1. Open Finder
2. Under the View menu
   - Show Path Bar
   - Show Status Bar

## Enable function keys

1. Go to _System Preferences_ → _Keyboard_.
2. Select: _Touch Bar shows_ **F1, F2, etc. Keys**
3. Check: _Use F1, F2, etc..._
4. Switch to the _Shortcuts_ tab
   - Set: **Shortcuts** → **Launchpad & Dock** → **Show Launchpad** → **F4**
   - Set: **Shortcuts** → **Mission Control** → **Mission Control** → **F3**
   - Set: **Shortcuts** → **Mission Control** → **Show Desktop** → **^F11**

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

# MacOS config changes

## Tools:

- homebrew: https://brew.sh/
- git

  ```bash
  brew install git
  ```

- brave - https://brave.com/

  ```bash
  brew install --cask brave-browser
  ```

- finicky - https://github.com/johnste/finicky

  ```bash
  brew install --cask finicky
  ```

- zsh - https://ohmyz.sh/

- docker

  ```bash
  brew install docker
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

- clean my mac

  ```bash
  brew install --cask cleanmymac
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

check the option found: _System Preferences_ -> _Keyboard_ -> _Use F1, F2, etc..._

then set:

**Shortcuts** -> **Launchpad & Dock** -> **Show Launchpad** -> **F4**

**Shortcuts** -> **Mission Control** -> **Mission Control** -> **F3**

## Add startup items

1. Go to _System Preferences_ → _Users & Groups_.
2. Switch to the _Login Items_ tab
3. Add
   - Itsycal
   - DisplayLink Manager

## SSH

1. Generate ssh key:

```base
ssh-keygen -t rsa
```

2. Copy the contents of the id_rsa.pub file.
3. Add the pub fingerprint to the `.ssh/authorized_keys` file on the host machine.

## Setup react-native environment:

https://www.youtube.com/watch?v=MJEcookWYUI
https://medium.com/@davidjasonharding/developing-a-react-native-app-on-an-m1-mac-without-rosetta-29fcc7314d70

# Windows config changes

Note: these commands need elevated permissions.

```powershell
# disable clipboard history
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System\ /v AllowClipboardHistory /t REG_DWORD /d 0

# install scoop
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
iwr -useb get.scoop.sh | iex
```

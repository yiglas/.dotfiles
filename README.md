# MacOS config changes

Tools:

- git
- brave - https://brave.com/
- finicky - https://github.com/johnste/finicky
- zsh - https://ohmyz.sh/
- emacs
- doom emacs - https://github.com/hlissner/doom-emacs
- remote desktop (app store)
- homebrew - https://brew.sh/
- vscode - https://code.visualstudio.com/
- itsycal - https://www.mowglii.com/itsycal/
- displaylink - https://www.synaptics.com/products/displaylink-graphics
- xcode (app store)
- ssh

Create symbolic links use the following statements:

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

Add VSCode's `code` to the path:

1. inside vscode
2. open command palette
3. run: `Shell Command: Install ‘code’ command in PATH`

Install custom fonts:

```bash
./install-fonts.sh
```

Enable function keys

check the option found: _System Preferences_ -> _Keyboard_ -> _Use F1, F2, etc..._

then set:

Shortcuts -> Launchpad & Dock -> Show Launchpad -> F4
Shortcuts -> Mission Control -> Mission Control -> F3

### SSH

1. Generate ssh key:

```base
ssh-keygen -t rsa
```

2. Copy the contents of the id_rsa.pub file.
3. Add the pub fingerprint to the `.ssh/authorized_keys` file on the host machine.

# Windows config changes

Note: these commands need elevated permissions.

```powershell
# disable clipboard history
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System\ /v AllowClipboardHistory /t REG_DWORD /d 0

# install scoop
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
iwr -useb get.scoop.sh | iex
```

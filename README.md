# MacOS config changes

Tools:

- git
- brave - https://brave.com/
- finicky - https://github.com/johnste/finicky
- zsh - https://ohmyz.sh/
- doom emacs - https://github.com/hlissner/doom-emacs
- homebrew - https://brew.sh/
- vscode - https://code.visualstudio.com/
- itsycal - https://www.mowglii.com/itsycal/
- displaylink - https://www.synaptics.com/products/displaylink-graphics

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

# Windows config changes

Note: these commands need elevated permissions.

```powershell
# disable clipboard history
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System\ /v AllowClipboardHistory /t REG_DWORD /d 0

# install scoop
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
iwr -useb get.scoop.sh | iex
```

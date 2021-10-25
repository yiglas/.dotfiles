# MacOS config changes

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

# Windows config changes

Note: these commands need elevated permissions.

```powershell
# disable clipboard history
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System\ /v AllowClipboardHistory /t REG_DWORD /d 0

# install scoop
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
iwr -useb get.scoop.sh | iex

```

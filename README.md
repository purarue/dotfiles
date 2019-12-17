# dotfiles

- zsh, [antigen](https://github.com/zsh-users/antigen) for autocompletion/highlighting
- [i3-gaps](https://github.com/Airblader/i3) - window manager
- [yadm](https://yadm.io) to manage dotfiles
- [termite](https://github.com/thestinger/termite) for terminal
- [picom ](https://github.com/yshui/picom) for window compositing
- [firefox-developer-edition](https://www.archlinux.org/packages/community/x86_64/firefox-developer-edition/)
- [rofi](https://github.com/davatorium/rofi) (launcher) with [solarized-darker](https://github.com/davatorium/rofi-themes/blob/master/User%20Themes/solarized-darker.rasi)
- [nvim](https://neovim.io/) as editor
- [i3lock-fancy](https://github.com/meskarune/i3lock-fancy) for screen locking
- [dunst](https://dunst-project.org/) for notificaitons
- [i3blocks](https://github.com/vivien/i3blocks) for status bar
- [lightdm](https://wiki.archlinux.org/index.php/LightDM) - display manager
- [todotxt](http://todotxt.org/) for todos

[.config/yadm](./.config/yadm) includes lists of packages for pacman/yay, python, and npm.

Packages can be added to the `.txt` files manually, and then `yadm bootstrap` can be run repeatedely to make sure everything is installed.

- [.scripts/bin](.scripts/bin) - generic scripts
- [.scripts/system](.scripts/system) - i3 related scripts
- [.config/shortcuts.conf](.config/shortcuts.conf) - describes basic shell scripts that are created by [shortcuts](https://github.com/seanbreckenridge/shortcuts)

### Install

    yadm clone https://github.com/seanbreckenridge/dotfiles
    yadm bootstrap

#### LICENSE

Unless where attributed, any customization and scripts are licensed under the MIT License:

```
MIT License

Copyright (c) 2019 Sean Breckenridge

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

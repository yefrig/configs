# configs

Config files are managed with [GNU Stow](https://www.gnu.org/software/stow/). To symlink a group of configs use:

```
> stow -Sv <group>
```

## tools

- [neovim](https://neovim.io/)
- [gcc](https://gcc.gnu.org/) for Tressitter
- [ripgrep](https://github.com/BurntSushi/ripgrep) for fast grep
- [node](https://nodejs.org/en) for installing language servers in neovim
- [fish shell](https://fishshell.com/)
- [starship prompt](https://starship.rs/)
- [stow](https://www.gnu.org/software/stow/manual/stow.html) for symlinking configs
- [fzf](https://github.com/junegunn/fzf) for fuzzy searching
- [fd](https://github.com/sharkdp/fd) for finding files
- [delta](https://github.com/dandavison/delta) for diffing
- [wezterm](https://wezfurlong.org/wezterm/) for terminal emulation

## Installation order

(depending on your package manager of choice)

- wezterm
```fish
sudo dnf copr enable wezfurlong/wezterm-nightly
sudo dnf install wezterm
```
- fish
```fish
sudo dnf install fish
sudo chsh -s $(which fish)
```
- neovim
```fish
sudo dnf install neovim
```
- starship
```fish
curl -sS https://starship.rs/install.sh | sh
```
- fzf
```fish
sudo dnf install fzf
```
- stow
```
sudo dnf install stow
```
- delta
```
sudo dnf install git-delta
```

# Welcome to my dotfiles!
This repository contains the entire configuration for my linux environment. This includes the programs I use, my desktop NixOS install, and for my programming work (mostly Neovim configuration).

This is not optimized at all to be viewed by other people. Its just my source controlled configs! But its free for you to peruse if youd like inspiration or ideas with using Nix.

## Packages
There are a few programs I've packaged for my own use. They mostly are just downloading binaries from Github repos. Most of these I dont actively use, so they are not guaranteed up to date.

If you need them yourself for NixOS reasons, or just want a starting point on how you maybe can create your own packages, check out the `packages` folder :)

The packages are included as outputs in my flake, so you can run them directly. The package name should mirror the file name.

You can run without installing like this
```
nix run github:Sheemap/.dotfiles#pants
```

If you need help with these packages, feel free to reach out. Though I make no promises.

## Formatting
This repo includes a formatter, using treefmt

Run `nix fmt` to apply the changes

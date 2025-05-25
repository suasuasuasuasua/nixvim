# `nixvim`

My personal `neovim` (powered by standalone `nixvim`) distribution (kind of but
not really).

<!-- NOTE: update with images as larger changes come through -->
![setup 25-05-2025.png](./assets/img/setup_25-05-2025.png)

## Testing your new configuration

To test your configuration simply run the following command

```nix
nix run .
```

To verify if the `nixvim` configuration is correct beforehand:

```nix
nix flake check
```

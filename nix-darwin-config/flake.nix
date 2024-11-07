# ❯ darwin-rebuild switch --flake ~/.dotfiles/nix-darwin-config
{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile
      environment.systemPackages =
        [ pkgs.vim
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;

      # Configure Nix settings
      nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        extra-platforms = [ "x86_64-darwin" "aarch64-darwin" ];
        trusted-users = [ "root" ];
        extra-substituters = [ "https://cache.nixos.org/" ];
        builders-use-substitutes = true;
      };

      # Enable Linux builder
      nix.linux-builder = {
        enable = true;
        ephemeral = true;
      };

      nix.linux-builder.package = pkgs.darwin.linux-builder;

      # Set Git commit hash for darwin-version
      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 5;

      # The platform the configuration will be used on
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."Philips-MacBook-Pro-2" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";  # Explicitly set system architecture
      modules = [ configuration ];
    };

    darwinPackages = self.darwinConfigurations."Philips-MacBook-Pro-2".pkgs;
  };
}

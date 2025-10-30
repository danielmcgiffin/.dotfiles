{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dms-cli = {
      url = "github:AvengeMedia/danklinux";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.dgop.follows = "dgop";
      inputs.dms-cli.follows = "dms-cli";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    nixpkgs = inputs.nixpkgs-unstable;
    
    # Supported systems for your flake packages, shell, etc.
    systems = [
      # "aarch64-linux"
      # "i686-linux"
      "x86_64-linux"
      # "aarch64-darwin"
      # "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in rec {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    # Development shells with reproducible toolchains
    devShells = forAllSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        qstrShell = pkgs.mkShell {
          packages = [
            pkgs.nodejs_22
            pkgs.postgresql_17
          ];
          shellHook = ''
            export PGDATA="''${PGDATA:-$HOME/.local/share/postgres/qstr}"
            export PGHOST="''${PGHOST:-$HOME/.local/share/postgres/run}"
            export PGPORT="''${PGPORT:-4444}"

            mkdir -p "$PGHOST"
            mkdir -p "$PGDATA"

            if [ ! -s "$PGDATA/PG_VERSION" ]; then
              echo "[qstr-db] Initializing new Postgres data dir at $PGDATA"
              initdb -D "$PGDATA"
            fi

            alias start-qstr-db='pg_ctl -D "$PGDATA" -o "-p $PGPORT -k $PGHOST" start'
            alias stop-qstr-db='pg_ctl -D "$PGDATA" stop'
            alias status-qstr-db='pg_ctl -D "$PGDATA" status'

            if [ -z "$SKIP_QSTR_DB_AUTOSTART" ]; then
              if ! pg_ctl -D "$PGDATA" status >/dev/null 2>&1; then
                rm -f "$PGHOST/.s.PGSQL.''${PGPORT}"
                pg_ctl -D "$PGDATA" -o "-p $PGPORT -k $PGHOST" start >/tmp/qstr-db.log 2>&1
                if pg_ctl -D "$PGDATA" status >/dev/null 2>&1; then
                  echo "[qstr-db] Postgres listening on socket dir $PGHOST port $PGPORT (log: /tmp/qstr-db.log)"
                else
                  echo "[qstr-db] Failed to start Postgres; see /tmp/qstr-db.log"
                fi
              fi
            fi
          '';
        };
      in {
        default = qstrShell;
        qstr = qstrShell;
      });
    qstr = devShells.${builtins.currentSystem}.qstr;

    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      noxbox = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          # > Our main nixos configuration file <
          ./nixos/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "epicus@noxbox" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          # > Our main home-manager configuration file <
          ./home-manager/home.nix
        ];
      };
    };
  };
}

{
    inputs = {
        nixpkgs.url = github:nixos/nixpkgs/23.11;
        levers = {
            url = "github:kquick/nix-levers";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        dronecan_DSDL-src = {
          url = "github:DroneCAN/DSDL";
          flake = false;
        };
        pydronecan-src = {
          url = "github:DroneCAN/pydronecan";
          flake = false;
        };
    };

    outputs = { self, nixpkgs, levers
              , dronecan_DSDL-src
              , pydronecan-src
              }:
    {
      packages = levers.eachSystem (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = self.packages.${system}.pydronecan;

          pydronecan = pkgs.python3Packages.buildPythonPackage rec {
              name = "pydronecan";
              src = pydronecan-src;
              preConfigure = ''
                ln -s ${dronecan_DSDL-src} dronecan/dsdl_specs
              '';
              propagatedBuildInputs = [

              ];
              doCheck = false;
          };

          dsdl = dronecan_DSDL-src;
        });
    };

}

{
  description = "A flake for my wyfy.dev dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    blowfish-tool = {
      url ="github:nunocoracao/blowfish";
      flake = false;
    };
  };
  outputs = {}:
    utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpgs {
            inherit system;
          };
        in
        {
          
        })
}

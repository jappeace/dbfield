{ pkgs ? (
   let 
    hostPkgs = import <nixpkgs> {};
    pinnedPkgs = hostPkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs-channels";
      # nixos-unstable as of 29.12.2018 
      rev = "76aafbf4bf4992c82da41ccefd8c6d481744524c";
      sha256 = "1xz8249i9yag4sxfzd5lkhqsyg7n6h3n2klb1cqqmcsav87f6x65";
    };
  in
  import pinnedPkgs {}
 )
}:
let 
    build = pkgs.haskellPackages.callPackage ./default.nix { };
in 
pkgs.stdenv.mkDerivation {
  name = "db-field";
  buildInputs = [
    pkgs.haskellPackages.hpack
    pkgs.cabal-install
    pkgs.ghc
    pkgs.postgresql
  ] ++ build.buildInputs;
    
}

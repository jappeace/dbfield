{ mkDerivation, base, hpack, lens, network-uri, stdenv }:
mkDerivation {
  pname = "network-uri-lenses";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ base lens network-uri ];
  libraryToolDepends = [ hpack ];
  preConfigure = "hpack";
  homepage = "https://github.com/jappeace/network-uri-lenses#readme";
  license = stdenv.lib.licenses.bsd3;
}

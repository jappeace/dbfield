{ mkDerivation, base, beam-core, beam-migrate, hpack, lens
, postgresql-simple, stdenv
}:
mkDerivation {
  pname = "dbfield";
  version = "0.2.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base beam-core beam-migrate lens postgresql-simple
  ];
  libraryToolDepends = [ hpack ];
  preConfigure = "hpack";
  homepage = "https://github.com/jappeace/dbfield#readme";
  description = "A newtype for wrapping newtypes into beam schemas";
  license = stdenv.lib.licenses.bsd3;
}

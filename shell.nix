{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, array, base, binary, bytestring, Cabal
      , containers, extensible-exceptions, filepath, ghc-prim, HaXml
      , HUnit, mtl, QuickCheck, regex-compat, stdenv
      }:
      mkDerivation {
        pname = "encoding";
        version = "0.8.2";
        src = ./.;
        setupHaskellDepends = [
          base Cabal containers filepath ghc-prim HaXml
        ];
        libraryHaskellDepends = [
          array base binary bytestring containers extensible-exceptions
          ghc-prim mtl regex-compat
        ];
        testHaskellDepends = [ base bytestring HUnit QuickCheck ];
        homepage = "http://code.haskell.org/encoding/";
        description = "A library for various character encodings";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv

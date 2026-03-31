{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module PackageInfo_rca (
    name,
    version,
    synopsis,
    copyright,
    homepage,
  ) where

import Data.Version (Version(..))
import Prelude

name :: String
name = "rca"
version :: Version
version = Version [0,1,0,0] []

synopsis :: String
synopsis = "Regulated Cell Architecture - Haskell Variant"
copyright :: String
copyright = ""
homepage :: String
homepage = ""

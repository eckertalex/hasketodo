{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_hasksite (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\ae\\Documents\\dev\\haskell-tests\\hasksite\\.stack-work\\install\\8c390635\\bin"
libdir     = "C:\\Users\\ae\\Documents\\dev\\haskell-tests\\hasksite\\.stack-work\\install\\8c390635\\lib\\x86_64-windows-ghc-8.4.3\\hasksite-0.1.0.0-61Xq1iHZXcp4vWUVh6EJbo-hasksite"
dynlibdir  = "C:\\Users\\ae\\Documents\\dev\\haskell-tests\\hasksite\\.stack-work\\install\\8c390635\\lib\\x86_64-windows-ghc-8.4.3"
datadir    = "C:\\Users\\ae\\Documents\\dev\\haskell-tests\\hasksite\\.stack-work\\install\\8c390635\\share\\x86_64-windows-ghc-8.4.3\\hasksite-0.1.0.0"
libexecdir = "C:\\Users\\ae\\Documents\\dev\\haskell-tests\\hasksite\\.stack-work\\install\\8c390635\\libexec\\x86_64-windows-ghc-8.4.3\\hasksite-0.1.0.0"
sysconfdir = "C:\\Users\\ae\\Documents\\dev\\haskell-tests\\hasksite\\.stack-work\\install\\8c390635\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "hasksite_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "hasksite_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "hasksite_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "hasksite_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "hasksite_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "hasksite_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)

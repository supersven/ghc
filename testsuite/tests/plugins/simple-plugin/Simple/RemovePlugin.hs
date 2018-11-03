{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
module Simple.RemovePlugin where

import Control.Monad.IO.Class
import Data.List (intercalate)
import Plugins
import Bag
import HscTypes
import TcRnTypes
import HsExtension
import HsExpr
import Outputable
import SrcLoc
import HsSyn
import HsBinds
import OccName
import RdrName
import Name
import Avail

plugin :: Plugin
plugin = defaultPlugin { parsedResultAction = parsedPlugin
                       , typeCheckResultAction = typecheckPlugin
                       , spliceRunAction = metaPlugin'
                       , interfaceLoadAction = interfaceLoadPlugin'
                       }

parsedPlugin :: [CommandLineOption] -> ModSummary -> HsParsedModule
                  -> Hsc HsParsedModule
parsedPlugin [name, "parse"] _ pm
  = return $ pm { hpm_module = removeParsedBinding name (hpm_module pm) }
parsedPlugin _ _ pm = return pm

removeParsedBinding :: String -> Located (HsModule GhcPs)
                         -> Located (HsModule GhcPs)
removeParsedBinding name (L l m)
  = (L l (m { hsmodDecls = filter (notNamedAs name) (hsmodDecls m) } ))
  where notNamedAs name (L _ (ValD _ (FunBind { fun_id = L _ fid })))
          = occNameString (rdrNameOcc fid) /= name
        notNamedAs _ _ = True

typecheckPlugin :: [CommandLineOption] -> ModSummary -> TcGblEnv -> TcM TcGblEnv
typecheckPlugin [name, "typecheck"] _ tc
  = return $ tc { tcg_exports = filter (availNotNamedAs name) (tcg_exports tc)
                , tcg_binds = filterBag (notNamedAs name) (tcg_binds tc)
                }
  where notNamedAs name (L _ FunBind { fun_id = L _ fid })
          = occNameString (getOccName fid) /= name
        notNamedAs name (L _ AbsBinds { abs_binds = bnds })
          = all (notNamedAs name) bnds
        notNamedAs _ (L _ b) = True
typecheckPlugin _ _ tc = return tc

metaPlugin' :: [CommandLineOption] -> LHsExpr GhcTc -> TcM (LHsExpr GhcTc)
metaPlugin' [name, "meta"] (L _ (HsApp noExt (L l (HsVar _ (L _ id))) e))
  | occNameString (getOccName id) == name
  = return e
metaPlugin' _ meta = return meta

interfaceLoadPlugin' :: [CommandLineOption] -> ModIface -> IfM lcl ModIface
interfaceLoadPlugin' [name, "interface"] iface
  = return $ iface { mi_exports = filter (availNotNamedAs name)
                                         (mi_exports iface)
                   }
interfaceLoadPlugin' _ iface = return iface

availNotNamedAs :: String -> AvailInfo -> Bool
availNotNamedAs name avail
  = occNameString (getOccName (availName avail)) /= name

module Main where

import qualified Data.HashMap.Strict as M
import           System.IO
import           Control.Monad (foldM_)

main :: IO ()
main = do hSetBuffering stdout LineBuffering
          hSetBuffering stdin LineBuffering
          commands <- map words <$> lines <$> getContents
          foldM_ execute M.empty commands
  where execute map ["put", key, value] = return $ M.insert key value map
        execute map ["get", key] = do putStrLn $ M.lookupDefault "" key map
                                      return map
        execute map _ = return map

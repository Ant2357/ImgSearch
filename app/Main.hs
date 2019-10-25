{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.IORef
import Control.Monad
import Network.HTTP.Simple
import Data.Maybe
import Text.HTML.Scalpel
import qualified Data.ByteString.Lazy as L

main :: IO ()
main = do
  let url = "http://strimuer213p.hatenablog.com/"

  imageLinks <- scrapeURL url (attrs "src" "img")
  maybe (putStrLn "NG")
    (\imgs -> do
      -- todo: IORefの排除
      fileCnt <- newIORef 1

      forM_ imgs $ \imgLink -> do
        res <- httpLBS $ parseRequest_ imgLink

        fileCnt' <- readIORef fileCnt
        let saveFilePath = "./outputs/" ++ (show fileCnt') ++  ".png"
        L.writeFile (saveFilePath) (getResponseBody res)

        putStrLn $ "Save: " ++ saveFilePath
        modifyIORef fileCnt (+1)
    ) imageLinks

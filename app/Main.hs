{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.Directory
import Control.Monad
import Network.HTTP.Simple
import Data.Maybe
import Text.HTML.Scalpel
import qualified Data.ByteString.Lazy as L

main :: IO ()
main = do
  let url = "http://strimuer213p.hatenablog.com"

  imageLinks <- scrapeURL url (attrs "src" "img")
  maybe (putStrLn "NG")
    (\imgs -> do
      forM_ imgs $ \imgLink -> do
        fileCnt <- length <$> listDirectory "outputs"
        let saveFilePath = "./outputs/" ++ (show fileCnt) ++ ".png"

        res <- httpLBS $ parseRequest_ imgLink
        L.writeFile (saveFilePath) (getResponseBody res)
        putStrLn $ "Save: " ++ saveFilePath
    ) imageLinks

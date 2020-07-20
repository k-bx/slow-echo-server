{-# LANGUAGE OverloadedStrings #-}

module Lib where

import qualified Control.Concurrent
import Control.Monad.IO.Class
import Data.Monoid (mconcat)
import Web.Scotty
import qualified Data.String.Class as S
import qualified Network.Wai

webapp :: IO ()
webapp = do
  liftIO $ putStrLn "> launching..."
  scotty 5001 $ do
    get "/" $ do
      req <- request
      hs <- headers
      let pathInfo = S.toString (Network.Wai.rawPathInfo req) ++ S.toString (Network.Wai.rawQueryString req) 
      liftIO $ putStrLn $ "> GET " ++ pathInfo ++ " headers: " ++ show hs
      liftIO $ putStrLn $ "> GET " ++ pathInfo ++ " waiting for 2 secs"
      liftIO $ Control.Concurrent.threadDelay (2 * 1000000)
      liftIO $ putStrLn $ "> GET " ++ pathInfo ++ " done waiting"
      html $ mconcat ["hey there"]
    get "/:word" $ do
      beam <- param "word"
      html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]

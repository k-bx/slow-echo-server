{-# LANGUAGE OverloadedStrings #-}

module Lib where

import qualified Control.Concurrent
import Control.Monad.IO.Class
import Data.Monoid (mconcat)
import Web.Scotty

webapp :: IO ()
webapp = scotty 5001 $ do
  get "/" $ do
    hs <- headers
    liftIO $ putStrLn $ "> GET / headers: " ++ show hs
    liftIO $ putStrLn "> GET / waiting for 2 secs"
    liftIO $ Control.Concurrent.threadDelay (2 * 1000000)
    liftIO $ putStrLn "> GET / done waiting"
    html $ mconcat ["hey there"]
  get "/:word" $ do
    beam <- param "word"
    html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]

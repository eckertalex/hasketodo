{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE TypeSynonymInstances       #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# OPTIONS_GHC -fno-warn-orphans       #-}

import qualified Web.Scotty as S
import qualified Text.Blaze.Html5 as H hiding (map, main)
import qualified Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Text
import Database.Persist
import Database.Persist.Sqlite
import Database.Persist.TH
import Data.Text (Text)
import Data.Time (UTCTime, getCurrentTime)
import qualified Data.Text as T
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Resource (runResourceT, ResourceT)
import Database.Persist.Sql
import Control.Monad (forM_)
import Control.Applicative
import Control.Monad.Logger
import Network.Wai.Middleware.RequestLogger

import Model

runDb :: SqlPersistT (ResourceT (NoLoggingT IO)) a -> IO a
runDb = runNoLoggingT 
      . runResourceT 
      . withSqliteConn "dev.sqlite3" 
      . runSqlConn

readPosts :: IO [Entity Post]
readPosts = (runDb $ selectList [] [LimitTo 10])

blaze = S.html . renderHtml

routes :: S.ScottyM ()
routes = do
  S.get "/" $ do
    _posts <- liftIO readPosts
    let posts = map (postTitle . entityVal) _posts
    blaze $ do
      H.html $ do
        H.body $ do
          H.h1 "My Todo App in Haskell"
          H.ul $ do
            forM_ posts $ \post -> H.li (H.toHtml post)
  S.get "/create/:title" $ do
    _title <- S.param "title"
    now <- liftIO getCurrentTime
    liftIO $ runDb $ insert $ Post _title now
    S.redirect "/"

main :: IO ()
main = do
  putStrLn "Starting Server..."
  runDb $ runMigration migrateAll
  S.scotty 3000 $ do
    routes
    S.middleware logStdoutDev
  
module Main where

import Control.Concurrent
import Control.Monad
import Data.ByteString.Builder (lazyByteString)
import Data.ByteString.Lazy as BL
import qualified Data.ByteString.Lazy.Char8 as C
import Data.List.Split as S
import Data.Text.Lazy as TL
import Network.Wai
import System.Environment
import System.IO
import Web.Scotty

frameSize = 30

streaming :: StreamingBody
streaming write flush = do
  h <- openFile "frames/frames.txt" ReadMode
  contents <- C.hGetContents h
  let loop (frame:frames) = do
        write $ lazyByteString $ C.unlines frame
        flush
        write $ lazyByteString "\ESC[2J\ESC[H"
        threadDelay (41 * 1000)
        eof <- hIsEOF h
        unless eof $ loop frames
  loop $ S.chunksOf frameSize $ C.lines contents

main :: IO ()
main = do
  port <- read <$> getEnv "PORT"
  scotty port $ do
    get "/" $ do
      ua <- header "user-agent"
      case fmap (TL.isInfixOf "curl") ua of
        Just True -> stream streaming
        _ -> redirect "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

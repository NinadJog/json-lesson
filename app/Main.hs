{-
Lesson 40: Working with JSON data using Aeson from the Manning book,
"Get Programming with Haskell" by Will Kurt.

Reads a JSON file and parses the data into Haskell data types using Aeson.

Contains the following changes from the book version of the code:

1) In function printResults, remove the last line that says 'print dataName'.
   It is a typo (pg 521 of the book)

2) The datacoverage field in the NOAAResult should have type Float instead of Int

3) I added a function called printEitherResults, which is similar to printResults
   but takes an Either String [NOAAResult] instead of Maybe [NOAAResult].

4) I added the dependencies to the package.yaml file rather than the
json-lesson.cabal file because the .cabal file is auto-generated and gets
automatically overwritten while doing stack build.

Ninad Jog
September 15, 2021
-}
module Main where

import Data.Aeson
import Data.Text                  as T
import Data.ByteString.Lazy       as B
import Data.ByteString.Lazy.Char8 as BC
import GHC.Generics
import Control.Monad

--------
{-
datacoverage should have type Float. In the book there's a typo;
the book shows it as Int
-}
data NOAAResult = NOAAResult {
  uid           :: T.Text,
  mindate       :: T.Text,
  maxdate       :: T.Text,
  name          :: T.Text,
  datacoverage  :: Float, -- appears incorrectly as Int in the book
  resultId      :: T.Text
} deriving Show

-- We need a custom implementation of FromJSON because 
-- the 'id' field clashes with Haskell's id
instance FromJSON NOAAResult where
  parseJSON (Object v) =
    NOAAResult  <$> v .: "uid"
                <*> v .: "mindate"
                <*> v .: "maxdate"
                <*> v .: "name"
                <*> v .: "datacoverage"
                <*> v .: "id"

--------
data ResultSet = ResultSet {
  count   :: Int,
  limit   :: Int,
  offset  :: Int
} deriving (Show, Generic)

instance FromJSON ResultSet

--------
data Metadata = Metadata {
  resultset :: ResultSet
} deriving (Show, Generic)

instance FromJSON Metadata

--------
data NOAAResponse = NOAAResponse {
  metadata  :: Metadata
, results   :: [NOAAResult]
} deriving (Show, Generic)

instance FromJSON NOAAResponse

--------
-- Print the results
-- Original function from the book
printResults :: Maybe [NOAAResult] -> IO ()
printResults Nothing = print "Error loading data"
printResults (Just results) = do
  forM_ results (print . name)

--------
-- Print the results
-- Same as the printResults function, but takes an Either
printEitherResults :: Either String [NOAAResult] -> IO ()
printEitherResults (Left message) = print message
printEitherResults (Right results) = do
  forM_ results (print . name)

--------
{-
Read the JSON file and parse it into the Haskell data types.
The original code from the book used the decode function, whereas
here we use eitherDecode
-}
processNoaaData :: IO ()
processNoaaData = do
  jsonData <- B.readFile "data/data.json"
  let noaaResponse  = eitherDecode jsonData :: Either String NOAAResponse
  -- The following line is the original line from the book
  -- let noaaResponse  = decode jsonData :: Maybe NOAAResponse
  -- print noaaResponse -- Just for debugging
  let noaaResults   = results <$> noaaResponse
  printEitherResults noaaResults

--------
main :: IO ()
main = processNoaaData

--------
{-
Output from running this program

"Daily Summaries"
"Global Summary of the Month"
"Global Summary of the Year"
"Weather Radar (Level II)"
"Weather Radar (Level III)"
"Normals Annual/Seasonal"
"Normals Daily"
"Normals Hourly"
"Normals Monthly"
"Precipitation 15 Minute"
"Precipitation Hourly"
-}
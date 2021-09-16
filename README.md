# json-lesson

Reads a JSON file and parses the data into Haskell data types using Aeson.

Based upon Lesson 40: _Working with JSON Data by Using Aeson_ from the Manning book,
**Get Programming with Haskell** by Will Kurt.

Contains the following changes from the book's code.

1. In function `printResults`, remove the last line that says `print dataName`.
   It is a typo (page 521 of the book)

1. The `datacoverage` field of `NOAAResult` should have type `Float` instead of `Int`

1. I added a function called `printEitherResults`, which is similar to `printResults`
   but takes an `Either String [NOAAResult]` instead of `Maybe [NOAAResult]`.

1. I added the dependencies to the package.yaml file rather than the
json-lesson.cabal file because the .cabal file is auto-generated and gets
automatically overwritten while doing stack build.

## Output

Here's the output from running this program.

````
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
````
module Show where
import Prelude 
  ( Int, String, ($), IO, (>>), (>>=), (++) )
import Types
  ( Exercise ( ToDo, Done, Missed ), Exercises, Date( D ), HopefullySome( IndeedItIs, Nothing )
  , HopefullyExerciseName, ToStringForUser, toStringForUser , Strings, HeaderRow, Headers
  , ExerciseData( subjectName, exerciseNumber, exerciseName) )
import Renaming
  ( convertIntToString, glue, forEach, (>>>), printString, unwrapAnd, andThen )
import UsefulFunctions
  ( doSequentially )
import Data.List 
  ( intercalate )
import ExercisesFromFile
  ( getToDoExercises, getDoneExercises, getMissedExercises )
import UsefulForActions
  ( beautify, putTogether, printBeutified, sortChrono )
import Data.Function
  ( (&) )

showActions :: [IO ()]
showActions = ( printHeaderRow >> ) `forEach` [ showToDo, showDone, showMissed, showAll ]

printHeaderRow :: IO ()
printHeaderRow = printBeutified headerRow

showToDo :: IO ()
showToDo = showTitleGetDo "ToDo" getToDoExercises ( sortChrono >>> print )

showDone :: IO ()
showDone = showTitleGetDo "Done" getDoneExercises print

showMissed :: IO ()
showMissed = showTitleGetDo "Missed" getMissedExercises print

showAll :: IO ()
showAll = doSequentially [ showToDo, showDone, showMissed ]

type Title = String

showTitleGetDo :: Title -> IO Exercises -> (Exercises -> IO ()) -> IO ()
showTitleGetDo = \t g d->
  printBeutified t >>
  g >>= d

print :: Exercises -> IO ()
print = toStringForUser >>> printString

printEx :: Exercise -> IO ()
printEx = toStringForUser >>> printString

headerRow :: HeaderRow
headerRow = putTogether headerList

headerList :: Headers
headerList = [ "Subject", "Number", "Name", "Date" ]

instance ToStringForUser Exercises where
  toStringForUser = forEach ( toStringForUser >>> beautify) >>> glue 

instance ToStringForUser Exercise where
  toStringForUser = \case
    Done exerciseData -> putTogether $ exerciseDataToStrings exerciseData
    Missed exerciseData -> putTogether $ exerciseDataToStrings exerciseData
    ToDo exerciseData date -> putTogether $ exerciseDataToStrings exerciseData ++
      [ toStringForUser date ]

exerciseDataToStrings :: ExerciseData -> Strings
exerciseDataToStrings exerciseData =
  [ subjectName exerciseData, exerciseNumber exerciseData
  , toStringForUser $ exerciseName exerciseData ]

instance ToStringForUser HopefullyExerciseName where
  toStringForUser = \case
    IndeedItIs n -> n 
    Nothing -> "No Name"

instance ToStringForUser Date where
  toStringForUser ( D d m y ) = [ d, m, y ] & forEach toStringForUser & intercalate "/"

instance ToStringForUser Int  where
  toStringForUser = convertIntToString

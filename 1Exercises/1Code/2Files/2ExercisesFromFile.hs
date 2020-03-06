module ExercisesFromFile where
import Renaming        (unwrapAnd,wrap,unwrapped,forEach,andThen)
import Renaming        (readFromFile,printErrorMessage,printString)
import Renaming        (convertIntFromString)
import Renaming        (and,splitInLines,splitInWords)
import Types           (FromStringTo,toType,Date,Line)
import Types           (Exercises,HopefullyExerciseName)
import Types           (Exercise(..),HopefullySome(..))
import Prelude         (String,Int,IO,filter,Bool(..))
import FileManagement  (getCurrentDataKeeper,getVersion)
import Data.List.Split (splitOn)
import Data.Function   ((&))

-- exercises from file
getExercises =
 getVersion`unwrapAnd`\case
 "0"-> printString "Who you kiddin?"`andThen`wrap []
 _  ->
  getCurrentDataKeeper`unwrapAnd`readFromFile`unwrapAnd`
  (splitInLines`and`forEach toType`and`wrap)::IO Exercises

-- get To Do, Done, Missed
[getToDo,getDone,getMissed] = [get toDo,get done,get missed]
get = \x->getExercises`unwrapAnd`(filter x`and`wrap)
toDo   = \case ToDo _ _->True;_->False 
done   = \case Done _  ->True;_->False
missed = \case Missed _->True;_->False

-- toType for Exercise,HopefullyExerciseName,Date,Int
instance FromStringTo Exercise where
 toType = (
  splitOn ","`and`\case
   ["d",sub,exNum,exName]     ->
    Done   (sub,exNum,exName&toType)
   ["m",sub,exNum,exName]     ->
    Missed (sub,exNum,exName&toType)
   ["t",sub,exNum,exName,date]->
    ToDo   (sub,exNum,exName&toType) (date&toType)
   _                                                 ->
    printErrorMessage "Line To Exercise")::Line->Exercise

instance FromStringTo HopefullyExerciseName where
 toType = \case "_"->Nothing;exName->IndeedItIs exName

instance FromStringTo Date where
 toType = splitOn "/"`and`\case
  [d,m,y]->forEach toType [d,m,y]
  _      ->printErrorMessage "Date"

instance FromStringTo Int where
 toType = convertIntFromString
module Actions.Delete where

import Prelude   
  ( IO, (>>=) )
import Types
  ( Exercises, ExerciseType( ToDoEx, DoneEx, OtherEx ) )
import Helpers
  ( removeChosen )
import Helpers2
  ( exsAfter )
import VeryUseful.Renaming
  ( wrap, (.>) )
import Actions.UsefulForActions
  ( exsToFileAndUpdate )
import Actions.ShowExercises
  ( getChosen )
import Control.Monad
  ( (>=>) )

deleteActions :: [ IO () ]
deleteActions = [ delete ToDoEx, delete DoneEx, delete OtherEx ]

delete :: ExerciseType -> IO ()
delete = exsAfter deleteChosen >=> exsToFileAndUpdate

deleteChosen :: Exercises -> IO Exercises
deleteChosen = getChosen >=> ( removeChosen .> wrap )

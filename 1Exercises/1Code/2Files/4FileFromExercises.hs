{-# LANGUAGE LambdaCase,FlexibleInstances #-} 
module FileFromExercises where
import Prelude  (String,Int)
import Renaming (forEach,and,glue,convertIntToString)
import Types    (StringVersionOf,Date,toString)
import Types    (HopefullySome(..),Exercise(..))
import Types    (HopefullyExerciseName,Line,Exercises)

exercisesToString = forEach convertToLine`and`glue::Exercises->String
convertToLine = (\case
 Done   (n,nu,e)   ->
  glue ["d ",n," ",nu," ",toString e,"\n"]
 Missed (n,nu,e)   ->
  glue ["m ",n," ",nu," ",toString e,"\n"]
 ToDo   (n,nu,e) da->
  glue ["t ",n," ",nu," ",toString e," ",toString da,"\n"]
 )::Exercise->Line

instance StringVersionOf HopefullyExerciseName where
 toString = \case
  Nothing     ->"_"
  IndeedItIs e->e 
instance StringVersionOf Date where
 toString = \(d,m,y)->
  glue [toString d,"/",toString m,"/",toString y]
instance StringVersionOf Int where toString = convertIntToString

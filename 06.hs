import           System.Environment (getArgs)
import           Data.Set (Set, fromList, unions, intersection)
import           Data.List.Split (splitWhen)

intersections :: Ord a => [Set a] -> Set a
intersections (s:ss) = foldl intersection s ss

main :: IO ()
main = do [_, part, file] <- getArgs
          setss <- map (map fromList) . splitWhen (== "") . lines <$> readFile file
          let oper = if part == "1" then unions else intersections
          print . sum $ map (length . oper) setss

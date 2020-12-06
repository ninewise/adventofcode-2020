import           System.Environment (getArgs)
import           Data.Set (Set, fromList, unions, intersection)
import           Data.List.Split (splitWhen)

intersections :: Ord a => [Set a] -> Set a
intersections = foldl1 intersection

main :: IO ()
main = do [_, part, file] <- getArgs
          setss <- map (map fromList) . splitWhen (== "") . lines <$> readFile file
          let oper = if part == "1" then unions else intersections
          print . sum $ map (length . oper) setss

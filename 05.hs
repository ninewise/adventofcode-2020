import           Parser
import           System.Environment (getArgs)
import           Data.List (sort, find)
import           Data.Maybe (fromJust)

seat :: Parser Int
seat = binToDec (`elem` "RB") <$> (plus (spot (/= '\n')) <* star (token '\n'))

binToDec :: (a -> Bool) -> [a] -> Int
binToDec p = foldl (\a c -> if p c then a * 2 + 1 else a * 2) 0

part1 :: [Int] -> IO ()
part1 = print . maximum

part2 :: [Int] -> IO ()
part2 = print . missing . sort
  where missing (l:ls) = (+1) . fst . fromJust . find (\(p,n) -> p + 1 /= n) $ zip (l:ls) ls

main :: IO ()
main = do [_, part, file] <- getArgs
          numbers <- parse' (star seat) <$> readFile file
          case part of "1" -> part1 numbers
                       "2" -> part2 numbers

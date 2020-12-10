import           System.Environment (getArgs)
import           Data.List (sort)
import           Utils (count)

main :: IO ()
main = do [_, part, file] <- getArgs
          sorted <- (0:) . sort . map read . lines <$> readFile file
          print $ (if part == "1" then part1 else part2) sorted

part1 :: [Int] -> Int
part1 (l:ls) = let diffs = zipWith (-) ls (l:ls)
                in (count (==1) diffs) * (count (==3) diffs + 1)

part2 :: [Int] -> Int
part2 = (!! 2) . foldl go [1, 0, 0] . present
  where go [n3, n2, n1] b = [n2, n1, b * (n3 + n2 + n1)]

present :: [Int] -> [Int]
present = go 0
  where
    go n [] = []
    go n (r:rs) | n < r = 0 : go (n + 1) (r:rs)
                | otherwise = 1 : go (n + 1) rs

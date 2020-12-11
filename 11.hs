import           Data.Char (isLower)
import           Parser
import           System.Environment (getArgs)
import           Utils (count)
import           Control.Monad (guard, join)
import           Data.List (find)
import           Data.Maybe (maybeToList, mapMaybe)
import qualified Data.Map as M
import qualified Data.Vector as V

type R = Int
type C = Int

type Grid = V.Vector (V.Vector Char)

create :: [[Char]] -> Grid
create = V.fromList . map V.fromList

get :: Grid -> R -> C -> Maybe Char
get g r c = return g >>= (V.!? r) >>= (V.!? c)

chars :: Grid -> [Char]
chars = V.toList . V.concat . V.toList

mapWithIndex :: (Grid -> R -> C -> Char -> Char) -> Grid -> Grid
mapWithIndex f g = V.imap (\r -> V.imap (\c -> f g r c)) g

-- type Grid = M.Map (R, C) Char
-- 
-- create :: [[Char]] -> Grid
-- create grid = M.fromList [ ((r, c), chr) | (r, row) <- zip [0..] grid
--                                          , (c, chr) <- zip [0..] row ]
-- 
-- get :: Grid -> R -> C -> Maybe Char
-- get grid r c = M.lookup (r, c) grid
-- 
-- chars :: Grid -> [Char]
-- chars = M.elems
-- 
-- mapWithIndex :: (Grid -> R -> C -> Char -> Char) -> Grid -> Grid
-- mapWithIndex f g = M.mapWithKey (uncurry $ f g) g

type Condition = Grid -> R -> C -> (Bool, Bool)

main :: IO ()
main = do [_, part, file] <- getArgs
          grid <- create . lines <$> readFile file
          let condition = if part == "1" then condition1 else condition2
              grids = iterate (step condition) grid
          print $ count (== '#') . chars . fst <$> find (uncurry (==)) (zip grids (drop 1 grids))

step :: Condition -> Grid -> Grid
step condition = mapWithIndex (live condition)

live :: Condition -> Grid -> R -> C -> Char -> Char
live condition grid r c 'L' | fst (condition grid r c)  =  '#'
live condition grid r c '#' | snd (condition grid r c)  =  'L'
live condition grid r c any                             =  any

condition1 :: Condition
condition1 grid r c = (occupied grid r c == 0, occupied grid r c >= 4)

occupied :: Grid -> R -> C -> Int
occupied grid r c = count (== '#') $ do
  r' <- [-1..1]
  c' <- [-1..1]
  guard $ (r', c') /= (0, 0)
  maybeToList $ get grid (r + r') (c + c')

condition2 :: Condition
condition2 grid r c = (see grid r c == 0, see grid r c >= 5)

see :: Grid -> R -> C -> Int
see grid r c = count (== Just '#') $ do
  r' <- [-1..1]
  c' <- [-1..1]
  guard $ (r', c') /= (0, 0)
  return . join . find (/= Just '.') $ map (\i -> get grid (r + r' * i) (c + c' * i)) [1..]

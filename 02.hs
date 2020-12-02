import           Data.Char (isLower)
import           Parser

data Desc = Desc Int Int Char String

password :: Parser Desc
password = Desc <$> (nat <* token '-')
                <*> (nat <* token ' ')
                <*> (char <* string ": ")
                <*> (star (spot isLower) <* star (token '\n'))

main :: IO ()
main = print . length . filter check1 . parse' (star password) =<< readFile "02-input"

check1 :: Desc -> Bool
check1 (Desc f s l p) = let n = length $ filter (== l) p
                         in f <= n && n <= s

check2 :: Desc -> Bool
check2 (Desc f s l p) = (p !! (f - 1) == l) /= (p !! (s - 1) == l)

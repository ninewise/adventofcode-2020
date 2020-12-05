import           Data.Char (isLower)
import           Parser
import           System.Environment (getArgs)

data Desc = Desc Int Int Char String

password :: Parser Desc
password = Desc <$> (nat <* token '-')
                <*> (nat <* token ' ')
                <*> (char <* string ": ")
                <*> (star (spot isLower) <* star (token '\n'))

main :: IO ()
main = do [_, part, file] <- getArgs
          let check = if part == "1" then check1 else check2
          print . length . filter check . parse' (star password) =<< readFile file

check1 :: Desc -> Bool
check1 (Desc f s l p) = let n = length $ filter (== l) p
                         in f <= n && n <= s

check2 :: Desc -> Bool
check2 (Desc f s l p) = (p !! (f - 1) == l) /= (p !! (s - 1) == l)

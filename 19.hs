import           Control.Applicative ((<|>))
import           Data.Char (isAlpha)
import           Data.Either (lefts)
import           Parser
import           System.Environment (getArgs)
import qualified Data.Map.Strict as M
import           Control.Monad (guard)

data RefRule = RefLeaf String | RefAlternative RefRule RefRule | RefSequence [Int]
          deriving Show

rule :: Parser (Int, RefRule)
rule = (,) <$> line <*> ((leaf <|> alternative <|> sequence) <* newline)
  where leaf = RefLeaf <$> (token '"' *> plus (spot (/= '"')) <* token '"')
        alternative = RefAlternative <$> sequence <*> (string " | " *> sequence)
        sequence = RefSequence <$> (nat `sepBy` space)
        line = nat <* string ": "

validMessages :: Parser String -> Parser [String]
validMessages format = lefts <$> plus (choice (format <* newline) (plus (spot (/= '\n')) <* (newline <|> eof)))

resolve :: RefRule -> M.Map Int RefRule -> Parser String
resolve (RefLeaf s) rules = s <$ string s
resolve (RefAlternative r1 r2) rules = resolve r1 rules <|> resolve r2 rules
resolve (RefSequence is) rules = concat <$> (list $ map (\i -> resolve (rules M.! i) rules) is)

solution :: (M.Map Int RefRule -> M.Map Int RefRule) -> Parser Int
solution mod = do rules <- mod . M.fromList <$> plus rule <* newline
                  length <$> validMessages (resolve (rules M.! 0) rules)

main :: IO ()
main = do [_, part, file] <- getArgs
          let mod = if part == "1" then id else
                ( M.insert 8 (RefAlternative (RefSequence [42, 8]) (RefSequence [42]))
                . M.insert 11 (RefAlternative (RefSequence [42, 31]) (RefSequence [42, 11, 31]))
                )
          count <- parse' (solution mod) <$> readFile file
          print count
          -- let parser = if part == "1" then part else expression2

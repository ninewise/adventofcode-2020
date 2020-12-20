import           Parser
import           Prelude hiding (const)
import           System.Environment (getArgs)
import           Control.Applicative ((<|>))

data Expr = Const Int | Add Expr Expr | Mul Expr Expr
          deriving Show

const :: Parser Expr
const = Const <$> nat

expression1 :: Parser Expr
expression1 = foldl (\e (o, e') -> o e e') <$> single <*> star ((,) <$> operator <*> single)
  where single = const <|> parens expression1
        operator = (string " + " *> pure Add) <|> (string " * " *> pure Mul)

eval :: Expr -> Int
eval (Const x) = x
eval (Add x y) = eval x + eval y
eval (Mul x y) = eval x * eval y

expression2 :: Parser Expr
expression2 = mul
  where mul = Mul <$> add <*> (string " * " *> mul) <|> add
        add = Add <$> single <*> (string " + " *> add) <|> single
        single = const <|> parens expression2

main :: IO ()
main = do [_, part, file] <- getArgs
          let parser = if part == "1" then expression1 else expression2
          expressions <- parse' (plus $ parser <* star newline) <$> readFile file
          -- mapM_ (print . eval) expressions
          print . sum $ map eval expressions

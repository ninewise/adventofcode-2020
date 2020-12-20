module Parser where

import           Control.Applicative ((<|>), Alternative(..))
import           Data.Char (isDigit)
import           Data.Maybe (fromJust)
import           Data.List (find)

newtype Parser a = Parser { apply :: String -> [(a, String)] }

parse :: Parser a -> String -> Maybe a
parse p s = fmap fst $ find (null . snd) $ apply p s

parse' :: Parser a -> String -> a
parse' p = fromJust . parse p

instance Functor Parser where
  fmap f p = Parser $ \s -> fmap (\(x, s') -> (f x, s')) (apply p s)

instance Applicative Parser where 
  pure x  = Parser $ \s -> pure (x, s)
  f <*> x = Parser $ \s -> do (f', s') <- apply f s
                              (x', s'') <- apply x s'
                              return (f' x', s'')

instance Alternative Parser where
  empty   = Parser $ \s -> empty
  m <|> n = Parser $ \s -> apply m s <|> apply n s

instance Monad Parser where
  return = pure
  x >>= f = Parser $ \s -> do (x', s') <- apply x s
                              apply (f x') s'

instance MonadFail Parser where
  fail s = empty

eof :: Parser ()
eof = Parser $ \s -> if null s then pure ((), "")
                               else empty

ignore :: Parser a -> Parser ()
ignore p = p *> pure ()

spot :: (Char -> Bool) -> Parser Char
spot p = Parser $ \s -> case s of
  c:cs | p c -> pure (c, cs)
  _          -> empty

char :: Parser Char
char = spot (const True)

token :: Char -> Parser ()
token c = ignore $ spot (== c)

-- match zero or more occurrences
star :: Parser a -> Parser [a]
star p = plus p <|> pure []

-- match one or more occurrences
plus :: Parser a -> Parser [a]
plus p = (:) <$> p <*> star p

sepBy :: Parser a -> Parser b -> Parser [a]
sepBy a b = (:) <$> a <*> star (b *> a)

list :: [Parser a] -> Parser [a]
list [] = pure []
list (p:ps) = (:) <$> p <*> list ps

string :: String -> Parser ()
string = ignore . list . map token

-- match a natural number
nat :: Parser Int
nat = read <$> plus (spot isDigit)

-- match a negative number
neg :: Parser Int
neg = (0-) <$> (token '-' *> nat)

-- match an integer
int :: Parser Int
int = nat <|> neg

newline :: Parser ()
newline = ignore $ token '\n'

space :: Parser ()
space = ignore $ token ' '

between :: Parser a -> Parser b -> Parser c -> Parser c
between a b c = a *> c <* b

parens :: Parser a -> Parser a
parens = between (token '(') (token ')')

choice :: Parser a -> Parser b -> Parser (Either a b)
choice a b = (Left <$> a) <|> (Right <$> b)

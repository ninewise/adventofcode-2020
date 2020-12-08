{-# LANGUAGE TupleSections #-}
import           System.Environment (getArgs)
import           Parser
import           Data.Maybe (catMaybes)
import           Control.Applicative ((<|>), Alternative(..))
import           Control.Zipper (farthest)

-- Program
data Program = Program { acc :: Int
                       , prev :: [Instruction]
                       , next :: [Instruction]
                       } deriving Show

data Instruction = Acc { chk :: Bool, inc :: Int }
                 | Nop { chk :: Bool, inc :: Int }
                 | Jmp { chk :: Bool, inc :: Int }
                 deriving Show

ran :: Instruction -> Instruction
ran i = i { chk = not $ chk i }

step :: Program -> Maybe Program
step (Program acc ps (n:ns)) | chk n   = Nothing
step (Program acc ps (n@(Nop b i):ns)) = Just $ Program acc (ran n:ps) ns
step (Program acc ps (n@(Acc b i):ns)) = Just $ Program (acc + i) (ran n:ps) ns
step (Program acc ps (n@(Jmp b i):ns)) = Just $ Program acc
                                                        (reverse (take i (ran n:ns)) ++ drop (-i) ps)
                                                        (reverse (take (-i) ps) ++ drop i (ran n:ns))

atAcc :: Program -> Bool
atAcc (Program _ _ ((Acc _ _):_)) = True
atAcc _                           = False

change :: Program -> Program
change p@(Program _ _ (n:ns)) = p { next = change' n : ns }
  where change' (Nop b i) = Jmp b i
        change' (Jmp b i) = Nop b i
        change' a         = a

finished :: Program -> Bool
finished p = null $ next p

-- Parser
offset :: Parser Int
offset = (token '+' *> nat) <|> int

instruction :: Parser (Bool -> Int -> Instruction)
instruction = (string "acc" *> pure Acc)
          <|> (string "jmp" *> pure Jmp)
          <|> (string "nop" *> pure Nop)

line :: Parser Instruction
line = instruction <*> pure False <*> (token ' ' *> offset <* star (token '\n'))

-- Main
main :: IO ()
main = do [_, part, file] <- getArgs
          program <- Program 0 [] <$> parse' (star line) <$> readFile file
          if part == "1"
          then print $ acc $ farthest step program
          else do print $ part2 [(False, program)]

part2 :: [(Bool, Program)] -> Maybe Int
part2 [] = Nothing
part2 ((changed, p):ps) | finished p = Just (acc p)
                        | otherwise  = part2 $ catMaybes followups ++ ps
  where followups | atAcc p || changed = [ (changed,) <$> step p ]
                  | otherwise          = [ (False,) <$> step p
                                         , (True,) <$> (step $ change p)
                                         ] 
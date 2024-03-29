
{- |
  Module : Statistic.Huffman
  Description : A module containing specifics for the Huffman compression method
  Maintainer : ???
-}
module Statistic.Huffman(tree) where
import Statistic.EncodingTree
{-
J'ai essayé de faire avec les 4 points du projet mais je n'ai pas résussi, à la fin j'obtenais un liste de la forme:
[[([Char], Int)]] contenant les node succesif mais je n'arrivais pas à fusionner cette dernière
A la place j'ai effecuté les étapes suivante:
1)convertir tous les caractères en feuilles au début
2)récuperer les 2 plus petits arbres et les fusionner en un arbre,
  pour cette étape j'ai une list d'arbres triée dans l'ordre croissant des fréquences, je fusionne les 2 premiers éléments 
3)répèter l'opération jusqu'à la fin 
Pour conclure, au lieu de manipuler [[([Char],Int)]], je manipuler directement des arbres
-}
elementCount :: Eq a => [a] -> a -> Int
elementCount [] _ = 0
elementCount (h:t) symbol
  | h == symbol = 1 + elementCount t symbol
  | otherwise = 0 + elementCount t symbol
-- Retourne une liste des fréquances de chaque lettre
frequencies :: (Eq a) => [a] -> [(a, Int)]
frequencies [] = []
frequencies (h:t) = (h, elementCount (h:t) h) : frequencies (filter (/= h) t) -- filter pour enlever les lettres que l'on a déjà compté)

-- 1)convertir tous les caractères en feuilles au début
convertToEncodingLeaf :: (a, Int) -> EncodingTree a
convertToEncodingLeaf (symbol, frequency) = EncodingLeaf frequency symbol

convertListOfSymbols :: [(a, Int)] -> [EncodingTree a]
convertListOfSymbols list = sortFreqAsc (map convertToEncodingLeaf list)

-- 2)récuperer les 2 plus petits arbres et les fusionne en un arbre
-- 3)répèter l'opération jusqu'à la fin 
createNewList :: [EncodingTree a] -> [EncodingTree a]
createNewList [] = []
createNewList [x] = [x]
createNewList (h1:h2:t) = createNewList newList
  where 
      newList = sortFreqAsc t ++ [EncodingNode frequency_of_h1_and_h2 h1 h2]
      frequency_of_h1_and_h2 = getFrequency h1 + getFrequency h2

getFrequency :: EncodingTree a -> Int
getFrequency (EncodingNode freq _ _) = freq -- Node
getFrequency (EncodingLeaf freq _) = freq -- Leaf

sortFreqAsc :: [EncodingTree a] -> [EncodingTree a]
sortFreqAsc [] = []
sortFreqAsc (h:t) = sortFreqAsc below ++ [h] ++ sortFreqAsc above
  where 
      below = filter (\y -> getFrequency y < getFrequency h) t -- Tous les arbres inférieurs
      above = filter (\y -> getFrequency y >= getFrequency h) t -- Tous les arbres supérieurs
-- | Huffman tree generation
tree :: Ord a => [a] -> Maybe (EncodingTree a)
tree [] = Nothing  -- Si la liste est vide, retourner Nothing
tree text = Just $ head $ createNewList $ convertListOfSymbols $ frequencies text

module IntLike.Map
  ( IntLikeMap (..)
  , empty
  , singleton
  , fromList
  , size
  , null
  , member
  , toList
  , keys
  , keysSet
  , elems
  , lookup
  , partialLookup
  , findWithDefault
  , insert
  , insertWith
  , adjust
  , alter
  , delete
  , minViewWithKey
  , filter
  , restrictKeys
  , map
  , traverseWithKey
  , traverseMaybeWithKey
  , insertState
  , mapWithKey
  , union
  , difference
  , unionWith
  , unionWithMaybe
  , unionWithMaybeA
  , intersectionWithMaybe
  , intersectionWithMaybeA
  , partition
  , split
  ) where

import Control.DeepSeq (NFData)
import Data.Coerce (Coercible, coerce)
import Data.IntMap.Strict (IntMap)
import Data.IntMap.Merge.Strict as IM
import qualified Data.IntMap.Strict as IntMap
import IntLike.Set (IntLikeSet (..))
import Prelude hiding (filter, lookup, map, null)
import GHC.Stack (HasCallStack)

newtype IntLikeMap x a = IntLikeMap {unIntLikeMap :: IntMap a}
  deriving stock (Show, Traversable)
  deriving newtype (Eq, Functor, Foldable, NFData, Semigroup, Monoid, Ord)

empty :: IntLikeMap x a
empty = IntLikeMap IntMap.empty
{-# INLINE empty #-}

singleton :: Coercible x Int => x -> a -> IntLikeMap x a
singleton x = IntLikeMap . IntMap.singleton (coerce x)
{-# INLINE singleton #-}

fromList :: Coercible x Int => [(x, a)] -> IntLikeMap x a
fromList = IntLikeMap . IntMap.fromList . coerce
{-# INLINE fromList #-}

size :: IntLikeMap x a -> Int
size = IntMap.size . unIntLikeMap
{-# INLINE size #-}

null :: IntLikeMap x a -> Bool
null = IntMap.null . unIntLikeMap
{-# INLINE null #-}

member :: Coercible x Int => x -> IntLikeMap x a -> Bool
member x = IntMap.member (coerce x) . unIntLikeMap
{-# INLINE member #-}

toList :: Coercible x Int => IntLikeMap x a -> [(x, a)]
toList = coerce . IntMap.toList . unIntLikeMap
{-# INLINE toList #-}

keys :: Coercible x Int => IntLikeMap x a -> [x]
keys = coerce . IntMap.keys . unIntLikeMap
{-# INLINE keys #-}

keysSet :: IntLikeMap x a -> IntLikeSet x
keysSet = IntLikeSet . IntMap.keysSet . unIntLikeMap
{-# INLINE keysSet #-}

elems :: IntLikeMap x a -> [a]
elems = IntMap.elems . unIntLikeMap
{-# INLINE elems #-}

lookup :: Coercible x Int => x -> IntLikeMap x a -> Maybe a
lookup x = IntMap.lookup (coerce x) . unIntLikeMap
{-# INLINE lookup #-}

partialLookup :: (HasCallStack, Coercible x Int) => x -> IntLikeMap x a -> a
partialLookup x m = case unIntLikeMap m IntMap.!? coerce x of
    Nothing -> error ("IntLikeMap.!: key " <> show (coerce x :: Int) <> "is not an element of the map")
    Just a -> a
{-# INLINE partialLookup #-}

findWithDefault :: Coercible x Int => a -> x -> IntLikeMap x a -> a
findWithDefault a x = IntMap.findWithDefault a (coerce x) . unIntLikeMap
{-# INLINE findWithDefault #-}

insert :: Coercible x Int => x -> a -> IntLikeMap x a -> IntLikeMap x a
insert x a = IntLikeMap . IntMap.insert (coerce x) a . unIntLikeMap
{-# INLINE insert #-}

insertWith :: Coercible x Int => (a -> a -> a) -> x -> a -> IntLikeMap x a -> IntLikeMap x a
insertWith f x a = IntLikeMap . IntMap.insertWith f (coerce x) a . unIntLikeMap
{-# INLINE insertWith #-}

adjust :: Coercible x Int => (a -> a) -> x -> IntLikeMap x a -> IntLikeMap x a
adjust f x = IntLikeMap . IntMap.adjust f (coerce x) . unIntLikeMap
{-# INLINE adjust #-}

alter :: Coercible x Int => (Maybe a -> Maybe a) -> x -> IntLikeMap x a -> IntLikeMap x a
alter f x = IntLikeMap . IntMap.alter f (coerce x) . unIntLikeMap
{-# INLINE alter #-}

delete :: Coercible x Int => x -> IntLikeMap x a -> IntLikeMap x a
delete x = IntLikeMap . IntMap.delete (coerce x) . unIntLikeMap
{-# INLINE delete #-}

minViewWithKey :: Coercible x Int => IntLikeMap x a -> Maybe ((x, a), IntLikeMap x a)
minViewWithKey = coerce . IntMap.minViewWithKey . unIntLikeMap
{-# INLINE minViewWithKey #-}

filter :: (a -> Bool) -> IntLikeMap x a -> IntLikeMap x a
filter f = IntLikeMap . IntMap.filter f . unIntLikeMap
{-# INLINE filter #-}

restrictKeys :: IntLikeMap x a -> IntLikeSet x -> IntLikeMap x a
restrictKeys m s = IntLikeMap (IntMap.restrictKeys (unIntLikeMap m) (unIntLikeSet s))
{-# INLINE restrictKeys #-}

map :: (a -> b) -> IntLikeMap x a -> IntLikeMap x b
map f = IntLikeMap . IntMap.map f . unIntLikeMap
{-# INLINE map #-}

mapWithKey :: Coercible x Int => (x -> a -> b) -> IntLikeMap x a -> IntLikeMap x b
mapWithKey f = IntLikeMap . IntMap.mapWithKey (\x a -> f (coerce x) a) . unIntLikeMap
{-# INLINE mapWithKey #-}

traverseWithKey :: (Coercible x Int, Applicative f) => (x -> a -> f b) -> IntLikeMap x a -> f (IntLikeMap x b)
traverseWithKey f = fmap IntLikeMap . IntMap.traverseWithKey (coerce f) . unIntLikeMap
{-# INLINE traverseWithKey #-}

traverseMaybeWithKey :: (Coercible x Int, Applicative f) => (x -> a -> f (Maybe b)) -> IntLikeMap x a -> f (IntLikeMap x b)
traverseMaybeWithKey f = fmap IntLikeMap . IntMap.traverseMaybeWithKey (coerce f) . unIntLikeMap
{-# INLINE traverseMaybeWithKey #-}

union :: IntLikeMap x a -> IntLikeMap x a -> IntLikeMap x a
union l r = IntLikeMap (IntMap.union (unIntLikeMap l) (unIntLikeMap r))
{-# INLINE union #-}

difference :: IntLikeMap x a -> IntLikeMap x o -> IntLikeMap x a
difference l r = IntLikeMap (IntMap.difference (unIntLikeMap l) (unIntLikeMap r))
{-# INLINE difference #-}

unionWith :: (a -> a -> a) -> IntLikeMap x a -> IntLikeMap x a -> IntLikeMap x a
unionWith f l r = IntLikeMap (IntMap.unionWith f (unIntLikeMap l) (unIntLikeMap r))
{-# INLINE unionWith #-}

unionWithMaybe :: Coercible x Int => (x -> a -> a -> Maybe a) -> IntLikeMap x a -> IntLikeMap x a -> IntLikeMap x a
unionWithMaybe f l r = IntLikeMap (IM.merge IM.preserveMissing IM.preserveMissing (IM.zipWithMaybeMatched (\x -> f (coerce x))) (unIntLikeMap l) (unIntLikeMap r))
{-# INLINE unionWithMaybe #-}

unionWithMaybeA :: (Applicative f, Coercible x Int) => (x -> a -> a -> f (Maybe a)) -> IntLikeMap x a -> IntLikeMap x a -> f (IntLikeMap x a)
unionWithMaybeA f l r = fmap IntLikeMap (IM.mergeA IM.preserveMissing IM.preserveMissing (IM.zipWithMaybeAMatched (\x -> f (coerce x))) (unIntLikeMap l) (unIntLikeMap r))
{-# INLINE unionWithMaybeA #-}

intersectionWithMaybe :: Coercible x Int => (x -> a -> a -> Maybe a) -> IntLikeMap x a -> IntLikeMap x a -> IntLikeMap x a
intersectionWithMaybe f l r = IntLikeMap (IM.merge IM.dropMissing IM.dropMissing (IM.zipWithMaybeMatched (\x -> f (coerce x))) (unIntLikeMap l) (unIntLikeMap r))
{-# INLINE intersectionWithMaybe #-}

-- Really should just expose everything
intersectionWithMaybeA :: (Applicative f, Coercible x Int) => (x -> a -> a -> f (Maybe a)) -> IntLikeMap x a -> IntLikeMap x a -> f (IntLikeMap x a)
intersectionWithMaybeA f l r = fmap IntLikeMap (IM.mergeA IM.dropMissing IM.dropMissing (IM.zipWithMaybeAMatched (\x -> f (coerce x))) (unIntLikeMap l) (unIntLikeMap r))
{-# INLINE intersectionWithMaybeA #-}

update :: Coercible x Int => (a -> Maybe a) -> x -> IntLikeMap x a -> IntLikeMap x a
update f x m = IntLikeMap (IntMap.update f (coerce x) (unIntLikeMap m))
{-# INLINE update #-}

partition :: (a -> Bool) -> IntLikeMap x a -> (IntLikeMap x a, IntLikeMap x a)
partition f m = case IntMap.partition f (unIntLikeMap m) of
   (l,r) -> (IntLikeMap l, IntLikeMap r)
{-# INLINE partition #-}

split :: (Coercible x Int) => x -> IntLikeMap x a -> (IntLikeMap x a, IntLikeMap x a)
split x m = case IntMap.split (coerce x) (unIntLikeMap m) of
   (l,r) -> (IntLikeMap l, IntLikeMap r)
{-# INLINE split #-}

insertState :: Coercible x Int => (Maybe a -> b) -> x -> a -> IntLikeMap x a -> (b, IntLikeMap x a)
insertState f x a = coerce . IntMap.alterF (\m -> (f m, Just a)) (coerce x) . unIntLikeMap
{-# INLINE insertState #-}



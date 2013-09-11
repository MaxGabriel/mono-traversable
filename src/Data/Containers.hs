{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilies #-}
module Data.Containers where

import qualified Data.Map as Map
import qualified Data.HashMap.Strict as HashMap
import Data.Hashable (Hashable)
import qualified Data.Set as Set
import qualified Data.HashSet as HashSet
import Data.Monoid (Monoid)
import Data.MonoTraversable (MonoFoldable, MonoTraversable, Element)
import qualified Data.IntMap as IntMap

class (Monoid c, MonoFoldable c) => Container c where
    type ContainerKey c
    member :: ContainerKey c -> c -> Bool
    notMember ::  ContainerKey c -> c -> Bool
    union :: c -> c -> c
    difference :: c -> c -> c
    intersection :: c -> c -> c
instance Ord k => Container (Map.Map k v) where
    type ContainerKey (Map.Map k v) = k
    member = Map.member
    notMember = Map.notMember
    union = Map.union
    difference = Map.difference
    intersection = Map.intersection
instance (Eq k, Hashable k) => Container (HashMap.HashMap k v) where
    type ContainerKey (HashMap.HashMap k v) = k
    member = HashMap.member
    notMember k = not . HashMap.member k
    union = HashMap.union
    difference = HashMap.difference
    intersection = HashMap.intersection
instance Container (IntMap.IntMap v) where
    type ContainerKey (IntMap.IntMap v) = Int
    member = IntMap.member
    notMember = IntMap.notMember
    union = IntMap.union
    difference = IntMap.difference
    intersection = IntMap.intersection
instance Ord e => Container (Set.Set e) where
    type ContainerKey (Set.Set e) = e
    member = Set.member
    notMember = Set.notMember
    union = Set.union
    difference = Set.difference
    intersection = Set.intersection
instance (Eq e, Hashable e) => Container (HashSet.HashSet e) where
    type ContainerKey (HashSet.HashSet e) = e
    member = HashSet.member
    notMember e = not . HashSet.member e
    union = HashSet.union
    difference = HashSet.difference
    intersection = HashSet.intersection

class (MonoTraversable m, Container m) => IsMap m where
    lookup :: ContainerKey m -> m -> Maybe (Element m)
    insertMap :: ContainerKey m -> Element m -> m -> m
    deleteMap :: ContainerKey m -> m -> m
    singletonMap :: ContainerKey m -> Element m -> m
instance Ord k => IsMap (Map.Map k v) where
    lookup = Map.lookup
    insertMap = Map.insert
    deleteMap = Map.delete
    singletonMap = Map.singleton
instance (Eq k, Hashable k) => IsMap (HashMap.HashMap k v) where
    lookup = HashMap.lookup
    insertMap = HashMap.insert
    deleteMap = HashMap.delete
    singletonMap = HashMap.singleton
instance IsMap (IntMap.IntMap v) where
    lookup = IntMap.lookup
    insertMap = IntMap.insert
    deleteMap = IntMap.delete
    singletonMap = IntMap.singleton

class (Container s, Element s ~ ContainerKey s) => IsSet s where
    insertSet :: Element s -> s -> s
    deleteSet :: Element s -> s -> s
    singletonSet :: Element s -> s
instance Ord e => IsSet (Set.Set e) where
    insertSet = Set.insert
    deleteSet = Set.delete
    singletonSet = Set.singleton
instance (Eq e, Hashable e) => IsSet (HashSet.HashSet e) where
    insertSet = HashSet.insert
    deleteSet = HashSet.delete
    singletonSet = HashSet.singleton
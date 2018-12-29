{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE UndecidableInstances  #-}

-- | A field for dealing with newtypes, implements a bunch of default
--   db instances for them.
--   Currenlty only works with postgres
module Database.Beam.Wrapped(DBFieldWrap(..)) where

import           Control.Lens
import           Database.Beam
import           Database.Beam.Backend.SQL       (HasSqlValueSyntax (..))
import           Database.Beam.Backend.SQL.SQL92 (IsSql92DataTypeSyntax,
                                                  IsSql92ExpressionSyntax)
import           Database.Beam.Backend.Types     (BackendFromField, BeamBackend)
import           Database.Beam.Migrate
import           GHC.Generics                    (Generic)
import           Raster.Backend.DB.Enum

-- | A wrapper for newtyps in the database, the only restriction it
--   places on newtypes is that they implement Wrapped from
--   Control.Lens.Wrapped.
--   The underlying types need to implmeent the various database
--   instances.
newtype DBFieldWrap a = DBFieldWrap
  { _unField :: a
  } deriving (Generic, Show)

instance Wrapped a => Wrapped (DBFieldWrap a)

instance (Wrapped a, BeamBackend be,
          FromBackendRow be (Unwrapped a),
          BackendFromField be (DBFieldWrap a)
         ) =>
         FromBackendRow be (DBFieldWrap a)

instance ( IsSql92ExpressionSyntax be
         , Wrapped a
         , HasSqlEqualityCheck be (Unwrapped a)
         ) =>
         HasSqlEqualityCheck be (DBFieldWrap a)

instance (Wrapped a, FromField (Unwrapped a)) => FromField (DBFieldWrap a) where
  fromField a b = review (_Wrapped' . _Wrapped') <$> fromField a b

instance (Wrapped a, HasSqlValueSyntax be (Unwrapped a)) =>
         HasSqlValueSyntax be (DBFieldWrap a) where
  sqlValueSyntax = sqlValueSyntax . view (_Wrapped' . _Wrapped')

instance ( IsSql92ColumnSchemaSyntax be
         , Wrapped a
         , HasDefaultSqlDataTypeConstraints be (Unwrapped a)
         ) =>
         HasDefaultSqlDataTypeConstraints be (DBFieldWrap a)

instance ( IsSql92DataTypeSyntax be
         , Wrapped a
         , HasDefaultSqlDataType be (Unwrapped a)
         ) =>
         HasDefaultSqlDataType be (DBFieldWrap a) where
  defaultSqlDataType proxy =
    defaultSqlDataType $ view (_Wrapped' . _Wrapped') <$> proxy

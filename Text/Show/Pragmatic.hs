-- |
-- Module      : Text.Show.Pragmatic
-- Copyright   : (c) Justus Sagemüller 2017
-- License     : GPL v3
-- 
-- Maintainer  : (@) jsagemue $ uni-koeln.de
-- Stability   : experimental
-- Portability : portable
-- 

{-# LANGUAGE CPP #-}

module Text.Show.Pragmatic where

import Prelude hiding (Show(..), shows)
import qualified Prelude

import Data.Int (Int8, Int16, Int32, Int64)
import Data.Word (Word8, Word16, Word32, Word64)
#if MIN_VERSION_base(4,8,0)
import Numeric.Natural (Natural)
#endif
#if MIN_VERSION_base(4,10,0)
import Type.Reflection (TyCon, SomeTypeRep, Module)
#endif
#if MIN_VERSION_base(4,9,0)
import GHC.Stack (SrcLoc, CallStack)
#endif
#if MIN_VERSION_base(3,0,0)
import Control.Exception.Base ( SomeException, ArithException, ErrorCall, IOException
                              , MaskingState
                              , ArrayException, AsyncException
#if MIN_VERSION_base(4,7,0)
                              , SomeAsyncException
#endif
                              , AssertionFailed
#if MIN_VERSION_base(4,10,0)
                              , CompactionFailed
#endif
#if MIN_VERSION_base(4,7,1)
                              , AllocationLimitExceeded
#endif
                              , Deadlock, BlockedIndefinitelyOnSTM
                              , BlockedIndefinitelyOnMVar
                              , NestedAtomically, NonTermination
#if MIN_VERSION_base(4,9,0)
                              , TypeError
#endif
                              , NoMethodError
                              , RecUpdError, RecConError, RecSelError, PatternMatchFail
                              )
#endif
import Data.Char (GeneralCategory)
import Text.Read.Lex (Number, Lexeme)
#if MIN_VERSION_base(4,7,0)
import GHC.Fingerprint.Type (Fingerprint)
#endif
import System.IO (IOMode)
import System.IO.Error (IOErrorType)
import System.Exit (ExitCode)
import Foreign.Ptr (IntPtr, WordPtr)
import Foreign.C.Types ( CUIntMax, CIntMax, CUIntPtr, CIntPtr
                       , CSUSeconds, CUSeconds, CTime, CClock
                       , CSigAtomic, CWchar, CSize, CPtrdiff
                       , CDouble, CFloat
#if MIN_VERSION_base(4,10,0)
                       , CBool
#endif
                       , CULLong, CLLong, CULong, CLong, CUInt, CInt, CUShort, CShort
                       , CUChar, CSChar, CChar
                       )
#if MIN_VERSION_base(4,10,0)
import GHC.TypeNats (SomeNat)
import GHC.TypeLits (SomeSymbol)
#endif
#if MIN_VERSION_base(4,9,0)
import GHC.Generics ( DecidedStrictness, SourceStrictness, SourceUnpackedness
                    , Associativity, Fixity )
#endif
import Data.Monoid (Any, All)
#if MIN_VERSION_base(4,4,0)
import GHC.IO.Encoding.Types (CodingProgress, TextEncoding)
import GHC.IO.Encoding.Failure (CodingFailureMode)
#endif
import GHC.IO.Device (SeekMode)
import GHC.IO.Handle (NewlineMode, Newline, BufferMode, Handle, HandlePosn)
#if MIN_VERSION_base(4,10,0)
import GHC.IO.Handle.Lock (FileLockingNotSupported)
#endif
#if MIN_VERSION_base(4,9,0)
import GHC.StaticPtr (StaticPtrInfo)
#endif
import System.Posix.Types ( Fd
#if MIN_VERSION_base(4,10,0)
                          , CTimer, CKey, CId, CFsFilCnt, CFsBlkCnt, CClockId
                          , CBlkCnt, CBlkSize
#endif
                          , CRLim, CTcflag, CSpeed, CCc, CUid
                          , CNlink, CGid, CSsize, CPid, COff, CMode, CIno, CDev )
#if MIN_VERSION_base(4,8,1)
import GHC.Event (Lifetime, Event, FdKey)
#endif
#if MIN_VERSION_base(2,1,0)
import Data.Dynamic (Dynamic)
#endif
import GHC.Conc (ThreadStatus, BlockReason)
import Control.Concurrent (ThreadId)
#if MIN_VERSION_base(4,8,0)
import Data.Version (Version)
#endif
#if MIN_VERSION_base(4,5,0)
import Data.Version (Version)
#endif
#if MIN_VERSION_base(4,9,0)
import GHC.Stats (RTSStats)
import GHC.RTS.Flags ( RTSFlags, ParFlags, TickyFlags, TraceFlags, DoTrace, ProfFlags
                     , DoHeapProfile, CCFlags, DoCostCentres, DebugFlags, MiscFlags
                     , ConcFlags, GCFlags, GiveGCStats )
#endif
import Data.Data ( Fixity, ConstrRep, DataRep
#if MIN_VERSION_base(4,0,0)
                 , Constr
#endif
                 , DataType )
#if MIN_VERSION_base(4,8,0)
import Data.Void
#endif



class Show a where
  {-# MINIMAL showsPrec | show #-}
  showsPrec :: Int -> a -> ShowS
  showsPrec _ x = (show x++)
  show :: a -> String
  show = (`shows`"")
  showList :: [a] -> ShowS
  showList [] = ("[]"++)
  showList (x:xs) = ('[':) . shows x . flip (foldr (\y -> (',':) . shows y)) xs . (']':)

shows :: Show a => a -> ShowS
shows = showsPrec 0

#define StdShow(A)             \
instance Show (A) where {       \
  show = Prelude.show;           \
  showsPrec = Prelude.showsPrec;  \
  showList = Prelude.showList }

StdShow (Bool)
StdShow (Int)
StdShow (Int8)
StdShow (Int16)
StdShow (Int32)
StdShow (Int64)
StdShow (Integer)

#if MIN_VERSION_base(4,8,0)
StdShow (Natural)
#endif

StdShow (Ordering)
StdShow (Word)
StdShow (Word8)
StdShow (Word16)
StdShow (Word32)
StdShow (Word64)

#if MIN_VERSION_base(4,9,0)
StdShow (CallStack)
#endif

#if MIN_VERSION_base(4,10,0)
StdShow (SomeTypeRep)
#endif

StdShow (())

#if MIN_VERSION_base(4,10,0)
StdShow (TyCon)
#endif

#if MIN_VERSION_base(4,9,0)
StdShow (Module)
#endif

#if MIN_VERSION_base(4,9,0)
StdShow (SrcLoc)
#endif

#if MIN_VERSION_base(3,0,0)
StdShow (SomeException)
#endif

StdShow (GeneralCategory)
StdShow (Number)
StdShow (Lexeme)

#if MIN_VERSION_base(4,7,0)
StdShow (Fingerprint)
#endif

StdShow (IOMode)
StdShow (IntPtr)
StdShow (WordPtr)
StdShow (CUIntMax)
StdShow (CIntMax)
StdShow (CUIntPtr)
StdShow (CIntPtr)
StdShow (CSUSeconds)
StdShow (CUSeconds)
StdShow (CTime)
StdShow (CClock)
StdShow (CSigAtomic)
StdShow (CWchar)
StdShow (CSize)
StdShow (CPtrdiff)

#if MIN_VERSION_base(4,10,0)
StdShow (CBool)
#endif

StdShow (CULLong)
StdShow (CLLong)
StdShow (CULong)
StdShow (CLong)
StdShow (CUInt)
StdShow (CInt)
StdShow (CUShort)
StdShow (CShort)
StdShow (CUChar)
StdShow (CSChar)
StdShow (CChar)

#if MIN_VERSION_base(4,10,0)
StdShow (SomeNat)
StdShow (SomeSymbol)
#endif

#if MIN_VERSION_base(4,9,0)
StdShow (DecidedStrictness)
StdShow (SourceStrictness)
StdShow (SourceUnpackedness)
StdShow (Associativity)
StdShow (GHC.Generics.Fixity)
#endif

StdShow (Any)
StdShow (All)

#if MIN_VERSION_base(4,0,0)
StdShow (ArithException)
StdShow (ErrorCall)
#endif

#if MIN_VERSION_base(4,1,0)
StdShow (IOException)
#endif

StdShow (MaskingState)

#if MIN_VERSION_base(4,4,0)
StdShow (CodingProgress)
#endif

#if MIN_VERSION_base(4,3,0)
StdShow (TextEncoding)
#endif

StdShow (SeekMode)
StdShow (NewlineMode)
StdShow (Newline)
StdShow (BufferMode)

#if MIN_VERSION_base(4,1,0)
StdShow (Handle)
StdShow (IOErrorType)
#endif

StdShow (ExitCode)

#if MIN_VERSION_base(4,1,0)
StdShow (ArrayException)
StdShow (AsyncException)
#endif

#if MIN_VERSION_base(4,7,0)
StdShow (SomeAsyncException)
#endif

#if MIN_VERSION_base(4,1,0)
StdShow (AssertionFailed)
#endif

#if MIN_VERSION_base(4,10,0)
StdShow (CompactionFailed)
#endif

#if MIN_VERSION_base(4,7,1)
StdShow (AllocationLimitExceeded)
#endif

#if MIN_VERSION_base(4,1,0)
StdShow (Deadlock)
StdShow (BlockedIndefinitelyOnSTM)
StdShow (BlockedIndefinitelyOnMVar)
StdShow (CodingFailureMode)
#endif

StdShow (Fd)

#if MIN_VERSION_base(4,10,0)
StdShow (CTimer)
StdShow (CKey)
StdShow (CId)
StdShow (CFsFilCnt)
StdShow (CFsBlkCnt)
StdShow (CClockId)
StdShow (CBlkCnt)
StdShow (CBlkSize)
#endif
StdShow (CRLim)
StdShow (CTcflag)
StdShow (CSpeed)
StdShow (CCc)
StdShow (CUid)
StdShow (CNlink)
StdShow (CGid)
StdShow (CSsize)
StdShow (CPid)
StdShow (COff)
StdShow (CMode)
StdShow (CIno)
StdShow (CDev)

#if MIN_VERSION_base(4,8,1)
StdShow (Lifetime)
StdShow (Event)
#endif

#if MIN_VERSION_base(2,1,0)
StdShow (Dynamic)
#endif

StdShow (ThreadStatus)
StdShow (BlockReason)

#if MIN_VERSION_base(4,2,0)
StdShow (ThreadId)
#endif

#if MIN_VERSION_base(4,0,0)
StdShow (NestedAtomically)
StdShow (NonTermination)
#endif

#if MIN_VERSION_base(4,9,0)
StdShow (TypeError)
#endif

#if MIN_VERSION_base(4,0,0)
StdShow (NoMethodError)
StdShow (RecUpdError)
StdShow (RecConError)
StdShow (RecSelError)
StdShow (PatternMatchFail)
#endif

StdShow (FdKey)
#if MIN_VERSION_base(4,10,0)
StdShow (FileLockingNotSupported)
#endif

#if MIN_VERSION_base(4,1,0)
StdShow (HandlePosn)
#endif

#if MIN_VERSION_base(4,8,0)
StdShow (Version)
#endif

#if MIN_VERSION_base(4,9,0)
StdShow (RTSStats)
StdShow (RTSFlags)
StdShow (ParFlags)
StdShow (TickyFlags)
StdShow (TraceFlags)
StdShow (DoTrace)
StdShow (ProfFlags)
StdShow (DoHeapProfile)
StdShow (CCFlags)
StdShow (DoCostCentres)
StdShow (DebugFlags)
StdShow (MiscFlags)
StdShow (ConcFlags)
StdShow (GCFlags)
StdShow (GiveGCStats)
#endif

StdShow (Data.Data.Fixity)
StdShow (ConstrRep)
StdShow (DataRep)

#if MIN_VERSION_base(4,0,0)
StdShow (Constr)
#endif

StdShow (DataType)

#if MIN_VERSION_base(4,9,0)
StdShow (StaticPtrInfo)
#endif

#if MIN_VERSION_base(4,8,0)
StdShow (Void)
#endif


instance Show Char where
  show c | c>'\31', c/='\'', c/='\\'
                      = '\'':c:"'"
         | otherwise  = Prelude.show c
  showList cs = ('"':) . flip (foldr showc) cs . ('"':)
   where showc '"' = ("\\\""++)
         showc '\\' = ("\\\\"++)
         showc '\SO' = ("\\SO\\&"++)  -- prevent problem with "\SO\&H"≈[14,72] getting
                                      -- shown as "\SOH"≈[2]. (Thanks, QuickCheck!)
         showc c | c>'\31'    = (c:)
                 | otherwise  = case show c of
                     ('\'':q) -> case break (=='\'') q of
                       (r,"'") -> (r++)


instance (Show a) => Show [a] where
  showsPrec _ = showList

instance (Show a, Show b) => Show (a,b) where
  showsPrec _ (a,b) = ('(':) . shows a . (',':) . shows b . (')':)
instance (Show a, Show b, Show c) => Show (a,b,c) where
  showsPrec _ (a,b,c) = ('(':) . shows a . (',':) . shows b . (',':) . shows c . (')':)
instance (Show a, Show b, Show c, Show d) => Show (a,b,c,d) where
  showsPrec _ (a,b,c,d) = ('(':)
           . shows a . (',':) . shows b . (',':) . shows c . (',':) . shows d
                        . (')':)

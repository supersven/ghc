{-# OPTIONS_GHC -w #-}
module Parser (parse) where

import Lexer (lex_tok)
import ParserM (Token(..), ParserM, run_parser, get_pos, show_pos,
                happyError)
import Syntax

import AccessOps
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Prelude.Int
	| HappyAbsSyn4 (Info)
	| HappyAbsSyn5 ([Option])
	| HappyAbsSyn7 (Option)
	| HappyAbsSyn8 (Maybe Fixity)
	| HappyAbsSyn9 (PrimOpEffect)
	| HappyAbsSyn10 (Maybe Word)
	| HappyAbsSyn11 (PrimOpCanFailWarnFlag)
	| HappyAbsSyn12 ([Entry])
	| HappyAbsSyn14 (Entry)
	| HappyAbsSyn20 (Category)
	| HappyAbsSyn21 (String)
	| HappyAbsSyn25 ([(String, String, Int)])
	| HappyAbsSyn27 ((String, String, Int))
	| HappyAbsSyn28 (Ty)
	| HappyAbsSyn31 ([Ty])
	| HappyAbsSyn34 (TyCon)

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117,
 action_118,
 action_119,
 action_120,
 action_121,
 action_122,
 action_123,
 action_124,
 action_125,
 action_126,
 action_127,
 action_128,
 action_129,
 action_130,
 action_131,
 action_132,
 action_133,
 action_134 :: () => Prelude.Int -> ({-HappyReduction (ParserM) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> (ParserM) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> (ParserM) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> (ParserM) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65,
 happyReduce_66,
 happyReduce_67,
 happyReduce_68,
 happyReduce_69,
 happyReduce_70,
 happyReduce_71,
 happyReduce_72,
 happyReduce_73,
 happyReduce_74,
 happyReduce_75,
 happyReduce_76,
 happyReduce_77 :: () => ({-HappyReduction (ParserM) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> (ParserM) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> (ParserM) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> (ParserM) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,252) ([0,0,0,32,0,0,0,0,4096,0,0,0,0,49152,3,12288,0,0,0,32768,17936,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,49680,2056,0,0,32,0,0,0,0,4096,0,0,0,0,0,8,0,0,0,0,1024,0,0,0,0,0,2,0,0,0,0,256,0,0,0,0,0,0,0,2048,0,0,0,60,0,3,0,0,7680,0,384,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32768,0,0,0,0,0,32,0,0,0,0,8192,0,0,640,0,30720,12,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,32768,1,0,0,0,0,0,0,0,0,0,0,2,0,12768,0,0,1808,0,61440,24,0,32768,6,0,3192,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,6384,0,0,0,0,0,16,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16384,3072,0,256,0,0,128,0,0,0,0,0,0,1792,0,0,0,0,128,8192,0,0,0,0,15,0,0,0,0,60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,128,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,2048,0,0,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,24,0,0,0,4096,0,0,0,0,16384,0,0,0,0,0,512,0,0,0,0,0,0,0,0,0,0,32,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,6384,0,0,0,0,0,0,0,33792,0,0,0,0,0,0,0,0,0,0,20480,0,0,399,0,0,40,0,51072,0,0,0,256,0,0,0,0,0,0,0,0,0,0,4096,2242,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2560,0,57344,49,0,0,16384,0,0,0,0,640,0,30720,12,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,128,0,0,4,0,16384,0,0,512,0,0,0,0,0,0,0,32768,0,0,0,0,16384,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,512,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,4,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parsex","info","pDefaults","pOptions","pOption","pInfix","pEffect","pGoodBits","pPrimOpCanFailWarnFlag","pEntries","pAccessOps","pEntry","pPrimOpSpec","pPrimTypeSpec","pPseudoOpSpec","pSection","pWithOptions","pCategory","pDesc","pStuffBetweenBraces","pInsides","pInside","pVectorTemplate","pVectors","pVector","pType","paT","pUnboxedTupleTy","pCommaTypes","ppTs","ppT","pTycon","'->'","'=>'","'='","','","'('","')'","'(#'","'#)'","'{'","'}'","'['","']'","'<'","'>'","section","primop","pseudoop","primtype","with","defaults","true","false","compare","genprimop","fixity","infix","infixl","infixr","nothing","effect","NoEffect","CanFail","ThrowsException","ReadWriteEffect","defined_bits","can_fail_warning","DoNotWarnCanFail","WarnIfEffectIsCanFail","YesWarnCanFail","vector","SCALAR","VECTOR","VECTUPLE","INTVECTUPLE","bytearray_access_ops","addr_access_ops","thats_all_folks","lowerName","upperName","string","integer","noBraces","%eof"]
        bit_start = st Prelude.* 87
        bit_end = (st Prelude.+ 1) Prelude.* 87
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..86]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (54) = happyShift action_3
action_0 (4) = happyGoto action_4
action_0 (5) = happyGoto action_2
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (54) = happyShift action_3
action_1 (5) = happyGoto action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (49) = happyShift action_20
action_2 (50) = happyShift action_21
action_2 (51) = happyShift action_22
action_2 (52) = happyShift action_23
action_2 (79) = happyShift action_24
action_2 (80) = happyShift action_25
action_2 (12) = happyGoto action_13
action_2 (13) = happyGoto action_14
action_2 (14) = happyGoto action_15
action_2 (15) = happyGoto action_16
action_2 (16) = happyGoto action_17
action_2 (17) = happyGoto action_18
action_2 (18) = happyGoto action_19
action_2 _ = happyReduce_29

action_3 (59) = happyShift action_7
action_3 (64) = happyShift action_8
action_3 (69) = happyShift action_9
action_3 (70) = happyShift action_10
action_3 (74) = happyShift action_11
action_3 (82) = happyShift action_12
action_3 (6) = happyGoto action_5
action_3 (7) = happyGoto action_6
action_3 _ = happyReduce_4

action_4 (87) = happyAccept
action_4 _ = happyFail (happyExpListPerState 4)

action_5 _ = happyReduce_2

action_6 (59) = happyShift action_7
action_6 (64) = happyShift action_8
action_6 (69) = happyShift action_9
action_6 (70) = happyShift action_10
action_6 (74) = happyShift action_11
action_6 (82) = happyShift action_12
action_6 (6) = happyGoto action_50
action_6 (7) = happyGoto action_6
action_6 _ = happyReduce_4

action_7 (37) = happyShift action_49
action_7 _ = happyFail (happyExpListPerState 7)

action_8 (37) = happyShift action_48
action_8 _ = happyFail (happyExpListPerState 8)

action_9 (37) = happyShift action_47
action_9 _ = happyFail (happyExpListPerState 9)

action_10 (37) = happyShift action_46
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (37) = happyShift action_45
action_11 _ = happyFail (happyExpListPerState 11)

action_12 (37) = happyShift action_44
action_12 _ = happyFail (happyExpListPerState 12)

action_13 (81) = happyShift action_43
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (49) = happyShift action_20
action_14 (50) = happyShift action_21
action_14 (51) = happyShift action_22
action_14 (52) = happyShift action_23
action_14 (79) = happyShift action_24
action_14 (80) = happyShift action_25
action_14 (12) = happyGoto action_42
action_14 (13) = happyGoto action_14
action_14 (14) = happyGoto action_15
action_14 (15) = happyGoto action_16
action_14 (16) = happyGoto action_17
action_14 (17) = happyGoto action_18
action_14 (18) = happyGoto action_19
action_14 _ = happyReduce_29

action_15 (49) = happyShift action_20
action_15 (50) = happyShift action_21
action_15 (51) = happyShift action_22
action_15 (52) = happyShift action_23
action_15 (79) = happyShift action_24
action_15 (80) = happyShift action_25
action_15 (12) = happyGoto action_41
action_15 (13) = happyGoto action_14
action_15 (14) = happyGoto action_15
action_15 (15) = happyGoto action_16
action_15 (16) = happyGoto action_17
action_15 (17) = happyGoto action_18
action_15 (18) = happyGoto action_19
action_15 _ = happyReduce_29

action_16 _ = happyReduce_32

action_17 _ = happyReduce_33

action_18 _ = happyReduce_34

action_19 _ = happyReduce_35

action_20 (84) = happyShift action_40
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (83) = happyShift action_39
action_21 _ = happyFail (happyExpListPerState 21)

action_22 (84) = happyShift action_38
action_22 _ = happyFail (happyExpListPerState 22)

action_23 (39) = happyShift action_30
action_23 (41) = happyShift action_31
action_23 (75) = happyShift action_32
action_23 (76) = happyShift action_33
action_23 (77) = happyShift action_34
action_23 (78) = happyShift action_35
action_23 (82) = happyShift action_36
action_23 (83) = happyShift action_37
action_23 (28) = happyGoto action_26
action_23 (29) = happyGoto action_27
action_23 (30) = happyGoto action_28
action_23 (34) = happyGoto action_29
action_23 _ = happyFail (happyExpListPerState 23)

action_24 _ = happyReduce_30

action_25 _ = happyReduce_31

action_26 (43) = happyShift action_71
action_26 (21) = happyGoto action_92
action_26 (22) = happyGoto action_76
action_26 _ = happyReduce_45

action_27 (35) = happyShift action_90
action_27 (36) = happyShift action_91
action_27 _ = happyReduce_58

action_28 _ = happyReduce_60

action_29 (39) = happyShift action_88
action_29 (75) = happyShift action_32
action_29 (76) = happyShift action_33
action_29 (77) = happyShift action_34
action_29 (78) = happyShift action_35
action_29 (82) = happyShift action_89
action_29 (83) = happyShift action_37
action_29 (32) = happyGoto action_85
action_29 (33) = happyGoto action_86
action_29 (34) = happyGoto action_87
action_29 _ = happyReduce_68

action_30 (35) = happyShift action_83
action_30 (39) = happyShift action_30
action_30 (40) = happyShift action_84
action_30 (41) = happyShift action_31
action_30 (75) = happyShift action_32
action_30 (76) = happyShift action_33
action_30 (77) = happyShift action_34
action_30 (78) = happyShift action_35
action_30 (82) = happyShift action_36
action_30 (83) = happyShift action_37
action_30 (28) = happyGoto action_82
action_30 (29) = happyGoto action_27
action_30 (30) = happyGoto action_28
action_30 (34) = happyGoto action_29
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (39) = happyShift action_30
action_31 (41) = happyShift action_31
action_31 (42) = happyShift action_81
action_31 (75) = happyShift action_32
action_31 (76) = happyShift action_33
action_31 (77) = happyShift action_34
action_31 (78) = happyShift action_35
action_31 (82) = happyShift action_36
action_31 (83) = happyShift action_37
action_31 (28) = happyGoto action_79
action_31 (29) = happyGoto action_27
action_31 (30) = happyGoto action_28
action_31 (31) = happyGoto action_80
action_31 (34) = happyGoto action_29
action_31 _ = happyFail (happyExpListPerState 31)

action_32 _ = happyReduce_74

action_33 _ = happyReduce_75

action_34 _ = happyReduce_76

action_35 _ = happyReduce_77

action_36 _ = happyReduce_62

action_37 _ = happyReduce_71

action_38 (39) = happyShift action_30
action_38 (41) = happyShift action_31
action_38 (75) = happyShift action_32
action_38 (76) = happyShift action_33
action_38 (77) = happyShift action_34
action_38 (78) = happyShift action_35
action_38 (82) = happyShift action_36
action_38 (83) = happyShift action_37
action_38 (28) = happyGoto action_78
action_38 (29) = happyGoto action_27
action_38 (30) = happyGoto action_28
action_38 (34) = happyGoto action_29
action_38 _ = happyFail (happyExpListPerState 38)

action_39 (84) = happyShift action_77
action_39 _ = happyFail (happyExpListPerState 39)

action_40 (43) = happyShift action_71
action_40 (21) = happyGoto action_75
action_40 (22) = happyGoto action_76
action_40 _ = happyReduce_45

action_41 _ = happyReduce_27

action_42 _ = happyReduce_28

action_43 _ = happyReduce_1

action_44 (43) = happyShift action_71
action_44 (55) = happyShift action_72
action_44 (56) = happyShift action_73
action_44 (85) = happyShift action_74
action_44 (22) = happyGoto action_70
action_44 _ = happyFail (happyExpListPerState 44)

action_45 (45) = happyShift action_69
action_45 (25) = happyGoto action_68
action_45 _ = happyFail (happyExpListPerState 45)

action_46 (71) = happyShift action_65
action_46 (72) = happyShift action_66
action_46 (73) = happyShift action_67
action_46 (11) = happyGoto action_64
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (63) = happyShift action_62
action_47 (85) = happyShift action_63
action_47 (10) = happyGoto action_61
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (65) = happyShift action_57
action_48 (66) = happyShift action_58
action_48 (67) = happyShift action_59
action_48 (68) = happyShift action_60
action_48 (9) = happyGoto action_56
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (60) = happyShift action_52
action_49 (61) = happyShift action_53
action_49 (62) = happyShift action_54
action_49 (63) = happyShift action_55
action_49 (8) = happyGoto action_51
action_49 _ = happyFail (happyExpListPerState 49)

action_50 _ = happyReduce_3

action_51 _ = happyReduce_10

action_52 (85) = happyShift action_115
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (85) = happyShift action_114
action_53 _ = happyFail (happyExpListPerState 53)

action_54 (85) = happyShift action_113
action_54 _ = happyFail (happyExpListPerState 54)

action_55 _ = happyReduce_17

action_56 _ = happyReduce_11

action_57 _ = happyReduce_18

action_58 _ = happyReduce_19

action_59 _ = happyReduce_20

action_60 _ = happyReduce_21

action_61 _ = happyReduce_12

action_62 _ = happyReduce_23

action_63 _ = happyReduce_22

action_64 _ = happyReduce_13

action_65 _ = happyReduce_24

action_66 _ = happyReduce_25

action_67 _ = happyReduce_26

action_68 _ = happyReduce_9

action_69 (47) = happyShift action_112
action_69 (26) = happyGoto action_110
action_69 (27) = happyGoto action_111
action_69 _ = happyReduce_54

action_70 _ = happyReduce_7

action_71 (43) = happyShift action_108
action_71 (86) = happyShift action_109
action_71 (23) = happyGoto action_106
action_71 (24) = happyGoto action_107
action_71 _ = happyReduce_48

action_72 _ = happyReduce_6

action_73 _ = happyReduce_5

action_74 _ = happyReduce_8

action_75 _ = happyReduce_39

action_76 _ = happyReduce_44

action_77 (57) = happyShift action_104
action_77 (58) = happyShift action_105
action_77 (20) = happyGoto action_103
action_77 _ = happyFail (happyExpListPerState 77)

action_78 (43) = happyShift action_71
action_78 (21) = happyGoto action_102
action_78 (22) = happyGoto action_76
action_78 _ = happyReduce_45

action_79 (38) = happyShift action_101
action_79 _ = happyReduce_66

action_80 (42) = happyShift action_100
action_80 _ = happyFail (happyExpListPerState 80)

action_81 _ = happyReduce_64

action_82 (40) = happyShift action_99
action_82 _ = happyFail (happyExpListPerState 82)

action_83 (40) = happyShift action_98
action_83 _ = happyFail (happyExpListPerState 83)

action_84 _ = happyReduce_72

action_85 _ = happyReduce_59

action_86 (39) = happyShift action_88
action_86 (75) = happyShift action_32
action_86 (76) = happyShift action_33
action_86 (77) = happyShift action_34
action_86 (78) = happyShift action_35
action_86 (82) = happyShift action_89
action_86 (83) = happyShift action_37
action_86 (32) = happyGoto action_97
action_86 (33) = happyGoto action_86
action_86 (34) = happyGoto action_87
action_86 _ = happyReduce_68

action_87 _ = happyReduce_70

action_88 (35) = happyShift action_83
action_88 (40) = happyShift action_84
action_88 _ = happyFail (happyExpListPerState 88)

action_89 _ = happyReduce_69

action_90 (39) = happyShift action_30
action_90 (41) = happyShift action_31
action_90 (75) = happyShift action_32
action_90 (76) = happyShift action_33
action_90 (77) = happyShift action_34
action_90 (78) = happyShift action_35
action_90 (82) = happyShift action_36
action_90 (83) = happyShift action_37
action_90 (28) = happyGoto action_96
action_90 (29) = happyGoto action_27
action_90 (30) = happyGoto action_28
action_90 (34) = happyGoto action_29
action_90 _ = happyFail (happyExpListPerState 90)

action_91 (39) = happyShift action_30
action_91 (41) = happyShift action_31
action_91 (75) = happyShift action_32
action_91 (76) = happyShift action_33
action_91 (77) = happyShift action_34
action_91 (78) = happyShift action_35
action_91 (82) = happyShift action_36
action_91 (83) = happyShift action_37
action_91 (28) = happyGoto action_95
action_91 (29) = happyGoto action_27
action_91 (30) = happyGoto action_28
action_91 (34) = happyGoto action_29
action_91 _ = happyFail (happyExpListPerState 91)

action_92 (53) = happyShift action_94
action_92 (19) = happyGoto action_93
action_92 _ = happyReduce_41

action_93 _ = happyReduce_37

action_94 (59) = happyShift action_7
action_94 (64) = happyShift action_8
action_94 (69) = happyShift action_9
action_94 (70) = happyShift action_10
action_94 (74) = happyShift action_11
action_94 (82) = happyShift action_12
action_94 (6) = happyGoto action_125
action_94 (7) = happyGoto action_6
action_94 _ = happyReduce_4

action_95 _ = happyReduce_57

action_96 _ = happyReduce_56

action_97 _ = happyReduce_67

action_98 _ = happyReduce_73

action_99 _ = happyReduce_61

action_100 _ = happyReduce_63

action_101 (39) = happyShift action_30
action_101 (41) = happyShift action_31
action_101 (75) = happyShift action_32
action_101 (76) = happyShift action_33
action_101 (77) = happyShift action_34
action_101 (78) = happyShift action_35
action_101 (82) = happyShift action_36
action_101 (83) = happyShift action_37
action_101 (28) = happyGoto action_79
action_101 (29) = happyGoto action_27
action_101 (30) = happyGoto action_28
action_101 (31) = happyGoto action_124
action_101 (34) = happyGoto action_29
action_101 _ = happyFail (happyExpListPerState 101)

action_102 (53) = happyShift action_94
action_102 (19) = happyGoto action_123
action_102 _ = happyReduce_41

action_103 (39) = happyShift action_30
action_103 (41) = happyShift action_31
action_103 (75) = happyShift action_32
action_103 (76) = happyShift action_33
action_103 (77) = happyShift action_34
action_103 (78) = happyShift action_35
action_103 (82) = happyShift action_36
action_103 (83) = happyShift action_37
action_103 (28) = happyGoto action_122
action_103 (29) = happyGoto action_27
action_103 (30) = happyGoto action_28
action_103 (34) = happyGoto action_29
action_103 _ = happyFail (happyExpListPerState 103)

action_104 _ = happyReduce_42

action_105 _ = happyReduce_43

action_106 (44) = happyShift action_121
action_106 _ = happyFail (happyExpListPerState 106)

action_107 (43) = happyShift action_108
action_107 (86) = happyShift action_109
action_107 (23) = happyGoto action_120
action_107 (24) = happyGoto action_107
action_107 _ = happyReduce_48

action_108 (43) = happyShift action_108
action_108 (86) = happyShift action_109
action_108 (23) = happyGoto action_119
action_108 (24) = happyGoto action_107
action_108 _ = happyReduce_48

action_109 _ = happyReduce_50

action_110 (46) = happyShift action_118
action_110 _ = happyFail (happyExpListPerState 110)

action_111 (38) = happyShift action_117
action_111 _ = happyReduce_53

action_112 (83) = happyShift action_116
action_112 _ = happyFail (happyExpListPerState 112)

action_113 _ = happyReduce_16

action_114 _ = happyReduce_15

action_115 _ = happyReduce_14

action_116 (38) = happyShift action_129
action_116 _ = happyFail (happyExpListPerState 116)

action_117 (47) = happyShift action_112
action_117 (26) = happyGoto action_128
action_117 (27) = happyGoto action_111
action_117 _ = happyReduce_54

action_118 _ = happyReduce_51

action_119 (44) = happyShift action_127
action_119 _ = happyFail (happyExpListPerState 119)

action_120 _ = happyReduce_47

action_121 _ = happyReduce_46

action_122 (43) = happyShift action_71
action_122 (21) = happyGoto action_126
action_122 (22) = happyGoto action_76
action_122 _ = happyReduce_45

action_123 _ = happyReduce_38

action_124 _ = happyReduce_65

action_125 _ = happyReduce_40

action_126 (53) = happyShift action_94
action_126 (19) = happyGoto action_131
action_126 _ = happyReduce_41

action_127 _ = happyReduce_49

action_128 _ = happyReduce_52

action_129 (83) = happyShift action_130
action_129 _ = happyFail (happyExpListPerState 129)

action_130 (38) = happyShift action_132
action_130 _ = happyFail (happyExpListPerState 130)

action_131 _ = happyReduce_36

action_132 (85) = happyShift action_133
action_132 _ = happyFail (happyExpListPerState 132)

action_133 (48) = happyShift action_134
action_133 _ = happyFail (happyExpListPerState 133)

action_134 _ = happyReduce_55

happyReduce_1 = happySpecReduce_3  4 happyReduction_1
happyReduction_1 _
	(HappyAbsSyn12  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (Info happy_var_1 happy_var_2
	)
happyReduction_1 _ _ _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_2  5 happyReduction_2
happyReduction_2 (HappyAbsSyn5  happy_var_2)
	_
	 =  HappyAbsSyn5
		 (happy_var_2
	)
happyReduction_2 _ _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_2  6 happyReduction_3
happyReduction_3 (HappyAbsSyn5  happy_var_2)
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1 : happy_var_2
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_0  6 happyReduction_4
happyReduction_4  =  HappyAbsSyn5
		 ([]
	)

happyReduce_5 = happySpecReduce_3  7 happyReduction_5
happyReduction_5 _
	_
	(HappyTerminal (TLowerName happy_var_1))
	 =  HappyAbsSyn7
		 (OptionFalse   happy_var_1
	)
happyReduction_5 _ _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_3  7 happyReduction_6
happyReduction_6 _
	_
	(HappyTerminal (TLowerName happy_var_1))
	 =  HappyAbsSyn7
		 (OptionTrue    happy_var_1
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  7 happyReduction_7
happyReduction_7 (HappyAbsSyn21  happy_var_3)
	_
	(HappyTerminal (TLowerName happy_var_1))
	 =  HappyAbsSyn7
		 (OptionString  happy_var_1  happy_var_3
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_3  7 happyReduction_8
happyReduction_8 (HappyTerminal (TInteger happy_var_3))
	_
	(HappyTerminal (TLowerName happy_var_1))
	 =  HappyAbsSyn7
		 (OptionInteger happy_var_1  happy_var_3
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  7 happyReduction_9
happyReduction_9 (HappyAbsSyn25  happy_var_3)
	_
	_
	 =  HappyAbsSyn7
		 (OptionVector      happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_3  7 happyReduction_10
happyReduction_10 (HappyAbsSyn8  happy_var_3)
	_
	_
	 =  HappyAbsSyn7
		 (OptionFixity      happy_var_3
	)
happyReduction_10 _ _ _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_3  7 happyReduction_11
happyReduction_11 (HappyAbsSyn9  happy_var_3)
	_
	_
	 =  HappyAbsSyn7
		 (OptionEffect      happy_var_3
	)
happyReduction_11 _ _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  7 happyReduction_12
happyReduction_12 (HappyAbsSyn10  happy_var_3)
	_
	_
	 =  HappyAbsSyn7
		 (OptionDefinedBits happy_var_3
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  7 happyReduction_13
happyReduction_13 (HappyAbsSyn11  happy_var_3)
	_
	_
	 =  HappyAbsSyn7
		 (OptionCanFailWarnFlag happy_var_3
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_2  8 happyReduction_14
happyReduction_14 (HappyTerminal (TInteger happy_var_2))
	_
	 =  HappyAbsSyn8
		 (Just $ Fixity happy_var_2 InfixN
	)
happyReduction_14 _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_2  8 happyReduction_15
happyReduction_15 (HappyTerminal (TInteger happy_var_2))
	_
	 =  HappyAbsSyn8
		 (Just $ Fixity happy_var_2 InfixL
	)
happyReduction_15 _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_2  8 happyReduction_16
happyReduction_16 (HappyTerminal (TInteger happy_var_2))
	_
	 =  HappyAbsSyn8
		 (Just $ Fixity happy_var_2 InfixR
	)
happyReduction_16 _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  8 happyReduction_17
happyReduction_17 _
	 =  HappyAbsSyn8
		 (Nothing
	)

happyReduce_18 = happySpecReduce_1  9 happyReduction_18
happyReduction_18 _
	 =  HappyAbsSyn9
		 (NoEffect
	)

happyReduce_19 = happySpecReduce_1  9 happyReduction_19
happyReduction_19 _
	 =  HappyAbsSyn9
		 (CanFail
	)

happyReduce_20 = happySpecReduce_1  9 happyReduction_20
happyReduction_20 _
	 =  HappyAbsSyn9
		 (ThrowsException
	)

happyReduce_21 = happySpecReduce_1  9 happyReduction_21
happyReduction_21 _
	 =  HappyAbsSyn9
		 (ReadWriteEffect
	)

happyReduce_22 = happySpecReduce_1  10 happyReduction_22
happyReduction_22 (HappyTerminal (TInteger happy_var_1))
	 =  HappyAbsSyn10
		 (Just $ toEnum happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  10 happyReduction_23
happyReduction_23 _
	 =  HappyAbsSyn10
		 (Nothing
	)

happyReduce_24 = happySpecReduce_1  11 happyReduction_24
happyReduction_24 _
	 =  HappyAbsSyn11
		 (DoNotWarnCanFail
	)

happyReduce_25 = happySpecReduce_1  11 happyReduction_25
happyReduction_25 _
	 =  HappyAbsSyn11
		 (WarnIfEffectIsCanFail
	)

happyReduce_26 = happySpecReduce_1  11 happyReduction_26
happyReduction_26 _
	 =  HappyAbsSyn11
		 (YesWarnCanFail
	)

happyReduce_27 = happySpecReduce_2  12 happyReduction_27
happyReduction_27 (HappyAbsSyn12  happy_var_2)
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1 : happy_var_2
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_2  12 happyReduction_28
happyReduction_28 (HappyAbsSyn12  happy_var_2)
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1 ++ happy_var_2
	)
happyReduction_28 _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_0  12 happyReduction_29
happyReduction_29  =  HappyAbsSyn12
		 ([]
	)

happyReduce_30 = happySpecReduce_1  13 happyReduction_30
happyReduction_30 _
	 =  HappyAbsSyn12
		 (byteArrayAccessOps
	)

happyReduce_31 = happySpecReduce_1  13 happyReduction_31
happyReduction_31 _
	 =  HappyAbsSyn12
		 (addrAccessOps
	)

happyReduce_32 = happySpecReduce_1  14 happyReduction_32
happyReduction_32 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  14 happyReduction_33
happyReduction_33 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  14 happyReduction_34
happyReduction_34 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_1  14 happyReduction_35
happyReduction_35 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_35 _  = notHappyAtAll 

happyReduce_36 = happyReduce 7 15 happyReduction_36
happyReduction_36 ((HappyAbsSyn5  happy_var_7) `HappyStk`
	(HappyAbsSyn21  happy_var_6) `HappyStk`
	(HappyAbsSyn28  happy_var_5) `HappyStk`
	(HappyAbsSyn20  happy_var_4) `HappyStk`
	(HappyTerminal (TString happy_var_3)) `HappyStk`
	(HappyTerminal (TUpperName happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (PrimOpSpec {
                    cons = happy_var_2,
                    name = happy_var_3,
                    cat = happy_var_4,
                    ty = happy_var_5,
                    desc = happy_var_6,
                    opts = happy_var_7
                }
	) `HappyStk` happyRest

happyReduce_37 = happyReduce 4 16 happyReduction_37
happyReduction_37 ((HappyAbsSyn5  happy_var_4) `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	(HappyAbsSyn28  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (PrimTypeSpec { ty = happy_var_2, desc = happy_var_3, opts = happy_var_4 }
	) `HappyStk` happyRest

happyReduce_38 = happyReduce 5 17 happyReduction_38
happyReduction_38 ((HappyAbsSyn5  happy_var_5) `HappyStk`
	(HappyAbsSyn21  happy_var_4) `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	(HappyTerminal (TString happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (PseudoOpSpec { name = happy_var_2, ty = happy_var_3, desc = happy_var_4, opts = happy_var_5 }
	) `HappyStk` happyRest

happyReduce_39 = happySpecReduce_3  18 happyReduction_39
happyReduction_39 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal (TString happy_var_2))
	_
	 =  HappyAbsSyn14
		 (Section { title = happy_var_2, desc = happy_var_3 }
	)
happyReduction_39 _ _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_2  19 happyReduction_40
happyReduction_40 (HappyAbsSyn5  happy_var_2)
	_
	 =  HappyAbsSyn5
		 (happy_var_2
	)
happyReduction_40 _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_0  19 happyReduction_41
happyReduction_41  =  HappyAbsSyn5
		 ([]
	)

happyReduce_42 = happySpecReduce_1  20 happyReduction_42
happyReduction_42 _
	 =  HappyAbsSyn20
		 (Compare
	)

happyReduce_43 = happySpecReduce_1  20 happyReduction_43
happyReduction_43 _
	 =  HappyAbsSyn20
		 (GenPrimOp
	)

happyReduce_44 = happySpecReduce_1  21 happyReduction_44
happyReduction_44 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_0  21 happyReduction_45
happyReduction_45  =  HappyAbsSyn21
		 (""
	)

happyReduce_46 = happySpecReduce_3  22 happyReduction_46
happyReduction_46 _
	(HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (happy_var_2
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_2  23 happyReduction_47
happyReduction_47 (HappyAbsSyn21  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1 ++ happy_var_2
	)
happyReduction_47 _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_0  23 happyReduction_48
happyReduction_48  =  HappyAbsSyn21
		 (""
	)

happyReduce_49 = happySpecReduce_3  24 happyReduction_49
happyReduction_49 _
	(HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn21
		 ("{" ++ happy_var_2 ++ "}"
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  24 happyReduction_50
happyReduction_50 (HappyTerminal (TNoBraces happy_var_1))
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_3  25 happyReduction_51
happyReduction_51 _
	(HappyAbsSyn25  happy_var_2)
	_
	 =  HappyAbsSyn25
		 (happy_var_2
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_3  26 happyReduction_52
happyReduction_52 (HappyAbsSyn25  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn25
		 ([happy_var_1] ++ happy_var_3
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_1  26 happyReduction_53
happyReduction_53 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn25
		 ([happy_var_1]
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_0  26 happyReduction_54
happyReduction_54  =  HappyAbsSyn25
		 ([]
	)

happyReduce_55 = happyReduce 7 27 happyReduction_55
happyReduction_55 (_ `HappyStk`
	(HappyTerminal (TInteger happy_var_6)) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TUpperName happy_var_4)) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TUpperName happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn27
		 ((happy_var_2, happy_var_4, happy_var_6)
	) `HappyStk` happyRest

happyReduce_56 = happySpecReduce_3  28 happyReduction_56
happyReduction_56 (HappyAbsSyn28  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (TyF happy_var_1 happy_var_3
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  28 happyReduction_57
happyReduction_57 (HappyAbsSyn28  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (TyC happy_var_1 happy_var_3
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_1  28 happyReduction_58
happyReduction_58 (HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_2  29 happyReduction_59
happyReduction_59 (HappyAbsSyn31  happy_var_2)
	(HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn28
		 (TyApp happy_var_1 happy_var_2
	)
happyReduction_59 _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_1  29 happyReduction_60
happyReduction_60 (HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  29 happyReduction_61
happyReduction_61 _
	(HappyAbsSyn28  happy_var_2)
	_
	 =  HappyAbsSyn28
		 (happy_var_2
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_1  29 happyReduction_62
happyReduction_62 (HappyTerminal (TLowerName happy_var_1))
	 =  HappyAbsSyn28
		 (TyVar happy_var_1
	)
happyReduction_62 _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  30 happyReduction_63
happyReduction_63 _
	(HappyAbsSyn31  happy_var_2)
	_
	 =  HappyAbsSyn28
		 (TyUTup happy_var_2
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_2  30 happyReduction_64
happyReduction_64 _
	_
	 =  HappyAbsSyn28
		 (TyUTup []
	)

happyReduce_65 = happySpecReduce_3  31 happyReduction_65
happyReduction_65 (HappyAbsSyn31  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn31
		 (happy_var_1 : happy_var_3
	)
happyReduction_65 _ _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_1  31 happyReduction_66
happyReduction_66 (HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn31
		 ([happy_var_1]
	)
happyReduction_66 _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_2  32 happyReduction_67
happyReduction_67 (HappyAbsSyn31  happy_var_2)
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn31
		 (happy_var_1 : happy_var_2
	)
happyReduction_67 _ _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_0  32 happyReduction_68
happyReduction_68  =  HappyAbsSyn31
		 ([]
	)

happyReduce_69 = happySpecReduce_1  33 happyReduction_69
happyReduction_69 (HappyTerminal (TLowerName happy_var_1))
	 =  HappyAbsSyn28
		 (TyVar happy_var_1
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_1  33 happyReduction_70
happyReduction_70 (HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn28
		 (TyApp happy_var_1 []
	)
happyReduction_70 _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_1  34 happyReduction_71
happyReduction_71 (HappyTerminal (TUpperName happy_var_1))
	 =  HappyAbsSyn34
		 (TyCon happy_var_1
	)
happyReduction_71 _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_2  34 happyReduction_72
happyReduction_72 _
	_
	 =  HappyAbsSyn34
		 (TyCon "()"
	)

happyReduce_73 = happySpecReduce_3  34 happyReduction_73
happyReduction_73 _
	_
	_
	 =  HappyAbsSyn34
		 (TyCon "->"
	)

happyReduce_74 = happySpecReduce_1  34 happyReduction_74
happyReduction_74 _
	 =  HappyAbsSyn34
		 (SCALAR
	)

happyReduce_75 = happySpecReduce_1  34 happyReduction_75
happyReduction_75 _
	 =  HappyAbsSyn34
		 (VECTOR
	)

happyReduce_76 = happySpecReduce_1  34 happyReduction_76
happyReduction_76 _
	 =  HappyAbsSyn34
		 (VECTUPLE
	)

happyReduce_77 = happySpecReduce_1  34 happyReduction_77
happyReduction_77 _
	 =  HappyAbsSyn34
		 (INTVECTUPLE
	)

happyNewToken action sts stk
	= lex_tok(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	TEOF -> action 87 87 tk (HappyState action) sts stk;
	TArrow -> cont 35;
	TDArrow -> cont 36;
	TEquals -> cont 37;
	TComma -> cont 38;
	TOpenParen -> cont 39;
	TCloseParen -> cont 40;
	TOpenParenHash -> cont 41;
	THashCloseParen -> cont 42;
	TOpenBrace -> cont 43;
	TCloseBrace -> cont 44;
	TOpenBracket -> cont 45;
	TCloseBracket -> cont 46;
	TOpenAngle -> cont 47;
	TCloseAngle -> cont 48;
	TSection -> cont 49;
	TPrimop -> cont 50;
	TPseudoop -> cont 51;
	TPrimtype -> cont 52;
	TWith -> cont 53;
	TDefaults -> cont 54;
	TTrue -> cont 55;
	TFalse -> cont 56;
	TCompare -> cont 57;
	TGenPrimOp -> cont 58;
	TFixity -> cont 59;
	TInfixN -> cont 60;
	TInfixL -> cont 61;
	TInfixR -> cont 62;
	TNothing -> cont 63;
	TEffect -> cont 64;
	TNoEffect -> cont 65;
	TCanFail -> cont 66;
	TThrowsException -> cont 67;
	TReadWriteEffect -> cont 68;
	TDefinedBits -> cont 69;
	TCanFailWarnFlag -> cont 70;
	TDoNotWarnCanFail -> cont 71;
	TWarnIfEffectIsCanFail -> cont 72;
	TYesWarnCanFail -> cont 73;
	TVector -> cont 74;
	TSCALAR -> cont 75;
	TVECTOR -> cont 76;
	TVECTUPLE -> cont 77;
	TINTVECTUPLE -> cont 78;
	TByteArrayAccessOps -> cont 79;
	TAddrAccessOps -> cont 80;
	TThatsAllFolks -> cont 81;
	TLowerName happy_dollar_dollar -> cont 82;
	TUpperName happy_dollar_dollar -> cont 83;
	TString happy_dollar_dollar -> cont 84;
	TInteger happy_dollar_dollar -> cont 85;
	TNoBraces happy_dollar_dollar -> cont 86;
	_ -> happyError' (tk, [])
	})

happyError_ explist 87 tk = happyError' (tk, explist)
happyError_ explist _ tk = happyError' (tk, explist)

happyThen :: () => ParserM a -> (a -> ParserM b) -> ParserM b
happyThen = (Prelude.>>=)
happyReturn :: () => a -> ParserM a
happyReturn = (Prelude.return)
happyThen1 :: () => ParserM a -> (a -> ParserM b) -> ParserM b
happyThen1 = happyThen
happyReturn1 :: () => a -> ParserM a
happyReturn1 = happyReturn
happyError' :: () => ((Token), [Prelude.String]) -> ParserM a
happyError' tk = (\(tokens, explist) -> happyError) tk
parsex = happySomeParser where
 happySomeParser = happyThen (happyParse action_0) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parse :: String -> Either String Info
parse = run_parser parsex
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $










































data Happy_IntList = HappyCons Prelude.Int Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action









































indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x Prelude.< y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `Prelude.div` 16)) (bit `Prelude.mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Prelude.Int ->                    -- token number
         Prelude.Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Prelude.- ((1) :: Prelude.Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Prelude.Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n Prelude.- ((1) :: Prelude.Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Prelude.- ((1)::Prelude.Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ((HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.

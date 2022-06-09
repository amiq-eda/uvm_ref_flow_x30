//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define20.v                                                ////
////                                                              ////
////  This20 file is part of the SPI20 IP20 core20 project20                ////
////  http20://www20.opencores20.org20/projects20/spi20/                      ////
////                                                              ////
////  Author20(s):                                                  ////
////      - Simon20 Srot20 (simons20@opencores20.org20)                     ////
////                                                              ////
////  All additional20 information is avaliable20 in the Readme20.txt20   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2002 Authors20                                   ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number20 of bits used for devider20 register. If20 used in system with
// low20 frequency20 of system clock20 this can be reduced20.
// Use SPI_DIVIDER_LEN20 for fine20 tuning20 theexact20 number20.
//
//`define SPI_DIVIDER_LEN_820
`define SPI_DIVIDER_LEN_1620
//`define SPI_DIVIDER_LEN_2420
//`define SPI_DIVIDER_LEN_3220

`ifdef SPI_DIVIDER_LEN_820
  `define SPI_DIVIDER_LEN20       8    // Can20 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1620                                       
  `define SPI_DIVIDER_LEN20       16   // Can20 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2420                                       
  `define SPI_DIVIDER_LEN20       24   // Can20 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3220                                       
  `define SPI_DIVIDER_LEN20       32   // Can20 be set from 25 to 32 
`endif

//
// Maximum20 nuber20 of bits that can be send/received20 at once20. 
// Use SPI_MAX_CHAR20 for fine20 tuning20 the exact20 number20, when using
// SPI_MAX_CHAR_3220, SPI_MAX_CHAR_2420, SPI_MAX_CHAR_1620, SPI_MAX_CHAR_820.
//
`define SPI_MAX_CHAR_12820
//`define SPI_MAX_CHAR_6420
//`define SPI_MAX_CHAR_3220
//`define SPI_MAX_CHAR_2420
//`define SPI_MAX_CHAR_1620
//`define SPI_MAX_CHAR_820

`ifdef SPI_MAX_CHAR_12820
  `define SPI_MAX_CHAR20          128  // Can20 only be set to 128 
  `define SPI_CHAR_LEN_BITS20     7
`endif
`ifdef SPI_MAX_CHAR_6420
  `define SPI_MAX_CHAR20          64   // Can20 only be set to 64 
  `define SPI_CHAR_LEN_BITS20     6
`endif
`ifdef SPI_MAX_CHAR_3220
  `define SPI_MAX_CHAR20          32   // Can20 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS20     5
`endif
`ifdef SPI_MAX_CHAR_2420
  `define SPI_MAX_CHAR20          24   // Can20 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS20     5
`endif
`ifdef SPI_MAX_CHAR_1620
  `define SPI_MAX_CHAR20          16   // Can20 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS20     4
`endif
`ifdef SPI_MAX_CHAR_820
  `define SPI_MAX_CHAR20          8    // Can20 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS20     3
`endif

//
// Number20 of device20 select20 signals20. Use SPI_SS_NB20 for fine20 tuning20 the 
// exact20 number20.
//
`define SPI_SS_NB_820
//`define SPI_SS_NB_1620
//`define SPI_SS_NB_2420
//`define SPI_SS_NB_3220

`ifdef SPI_SS_NB_820
  `define SPI_SS_NB20             8    // Can20 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1620
  `define SPI_SS_NB20             16   // Can20 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2420
  `define SPI_SS_NB20             24   // Can20 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3220
  `define SPI_SS_NB20             32   // Can20 be set from 25 to 32
`endif

//
// Bits20 of WISHBONE20 address used for partial20 decoding20 of SPI20 registers.
//
`define SPI_OFS_BITS20	          4:2

//
// Register offset
//
`define SPI_RX_020                0
`define SPI_RX_120                1
`define SPI_RX_220                2
`define SPI_RX_320                3
`define SPI_TX_020                0
`define SPI_TX_120                1
`define SPI_TX_220                2
`define SPI_TX_320                3
`define SPI_CTRL20                4
`define SPI_DEVIDE20              5
`define SPI_SS20                  6

//
// Number20 of bits in ctrl20 register
//
`define SPI_CTRL_BIT_NB20         14

//
// Control20 register bit position20
//
`define SPI_CTRL_ASS20            13
`define SPI_CTRL_IE20             12
`define SPI_CTRL_LSB20            11
`define SPI_CTRL_TX_NEGEDGE20     10
`define SPI_CTRL_RX_NEGEDGE20     9
`define SPI_CTRL_GO20             8
`define SPI_CTRL_RES_120          7
`define SPI_CTRL_CHAR_LEN20       6:0


//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define6.v                                                ////
////                                                              ////
////  This6 file is part of the SPI6 IP6 core6 project6                ////
////  http6://www6.opencores6.org6/projects6/spi6/                      ////
////                                                              ////
////  Author6(s):                                                  ////
////      - Simon6 Srot6 (simons6@opencores6.org6)                     ////
////                                                              ////
////  All additional6 information is avaliable6 in the Readme6.txt6   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2002 Authors6                                   ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number6 of bits used for devider6 register. If6 used in system with
// low6 frequency6 of system clock6 this can be reduced6.
// Use SPI_DIVIDER_LEN6 for fine6 tuning6 theexact6 number6.
//
//`define SPI_DIVIDER_LEN_86
`define SPI_DIVIDER_LEN_166
//`define SPI_DIVIDER_LEN_246
//`define SPI_DIVIDER_LEN_326

`ifdef SPI_DIVIDER_LEN_86
  `define SPI_DIVIDER_LEN6       8    // Can6 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_166                                       
  `define SPI_DIVIDER_LEN6       16   // Can6 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_246                                       
  `define SPI_DIVIDER_LEN6       24   // Can6 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_326                                       
  `define SPI_DIVIDER_LEN6       32   // Can6 be set from 25 to 32 
`endif

//
// Maximum6 nuber6 of bits that can be send/received6 at once6. 
// Use SPI_MAX_CHAR6 for fine6 tuning6 the exact6 number6, when using
// SPI_MAX_CHAR_326, SPI_MAX_CHAR_246, SPI_MAX_CHAR_166, SPI_MAX_CHAR_86.
//
`define SPI_MAX_CHAR_1286
//`define SPI_MAX_CHAR_646
//`define SPI_MAX_CHAR_326
//`define SPI_MAX_CHAR_246
//`define SPI_MAX_CHAR_166
//`define SPI_MAX_CHAR_86

`ifdef SPI_MAX_CHAR_1286
  `define SPI_MAX_CHAR6          128  // Can6 only be set to 128 
  `define SPI_CHAR_LEN_BITS6     7
`endif
`ifdef SPI_MAX_CHAR_646
  `define SPI_MAX_CHAR6          64   // Can6 only be set to 64 
  `define SPI_CHAR_LEN_BITS6     6
`endif
`ifdef SPI_MAX_CHAR_326
  `define SPI_MAX_CHAR6          32   // Can6 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS6     5
`endif
`ifdef SPI_MAX_CHAR_246
  `define SPI_MAX_CHAR6          24   // Can6 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS6     5
`endif
`ifdef SPI_MAX_CHAR_166
  `define SPI_MAX_CHAR6          16   // Can6 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS6     4
`endif
`ifdef SPI_MAX_CHAR_86
  `define SPI_MAX_CHAR6          8    // Can6 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS6     3
`endif

//
// Number6 of device6 select6 signals6. Use SPI_SS_NB6 for fine6 tuning6 the 
// exact6 number6.
//
`define SPI_SS_NB_86
//`define SPI_SS_NB_166
//`define SPI_SS_NB_246
//`define SPI_SS_NB_326

`ifdef SPI_SS_NB_86
  `define SPI_SS_NB6             8    // Can6 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_166
  `define SPI_SS_NB6             16   // Can6 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_246
  `define SPI_SS_NB6             24   // Can6 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_326
  `define SPI_SS_NB6             32   // Can6 be set from 25 to 32
`endif

//
// Bits6 of WISHBONE6 address used for partial6 decoding6 of SPI6 registers.
//
`define SPI_OFS_BITS6	          4:2

//
// Register offset
//
`define SPI_RX_06                0
`define SPI_RX_16                1
`define SPI_RX_26                2
`define SPI_RX_36                3
`define SPI_TX_06                0
`define SPI_TX_16                1
`define SPI_TX_26                2
`define SPI_TX_36                3
`define SPI_CTRL6                4
`define SPI_DEVIDE6              5
`define SPI_SS6                  6

//
// Number6 of bits in ctrl6 register
//
`define SPI_CTRL_BIT_NB6         14

//
// Control6 register bit position6
//
`define SPI_CTRL_ASS6            13
`define SPI_CTRL_IE6             12
`define SPI_CTRL_LSB6            11
`define SPI_CTRL_TX_NEGEDGE6     10
`define SPI_CTRL_RX_NEGEDGE6     9
`define SPI_CTRL_GO6             8
`define SPI_CTRL_RES_16          7
`define SPI_CTRL_CHAR_LEN6       6:0


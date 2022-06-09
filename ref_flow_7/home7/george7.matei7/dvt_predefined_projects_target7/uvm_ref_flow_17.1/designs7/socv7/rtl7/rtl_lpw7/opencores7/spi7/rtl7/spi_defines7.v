//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define7.v                                                ////
////                                                              ////
////  This7 file is part of the SPI7 IP7 core7 project7                ////
////  http7://www7.opencores7.org7/projects7/spi7/                      ////
////                                                              ////
////  Author7(s):                                                  ////
////      - Simon7 Srot7 (simons7@opencores7.org7)                     ////
////                                                              ////
////  All additional7 information is avaliable7 in the Readme7.txt7   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2002 Authors7                                   ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number7 of bits used for devider7 register. If7 used in system with
// low7 frequency7 of system clock7 this can be reduced7.
// Use SPI_DIVIDER_LEN7 for fine7 tuning7 theexact7 number7.
//
//`define SPI_DIVIDER_LEN_87
`define SPI_DIVIDER_LEN_167
//`define SPI_DIVIDER_LEN_247
//`define SPI_DIVIDER_LEN_327

`ifdef SPI_DIVIDER_LEN_87
  `define SPI_DIVIDER_LEN7       8    // Can7 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_167                                       
  `define SPI_DIVIDER_LEN7       16   // Can7 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_247                                       
  `define SPI_DIVIDER_LEN7       24   // Can7 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_327                                       
  `define SPI_DIVIDER_LEN7       32   // Can7 be set from 25 to 32 
`endif

//
// Maximum7 nuber7 of bits that can be send/received7 at once7. 
// Use SPI_MAX_CHAR7 for fine7 tuning7 the exact7 number7, when using
// SPI_MAX_CHAR_327, SPI_MAX_CHAR_247, SPI_MAX_CHAR_167, SPI_MAX_CHAR_87.
//
`define SPI_MAX_CHAR_1287
//`define SPI_MAX_CHAR_647
//`define SPI_MAX_CHAR_327
//`define SPI_MAX_CHAR_247
//`define SPI_MAX_CHAR_167
//`define SPI_MAX_CHAR_87

`ifdef SPI_MAX_CHAR_1287
  `define SPI_MAX_CHAR7          128  // Can7 only be set to 128 
  `define SPI_CHAR_LEN_BITS7     7
`endif
`ifdef SPI_MAX_CHAR_647
  `define SPI_MAX_CHAR7          64   // Can7 only be set to 64 
  `define SPI_CHAR_LEN_BITS7     6
`endif
`ifdef SPI_MAX_CHAR_327
  `define SPI_MAX_CHAR7          32   // Can7 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS7     5
`endif
`ifdef SPI_MAX_CHAR_247
  `define SPI_MAX_CHAR7          24   // Can7 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS7     5
`endif
`ifdef SPI_MAX_CHAR_167
  `define SPI_MAX_CHAR7          16   // Can7 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS7     4
`endif
`ifdef SPI_MAX_CHAR_87
  `define SPI_MAX_CHAR7          8    // Can7 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS7     3
`endif

//
// Number7 of device7 select7 signals7. Use SPI_SS_NB7 for fine7 tuning7 the 
// exact7 number7.
//
`define SPI_SS_NB_87
//`define SPI_SS_NB_167
//`define SPI_SS_NB_247
//`define SPI_SS_NB_327

`ifdef SPI_SS_NB_87
  `define SPI_SS_NB7             8    // Can7 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_167
  `define SPI_SS_NB7             16   // Can7 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_247
  `define SPI_SS_NB7             24   // Can7 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_327
  `define SPI_SS_NB7             32   // Can7 be set from 25 to 32
`endif

//
// Bits7 of WISHBONE7 address used for partial7 decoding7 of SPI7 registers.
//
`define SPI_OFS_BITS7	          4:2

//
// Register offset
//
`define SPI_RX_07                0
`define SPI_RX_17                1
`define SPI_RX_27                2
`define SPI_RX_37                3
`define SPI_TX_07                0
`define SPI_TX_17                1
`define SPI_TX_27                2
`define SPI_TX_37                3
`define SPI_CTRL7                4
`define SPI_DEVIDE7              5
`define SPI_SS7                  6

//
// Number7 of bits in ctrl7 register
//
`define SPI_CTRL_BIT_NB7         14

//
// Control7 register bit position7
//
`define SPI_CTRL_ASS7            13
`define SPI_CTRL_IE7             12
`define SPI_CTRL_LSB7            11
`define SPI_CTRL_TX_NEGEDGE7     10
`define SPI_CTRL_RX_NEGEDGE7     9
`define SPI_CTRL_GO7             8
`define SPI_CTRL_RES_17          7
`define SPI_CTRL_CHAR_LEN7       6:0


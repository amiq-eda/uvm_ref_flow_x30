//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define22.v                                                ////
////                                                              ////
////  This22 file is part of the SPI22 IP22 core22 project22                ////
////  http22://www22.opencores22.org22/projects22/spi22/                      ////
////                                                              ////
////  Author22(s):                                                  ////
////      - Simon22 Srot22 (simons22@opencores22.org22)                     ////
////                                                              ////
////  All additional22 information is avaliable22 in the Readme22.txt22   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2002 Authors22                                   ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number22 of bits used for devider22 register. If22 used in system with
// low22 frequency22 of system clock22 this can be reduced22.
// Use SPI_DIVIDER_LEN22 for fine22 tuning22 theexact22 number22.
//
//`define SPI_DIVIDER_LEN_822
`define SPI_DIVIDER_LEN_1622
//`define SPI_DIVIDER_LEN_2422
//`define SPI_DIVIDER_LEN_3222

`ifdef SPI_DIVIDER_LEN_822
  `define SPI_DIVIDER_LEN22       8    // Can22 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1622                                       
  `define SPI_DIVIDER_LEN22       16   // Can22 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2422                                       
  `define SPI_DIVIDER_LEN22       24   // Can22 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3222                                       
  `define SPI_DIVIDER_LEN22       32   // Can22 be set from 25 to 32 
`endif

//
// Maximum22 nuber22 of bits that can be send/received22 at once22. 
// Use SPI_MAX_CHAR22 for fine22 tuning22 the exact22 number22, when using
// SPI_MAX_CHAR_3222, SPI_MAX_CHAR_2422, SPI_MAX_CHAR_1622, SPI_MAX_CHAR_822.
//
`define SPI_MAX_CHAR_12822
//`define SPI_MAX_CHAR_6422
//`define SPI_MAX_CHAR_3222
//`define SPI_MAX_CHAR_2422
//`define SPI_MAX_CHAR_1622
//`define SPI_MAX_CHAR_822

`ifdef SPI_MAX_CHAR_12822
  `define SPI_MAX_CHAR22          128  // Can22 only be set to 128 
  `define SPI_CHAR_LEN_BITS22     7
`endif
`ifdef SPI_MAX_CHAR_6422
  `define SPI_MAX_CHAR22          64   // Can22 only be set to 64 
  `define SPI_CHAR_LEN_BITS22     6
`endif
`ifdef SPI_MAX_CHAR_3222
  `define SPI_MAX_CHAR22          32   // Can22 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS22     5
`endif
`ifdef SPI_MAX_CHAR_2422
  `define SPI_MAX_CHAR22          24   // Can22 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS22     5
`endif
`ifdef SPI_MAX_CHAR_1622
  `define SPI_MAX_CHAR22          16   // Can22 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS22     4
`endif
`ifdef SPI_MAX_CHAR_822
  `define SPI_MAX_CHAR22          8    // Can22 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS22     3
`endif

//
// Number22 of device22 select22 signals22. Use SPI_SS_NB22 for fine22 tuning22 the 
// exact22 number22.
//
`define SPI_SS_NB_822
//`define SPI_SS_NB_1622
//`define SPI_SS_NB_2422
//`define SPI_SS_NB_3222

`ifdef SPI_SS_NB_822
  `define SPI_SS_NB22             8    // Can22 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1622
  `define SPI_SS_NB22             16   // Can22 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2422
  `define SPI_SS_NB22             24   // Can22 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3222
  `define SPI_SS_NB22             32   // Can22 be set from 25 to 32
`endif

//
// Bits22 of WISHBONE22 address used for partial22 decoding22 of SPI22 registers.
//
`define SPI_OFS_BITS22	          4:2

//
// Register offset
//
`define SPI_RX_022                0
`define SPI_RX_122                1
`define SPI_RX_222                2
`define SPI_RX_322                3
`define SPI_TX_022                0
`define SPI_TX_122                1
`define SPI_TX_222                2
`define SPI_TX_322                3
`define SPI_CTRL22                4
`define SPI_DEVIDE22              5
`define SPI_SS22                  6

//
// Number22 of bits in ctrl22 register
//
`define SPI_CTRL_BIT_NB22         14

//
// Control22 register bit position22
//
`define SPI_CTRL_ASS22            13
`define SPI_CTRL_IE22             12
`define SPI_CTRL_LSB22            11
`define SPI_CTRL_TX_NEGEDGE22     10
`define SPI_CTRL_RX_NEGEDGE22     9
`define SPI_CTRL_GO22             8
`define SPI_CTRL_RES_122          7
`define SPI_CTRL_CHAR_LEN22       6:0


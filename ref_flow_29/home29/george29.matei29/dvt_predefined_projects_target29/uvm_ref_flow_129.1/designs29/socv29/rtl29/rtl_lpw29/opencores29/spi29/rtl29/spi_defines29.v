//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define29.v                                                ////
////                                                              ////
////  This29 file is part of the SPI29 IP29 core29 project29                ////
////  http29://www29.opencores29.org29/projects29/spi29/                      ////
////                                                              ////
////  Author29(s):                                                  ////
////      - Simon29 Srot29 (simons29@opencores29.org29)                     ////
////                                                              ////
////  All additional29 information is avaliable29 in the Readme29.txt29   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2002 Authors29                                   ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number29 of bits used for devider29 register. If29 used in system with
// low29 frequency29 of system clock29 this can be reduced29.
// Use SPI_DIVIDER_LEN29 for fine29 tuning29 theexact29 number29.
//
//`define SPI_DIVIDER_LEN_829
`define SPI_DIVIDER_LEN_1629
//`define SPI_DIVIDER_LEN_2429
//`define SPI_DIVIDER_LEN_3229

`ifdef SPI_DIVIDER_LEN_829
  `define SPI_DIVIDER_LEN29       8    // Can29 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1629                                       
  `define SPI_DIVIDER_LEN29       16   // Can29 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2429                                       
  `define SPI_DIVIDER_LEN29       24   // Can29 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3229                                       
  `define SPI_DIVIDER_LEN29       32   // Can29 be set from 25 to 32 
`endif

//
// Maximum29 nuber29 of bits that can be send/received29 at once29. 
// Use SPI_MAX_CHAR29 for fine29 tuning29 the exact29 number29, when using
// SPI_MAX_CHAR_3229, SPI_MAX_CHAR_2429, SPI_MAX_CHAR_1629, SPI_MAX_CHAR_829.
//
`define SPI_MAX_CHAR_12829
//`define SPI_MAX_CHAR_6429
//`define SPI_MAX_CHAR_3229
//`define SPI_MAX_CHAR_2429
//`define SPI_MAX_CHAR_1629
//`define SPI_MAX_CHAR_829

`ifdef SPI_MAX_CHAR_12829
  `define SPI_MAX_CHAR29          128  // Can29 only be set to 128 
  `define SPI_CHAR_LEN_BITS29     7
`endif
`ifdef SPI_MAX_CHAR_6429
  `define SPI_MAX_CHAR29          64   // Can29 only be set to 64 
  `define SPI_CHAR_LEN_BITS29     6
`endif
`ifdef SPI_MAX_CHAR_3229
  `define SPI_MAX_CHAR29          32   // Can29 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS29     5
`endif
`ifdef SPI_MAX_CHAR_2429
  `define SPI_MAX_CHAR29          24   // Can29 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS29     5
`endif
`ifdef SPI_MAX_CHAR_1629
  `define SPI_MAX_CHAR29          16   // Can29 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS29     4
`endif
`ifdef SPI_MAX_CHAR_829
  `define SPI_MAX_CHAR29          8    // Can29 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS29     3
`endif

//
// Number29 of device29 select29 signals29. Use SPI_SS_NB29 for fine29 tuning29 the 
// exact29 number29.
//
`define SPI_SS_NB_829
//`define SPI_SS_NB_1629
//`define SPI_SS_NB_2429
//`define SPI_SS_NB_3229

`ifdef SPI_SS_NB_829
  `define SPI_SS_NB29             8    // Can29 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1629
  `define SPI_SS_NB29             16   // Can29 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2429
  `define SPI_SS_NB29             24   // Can29 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3229
  `define SPI_SS_NB29             32   // Can29 be set from 25 to 32
`endif

//
// Bits29 of WISHBONE29 address used for partial29 decoding29 of SPI29 registers.
//
`define SPI_OFS_BITS29	          4:2

//
// Register offset
//
`define SPI_RX_029                0
`define SPI_RX_129                1
`define SPI_RX_229                2
`define SPI_RX_329                3
`define SPI_TX_029                0
`define SPI_TX_129                1
`define SPI_TX_229                2
`define SPI_TX_329                3
`define SPI_CTRL29                4
`define SPI_DEVIDE29              5
`define SPI_SS29                  6

//
// Number29 of bits in ctrl29 register
//
`define SPI_CTRL_BIT_NB29         14

//
// Control29 register bit position29
//
`define SPI_CTRL_ASS29            13
`define SPI_CTRL_IE29             12
`define SPI_CTRL_LSB29            11
`define SPI_CTRL_TX_NEGEDGE29     10
`define SPI_CTRL_RX_NEGEDGE29     9
`define SPI_CTRL_GO29             8
`define SPI_CTRL_RES_129          7
`define SPI_CTRL_CHAR_LEN29       6:0


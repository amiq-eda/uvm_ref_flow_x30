//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define13.v                                                ////
////                                                              ////
////  This13 file is part of the SPI13 IP13 core13 project13                ////
////  http13://www13.opencores13.org13/projects13/spi13/                      ////
////                                                              ////
////  Author13(s):                                                  ////
////      - Simon13 Srot13 (simons13@opencores13.org13)                     ////
////                                                              ////
////  All additional13 information is avaliable13 in the Readme13.txt13   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2002 Authors13                                   ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number13 of bits used for devider13 register. If13 used in system with
// low13 frequency13 of system clock13 this can be reduced13.
// Use SPI_DIVIDER_LEN13 for fine13 tuning13 theexact13 number13.
//
//`define SPI_DIVIDER_LEN_813
`define SPI_DIVIDER_LEN_1613
//`define SPI_DIVIDER_LEN_2413
//`define SPI_DIVIDER_LEN_3213

`ifdef SPI_DIVIDER_LEN_813
  `define SPI_DIVIDER_LEN13       8    // Can13 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1613                                       
  `define SPI_DIVIDER_LEN13       16   // Can13 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2413                                       
  `define SPI_DIVIDER_LEN13       24   // Can13 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3213                                       
  `define SPI_DIVIDER_LEN13       32   // Can13 be set from 25 to 32 
`endif

//
// Maximum13 nuber13 of bits that can be send/received13 at once13. 
// Use SPI_MAX_CHAR13 for fine13 tuning13 the exact13 number13, when using
// SPI_MAX_CHAR_3213, SPI_MAX_CHAR_2413, SPI_MAX_CHAR_1613, SPI_MAX_CHAR_813.
//
`define SPI_MAX_CHAR_12813
//`define SPI_MAX_CHAR_6413
//`define SPI_MAX_CHAR_3213
//`define SPI_MAX_CHAR_2413
//`define SPI_MAX_CHAR_1613
//`define SPI_MAX_CHAR_813

`ifdef SPI_MAX_CHAR_12813
  `define SPI_MAX_CHAR13          128  // Can13 only be set to 128 
  `define SPI_CHAR_LEN_BITS13     7
`endif
`ifdef SPI_MAX_CHAR_6413
  `define SPI_MAX_CHAR13          64   // Can13 only be set to 64 
  `define SPI_CHAR_LEN_BITS13     6
`endif
`ifdef SPI_MAX_CHAR_3213
  `define SPI_MAX_CHAR13          32   // Can13 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS13     5
`endif
`ifdef SPI_MAX_CHAR_2413
  `define SPI_MAX_CHAR13          24   // Can13 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS13     5
`endif
`ifdef SPI_MAX_CHAR_1613
  `define SPI_MAX_CHAR13          16   // Can13 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS13     4
`endif
`ifdef SPI_MAX_CHAR_813
  `define SPI_MAX_CHAR13          8    // Can13 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS13     3
`endif

//
// Number13 of device13 select13 signals13. Use SPI_SS_NB13 for fine13 tuning13 the 
// exact13 number13.
//
`define SPI_SS_NB_813
//`define SPI_SS_NB_1613
//`define SPI_SS_NB_2413
//`define SPI_SS_NB_3213

`ifdef SPI_SS_NB_813
  `define SPI_SS_NB13             8    // Can13 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1613
  `define SPI_SS_NB13             16   // Can13 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2413
  `define SPI_SS_NB13             24   // Can13 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3213
  `define SPI_SS_NB13             32   // Can13 be set from 25 to 32
`endif

//
// Bits13 of WISHBONE13 address used for partial13 decoding13 of SPI13 registers.
//
`define SPI_OFS_BITS13	          4:2

//
// Register offset
//
`define SPI_RX_013                0
`define SPI_RX_113                1
`define SPI_RX_213                2
`define SPI_RX_313                3
`define SPI_TX_013                0
`define SPI_TX_113                1
`define SPI_TX_213                2
`define SPI_TX_313                3
`define SPI_CTRL13                4
`define SPI_DEVIDE13              5
`define SPI_SS13                  6

//
// Number13 of bits in ctrl13 register
//
`define SPI_CTRL_BIT_NB13         14

//
// Control13 register bit position13
//
`define SPI_CTRL_ASS13            13
`define SPI_CTRL_IE13             12
`define SPI_CTRL_LSB13            11
`define SPI_CTRL_TX_NEGEDGE13     10
`define SPI_CTRL_RX_NEGEDGE13     9
`define SPI_CTRL_GO13             8
`define SPI_CTRL_RES_113          7
`define SPI_CTRL_CHAR_LEN13       6:0


//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define19.v                                                ////
////                                                              ////
////  This19 file is part of the SPI19 IP19 core19 project19                ////
////  http19://www19.opencores19.org19/projects19/spi19/                      ////
////                                                              ////
////  Author19(s):                                                  ////
////      - Simon19 Srot19 (simons19@opencores19.org19)                     ////
////                                                              ////
////  All additional19 information is avaliable19 in the Readme19.txt19   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2002 Authors19                                   ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number19 of bits used for devider19 register. If19 used in system with
// low19 frequency19 of system clock19 this can be reduced19.
// Use SPI_DIVIDER_LEN19 for fine19 tuning19 theexact19 number19.
//
//`define SPI_DIVIDER_LEN_819
`define SPI_DIVIDER_LEN_1619
//`define SPI_DIVIDER_LEN_2419
//`define SPI_DIVIDER_LEN_3219

`ifdef SPI_DIVIDER_LEN_819
  `define SPI_DIVIDER_LEN19       8    // Can19 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1619                                       
  `define SPI_DIVIDER_LEN19       16   // Can19 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2419                                       
  `define SPI_DIVIDER_LEN19       24   // Can19 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3219                                       
  `define SPI_DIVIDER_LEN19       32   // Can19 be set from 25 to 32 
`endif

//
// Maximum19 nuber19 of bits that can be send/received19 at once19. 
// Use SPI_MAX_CHAR19 for fine19 tuning19 the exact19 number19, when using
// SPI_MAX_CHAR_3219, SPI_MAX_CHAR_2419, SPI_MAX_CHAR_1619, SPI_MAX_CHAR_819.
//
`define SPI_MAX_CHAR_12819
//`define SPI_MAX_CHAR_6419
//`define SPI_MAX_CHAR_3219
//`define SPI_MAX_CHAR_2419
//`define SPI_MAX_CHAR_1619
//`define SPI_MAX_CHAR_819

`ifdef SPI_MAX_CHAR_12819
  `define SPI_MAX_CHAR19          128  // Can19 only be set to 128 
  `define SPI_CHAR_LEN_BITS19     7
`endif
`ifdef SPI_MAX_CHAR_6419
  `define SPI_MAX_CHAR19          64   // Can19 only be set to 64 
  `define SPI_CHAR_LEN_BITS19     6
`endif
`ifdef SPI_MAX_CHAR_3219
  `define SPI_MAX_CHAR19          32   // Can19 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS19     5
`endif
`ifdef SPI_MAX_CHAR_2419
  `define SPI_MAX_CHAR19          24   // Can19 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS19     5
`endif
`ifdef SPI_MAX_CHAR_1619
  `define SPI_MAX_CHAR19          16   // Can19 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS19     4
`endif
`ifdef SPI_MAX_CHAR_819
  `define SPI_MAX_CHAR19          8    // Can19 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS19     3
`endif

//
// Number19 of device19 select19 signals19. Use SPI_SS_NB19 for fine19 tuning19 the 
// exact19 number19.
//
`define SPI_SS_NB_819
//`define SPI_SS_NB_1619
//`define SPI_SS_NB_2419
//`define SPI_SS_NB_3219

`ifdef SPI_SS_NB_819
  `define SPI_SS_NB19             8    // Can19 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1619
  `define SPI_SS_NB19             16   // Can19 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2419
  `define SPI_SS_NB19             24   // Can19 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3219
  `define SPI_SS_NB19             32   // Can19 be set from 25 to 32
`endif

//
// Bits19 of WISHBONE19 address used for partial19 decoding19 of SPI19 registers.
//
`define SPI_OFS_BITS19	          4:2

//
// Register offset
//
`define SPI_RX_019                0
`define SPI_RX_119                1
`define SPI_RX_219                2
`define SPI_RX_319                3
`define SPI_TX_019                0
`define SPI_TX_119                1
`define SPI_TX_219                2
`define SPI_TX_319                3
`define SPI_CTRL19                4
`define SPI_DEVIDE19              5
`define SPI_SS19                  6

//
// Number19 of bits in ctrl19 register
//
`define SPI_CTRL_BIT_NB19         14

//
// Control19 register bit position19
//
`define SPI_CTRL_ASS19            13
`define SPI_CTRL_IE19             12
`define SPI_CTRL_LSB19            11
`define SPI_CTRL_TX_NEGEDGE19     10
`define SPI_CTRL_RX_NEGEDGE19     9
`define SPI_CTRL_GO19             8
`define SPI_CTRL_RES_119          7
`define SPI_CTRL_CHAR_LEN19       6:0


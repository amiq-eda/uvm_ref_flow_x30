//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define15.v                                                ////
////                                                              ////
////  This15 file is part of the SPI15 IP15 core15 project15                ////
////  http15://www15.opencores15.org15/projects15/spi15/                      ////
////                                                              ////
////  Author15(s):                                                  ////
////      - Simon15 Srot15 (simons15@opencores15.org15)                     ////
////                                                              ////
////  All additional15 information is avaliable15 in the Readme15.txt15   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2002 Authors15                                   ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number15 of bits used for devider15 register. If15 used in system with
// low15 frequency15 of system clock15 this can be reduced15.
// Use SPI_DIVIDER_LEN15 for fine15 tuning15 theexact15 number15.
//
//`define SPI_DIVIDER_LEN_815
`define SPI_DIVIDER_LEN_1615
//`define SPI_DIVIDER_LEN_2415
//`define SPI_DIVIDER_LEN_3215

`ifdef SPI_DIVIDER_LEN_815
  `define SPI_DIVIDER_LEN15       8    // Can15 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1615                                       
  `define SPI_DIVIDER_LEN15       16   // Can15 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2415                                       
  `define SPI_DIVIDER_LEN15       24   // Can15 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3215                                       
  `define SPI_DIVIDER_LEN15       32   // Can15 be set from 25 to 32 
`endif

//
// Maximum15 nuber15 of bits that can be send/received15 at once15. 
// Use SPI_MAX_CHAR15 for fine15 tuning15 the exact15 number15, when using
// SPI_MAX_CHAR_3215, SPI_MAX_CHAR_2415, SPI_MAX_CHAR_1615, SPI_MAX_CHAR_815.
//
`define SPI_MAX_CHAR_12815
//`define SPI_MAX_CHAR_6415
//`define SPI_MAX_CHAR_3215
//`define SPI_MAX_CHAR_2415
//`define SPI_MAX_CHAR_1615
//`define SPI_MAX_CHAR_815

`ifdef SPI_MAX_CHAR_12815
  `define SPI_MAX_CHAR15          128  // Can15 only be set to 128 
  `define SPI_CHAR_LEN_BITS15     7
`endif
`ifdef SPI_MAX_CHAR_6415
  `define SPI_MAX_CHAR15          64   // Can15 only be set to 64 
  `define SPI_CHAR_LEN_BITS15     6
`endif
`ifdef SPI_MAX_CHAR_3215
  `define SPI_MAX_CHAR15          32   // Can15 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS15     5
`endif
`ifdef SPI_MAX_CHAR_2415
  `define SPI_MAX_CHAR15          24   // Can15 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS15     5
`endif
`ifdef SPI_MAX_CHAR_1615
  `define SPI_MAX_CHAR15          16   // Can15 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS15     4
`endif
`ifdef SPI_MAX_CHAR_815
  `define SPI_MAX_CHAR15          8    // Can15 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS15     3
`endif

//
// Number15 of device15 select15 signals15. Use SPI_SS_NB15 for fine15 tuning15 the 
// exact15 number15.
//
`define SPI_SS_NB_815
//`define SPI_SS_NB_1615
//`define SPI_SS_NB_2415
//`define SPI_SS_NB_3215

`ifdef SPI_SS_NB_815
  `define SPI_SS_NB15             8    // Can15 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1615
  `define SPI_SS_NB15             16   // Can15 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2415
  `define SPI_SS_NB15             24   // Can15 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3215
  `define SPI_SS_NB15             32   // Can15 be set from 25 to 32
`endif

//
// Bits15 of WISHBONE15 address used for partial15 decoding15 of SPI15 registers.
//
`define SPI_OFS_BITS15	          4:2

//
// Register offset
//
`define SPI_RX_015                0
`define SPI_RX_115                1
`define SPI_RX_215                2
`define SPI_RX_315                3
`define SPI_TX_015                0
`define SPI_TX_115                1
`define SPI_TX_215                2
`define SPI_TX_315                3
`define SPI_CTRL15                4
`define SPI_DEVIDE15              5
`define SPI_SS15                  6

//
// Number15 of bits in ctrl15 register
//
`define SPI_CTRL_BIT_NB15         14

//
// Control15 register bit position15
//
`define SPI_CTRL_ASS15            13
`define SPI_CTRL_IE15             12
`define SPI_CTRL_LSB15            11
`define SPI_CTRL_TX_NEGEDGE15     10
`define SPI_CTRL_RX_NEGEDGE15     9
`define SPI_CTRL_GO15             8
`define SPI_CTRL_RES_115          7
`define SPI_CTRL_CHAR_LEN15       6:0


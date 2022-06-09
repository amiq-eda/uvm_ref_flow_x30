//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define5.v                                                ////
////                                                              ////
////  This5 file is part of the SPI5 IP5 core5 project5                ////
////  http5://www5.opencores5.org5/projects5/spi5/                      ////
////                                                              ////
////  Author5(s):                                                  ////
////      - Simon5 Srot5 (simons5@opencores5.org5)                     ////
////                                                              ////
////  All additional5 information is avaliable5 in the Readme5.txt5   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2002 Authors5                                   ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number5 of bits used for devider5 register. If5 used in system with
// low5 frequency5 of system clock5 this can be reduced5.
// Use SPI_DIVIDER_LEN5 for fine5 tuning5 theexact5 number5.
//
//`define SPI_DIVIDER_LEN_85
`define SPI_DIVIDER_LEN_165
//`define SPI_DIVIDER_LEN_245
//`define SPI_DIVIDER_LEN_325

`ifdef SPI_DIVIDER_LEN_85
  `define SPI_DIVIDER_LEN5       8    // Can5 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_165                                       
  `define SPI_DIVIDER_LEN5       16   // Can5 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_245                                       
  `define SPI_DIVIDER_LEN5       24   // Can5 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_325                                       
  `define SPI_DIVIDER_LEN5       32   // Can5 be set from 25 to 32 
`endif

//
// Maximum5 nuber5 of bits that can be send/received5 at once5. 
// Use SPI_MAX_CHAR5 for fine5 tuning5 the exact5 number5, when using
// SPI_MAX_CHAR_325, SPI_MAX_CHAR_245, SPI_MAX_CHAR_165, SPI_MAX_CHAR_85.
//
`define SPI_MAX_CHAR_1285
//`define SPI_MAX_CHAR_645
//`define SPI_MAX_CHAR_325
//`define SPI_MAX_CHAR_245
//`define SPI_MAX_CHAR_165
//`define SPI_MAX_CHAR_85

`ifdef SPI_MAX_CHAR_1285
  `define SPI_MAX_CHAR5          128  // Can5 only be set to 128 
  `define SPI_CHAR_LEN_BITS5     7
`endif
`ifdef SPI_MAX_CHAR_645
  `define SPI_MAX_CHAR5          64   // Can5 only be set to 64 
  `define SPI_CHAR_LEN_BITS5     6
`endif
`ifdef SPI_MAX_CHAR_325
  `define SPI_MAX_CHAR5          32   // Can5 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS5     5
`endif
`ifdef SPI_MAX_CHAR_245
  `define SPI_MAX_CHAR5          24   // Can5 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS5     5
`endif
`ifdef SPI_MAX_CHAR_165
  `define SPI_MAX_CHAR5          16   // Can5 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS5     4
`endif
`ifdef SPI_MAX_CHAR_85
  `define SPI_MAX_CHAR5          8    // Can5 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS5     3
`endif

//
// Number5 of device5 select5 signals5. Use SPI_SS_NB5 for fine5 tuning5 the 
// exact5 number5.
//
`define SPI_SS_NB_85
//`define SPI_SS_NB_165
//`define SPI_SS_NB_245
//`define SPI_SS_NB_325

`ifdef SPI_SS_NB_85
  `define SPI_SS_NB5             8    // Can5 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_165
  `define SPI_SS_NB5             16   // Can5 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_245
  `define SPI_SS_NB5             24   // Can5 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_325
  `define SPI_SS_NB5             32   // Can5 be set from 25 to 32
`endif

//
// Bits5 of WISHBONE5 address used for partial5 decoding5 of SPI5 registers.
//
`define SPI_OFS_BITS5	          4:2

//
// Register offset
//
`define SPI_RX_05                0
`define SPI_RX_15                1
`define SPI_RX_25                2
`define SPI_RX_35                3
`define SPI_TX_05                0
`define SPI_TX_15                1
`define SPI_TX_25                2
`define SPI_TX_35                3
`define SPI_CTRL5                4
`define SPI_DEVIDE5              5
`define SPI_SS5                  6

//
// Number5 of bits in ctrl5 register
//
`define SPI_CTRL_BIT_NB5         14

//
// Control5 register bit position5
//
`define SPI_CTRL_ASS5            13
`define SPI_CTRL_IE5             12
`define SPI_CTRL_LSB5            11
`define SPI_CTRL_TX_NEGEDGE5     10
`define SPI_CTRL_RX_NEGEDGE5     9
`define SPI_CTRL_GO5             8
`define SPI_CTRL_RES_15          7
`define SPI_CTRL_CHAR_LEN5       6:0


//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define11.v                                                ////
////                                                              ////
////  This11 file is part of the SPI11 IP11 core11 project11                ////
////  http11://www11.opencores11.org11/projects11/spi11/                      ////
////                                                              ////
////  Author11(s):                                                  ////
////      - Simon11 Srot11 (simons11@opencores11.org11)                     ////
////                                                              ////
////  All additional11 information is avaliable11 in the Readme11.txt11   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2002 Authors11                                   ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number11 of bits used for devider11 register. If11 used in system with
// low11 frequency11 of system clock11 this can be reduced11.
// Use SPI_DIVIDER_LEN11 for fine11 tuning11 theexact11 number11.
//
//`define SPI_DIVIDER_LEN_811
`define SPI_DIVIDER_LEN_1611
//`define SPI_DIVIDER_LEN_2411
//`define SPI_DIVIDER_LEN_3211

`ifdef SPI_DIVIDER_LEN_811
  `define SPI_DIVIDER_LEN11       8    // Can11 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1611                                       
  `define SPI_DIVIDER_LEN11       16   // Can11 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2411                                       
  `define SPI_DIVIDER_LEN11       24   // Can11 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3211                                       
  `define SPI_DIVIDER_LEN11       32   // Can11 be set from 25 to 32 
`endif

//
// Maximum11 nuber11 of bits that can be send/received11 at once11. 
// Use SPI_MAX_CHAR11 for fine11 tuning11 the exact11 number11, when using
// SPI_MAX_CHAR_3211, SPI_MAX_CHAR_2411, SPI_MAX_CHAR_1611, SPI_MAX_CHAR_811.
//
`define SPI_MAX_CHAR_12811
//`define SPI_MAX_CHAR_6411
//`define SPI_MAX_CHAR_3211
//`define SPI_MAX_CHAR_2411
//`define SPI_MAX_CHAR_1611
//`define SPI_MAX_CHAR_811

`ifdef SPI_MAX_CHAR_12811
  `define SPI_MAX_CHAR11          128  // Can11 only be set to 128 
  `define SPI_CHAR_LEN_BITS11     7
`endif
`ifdef SPI_MAX_CHAR_6411
  `define SPI_MAX_CHAR11          64   // Can11 only be set to 64 
  `define SPI_CHAR_LEN_BITS11     6
`endif
`ifdef SPI_MAX_CHAR_3211
  `define SPI_MAX_CHAR11          32   // Can11 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS11     5
`endif
`ifdef SPI_MAX_CHAR_2411
  `define SPI_MAX_CHAR11          24   // Can11 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS11     5
`endif
`ifdef SPI_MAX_CHAR_1611
  `define SPI_MAX_CHAR11          16   // Can11 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS11     4
`endif
`ifdef SPI_MAX_CHAR_811
  `define SPI_MAX_CHAR11          8    // Can11 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS11     3
`endif

//
// Number11 of device11 select11 signals11. Use SPI_SS_NB11 for fine11 tuning11 the 
// exact11 number11.
//
`define SPI_SS_NB_811
//`define SPI_SS_NB_1611
//`define SPI_SS_NB_2411
//`define SPI_SS_NB_3211

`ifdef SPI_SS_NB_811
  `define SPI_SS_NB11             8    // Can11 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1611
  `define SPI_SS_NB11             16   // Can11 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2411
  `define SPI_SS_NB11             24   // Can11 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3211
  `define SPI_SS_NB11             32   // Can11 be set from 25 to 32
`endif

//
// Bits11 of WISHBONE11 address used for partial11 decoding11 of SPI11 registers.
//
`define SPI_OFS_BITS11	          4:2

//
// Register offset
//
`define SPI_RX_011                0
`define SPI_RX_111                1
`define SPI_RX_211                2
`define SPI_RX_311                3
`define SPI_TX_011                0
`define SPI_TX_111                1
`define SPI_TX_211                2
`define SPI_TX_311                3
`define SPI_CTRL11                4
`define SPI_DEVIDE11              5
`define SPI_SS11                  6

//
// Number11 of bits in ctrl11 register
//
`define SPI_CTRL_BIT_NB11         14

//
// Control11 register bit position11
//
`define SPI_CTRL_ASS11            13
`define SPI_CTRL_IE11             12
`define SPI_CTRL_LSB11            11
`define SPI_CTRL_TX_NEGEDGE11     10
`define SPI_CTRL_RX_NEGEDGE11     9
`define SPI_CTRL_GO11             8
`define SPI_CTRL_RES_111          7
`define SPI_CTRL_CHAR_LEN11       6:0


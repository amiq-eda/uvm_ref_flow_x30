//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define28.v                                                ////
////                                                              ////
////  This28 file is part of the SPI28 IP28 core28 project28                ////
////  http28://www28.opencores28.org28/projects28/spi28/                      ////
////                                                              ////
////  Author28(s):                                                  ////
////      - Simon28 Srot28 (simons28@opencores28.org28)                     ////
////                                                              ////
////  All additional28 information is avaliable28 in the Readme28.txt28   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2002 Authors28                                   ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number28 of bits used for devider28 register. If28 used in system with
// low28 frequency28 of system clock28 this can be reduced28.
// Use SPI_DIVIDER_LEN28 for fine28 tuning28 theexact28 number28.
//
//`define SPI_DIVIDER_LEN_828
`define SPI_DIVIDER_LEN_1628
//`define SPI_DIVIDER_LEN_2428
//`define SPI_DIVIDER_LEN_3228

`ifdef SPI_DIVIDER_LEN_828
  `define SPI_DIVIDER_LEN28       8    // Can28 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1628                                       
  `define SPI_DIVIDER_LEN28       16   // Can28 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2428                                       
  `define SPI_DIVIDER_LEN28       24   // Can28 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3228                                       
  `define SPI_DIVIDER_LEN28       32   // Can28 be set from 25 to 32 
`endif

//
// Maximum28 nuber28 of bits that can be send/received28 at once28. 
// Use SPI_MAX_CHAR28 for fine28 tuning28 the exact28 number28, when using
// SPI_MAX_CHAR_3228, SPI_MAX_CHAR_2428, SPI_MAX_CHAR_1628, SPI_MAX_CHAR_828.
//
`define SPI_MAX_CHAR_12828
//`define SPI_MAX_CHAR_6428
//`define SPI_MAX_CHAR_3228
//`define SPI_MAX_CHAR_2428
//`define SPI_MAX_CHAR_1628
//`define SPI_MAX_CHAR_828

`ifdef SPI_MAX_CHAR_12828
  `define SPI_MAX_CHAR28          128  // Can28 only be set to 128 
  `define SPI_CHAR_LEN_BITS28     7
`endif
`ifdef SPI_MAX_CHAR_6428
  `define SPI_MAX_CHAR28          64   // Can28 only be set to 64 
  `define SPI_CHAR_LEN_BITS28     6
`endif
`ifdef SPI_MAX_CHAR_3228
  `define SPI_MAX_CHAR28          32   // Can28 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS28     5
`endif
`ifdef SPI_MAX_CHAR_2428
  `define SPI_MAX_CHAR28          24   // Can28 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS28     5
`endif
`ifdef SPI_MAX_CHAR_1628
  `define SPI_MAX_CHAR28          16   // Can28 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS28     4
`endif
`ifdef SPI_MAX_CHAR_828
  `define SPI_MAX_CHAR28          8    // Can28 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS28     3
`endif

//
// Number28 of device28 select28 signals28. Use SPI_SS_NB28 for fine28 tuning28 the 
// exact28 number28.
//
`define SPI_SS_NB_828
//`define SPI_SS_NB_1628
//`define SPI_SS_NB_2428
//`define SPI_SS_NB_3228

`ifdef SPI_SS_NB_828
  `define SPI_SS_NB28             8    // Can28 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1628
  `define SPI_SS_NB28             16   // Can28 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2428
  `define SPI_SS_NB28             24   // Can28 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3228
  `define SPI_SS_NB28             32   // Can28 be set from 25 to 32
`endif

//
// Bits28 of WISHBONE28 address used for partial28 decoding28 of SPI28 registers.
//
`define SPI_OFS_BITS28	          4:2

//
// Register offset
//
`define SPI_RX_028                0
`define SPI_RX_128                1
`define SPI_RX_228                2
`define SPI_RX_328                3
`define SPI_TX_028                0
`define SPI_TX_128                1
`define SPI_TX_228                2
`define SPI_TX_328                3
`define SPI_CTRL28                4
`define SPI_DEVIDE28              5
`define SPI_SS28                  6

//
// Number28 of bits in ctrl28 register
//
`define SPI_CTRL_BIT_NB28         14

//
// Control28 register bit position28
//
`define SPI_CTRL_ASS28            13
`define SPI_CTRL_IE28             12
`define SPI_CTRL_LSB28            11
`define SPI_CTRL_TX_NEGEDGE28     10
`define SPI_CTRL_RX_NEGEDGE28     9
`define SPI_CTRL_GO28             8
`define SPI_CTRL_RES_128          7
`define SPI_CTRL_CHAR_LEN28       6:0


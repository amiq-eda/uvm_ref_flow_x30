//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define12.v                                                ////
////                                                              ////
////  This12 file is part of the SPI12 IP12 core12 project12                ////
////  http12://www12.opencores12.org12/projects12/spi12/                      ////
////                                                              ////
////  Author12(s):                                                  ////
////      - Simon12 Srot12 (simons12@opencores12.org12)                     ////
////                                                              ////
////  All additional12 information is avaliable12 in the Readme12.txt12   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright12 (C) 2002 Authors12                                   ////
////                                                              ////
//// This12 source12 file may be used and distributed12 without         ////
//// restriction12 provided that this copyright12 statement12 is not    ////
//// removed from the file and that any derivative12 work12 contains12  ////
//// the original copyright12 notice12 and the associated disclaimer12. ////
////                                                              ////
//// This12 source12 file is free software12; you can redistribute12 it   ////
//// and/or modify it under the terms12 of the GNU12 Lesser12 General12   ////
//// Public12 License12 as published12 by the Free12 Software12 Foundation12; ////
//// either12 version12 2.1 of the License12, or (at your12 option) any   ////
//// later12 version12.                                               ////
////                                                              ////
//// This12 source12 is distributed12 in the hope12 that it will be       ////
//// useful12, but WITHOUT12 ANY12 WARRANTY12; without even12 the implied12   ////
//// warranty12 of MERCHANTABILITY12 or FITNESS12 FOR12 A PARTICULAR12      ////
//// PURPOSE12.  See the GNU12 Lesser12 General12 Public12 License12 for more ////
//// details12.                                                     ////
////                                                              ////
//// You should have received12 a copy of the GNU12 Lesser12 General12    ////
//// Public12 License12 along12 with this source12; if not, download12 it   ////
//// from http12://www12.opencores12.org12/lgpl12.shtml12                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number12 of bits used for devider12 register. If12 used in system with
// low12 frequency12 of system clock12 this can be reduced12.
// Use SPI_DIVIDER_LEN12 for fine12 tuning12 theexact12 number12.
//
//`define SPI_DIVIDER_LEN_812
`define SPI_DIVIDER_LEN_1612
//`define SPI_DIVIDER_LEN_2412
//`define SPI_DIVIDER_LEN_3212

`ifdef SPI_DIVIDER_LEN_812
  `define SPI_DIVIDER_LEN12       8    // Can12 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1612                                       
  `define SPI_DIVIDER_LEN12       16   // Can12 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2412                                       
  `define SPI_DIVIDER_LEN12       24   // Can12 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3212                                       
  `define SPI_DIVIDER_LEN12       32   // Can12 be set from 25 to 32 
`endif

//
// Maximum12 nuber12 of bits that can be send/received12 at once12. 
// Use SPI_MAX_CHAR12 for fine12 tuning12 the exact12 number12, when using
// SPI_MAX_CHAR_3212, SPI_MAX_CHAR_2412, SPI_MAX_CHAR_1612, SPI_MAX_CHAR_812.
//
`define SPI_MAX_CHAR_12812
//`define SPI_MAX_CHAR_6412
//`define SPI_MAX_CHAR_3212
//`define SPI_MAX_CHAR_2412
//`define SPI_MAX_CHAR_1612
//`define SPI_MAX_CHAR_812

`ifdef SPI_MAX_CHAR_12812
  `define SPI_MAX_CHAR12          128  // Can12 only be set to 128 
  `define SPI_CHAR_LEN_BITS12     7
`endif
`ifdef SPI_MAX_CHAR_6412
  `define SPI_MAX_CHAR12          64   // Can12 only be set to 64 
  `define SPI_CHAR_LEN_BITS12     6
`endif
`ifdef SPI_MAX_CHAR_3212
  `define SPI_MAX_CHAR12          32   // Can12 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS12     5
`endif
`ifdef SPI_MAX_CHAR_2412
  `define SPI_MAX_CHAR12          24   // Can12 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS12     5
`endif
`ifdef SPI_MAX_CHAR_1612
  `define SPI_MAX_CHAR12          16   // Can12 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS12     4
`endif
`ifdef SPI_MAX_CHAR_812
  `define SPI_MAX_CHAR12          8    // Can12 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS12     3
`endif

//
// Number12 of device12 select12 signals12. Use SPI_SS_NB12 for fine12 tuning12 the 
// exact12 number12.
//
`define SPI_SS_NB_812
//`define SPI_SS_NB_1612
//`define SPI_SS_NB_2412
//`define SPI_SS_NB_3212

`ifdef SPI_SS_NB_812
  `define SPI_SS_NB12             8    // Can12 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1612
  `define SPI_SS_NB12             16   // Can12 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2412
  `define SPI_SS_NB12             24   // Can12 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3212
  `define SPI_SS_NB12             32   // Can12 be set from 25 to 32
`endif

//
// Bits12 of WISHBONE12 address used for partial12 decoding12 of SPI12 registers.
//
`define SPI_OFS_BITS12	          4:2

//
// Register offset
//
`define SPI_RX_012                0
`define SPI_RX_112                1
`define SPI_RX_212                2
`define SPI_RX_312                3
`define SPI_TX_012                0
`define SPI_TX_112                1
`define SPI_TX_212                2
`define SPI_TX_312                3
`define SPI_CTRL12                4
`define SPI_DEVIDE12              5
`define SPI_SS12                  6

//
// Number12 of bits in ctrl12 register
//
`define SPI_CTRL_BIT_NB12         14

//
// Control12 register bit position12
//
`define SPI_CTRL_ASS12            13
`define SPI_CTRL_IE12             12
`define SPI_CTRL_LSB12            11
`define SPI_CTRL_TX_NEGEDGE12     10
`define SPI_CTRL_RX_NEGEDGE12     9
`define SPI_CTRL_GO12             8
`define SPI_CTRL_RES_112          7
`define SPI_CTRL_CHAR_LEN12       6:0


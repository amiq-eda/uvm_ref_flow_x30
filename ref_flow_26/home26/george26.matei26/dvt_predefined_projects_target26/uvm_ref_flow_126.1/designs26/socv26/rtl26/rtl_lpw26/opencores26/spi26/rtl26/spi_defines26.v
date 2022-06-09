//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define26.v                                                ////
////                                                              ////
////  This26 file is part of the SPI26 IP26 core26 project26                ////
////  http26://www26.opencores26.org26/projects26/spi26/                      ////
////                                                              ////
////  Author26(s):                                                  ////
////      - Simon26 Srot26 (simons26@opencores26.org26)                     ////
////                                                              ////
////  All additional26 information is avaliable26 in the Readme26.txt26   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2002 Authors26                                   ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number26 of bits used for devider26 register. If26 used in system with
// low26 frequency26 of system clock26 this can be reduced26.
// Use SPI_DIVIDER_LEN26 for fine26 tuning26 theexact26 number26.
//
//`define SPI_DIVIDER_LEN_826
`define SPI_DIVIDER_LEN_1626
//`define SPI_DIVIDER_LEN_2426
//`define SPI_DIVIDER_LEN_3226

`ifdef SPI_DIVIDER_LEN_826
  `define SPI_DIVIDER_LEN26       8    // Can26 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1626                                       
  `define SPI_DIVIDER_LEN26       16   // Can26 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2426                                       
  `define SPI_DIVIDER_LEN26       24   // Can26 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3226                                       
  `define SPI_DIVIDER_LEN26       32   // Can26 be set from 25 to 32 
`endif

//
// Maximum26 nuber26 of bits that can be send/received26 at once26. 
// Use SPI_MAX_CHAR26 for fine26 tuning26 the exact26 number26, when using
// SPI_MAX_CHAR_3226, SPI_MAX_CHAR_2426, SPI_MAX_CHAR_1626, SPI_MAX_CHAR_826.
//
`define SPI_MAX_CHAR_12826
//`define SPI_MAX_CHAR_6426
//`define SPI_MAX_CHAR_3226
//`define SPI_MAX_CHAR_2426
//`define SPI_MAX_CHAR_1626
//`define SPI_MAX_CHAR_826

`ifdef SPI_MAX_CHAR_12826
  `define SPI_MAX_CHAR26          128  // Can26 only be set to 128 
  `define SPI_CHAR_LEN_BITS26     7
`endif
`ifdef SPI_MAX_CHAR_6426
  `define SPI_MAX_CHAR26          64   // Can26 only be set to 64 
  `define SPI_CHAR_LEN_BITS26     6
`endif
`ifdef SPI_MAX_CHAR_3226
  `define SPI_MAX_CHAR26          32   // Can26 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS26     5
`endif
`ifdef SPI_MAX_CHAR_2426
  `define SPI_MAX_CHAR26          24   // Can26 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS26     5
`endif
`ifdef SPI_MAX_CHAR_1626
  `define SPI_MAX_CHAR26          16   // Can26 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS26     4
`endif
`ifdef SPI_MAX_CHAR_826
  `define SPI_MAX_CHAR26          8    // Can26 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS26     3
`endif

//
// Number26 of device26 select26 signals26. Use SPI_SS_NB26 for fine26 tuning26 the 
// exact26 number26.
//
`define SPI_SS_NB_826
//`define SPI_SS_NB_1626
//`define SPI_SS_NB_2426
//`define SPI_SS_NB_3226

`ifdef SPI_SS_NB_826
  `define SPI_SS_NB26             8    // Can26 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1626
  `define SPI_SS_NB26             16   // Can26 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2426
  `define SPI_SS_NB26             24   // Can26 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3226
  `define SPI_SS_NB26             32   // Can26 be set from 25 to 32
`endif

//
// Bits26 of WISHBONE26 address used for partial26 decoding26 of SPI26 registers.
//
`define SPI_OFS_BITS26	          4:2

//
// Register offset
//
`define SPI_RX_026                0
`define SPI_RX_126                1
`define SPI_RX_226                2
`define SPI_RX_326                3
`define SPI_TX_026                0
`define SPI_TX_126                1
`define SPI_TX_226                2
`define SPI_TX_326                3
`define SPI_CTRL26                4
`define SPI_DEVIDE26              5
`define SPI_SS26                  6

//
// Number26 of bits in ctrl26 register
//
`define SPI_CTRL_BIT_NB26         14

//
// Control26 register bit position26
//
`define SPI_CTRL_ASS26            13
`define SPI_CTRL_IE26             12
`define SPI_CTRL_LSB26            11
`define SPI_CTRL_TX_NEGEDGE26     10
`define SPI_CTRL_RX_NEGEDGE26     9
`define SPI_CTRL_GO26             8
`define SPI_CTRL_RES_126          7
`define SPI_CTRL_CHAR_LEN26       6:0


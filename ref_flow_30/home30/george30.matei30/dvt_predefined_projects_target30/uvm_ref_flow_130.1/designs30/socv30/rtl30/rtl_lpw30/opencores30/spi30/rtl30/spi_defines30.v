//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define30.v                                                ////
////                                                              ////
////  This30 file is part of the SPI30 IP30 core30 project30                ////
////  http30://www30.opencores30.org30/projects30/spi30/                      ////
////                                                              ////
////  Author30(s):                                                  ////
////      - Simon30 Srot30 (simons30@opencores30.org30)                     ////
////                                                              ////
////  All additional30 information is avaliable30 in the Readme30.txt30   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2002 Authors30                                   ////
////                                                              ////
//// This30 source30 file may be used and distributed30 without         ////
//// restriction30 provided that this copyright30 statement30 is not    ////
//// removed from the file and that any derivative30 work30 contains30  ////
//// the original copyright30 notice30 and the associated disclaimer30. ////
////                                                              ////
//// This30 source30 file is free software30; you can redistribute30 it   ////
//// and/or modify it under the terms30 of the GNU30 Lesser30 General30   ////
//// Public30 License30 as published30 by the Free30 Software30 Foundation30; ////
//// either30 version30 2.1 of the License30, or (at your30 option) any   ////
//// later30 version30.                                               ////
////                                                              ////
//// This30 source30 is distributed30 in the hope30 that it will be       ////
//// useful30, but WITHOUT30 ANY30 WARRANTY30; without even30 the implied30   ////
//// warranty30 of MERCHANTABILITY30 or FITNESS30 FOR30 A PARTICULAR30      ////
//// PURPOSE30.  See the GNU30 Lesser30 General30 Public30 License30 for more ////
//// details30.                                                     ////
////                                                              ////
//// You should have received30 a copy of the GNU30 Lesser30 General30    ////
//// Public30 License30 along30 with this source30; if not, download30 it   ////
//// from http30://www30.opencores30.org30/lgpl30.shtml30                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number30 of bits used for devider30 register. If30 used in system with
// low30 frequency30 of system clock30 this can be reduced30.
// Use SPI_DIVIDER_LEN30 for fine30 tuning30 theexact30 number30.
//
//`define SPI_DIVIDER_LEN_830
`define SPI_DIVIDER_LEN_1630
//`define SPI_DIVIDER_LEN_2430
//`define SPI_DIVIDER_LEN_3230

`ifdef SPI_DIVIDER_LEN_830
  `define SPI_DIVIDER_LEN30       8    // Can30 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1630                                       
  `define SPI_DIVIDER_LEN30       16   // Can30 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2430                                       
  `define SPI_DIVIDER_LEN30       24   // Can30 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3230                                       
  `define SPI_DIVIDER_LEN30       32   // Can30 be set from 25 to 32 
`endif

//
// Maximum30 nuber30 of bits that can be send/received30 at once30. 
// Use SPI_MAX_CHAR30 for fine30 tuning30 the exact30 number30, when using
// SPI_MAX_CHAR_3230, SPI_MAX_CHAR_2430, SPI_MAX_CHAR_1630, SPI_MAX_CHAR_830.
//
`define SPI_MAX_CHAR_12830
//`define SPI_MAX_CHAR_6430
//`define SPI_MAX_CHAR_3230
//`define SPI_MAX_CHAR_2430
//`define SPI_MAX_CHAR_1630
//`define SPI_MAX_CHAR_830

`ifdef SPI_MAX_CHAR_12830
  `define SPI_MAX_CHAR30          128  // Can30 only be set to 128 
  `define SPI_CHAR_LEN_BITS30     7
`endif
`ifdef SPI_MAX_CHAR_6430
  `define SPI_MAX_CHAR30          64   // Can30 only be set to 64 
  `define SPI_CHAR_LEN_BITS30     6
`endif
`ifdef SPI_MAX_CHAR_3230
  `define SPI_MAX_CHAR30          32   // Can30 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS30     5
`endif
`ifdef SPI_MAX_CHAR_2430
  `define SPI_MAX_CHAR30          24   // Can30 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS30     5
`endif
`ifdef SPI_MAX_CHAR_1630
  `define SPI_MAX_CHAR30          16   // Can30 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS30     4
`endif
`ifdef SPI_MAX_CHAR_830
  `define SPI_MAX_CHAR30          8    // Can30 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS30     3
`endif

//
// Number30 of device30 select30 signals30. Use SPI_SS_NB30 for fine30 tuning30 the 
// exact30 number30.
//
`define SPI_SS_NB_830
//`define SPI_SS_NB_1630
//`define SPI_SS_NB_2430
//`define SPI_SS_NB_3230

`ifdef SPI_SS_NB_830
  `define SPI_SS_NB30             8    // Can30 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1630
  `define SPI_SS_NB30             16   // Can30 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2430
  `define SPI_SS_NB30             24   // Can30 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3230
  `define SPI_SS_NB30             32   // Can30 be set from 25 to 32
`endif

//
// Bits30 of WISHBONE30 address used for partial30 decoding30 of SPI30 registers.
//
`define SPI_OFS_BITS30	          4:2

//
// Register offset
//
`define SPI_RX_030                0
`define SPI_RX_130                1
`define SPI_RX_230                2
`define SPI_RX_330                3
`define SPI_TX_030                0
`define SPI_TX_130                1
`define SPI_TX_230                2
`define SPI_TX_330                3
`define SPI_CTRL30                4
`define SPI_DEVIDE30              5
`define SPI_SS30                  6

//
// Number30 of bits in ctrl30 register
//
`define SPI_CTRL_BIT_NB30         14

//
// Control30 register bit position30
//
`define SPI_CTRL_ASS30            13
`define SPI_CTRL_IE30             12
`define SPI_CTRL_LSB30            11
`define SPI_CTRL_TX_NEGEDGE30     10
`define SPI_CTRL_RX_NEGEDGE30     9
`define SPI_CTRL_GO30             8
`define SPI_CTRL_RES_130          7
`define SPI_CTRL_CHAR_LEN30       6:0


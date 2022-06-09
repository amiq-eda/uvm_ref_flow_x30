/*-------------------------------------------------------------------------
File16 name   : spi_pkg16.sv
Title16       : Package16 for SPI16 OVC16
Project16     :
Created16     :
Description16 : 
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH16
`define SPI_PKG_SVH16

package spi_pkg16;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class16 Forward16 Declarations16        //
//////////////////////////////////////////////////

typedef class spi_agent16;
typedef class spi_csr16;
typedef class spi_driver16;
typedef class spi_env16;
typedef class spi_monitor16;
typedef class trans_seq16;
typedef class spi_incr_payload16;
typedef class spi_sequencer16;
typedef class spi_transfer16;

//////////////////////////////////////////////////
//              Include16 files                   //
//////////////////////////////////////////////////
`include "spi_csr16.sv"
`include "spi_transfer16.sv"
`include "spi_config16.sv"

`include "spi_monitor16.sv"
`include "spi_sequencer16.sv"
`include "spi_driver16.sv"
`include "spi_agent16.sv"

`include "spi_env16.sv"

`include "spi_seq_lib16.sv"

endpackage : spi_pkg16
`endif

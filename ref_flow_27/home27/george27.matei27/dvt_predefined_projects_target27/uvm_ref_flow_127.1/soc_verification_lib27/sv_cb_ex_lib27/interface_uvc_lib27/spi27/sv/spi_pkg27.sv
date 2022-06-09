/*-------------------------------------------------------------------------
File27 name   : spi_pkg27.sv
Title27       : Package27 for SPI27 OVC27
Project27     :
Created27     :
Description27 : 
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH27
`define SPI_PKG_SVH27

package spi_pkg27;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class27 Forward27 Declarations27        //
//////////////////////////////////////////////////

typedef class spi_agent27;
typedef class spi_csr27;
typedef class spi_driver27;
typedef class spi_env27;
typedef class spi_monitor27;
typedef class trans_seq27;
typedef class spi_incr_payload27;
typedef class spi_sequencer27;
typedef class spi_transfer27;

//////////////////////////////////////////////////
//              Include27 files                   //
//////////////////////////////////////////////////
`include "spi_csr27.sv"
`include "spi_transfer27.sv"
`include "spi_config27.sv"

`include "spi_monitor27.sv"
`include "spi_sequencer27.sv"
`include "spi_driver27.sv"
`include "spi_agent27.sv"

`include "spi_env27.sv"

`include "spi_seq_lib27.sv"

endpackage : spi_pkg27
`endif

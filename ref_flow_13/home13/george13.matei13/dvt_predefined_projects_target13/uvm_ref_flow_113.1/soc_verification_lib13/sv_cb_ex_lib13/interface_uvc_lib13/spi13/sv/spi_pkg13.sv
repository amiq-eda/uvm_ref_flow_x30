/*-------------------------------------------------------------------------
File13 name   : spi_pkg13.sv
Title13       : Package13 for SPI13 OVC13
Project13     :
Created13     :
Description13 : 
Notes13       :  
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH13
`define SPI_PKG_SVH13

package spi_pkg13;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class13 Forward13 Declarations13        //
//////////////////////////////////////////////////

typedef class spi_agent13;
typedef class spi_csr13;
typedef class spi_driver13;
typedef class spi_env13;
typedef class spi_monitor13;
typedef class trans_seq13;
typedef class spi_incr_payload13;
typedef class spi_sequencer13;
typedef class spi_transfer13;

//////////////////////////////////////////////////
//              Include13 files                   //
//////////////////////////////////////////////////
`include "spi_csr13.sv"
`include "spi_transfer13.sv"
`include "spi_config13.sv"

`include "spi_monitor13.sv"
`include "spi_sequencer13.sv"
`include "spi_driver13.sv"
`include "spi_agent13.sv"

`include "spi_env13.sv"

`include "spi_seq_lib13.sv"

endpackage : spi_pkg13
`endif

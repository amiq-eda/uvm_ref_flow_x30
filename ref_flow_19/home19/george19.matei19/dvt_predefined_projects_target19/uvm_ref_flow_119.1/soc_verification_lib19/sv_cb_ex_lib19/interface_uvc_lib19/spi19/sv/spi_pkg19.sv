/*-------------------------------------------------------------------------
File19 name   : spi_pkg19.sv
Title19       : Package19 for SPI19 OVC19
Project19     :
Created19     :
Description19 : 
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH19
`define SPI_PKG_SVH19

package spi_pkg19;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class19 Forward19 Declarations19        //
//////////////////////////////////////////////////

typedef class spi_agent19;
typedef class spi_csr19;
typedef class spi_driver19;
typedef class spi_env19;
typedef class spi_monitor19;
typedef class trans_seq19;
typedef class spi_incr_payload19;
typedef class spi_sequencer19;
typedef class spi_transfer19;

//////////////////////////////////////////////////
//              Include19 files                   //
//////////////////////////////////////////////////
`include "spi_csr19.sv"
`include "spi_transfer19.sv"
`include "spi_config19.sv"

`include "spi_monitor19.sv"
`include "spi_sequencer19.sv"
`include "spi_driver19.sv"
`include "spi_agent19.sv"

`include "spi_env19.sv"

`include "spi_seq_lib19.sv"

endpackage : spi_pkg19
`endif

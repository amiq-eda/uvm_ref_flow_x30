/*-------------------------------------------------------------------------
File11 name   : spi_pkg11.sv
Title11       : Package11 for SPI11 OVC11
Project11     :
Created11     :
Description11 : 
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH11
`define SPI_PKG_SVH11

package spi_pkg11;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class11 Forward11 Declarations11        //
//////////////////////////////////////////////////

typedef class spi_agent11;
typedef class spi_csr11;
typedef class spi_driver11;
typedef class spi_env11;
typedef class spi_monitor11;
typedef class trans_seq11;
typedef class spi_incr_payload11;
typedef class spi_sequencer11;
typedef class spi_transfer11;

//////////////////////////////////////////////////
//              Include11 files                   //
//////////////////////////////////////////////////
`include "spi_csr11.sv"
`include "spi_transfer11.sv"
`include "spi_config11.sv"

`include "spi_monitor11.sv"
`include "spi_sequencer11.sv"
`include "spi_driver11.sv"
`include "spi_agent11.sv"

`include "spi_env11.sv"

`include "spi_seq_lib11.sv"

endpackage : spi_pkg11
`endif

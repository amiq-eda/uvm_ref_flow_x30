/*-------------------------------------------------------------------------
File23 name   : spi_pkg23.sv
Title23       : Package23 for SPI23 OVC23
Project23     :
Created23     :
Description23 : 
Notes23       :  
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH23
`define SPI_PKG_SVH23

package spi_pkg23;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class23 Forward23 Declarations23        //
//////////////////////////////////////////////////

typedef class spi_agent23;
typedef class spi_csr23;
typedef class spi_driver23;
typedef class spi_env23;
typedef class spi_monitor23;
typedef class trans_seq23;
typedef class spi_incr_payload23;
typedef class spi_sequencer23;
typedef class spi_transfer23;

//////////////////////////////////////////////////
//              Include23 files                   //
//////////////////////////////////////////////////
`include "spi_csr23.sv"
`include "spi_transfer23.sv"
`include "spi_config23.sv"

`include "spi_monitor23.sv"
`include "spi_sequencer23.sv"
`include "spi_driver23.sv"
`include "spi_agent23.sv"

`include "spi_env23.sv"

`include "spi_seq_lib23.sv"

endpackage : spi_pkg23
`endif

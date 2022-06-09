/*-------------------------------------------------------------------------
File21 name   : spi_pkg21.sv
Title21       : Package21 for SPI21 OVC21
Project21     :
Created21     :
Description21 : 
Notes21       :  
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH21
`define SPI_PKG_SVH21

package spi_pkg21;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class21 Forward21 Declarations21        //
//////////////////////////////////////////////////

typedef class spi_agent21;
typedef class spi_csr21;
typedef class spi_driver21;
typedef class spi_env21;
typedef class spi_monitor21;
typedef class trans_seq21;
typedef class spi_incr_payload21;
typedef class spi_sequencer21;
typedef class spi_transfer21;

//////////////////////////////////////////////////
//              Include21 files                   //
//////////////////////////////////////////////////
`include "spi_csr21.sv"
`include "spi_transfer21.sv"
`include "spi_config21.sv"

`include "spi_monitor21.sv"
`include "spi_sequencer21.sv"
`include "spi_driver21.sv"
`include "spi_agent21.sv"

`include "spi_env21.sv"

`include "spi_seq_lib21.sv"

endpackage : spi_pkg21
`endif

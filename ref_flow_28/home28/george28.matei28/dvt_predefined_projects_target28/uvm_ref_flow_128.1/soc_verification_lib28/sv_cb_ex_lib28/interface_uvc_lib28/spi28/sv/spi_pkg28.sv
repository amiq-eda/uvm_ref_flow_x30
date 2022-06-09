/*-------------------------------------------------------------------------
File28 name   : spi_pkg28.sv
Title28       : Package28 for SPI28 OVC28
Project28     :
Created28     :
Description28 : 
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH28
`define SPI_PKG_SVH28

package spi_pkg28;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class28 Forward28 Declarations28        //
//////////////////////////////////////////////////

typedef class spi_agent28;
typedef class spi_csr28;
typedef class spi_driver28;
typedef class spi_env28;
typedef class spi_monitor28;
typedef class trans_seq28;
typedef class spi_incr_payload28;
typedef class spi_sequencer28;
typedef class spi_transfer28;

//////////////////////////////////////////////////
//              Include28 files                   //
//////////////////////////////////////////////////
`include "spi_csr28.sv"
`include "spi_transfer28.sv"
`include "spi_config28.sv"

`include "spi_monitor28.sv"
`include "spi_sequencer28.sv"
`include "spi_driver28.sv"
`include "spi_agent28.sv"

`include "spi_env28.sv"

`include "spi_seq_lib28.sv"

endpackage : spi_pkg28
`endif

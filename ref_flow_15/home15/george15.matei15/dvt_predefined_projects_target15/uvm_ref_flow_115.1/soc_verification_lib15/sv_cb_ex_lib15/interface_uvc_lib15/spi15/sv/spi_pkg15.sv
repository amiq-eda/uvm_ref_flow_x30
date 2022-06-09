/*-------------------------------------------------------------------------
File15 name   : spi_pkg15.sv
Title15       : Package15 for SPI15 OVC15
Project15     :
Created15     :
Description15 : 
Notes15       :  
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH15
`define SPI_PKG_SVH15

package spi_pkg15;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class15 Forward15 Declarations15        //
//////////////////////////////////////////////////

typedef class spi_agent15;
typedef class spi_csr15;
typedef class spi_driver15;
typedef class spi_env15;
typedef class spi_monitor15;
typedef class trans_seq15;
typedef class spi_incr_payload15;
typedef class spi_sequencer15;
typedef class spi_transfer15;

//////////////////////////////////////////////////
//              Include15 files                   //
//////////////////////////////////////////////////
`include "spi_csr15.sv"
`include "spi_transfer15.sv"
`include "spi_config15.sv"

`include "spi_monitor15.sv"
`include "spi_sequencer15.sv"
`include "spi_driver15.sv"
`include "spi_agent15.sv"

`include "spi_env15.sv"

`include "spi_seq_lib15.sv"

endpackage : spi_pkg15
`endif

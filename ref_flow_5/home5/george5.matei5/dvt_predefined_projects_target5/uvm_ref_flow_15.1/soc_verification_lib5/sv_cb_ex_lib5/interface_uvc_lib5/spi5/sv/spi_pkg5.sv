/*-------------------------------------------------------------------------
File5 name   : spi_pkg5.sv
Title5       : Package5 for SPI5 OVC5
Project5     :
Created5     :
Description5 : 
Notes5       :  
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH5
`define SPI_PKG_SVH5

package spi_pkg5;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class5 Forward5 Declarations5        //
//////////////////////////////////////////////////

typedef class spi_agent5;
typedef class spi_csr5;
typedef class spi_driver5;
typedef class spi_env5;
typedef class spi_monitor5;
typedef class trans_seq5;
typedef class spi_incr_payload5;
typedef class spi_sequencer5;
typedef class spi_transfer5;

//////////////////////////////////////////////////
//              Include5 files                   //
//////////////////////////////////////////////////
`include "spi_csr5.sv"
`include "spi_transfer5.sv"
`include "spi_config5.sv"

`include "spi_monitor5.sv"
`include "spi_sequencer5.sv"
`include "spi_driver5.sv"
`include "spi_agent5.sv"

`include "spi_env5.sv"

`include "spi_seq_lib5.sv"

endpackage : spi_pkg5
`endif

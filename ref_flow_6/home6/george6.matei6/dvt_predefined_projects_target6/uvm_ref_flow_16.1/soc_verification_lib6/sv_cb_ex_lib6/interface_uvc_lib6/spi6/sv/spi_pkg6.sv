/*-------------------------------------------------------------------------
File6 name   : spi_pkg6.sv
Title6       : Package6 for SPI6 OVC6
Project6     :
Created6     :
Description6 : 
Notes6       :  
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH6
`define SPI_PKG_SVH6

package spi_pkg6;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class6 Forward6 Declarations6        //
//////////////////////////////////////////////////

typedef class spi_agent6;
typedef class spi_csr6;
typedef class spi_driver6;
typedef class spi_env6;
typedef class spi_monitor6;
typedef class trans_seq6;
typedef class spi_incr_payload6;
typedef class spi_sequencer6;
typedef class spi_transfer6;

//////////////////////////////////////////////////
//              Include6 files                   //
//////////////////////////////////////////////////
`include "spi_csr6.sv"
`include "spi_transfer6.sv"
`include "spi_config6.sv"

`include "spi_monitor6.sv"
`include "spi_sequencer6.sv"
`include "spi_driver6.sv"
`include "spi_agent6.sv"

`include "spi_env6.sv"

`include "spi_seq_lib6.sv"

endpackage : spi_pkg6
`endif

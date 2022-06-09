/*-------------------------------------------------------------------------
File29 name   : spi_pkg29.sv
Title29       : Package29 for SPI29 OVC29
Project29     :
Created29     :
Description29 : 
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH29
`define SPI_PKG_SVH29

package spi_pkg29;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class29 Forward29 Declarations29        //
//////////////////////////////////////////////////

typedef class spi_agent29;
typedef class spi_csr29;
typedef class spi_driver29;
typedef class spi_env29;
typedef class spi_monitor29;
typedef class trans_seq29;
typedef class spi_incr_payload29;
typedef class spi_sequencer29;
typedef class spi_transfer29;

//////////////////////////////////////////////////
//              Include29 files                   //
//////////////////////////////////////////////////
`include "spi_csr29.sv"
`include "spi_transfer29.sv"
`include "spi_config29.sv"

`include "spi_monitor29.sv"
`include "spi_sequencer29.sv"
`include "spi_driver29.sv"
`include "spi_agent29.sv"

`include "spi_env29.sv"

`include "spi_seq_lib29.sv"

endpackage : spi_pkg29
`endif

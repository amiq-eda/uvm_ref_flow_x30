/*-------------------------------------------------------------------------
File3 name   : spi_pkg3.sv
Title3       : Package3 for SPI3 OVC3
Project3     :
Created3     :
Description3 : 
Notes3       :  
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH3
`define SPI_PKG_SVH3

package spi_pkg3;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class3 Forward3 Declarations3        //
//////////////////////////////////////////////////

typedef class spi_agent3;
typedef class spi_csr3;
typedef class spi_driver3;
typedef class spi_env3;
typedef class spi_monitor3;
typedef class trans_seq3;
typedef class spi_incr_payload3;
typedef class spi_sequencer3;
typedef class spi_transfer3;

//////////////////////////////////////////////////
//              Include3 files                   //
//////////////////////////////////////////////////
`include "spi_csr3.sv"
`include "spi_transfer3.sv"
`include "spi_config3.sv"

`include "spi_monitor3.sv"
`include "spi_sequencer3.sv"
`include "spi_driver3.sv"
`include "spi_agent3.sv"

`include "spi_env3.sv"

`include "spi_seq_lib3.sv"

endpackage : spi_pkg3
`endif

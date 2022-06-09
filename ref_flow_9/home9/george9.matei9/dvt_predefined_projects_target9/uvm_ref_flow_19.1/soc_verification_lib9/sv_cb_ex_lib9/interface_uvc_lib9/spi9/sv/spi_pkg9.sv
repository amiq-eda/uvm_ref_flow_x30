/*-------------------------------------------------------------------------
File9 name   : spi_pkg9.sv
Title9       : Package9 for SPI9 OVC9
Project9     :
Created9     :
Description9 : 
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH9
`define SPI_PKG_SVH9

package spi_pkg9;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class9 Forward9 Declarations9        //
//////////////////////////////////////////////////

typedef class spi_agent9;
typedef class spi_csr9;
typedef class spi_driver9;
typedef class spi_env9;
typedef class spi_monitor9;
typedef class trans_seq9;
typedef class spi_incr_payload9;
typedef class spi_sequencer9;
typedef class spi_transfer9;

//////////////////////////////////////////////////
//              Include9 files                   //
//////////////////////////////////////////////////
`include "spi_csr9.sv"
`include "spi_transfer9.sv"
`include "spi_config9.sv"

`include "spi_monitor9.sv"
`include "spi_sequencer9.sv"
`include "spi_driver9.sv"
`include "spi_agent9.sv"

`include "spi_env9.sv"

`include "spi_seq_lib9.sv"

endpackage : spi_pkg9
`endif

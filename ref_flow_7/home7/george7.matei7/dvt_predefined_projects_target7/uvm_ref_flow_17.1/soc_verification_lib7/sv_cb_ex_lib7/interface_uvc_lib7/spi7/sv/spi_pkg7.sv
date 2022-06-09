/*-------------------------------------------------------------------------
File7 name   : spi_pkg7.sv
Title7       : Package7 for SPI7 OVC7
Project7     :
Created7     :
Description7 : 
Notes7       :  
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH7
`define SPI_PKG_SVH7

package spi_pkg7;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class7 Forward7 Declarations7        //
//////////////////////////////////////////////////

typedef class spi_agent7;
typedef class spi_csr7;
typedef class spi_driver7;
typedef class spi_env7;
typedef class spi_monitor7;
typedef class trans_seq7;
typedef class spi_incr_payload7;
typedef class spi_sequencer7;
typedef class spi_transfer7;

//////////////////////////////////////////////////
//              Include7 files                   //
//////////////////////////////////////////////////
`include "spi_csr7.sv"
`include "spi_transfer7.sv"
`include "spi_config7.sv"

`include "spi_monitor7.sv"
`include "spi_sequencer7.sv"
`include "spi_driver7.sv"
`include "spi_agent7.sv"

`include "spi_env7.sv"

`include "spi_seq_lib7.sv"

endpackage : spi_pkg7
`endif

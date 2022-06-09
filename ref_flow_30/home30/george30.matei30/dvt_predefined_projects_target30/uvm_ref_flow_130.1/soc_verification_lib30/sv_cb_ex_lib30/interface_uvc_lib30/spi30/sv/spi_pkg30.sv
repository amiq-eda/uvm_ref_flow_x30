/*-------------------------------------------------------------------------
File30 name   : spi_pkg30.sv
Title30       : Package30 for SPI30 OVC30
Project30     :
Created30     :
Description30 : 
Notes30       :  
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH30
`define SPI_PKG_SVH30

package spi_pkg30;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class30 Forward30 Declarations30        //
//////////////////////////////////////////////////

typedef class spi_agent30;
typedef class spi_csr30;
typedef class spi_driver30;
typedef class spi_env30;
typedef class spi_monitor30;
typedef class trans_seq30;
typedef class spi_incr_payload30;
typedef class spi_sequencer30;
typedef class spi_transfer30;

//////////////////////////////////////////////////
//              Include30 files                   //
//////////////////////////////////////////////////
`include "spi_csr30.sv"
`include "spi_transfer30.sv"
`include "spi_config30.sv"

`include "spi_monitor30.sv"
`include "spi_sequencer30.sv"
`include "spi_driver30.sv"
`include "spi_agent30.sv"

`include "spi_env30.sv"

`include "spi_seq_lib30.sv"

endpackage : spi_pkg30
`endif

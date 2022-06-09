/*-------------------------------------------------------------------------
File24 name   : spi_pkg24.sv
Title24       : Package24 for SPI24 OVC24
Project24     :
Created24     :
Description24 : 
Notes24       :  
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH24
`define SPI_PKG_SVH24

package spi_pkg24;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class24 Forward24 Declarations24        //
//////////////////////////////////////////////////

typedef class spi_agent24;
typedef class spi_csr24;
typedef class spi_driver24;
typedef class spi_env24;
typedef class spi_monitor24;
typedef class trans_seq24;
typedef class spi_incr_payload24;
typedef class spi_sequencer24;
typedef class spi_transfer24;

//////////////////////////////////////////////////
//              Include24 files                   //
//////////////////////////////////////////////////
`include "spi_csr24.sv"
`include "spi_transfer24.sv"
`include "spi_config24.sv"

`include "spi_monitor24.sv"
`include "spi_sequencer24.sv"
`include "spi_driver24.sv"
`include "spi_agent24.sv"

`include "spi_env24.sv"

`include "spi_seq_lib24.sv"

endpackage : spi_pkg24
`endif

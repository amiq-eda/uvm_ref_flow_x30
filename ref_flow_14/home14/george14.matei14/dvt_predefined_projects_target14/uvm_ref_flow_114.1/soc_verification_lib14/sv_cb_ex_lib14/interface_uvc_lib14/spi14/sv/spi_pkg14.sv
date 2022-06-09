/*-------------------------------------------------------------------------
File14 name   : spi_pkg14.sv
Title14       : Package14 for SPI14 OVC14
Project14     :
Created14     :
Description14 : 
Notes14       :  
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH14
`define SPI_PKG_SVH14

package spi_pkg14;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class14 Forward14 Declarations14        //
//////////////////////////////////////////////////

typedef class spi_agent14;
typedef class spi_csr14;
typedef class spi_driver14;
typedef class spi_env14;
typedef class spi_monitor14;
typedef class trans_seq14;
typedef class spi_incr_payload14;
typedef class spi_sequencer14;
typedef class spi_transfer14;

//////////////////////////////////////////////////
//              Include14 files                   //
//////////////////////////////////////////////////
`include "spi_csr14.sv"
`include "spi_transfer14.sv"
`include "spi_config14.sv"

`include "spi_monitor14.sv"
`include "spi_sequencer14.sv"
`include "spi_driver14.sv"
`include "spi_agent14.sv"

`include "spi_env14.sv"

`include "spi_seq_lib14.sv"

endpackage : spi_pkg14
`endif

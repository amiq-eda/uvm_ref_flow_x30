/*-------------------------------------------------------------------------
File26 name   : spi_pkg26.sv
Title26       : Package26 for SPI26 OVC26
Project26     :
Created26     :
Description26 : 
Notes26       :  
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH26
`define SPI_PKG_SVH26

package spi_pkg26;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class26 Forward26 Declarations26        //
//////////////////////////////////////////////////

typedef class spi_agent26;
typedef class spi_csr26;
typedef class spi_driver26;
typedef class spi_env26;
typedef class spi_monitor26;
typedef class trans_seq26;
typedef class spi_incr_payload26;
typedef class spi_sequencer26;
typedef class spi_transfer26;

//////////////////////////////////////////////////
//              Include26 files                   //
//////////////////////////////////////////////////
`include "spi_csr26.sv"
`include "spi_transfer26.sv"
`include "spi_config26.sv"

`include "spi_monitor26.sv"
`include "spi_sequencer26.sv"
`include "spi_driver26.sv"
`include "spi_agent26.sv"

`include "spi_env26.sv"

`include "spi_seq_lib26.sv"

endpackage : spi_pkg26
`endif

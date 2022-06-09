/*-------------------------------------------------------------------------
File12 name   : spi_pkg12.sv
Title12       : Package12 for SPI12 OVC12
Project12     :
Created12     :
Description12 : 
Notes12       :  
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH12
`define SPI_PKG_SVH12

package spi_pkg12;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class12 Forward12 Declarations12        //
//////////////////////////////////////////////////

typedef class spi_agent12;
typedef class spi_csr12;
typedef class spi_driver12;
typedef class spi_env12;
typedef class spi_monitor12;
typedef class trans_seq12;
typedef class spi_incr_payload12;
typedef class spi_sequencer12;
typedef class spi_transfer12;

//////////////////////////////////////////////////
//              Include12 files                   //
//////////////////////////////////////////////////
`include "spi_csr12.sv"
`include "spi_transfer12.sv"
`include "spi_config12.sv"

`include "spi_monitor12.sv"
`include "spi_sequencer12.sv"
`include "spi_driver12.sv"
`include "spi_agent12.sv"

`include "spi_env12.sv"

`include "spi_seq_lib12.sv"

endpackage : spi_pkg12
`endif

/*-------------------------------------------------------------------------
File18 name   : spi_pkg18.sv
Title18       : Package18 for SPI18 OVC18
Project18     :
Created18     :
Description18 : 
Notes18       :  
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

  
`ifndef SPI_PKG_SVH18
`define SPI_PKG_SVH18

package spi_pkg18;

import uvm_pkg::*;
`include "uvm_macros.svh"

//////////////////////////////////////////////////
//        UVM Class18 Forward18 Declarations18        //
//////////////////////////////////////////////////

typedef class spi_agent18;
typedef class spi_csr18;
typedef class spi_driver18;
typedef class spi_env18;
typedef class spi_monitor18;
typedef class trans_seq18;
typedef class spi_incr_payload18;
typedef class spi_sequencer18;
typedef class spi_transfer18;

//////////////////////////////////////////////////
//              Include18 files                   //
//////////////////////////////////////////////////
`include "spi_csr18.sv"
`include "spi_transfer18.sv"
`include "spi_config18.sv"

`include "spi_monitor18.sv"
`include "spi_sequencer18.sv"
`include "spi_driver18.sv"
`include "spi_agent18.sv"

`include "spi_env18.sv"

`include "spi_seq_lib18.sv"

endpackage : spi_pkg18
`endif

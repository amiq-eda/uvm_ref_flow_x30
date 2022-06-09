/*-------------------------------------------------------------------------
File10 name   : spi_transfer10.sv
Title10       : SPI10 SystemVerilog10 UVM UVC10
Project10     : SystemVerilog10 UVM Cluster10 Level10 Verification10
Created10     :
Description10 : 
Notes10       :  
---------------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV10
`define SPI_TRANSFER_SV10

class spi_transfer10 extends uvm_sequence_item;

  rand int unsigned transmit_delay10;

  rand bit [31:0] transfer_data10;
  bit [31:0] receive_data10;

  string agent10 = "";        //updated my10 monitor10 - scoreboard10 can use this

  constraint c_default_txmit_delay10 {transmit_delay10 >= 0; transmit_delay10 < 20;}

  // These10 declarations10 implement the create() and get_type_name() as well10 as enable automation10 of the
  // transfer10 fields   
  `uvm_object_utils_begin(spi_transfer10)
    `uvm_field_int(transmit_delay10, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data10,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data10,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent10,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This10 requires for registration10 of the ptp_tx_frame10   
  function new(string name = "spi_transfer10");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer10

`endif

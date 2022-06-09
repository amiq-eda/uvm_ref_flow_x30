/*-------------------------------------------------------------------------
File17 name   : spi_transfer17.sv
Title17       : SPI17 SystemVerilog17 UVM UVC17
Project17     : SystemVerilog17 UVM Cluster17 Level17 Verification17
Created17     :
Description17 : 
Notes17       :  
---------------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV17
`define SPI_TRANSFER_SV17

class spi_transfer17 extends uvm_sequence_item;

  rand int unsigned transmit_delay17;

  rand bit [31:0] transfer_data17;
  bit [31:0] receive_data17;

  string agent17 = "";        //updated my17 monitor17 - scoreboard17 can use this

  constraint c_default_txmit_delay17 {transmit_delay17 >= 0; transmit_delay17 < 20;}

  // These17 declarations17 implement the create() and get_type_name() as well17 as enable automation17 of the
  // transfer17 fields   
  `uvm_object_utils_begin(spi_transfer17)
    `uvm_field_int(transmit_delay17, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data17,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data17,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent17,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This17 requires for registration17 of the ptp_tx_frame17   
  function new(string name = "spi_transfer17");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer17

`endif

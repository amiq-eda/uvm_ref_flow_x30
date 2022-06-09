/*-------------------------------------------------------------------------
File26 name   : spi_transfer26.sv
Title26       : SPI26 SystemVerilog26 UVM UVC26
Project26     : SystemVerilog26 UVM Cluster26 Level26 Verification26
Created26     :
Description26 : 
Notes26       :  
---------------------------------------------------------------------------*/
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


`ifndef SPI_TRANSFER_SV26
`define SPI_TRANSFER_SV26

class spi_transfer26 extends uvm_sequence_item;

  rand int unsigned transmit_delay26;

  rand bit [31:0] transfer_data26;
  bit [31:0] receive_data26;

  string agent26 = "";        //updated my26 monitor26 - scoreboard26 can use this

  constraint c_default_txmit_delay26 {transmit_delay26 >= 0; transmit_delay26 < 20;}

  // These26 declarations26 implement the create() and get_type_name() as well26 as enable automation26 of the
  // transfer26 fields   
  `uvm_object_utils_begin(spi_transfer26)
    `uvm_field_int(transmit_delay26, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data26,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data26,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent26,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This26 requires for registration26 of the ptp_tx_frame26   
  function new(string name = "spi_transfer26");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer26

`endif

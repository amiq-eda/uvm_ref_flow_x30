/*-------------------------------------------------------------------------
File15 name   : spi_transfer15.sv
Title15       : SPI15 SystemVerilog15 UVM UVC15
Project15     : SystemVerilog15 UVM Cluster15 Level15 Verification15
Created15     :
Description15 : 
Notes15       :  
---------------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV15
`define SPI_TRANSFER_SV15

class spi_transfer15 extends uvm_sequence_item;

  rand int unsigned transmit_delay15;

  rand bit [31:0] transfer_data15;
  bit [31:0] receive_data15;

  string agent15 = "";        //updated my15 monitor15 - scoreboard15 can use this

  constraint c_default_txmit_delay15 {transmit_delay15 >= 0; transmit_delay15 < 20;}

  // These15 declarations15 implement the create() and get_type_name() as well15 as enable automation15 of the
  // transfer15 fields   
  `uvm_object_utils_begin(spi_transfer15)
    `uvm_field_int(transmit_delay15, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data15,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data15,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent15,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This15 requires for registration15 of the ptp_tx_frame15   
  function new(string name = "spi_transfer15");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer15

`endif

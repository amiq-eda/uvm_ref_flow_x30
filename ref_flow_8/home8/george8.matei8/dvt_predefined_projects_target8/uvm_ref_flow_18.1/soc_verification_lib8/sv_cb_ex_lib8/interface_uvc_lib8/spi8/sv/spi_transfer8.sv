/*-------------------------------------------------------------------------
File8 name   : spi_transfer8.sv
Title8       : SPI8 SystemVerilog8 UVM UVC8
Project8     : SystemVerilog8 UVM Cluster8 Level8 Verification8
Created8     :
Description8 : 
Notes8       :  
---------------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV8
`define SPI_TRANSFER_SV8

class spi_transfer8 extends uvm_sequence_item;

  rand int unsigned transmit_delay8;

  rand bit [31:0] transfer_data8;
  bit [31:0] receive_data8;

  string agent8 = "";        //updated my8 monitor8 - scoreboard8 can use this

  constraint c_default_txmit_delay8 {transmit_delay8 >= 0; transmit_delay8 < 20;}

  // These8 declarations8 implement the create() and get_type_name() as well8 as enable automation8 of the
  // transfer8 fields   
  `uvm_object_utils_begin(spi_transfer8)
    `uvm_field_int(transmit_delay8, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data8,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data8,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent8,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This8 requires for registration8 of the ptp_tx_frame8   
  function new(string name = "spi_transfer8");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer8

`endif

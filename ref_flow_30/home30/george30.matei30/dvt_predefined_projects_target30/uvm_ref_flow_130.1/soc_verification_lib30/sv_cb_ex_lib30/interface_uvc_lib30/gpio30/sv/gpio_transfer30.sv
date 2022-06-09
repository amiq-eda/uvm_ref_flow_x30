/*-------------------------------------------------------------------------
File30 name   : gpio_transfer30.sv
Title30       : GPIO30 SystemVerilog30 UVM OVC30
Project30     : SystemVerilog30 UVM Cluster30 Level30 Verification30
Created30     :
Description30 : 
Notes30       :  
---------------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV30
`define GPIO_TRANSFER_SV30

class gpio_transfer30 extends uvm_sequence_item;

  rand int unsigned transmit_delay30;

  rand bit [`GPIO_DATA_WIDTH30-1:0] transfer_data30;
  bit [`GPIO_DATA_WIDTH30-1:0] monitor_data30;
  bit [`GPIO_DATA_WIDTH30-1:0] output_enable30;

  string agent30 = "";        //updated my30 monitor30 - scoreboard30 can use this

  constraint c_default_txmit_delay30 {transmit_delay30 >= 0; transmit_delay30 < 20;}

  // These30 declarations30 implement the create() and get_type_name() as well30 as enable automation30 of the
  // transfer30 fields   
  `uvm_object_utils_begin(gpio_transfer30)
    `uvm_field_int(transmit_delay30, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data30,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data30,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable30,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent30,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This30 requires for registration30 of the ptp_tx_frame30   
  function new(string name = "gpio_transfer30");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer30

`endif

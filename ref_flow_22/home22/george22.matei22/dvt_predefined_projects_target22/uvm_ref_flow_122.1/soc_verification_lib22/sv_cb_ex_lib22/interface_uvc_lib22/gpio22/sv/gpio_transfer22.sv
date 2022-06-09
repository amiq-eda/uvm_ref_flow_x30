/*-------------------------------------------------------------------------
File22 name   : gpio_transfer22.sv
Title22       : GPIO22 SystemVerilog22 UVM OVC22
Project22     : SystemVerilog22 UVM Cluster22 Level22 Verification22
Created22     :
Description22 : 
Notes22       :  
---------------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV22
`define GPIO_TRANSFER_SV22

class gpio_transfer22 extends uvm_sequence_item;

  rand int unsigned transmit_delay22;

  rand bit [`GPIO_DATA_WIDTH22-1:0] transfer_data22;
  bit [`GPIO_DATA_WIDTH22-1:0] monitor_data22;
  bit [`GPIO_DATA_WIDTH22-1:0] output_enable22;

  string agent22 = "";        //updated my22 monitor22 - scoreboard22 can use this

  constraint c_default_txmit_delay22 {transmit_delay22 >= 0; transmit_delay22 < 20;}

  // These22 declarations22 implement the create() and get_type_name() as well22 as enable automation22 of the
  // transfer22 fields   
  `uvm_object_utils_begin(gpio_transfer22)
    `uvm_field_int(transmit_delay22, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data22,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data22,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable22,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent22,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This22 requires for registration22 of the ptp_tx_frame22   
  function new(string name = "gpio_transfer22");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer22

`endif

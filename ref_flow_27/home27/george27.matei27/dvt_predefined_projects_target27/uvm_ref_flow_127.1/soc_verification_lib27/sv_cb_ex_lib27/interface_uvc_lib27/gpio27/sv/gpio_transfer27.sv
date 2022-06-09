/*-------------------------------------------------------------------------
File27 name   : gpio_transfer27.sv
Title27       : GPIO27 SystemVerilog27 UVM OVC27
Project27     : SystemVerilog27 UVM Cluster27 Level27 Verification27
Created27     :
Description27 : 
Notes27       :  
---------------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV27
`define GPIO_TRANSFER_SV27

class gpio_transfer27 extends uvm_sequence_item;

  rand int unsigned transmit_delay27;

  rand bit [`GPIO_DATA_WIDTH27-1:0] transfer_data27;
  bit [`GPIO_DATA_WIDTH27-1:0] monitor_data27;
  bit [`GPIO_DATA_WIDTH27-1:0] output_enable27;

  string agent27 = "";        //updated my27 monitor27 - scoreboard27 can use this

  constraint c_default_txmit_delay27 {transmit_delay27 >= 0; transmit_delay27 < 20;}

  // These27 declarations27 implement the create() and get_type_name() as well27 as enable automation27 of the
  // transfer27 fields   
  `uvm_object_utils_begin(gpio_transfer27)
    `uvm_field_int(transmit_delay27, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data27,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data27,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable27,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent27,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This27 requires for registration27 of the ptp_tx_frame27   
  function new(string name = "gpio_transfer27");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer27

`endif

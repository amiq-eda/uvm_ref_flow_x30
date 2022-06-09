/*-------------------------------------------------------------------------
File11 name   : gpio_transfer11.sv
Title11       : GPIO11 SystemVerilog11 UVM OVC11
Project11     : SystemVerilog11 UVM Cluster11 Level11 Verification11
Created11     :
Description11 : 
Notes11       :  
---------------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV11
`define GPIO_TRANSFER_SV11

class gpio_transfer11 extends uvm_sequence_item;

  rand int unsigned transmit_delay11;

  rand bit [`GPIO_DATA_WIDTH11-1:0] transfer_data11;
  bit [`GPIO_DATA_WIDTH11-1:0] monitor_data11;
  bit [`GPIO_DATA_WIDTH11-1:0] output_enable11;

  string agent11 = "";        //updated my11 monitor11 - scoreboard11 can use this

  constraint c_default_txmit_delay11 {transmit_delay11 >= 0; transmit_delay11 < 20;}

  // These11 declarations11 implement the create() and get_type_name() as well11 as enable automation11 of the
  // transfer11 fields   
  `uvm_object_utils_begin(gpio_transfer11)
    `uvm_field_int(transmit_delay11, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data11,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data11,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable11,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent11,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This11 requires for registration11 of the ptp_tx_frame11   
  function new(string name = "gpio_transfer11");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer11

`endif

/*-------------------------------------------------------------------------
File6 name   : gpio_transfer6.sv
Title6       : GPIO6 SystemVerilog6 UVM OVC6
Project6     : SystemVerilog6 UVM Cluster6 Level6 Verification6
Created6     :
Description6 : 
Notes6       :  
---------------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV6
`define GPIO_TRANSFER_SV6

class gpio_transfer6 extends uvm_sequence_item;

  rand int unsigned transmit_delay6;

  rand bit [`GPIO_DATA_WIDTH6-1:0] transfer_data6;
  bit [`GPIO_DATA_WIDTH6-1:0] monitor_data6;
  bit [`GPIO_DATA_WIDTH6-1:0] output_enable6;

  string agent6 = "";        //updated my6 monitor6 - scoreboard6 can use this

  constraint c_default_txmit_delay6 {transmit_delay6 >= 0; transmit_delay6 < 20;}

  // These6 declarations6 implement the create() and get_type_name() as well6 as enable automation6 of the
  // transfer6 fields   
  `uvm_object_utils_begin(gpio_transfer6)
    `uvm_field_int(transmit_delay6, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data6,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data6,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable6,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent6,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This6 requires for registration6 of the ptp_tx_frame6   
  function new(string name = "gpio_transfer6");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer6

`endif

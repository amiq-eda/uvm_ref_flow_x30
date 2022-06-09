/*-------------------------------------------------------------------------
File5 name   : gpio_transfer5.sv
Title5       : GPIO5 SystemVerilog5 UVM OVC5
Project5     : SystemVerilog5 UVM Cluster5 Level5 Verification5
Created5     :
Description5 : 
Notes5       :  
---------------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV5
`define GPIO_TRANSFER_SV5

class gpio_transfer5 extends uvm_sequence_item;

  rand int unsigned transmit_delay5;

  rand bit [`GPIO_DATA_WIDTH5-1:0] transfer_data5;
  bit [`GPIO_DATA_WIDTH5-1:0] monitor_data5;
  bit [`GPIO_DATA_WIDTH5-1:0] output_enable5;

  string agent5 = "";        //updated my5 monitor5 - scoreboard5 can use this

  constraint c_default_txmit_delay5 {transmit_delay5 >= 0; transmit_delay5 < 20;}

  // These5 declarations5 implement the create() and get_type_name() as well5 as enable automation5 of the
  // transfer5 fields   
  `uvm_object_utils_begin(gpio_transfer5)
    `uvm_field_int(transmit_delay5, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data5,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data5,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable5,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent5,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This5 requires for registration5 of the ptp_tx_frame5   
  function new(string name = "gpio_transfer5");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer5

`endif

/*-------------------------------------------------------------------------
File9 name   : gpio_transfer9.sv
Title9       : GPIO9 SystemVerilog9 UVM OVC9
Project9     : SystemVerilog9 UVM Cluster9 Level9 Verification9
Created9     :
Description9 : 
Notes9       :  
---------------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV9
`define GPIO_TRANSFER_SV9

class gpio_transfer9 extends uvm_sequence_item;

  rand int unsigned transmit_delay9;

  rand bit [`GPIO_DATA_WIDTH9-1:0] transfer_data9;
  bit [`GPIO_DATA_WIDTH9-1:0] monitor_data9;
  bit [`GPIO_DATA_WIDTH9-1:0] output_enable9;

  string agent9 = "";        //updated my9 monitor9 - scoreboard9 can use this

  constraint c_default_txmit_delay9 {transmit_delay9 >= 0; transmit_delay9 < 20;}

  // These9 declarations9 implement the create() and get_type_name() as well9 as enable automation9 of the
  // transfer9 fields   
  `uvm_object_utils_begin(gpio_transfer9)
    `uvm_field_int(transmit_delay9, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data9,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data9,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable9,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent9,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This9 requires for registration9 of the ptp_tx_frame9   
  function new(string name = "gpio_transfer9");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer9

`endif

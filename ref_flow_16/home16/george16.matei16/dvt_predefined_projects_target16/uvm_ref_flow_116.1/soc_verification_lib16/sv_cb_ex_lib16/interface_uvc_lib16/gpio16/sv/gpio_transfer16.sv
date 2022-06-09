/*-------------------------------------------------------------------------
File16 name   : gpio_transfer16.sv
Title16       : GPIO16 SystemVerilog16 UVM OVC16
Project16     : SystemVerilog16 UVM Cluster16 Level16 Verification16
Created16     :
Description16 : 
Notes16       :  
---------------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV16
`define GPIO_TRANSFER_SV16

class gpio_transfer16 extends uvm_sequence_item;

  rand int unsigned transmit_delay16;

  rand bit [`GPIO_DATA_WIDTH16-1:0] transfer_data16;
  bit [`GPIO_DATA_WIDTH16-1:0] monitor_data16;
  bit [`GPIO_DATA_WIDTH16-1:0] output_enable16;

  string agent16 = "";        //updated my16 monitor16 - scoreboard16 can use this

  constraint c_default_txmit_delay16 {transmit_delay16 >= 0; transmit_delay16 < 20;}

  // These16 declarations16 implement the create() and get_type_name() as well16 as enable automation16 of the
  // transfer16 fields   
  `uvm_object_utils_begin(gpio_transfer16)
    `uvm_field_int(transmit_delay16, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data16,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data16,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable16,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent16,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This16 requires for registration16 of the ptp_tx_frame16   
  function new(string name = "gpio_transfer16");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer16

`endif

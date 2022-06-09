/*-------------------------------------------------------------------------
File23 name   : gpio_transfer23.sv
Title23       : GPIO23 SystemVerilog23 UVM OVC23
Project23     : SystemVerilog23 UVM Cluster23 Level23 Verification23
Created23     :
Description23 : 
Notes23       :  
---------------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV23
`define GPIO_TRANSFER_SV23

class gpio_transfer23 extends uvm_sequence_item;

  rand int unsigned transmit_delay23;

  rand bit [`GPIO_DATA_WIDTH23-1:0] transfer_data23;
  bit [`GPIO_DATA_WIDTH23-1:0] monitor_data23;
  bit [`GPIO_DATA_WIDTH23-1:0] output_enable23;

  string agent23 = "";        //updated my23 monitor23 - scoreboard23 can use this

  constraint c_default_txmit_delay23 {transmit_delay23 >= 0; transmit_delay23 < 20;}

  // These23 declarations23 implement the create() and get_type_name() as well23 as enable automation23 of the
  // transfer23 fields   
  `uvm_object_utils_begin(gpio_transfer23)
    `uvm_field_int(transmit_delay23, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data23,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data23,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable23,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent23,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This23 requires for registration23 of the ptp_tx_frame23   
  function new(string name = "gpio_transfer23");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer23

`endif

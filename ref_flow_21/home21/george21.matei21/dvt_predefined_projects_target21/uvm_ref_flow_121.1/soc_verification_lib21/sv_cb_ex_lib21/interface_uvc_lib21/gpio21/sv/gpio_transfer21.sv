/*-------------------------------------------------------------------------
File21 name   : gpio_transfer21.sv
Title21       : GPIO21 SystemVerilog21 UVM OVC21
Project21     : SystemVerilog21 UVM Cluster21 Level21 Verification21
Created21     :
Description21 : 
Notes21       :  
---------------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV21
`define GPIO_TRANSFER_SV21

class gpio_transfer21 extends uvm_sequence_item;

  rand int unsigned transmit_delay21;

  rand bit [`GPIO_DATA_WIDTH21-1:0] transfer_data21;
  bit [`GPIO_DATA_WIDTH21-1:0] monitor_data21;
  bit [`GPIO_DATA_WIDTH21-1:0] output_enable21;

  string agent21 = "";        //updated my21 monitor21 - scoreboard21 can use this

  constraint c_default_txmit_delay21 {transmit_delay21 >= 0; transmit_delay21 < 20;}

  // These21 declarations21 implement the create() and get_type_name() as well21 as enable automation21 of the
  // transfer21 fields   
  `uvm_object_utils_begin(gpio_transfer21)
    `uvm_field_int(transmit_delay21, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data21,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data21,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable21,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent21,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This21 requires for registration21 of the ptp_tx_frame21   
  function new(string name = "gpio_transfer21");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer21

`endif

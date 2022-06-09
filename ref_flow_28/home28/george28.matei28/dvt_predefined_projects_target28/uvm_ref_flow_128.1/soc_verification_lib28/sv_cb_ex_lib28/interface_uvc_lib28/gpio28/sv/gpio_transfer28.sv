/*-------------------------------------------------------------------------
File28 name   : gpio_transfer28.sv
Title28       : GPIO28 SystemVerilog28 UVM OVC28
Project28     : SystemVerilog28 UVM Cluster28 Level28 Verification28
Created28     :
Description28 : 
Notes28       :  
---------------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV28
`define GPIO_TRANSFER_SV28

class gpio_transfer28 extends uvm_sequence_item;

  rand int unsigned transmit_delay28;

  rand bit [`GPIO_DATA_WIDTH28-1:0] transfer_data28;
  bit [`GPIO_DATA_WIDTH28-1:0] monitor_data28;
  bit [`GPIO_DATA_WIDTH28-1:0] output_enable28;

  string agent28 = "";        //updated my28 monitor28 - scoreboard28 can use this

  constraint c_default_txmit_delay28 {transmit_delay28 >= 0; transmit_delay28 < 20;}

  // These28 declarations28 implement the create() and get_type_name() as well28 as enable automation28 of the
  // transfer28 fields   
  `uvm_object_utils_begin(gpio_transfer28)
    `uvm_field_int(transmit_delay28, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data28,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data28,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable28,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent28,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This28 requires for registration28 of the ptp_tx_frame28   
  function new(string name = "gpio_transfer28");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer28

`endif

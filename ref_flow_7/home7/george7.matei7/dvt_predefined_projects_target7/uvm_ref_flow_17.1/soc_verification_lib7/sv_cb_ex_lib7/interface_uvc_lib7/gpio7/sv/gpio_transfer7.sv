/*-------------------------------------------------------------------------
File7 name   : gpio_transfer7.sv
Title7       : GPIO7 SystemVerilog7 UVM OVC7
Project7     : SystemVerilog7 UVM Cluster7 Level7 Verification7
Created7     :
Description7 : 
Notes7       :  
---------------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV7
`define GPIO_TRANSFER_SV7

class gpio_transfer7 extends uvm_sequence_item;

  rand int unsigned transmit_delay7;

  rand bit [`GPIO_DATA_WIDTH7-1:0] transfer_data7;
  bit [`GPIO_DATA_WIDTH7-1:0] monitor_data7;
  bit [`GPIO_DATA_WIDTH7-1:0] output_enable7;

  string agent7 = "";        //updated my7 monitor7 - scoreboard7 can use this

  constraint c_default_txmit_delay7 {transmit_delay7 >= 0; transmit_delay7 < 20;}

  // These7 declarations7 implement the create() and get_type_name() as well7 as enable automation7 of the
  // transfer7 fields   
  `uvm_object_utils_begin(gpio_transfer7)
    `uvm_field_int(transmit_delay7, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data7,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data7,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable7,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent7,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This7 requires for registration7 of the ptp_tx_frame7   
  function new(string name = "gpio_transfer7");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer7

`endif

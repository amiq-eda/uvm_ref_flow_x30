/*-------------------------------------------------------------------------
File24 name   : gpio_transfer24.sv
Title24       : GPIO24 SystemVerilog24 UVM OVC24
Project24     : SystemVerilog24 UVM Cluster24 Level24 Verification24
Created24     :
Description24 : 
Notes24       :  
---------------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV24
`define GPIO_TRANSFER_SV24

class gpio_transfer24 extends uvm_sequence_item;

  rand int unsigned transmit_delay24;

  rand bit [`GPIO_DATA_WIDTH24-1:0] transfer_data24;
  bit [`GPIO_DATA_WIDTH24-1:0] monitor_data24;
  bit [`GPIO_DATA_WIDTH24-1:0] output_enable24;

  string agent24 = "";        //updated my24 monitor24 - scoreboard24 can use this

  constraint c_default_txmit_delay24 {transmit_delay24 >= 0; transmit_delay24 < 20;}

  // These24 declarations24 implement the create() and get_type_name() as well24 as enable automation24 of the
  // transfer24 fields   
  `uvm_object_utils_begin(gpio_transfer24)
    `uvm_field_int(transmit_delay24, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data24,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data24,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable24,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent24,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This24 requires for registration24 of the ptp_tx_frame24   
  function new(string name = "gpio_transfer24");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer24

`endif

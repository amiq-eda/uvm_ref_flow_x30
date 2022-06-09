/*-------------------------------------------------------------------------
File25 name   : gpio_transfer25.sv
Title25       : GPIO25 SystemVerilog25 UVM OVC25
Project25     : SystemVerilog25 UVM Cluster25 Level25 Verification25
Created25     :
Description25 : 
Notes25       :  
---------------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV25
`define GPIO_TRANSFER_SV25

class gpio_transfer25 extends uvm_sequence_item;

  rand int unsigned transmit_delay25;

  rand bit [`GPIO_DATA_WIDTH25-1:0] transfer_data25;
  bit [`GPIO_DATA_WIDTH25-1:0] monitor_data25;
  bit [`GPIO_DATA_WIDTH25-1:0] output_enable25;

  string agent25 = "";        //updated my25 monitor25 - scoreboard25 can use this

  constraint c_default_txmit_delay25 {transmit_delay25 >= 0; transmit_delay25 < 20;}

  // These25 declarations25 implement the create() and get_type_name() as well25 as enable automation25 of the
  // transfer25 fields   
  `uvm_object_utils_begin(gpio_transfer25)
    `uvm_field_int(transmit_delay25, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data25,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data25,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable25,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent25,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This25 requires for registration25 of the ptp_tx_frame25   
  function new(string name = "gpio_transfer25");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer25

`endif

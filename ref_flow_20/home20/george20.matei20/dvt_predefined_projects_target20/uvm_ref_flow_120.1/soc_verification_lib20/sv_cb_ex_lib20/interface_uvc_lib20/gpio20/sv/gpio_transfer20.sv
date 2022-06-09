/*-------------------------------------------------------------------------
File20 name   : gpio_transfer20.sv
Title20       : GPIO20 SystemVerilog20 UVM OVC20
Project20     : SystemVerilog20 UVM Cluster20 Level20 Verification20
Created20     :
Description20 : 
Notes20       :  
---------------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV20
`define GPIO_TRANSFER_SV20

class gpio_transfer20 extends uvm_sequence_item;

  rand int unsigned transmit_delay20;

  rand bit [`GPIO_DATA_WIDTH20-1:0] transfer_data20;
  bit [`GPIO_DATA_WIDTH20-1:0] monitor_data20;
  bit [`GPIO_DATA_WIDTH20-1:0] output_enable20;

  string agent20 = "";        //updated my20 monitor20 - scoreboard20 can use this

  constraint c_default_txmit_delay20 {transmit_delay20 >= 0; transmit_delay20 < 20;}

  // These20 declarations20 implement the create() and get_type_name() as well20 as enable automation20 of the
  // transfer20 fields   
  `uvm_object_utils_begin(gpio_transfer20)
    `uvm_field_int(transmit_delay20, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data20,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data20,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable20,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent20,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This20 requires for registration20 of the ptp_tx_frame20   
  function new(string name = "gpio_transfer20");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer20

`endif

/*-------------------------------------------------------------------------
File29 name   : gpio_transfer29.sv
Title29       : GPIO29 SystemVerilog29 UVM OVC29
Project29     : SystemVerilog29 UVM Cluster29 Level29 Verification29
Created29     :
Description29 : 
Notes29       :  
---------------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef GPIO_TRANSFER_SV29
`define GPIO_TRANSFER_SV29

class gpio_transfer29 extends uvm_sequence_item;

  rand int unsigned transmit_delay29;

  rand bit [`GPIO_DATA_WIDTH29-1:0] transfer_data29;
  bit [`GPIO_DATA_WIDTH29-1:0] monitor_data29;
  bit [`GPIO_DATA_WIDTH29-1:0] output_enable29;

  string agent29 = "";        //updated my29 monitor29 - scoreboard29 can use this

  constraint c_default_txmit_delay29 {transmit_delay29 >= 0; transmit_delay29 < 20;}

  // These29 declarations29 implement the create() and get_type_name() as well29 as enable automation29 of the
  // transfer29 fields   
  `uvm_object_utils_begin(gpio_transfer29)
    `uvm_field_int(transmit_delay29, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data29,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(monitor_data29,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(output_enable29,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent29,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This29 requires for registration29 of the ptp_tx_frame29   
  function new(string name = "gpio_transfer29");
	  super.new(name);
  endfunction 
   

endclass : gpio_transfer29

`endif

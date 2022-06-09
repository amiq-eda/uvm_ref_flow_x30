/*-------------------------------------------------------------------------
File13 name   : spi_transfer13.sv
Title13       : SPI13 SystemVerilog13 UVM UVC13
Project13     : SystemVerilog13 UVM Cluster13 Level13 Verification13
Created13     :
Description13 : 
Notes13       :  
---------------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV13
`define SPI_TRANSFER_SV13

class spi_transfer13 extends uvm_sequence_item;

  rand int unsigned transmit_delay13;

  rand bit [31:0] transfer_data13;
  bit [31:0] receive_data13;

  string agent13 = "";        //updated my13 monitor13 - scoreboard13 can use this

  constraint c_default_txmit_delay13 {transmit_delay13 >= 0; transmit_delay13 < 20;}

  // These13 declarations13 implement the create() and get_type_name() as well13 as enable automation13 of the
  // transfer13 fields   
  `uvm_object_utils_begin(spi_transfer13)
    `uvm_field_int(transmit_delay13, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data13,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data13,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent13,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This13 requires for registration13 of the ptp_tx_frame13   
  function new(string name = "spi_transfer13");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer13

`endif

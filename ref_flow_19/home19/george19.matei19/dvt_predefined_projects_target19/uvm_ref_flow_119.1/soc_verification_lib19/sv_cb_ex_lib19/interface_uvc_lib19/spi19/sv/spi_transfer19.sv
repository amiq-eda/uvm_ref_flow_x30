/*-------------------------------------------------------------------------
File19 name   : spi_transfer19.sv
Title19       : SPI19 SystemVerilog19 UVM UVC19
Project19     : SystemVerilog19 UVM Cluster19 Level19 Verification19
Created19     :
Description19 : 
Notes19       :  
---------------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV19
`define SPI_TRANSFER_SV19

class spi_transfer19 extends uvm_sequence_item;

  rand int unsigned transmit_delay19;

  rand bit [31:0] transfer_data19;
  bit [31:0] receive_data19;

  string agent19 = "";        //updated my19 monitor19 - scoreboard19 can use this

  constraint c_default_txmit_delay19 {transmit_delay19 >= 0; transmit_delay19 < 20;}

  // These19 declarations19 implement the create() and get_type_name() as well19 as enable automation19 of the
  // transfer19 fields   
  `uvm_object_utils_begin(spi_transfer19)
    `uvm_field_int(transmit_delay19, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data19,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data19,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent19,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This19 requires for registration19 of the ptp_tx_frame19   
  function new(string name = "spi_transfer19");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer19

`endif

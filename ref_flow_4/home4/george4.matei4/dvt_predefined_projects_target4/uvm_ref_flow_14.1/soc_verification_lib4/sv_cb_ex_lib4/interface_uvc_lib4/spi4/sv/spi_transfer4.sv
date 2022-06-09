/*-------------------------------------------------------------------------
File4 name   : spi_transfer4.sv
Title4       : SPI4 SystemVerilog4 UVM UVC4
Project4     : SystemVerilog4 UVM Cluster4 Level4 Verification4
Created4     :
Description4 : 
Notes4       :  
---------------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV4
`define SPI_TRANSFER_SV4

class spi_transfer4 extends uvm_sequence_item;

  rand int unsigned transmit_delay4;

  rand bit [31:0] transfer_data4;
  bit [31:0] receive_data4;

  string agent4 = "";        //updated my4 monitor4 - scoreboard4 can use this

  constraint c_default_txmit_delay4 {transmit_delay4 >= 0; transmit_delay4 < 20;}

  // These4 declarations4 implement the create() and get_type_name() as well4 as enable automation4 of the
  // transfer4 fields   
  `uvm_object_utils_begin(spi_transfer4)
    `uvm_field_int(transmit_delay4, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data4,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data4,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent4,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This4 requires for registration4 of the ptp_tx_frame4   
  function new(string name = "spi_transfer4");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer4

`endif

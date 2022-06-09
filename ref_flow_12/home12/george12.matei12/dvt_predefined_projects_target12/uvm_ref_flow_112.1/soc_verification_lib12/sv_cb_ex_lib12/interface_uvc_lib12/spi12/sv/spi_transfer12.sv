/*-------------------------------------------------------------------------
File12 name   : spi_transfer12.sv
Title12       : SPI12 SystemVerilog12 UVM UVC12
Project12     : SystemVerilog12 UVM Cluster12 Level12 Verification12
Created12     :
Description12 : 
Notes12       :  
---------------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV12
`define SPI_TRANSFER_SV12

class spi_transfer12 extends uvm_sequence_item;

  rand int unsigned transmit_delay12;

  rand bit [31:0] transfer_data12;
  bit [31:0] receive_data12;

  string agent12 = "";        //updated my12 monitor12 - scoreboard12 can use this

  constraint c_default_txmit_delay12 {transmit_delay12 >= 0; transmit_delay12 < 20;}

  // These12 declarations12 implement the create() and get_type_name() as well12 as enable automation12 of the
  // transfer12 fields   
  `uvm_object_utils_begin(spi_transfer12)
    `uvm_field_int(transmit_delay12, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data12,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data12,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent12,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This12 requires for registration12 of the ptp_tx_frame12   
  function new(string name = "spi_transfer12");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer12

`endif

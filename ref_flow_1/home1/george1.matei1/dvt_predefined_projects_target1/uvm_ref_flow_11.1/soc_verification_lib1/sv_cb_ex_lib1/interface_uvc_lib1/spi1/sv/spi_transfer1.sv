/*-------------------------------------------------------------------------
File1 name   : spi_transfer1.sv
Title1       : SPI1 SystemVerilog1 UVM UVC1
Project1     : SystemVerilog1 UVM Cluster1 Level1 Verification1
Created1     :
Description1 : 
Notes1       :  
---------------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV1
`define SPI_TRANSFER_SV1

class spi_transfer1 extends uvm_sequence_item;

  rand int unsigned transmit_delay1;

  rand bit [31:0] transfer_data1;
  bit [31:0] receive_data1;

  string agent1 = "";        //updated my1 monitor1 - scoreboard1 can use this

  constraint c_default_txmit_delay1 {transmit_delay1 >= 0; transmit_delay1 < 20;}

  // These1 declarations1 implement the create() and get_type_name() as well1 as enable automation1 of the
  // transfer1 fields   
  `uvm_object_utils_begin(spi_transfer1)
    `uvm_field_int(transmit_delay1, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data1,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data1,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent1,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This1 requires for registration1 of the ptp_tx_frame1   
  function new(string name = "spi_transfer1");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer1

`endif

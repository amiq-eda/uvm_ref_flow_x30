/*-------------------------------------------------------------------------
File3 name   : spi_transfer3.sv
Title3       : SPI3 SystemVerilog3 UVM UVC3
Project3     : SystemVerilog3 UVM Cluster3 Level3 Verification3
Created3     :
Description3 : 
Notes3       :  
---------------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV3
`define SPI_TRANSFER_SV3

class spi_transfer3 extends uvm_sequence_item;

  rand int unsigned transmit_delay3;

  rand bit [31:0] transfer_data3;
  bit [31:0] receive_data3;

  string agent3 = "";        //updated my3 monitor3 - scoreboard3 can use this

  constraint c_default_txmit_delay3 {transmit_delay3 >= 0; transmit_delay3 < 20;}

  // These3 declarations3 implement the create() and get_type_name() as well3 as enable automation3 of the
  // transfer3 fields   
  `uvm_object_utils_begin(spi_transfer3)
    `uvm_field_int(transmit_delay3, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data3,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data3,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent3,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This3 requires for registration3 of the ptp_tx_frame3   
  function new(string name = "spi_transfer3");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer3

`endif

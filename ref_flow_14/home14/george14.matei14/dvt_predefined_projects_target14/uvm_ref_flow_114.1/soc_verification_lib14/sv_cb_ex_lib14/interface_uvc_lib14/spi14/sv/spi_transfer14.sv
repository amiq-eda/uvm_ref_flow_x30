/*-------------------------------------------------------------------------
File14 name   : spi_transfer14.sv
Title14       : SPI14 SystemVerilog14 UVM UVC14
Project14     : SystemVerilog14 UVM Cluster14 Level14 Verification14
Created14     :
Description14 : 
Notes14       :  
---------------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV14
`define SPI_TRANSFER_SV14

class spi_transfer14 extends uvm_sequence_item;

  rand int unsigned transmit_delay14;

  rand bit [31:0] transfer_data14;
  bit [31:0] receive_data14;

  string agent14 = "";        //updated my14 monitor14 - scoreboard14 can use this

  constraint c_default_txmit_delay14 {transmit_delay14 >= 0; transmit_delay14 < 20;}

  // These14 declarations14 implement the create() and get_type_name() as well14 as enable automation14 of the
  // transfer14 fields   
  `uvm_object_utils_begin(spi_transfer14)
    `uvm_field_int(transmit_delay14, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data14,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data14,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent14,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This14 requires for registration14 of the ptp_tx_frame14   
  function new(string name = "spi_transfer14");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer14

`endif

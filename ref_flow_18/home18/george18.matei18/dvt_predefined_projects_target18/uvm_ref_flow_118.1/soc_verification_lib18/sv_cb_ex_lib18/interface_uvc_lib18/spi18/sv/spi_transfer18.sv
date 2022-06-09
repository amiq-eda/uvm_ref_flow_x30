/*-------------------------------------------------------------------------
File18 name   : spi_transfer18.sv
Title18       : SPI18 SystemVerilog18 UVM UVC18
Project18     : SystemVerilog18 UVM Cluster18 Level18 Verification18
Created18     :
Description18 : 
Notes18       :  
---------------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV18
`define SPI_TRANSFER_SV18

class spi_transfer18 extends uvm_sequence_item;

  rand int unsigned transmit_delay18;

  rand bit [31:0] transfer_data18;
  bit [31:0] receive_data18;

  string agent18 = "";        //updated my18 monitor18 - scoreboard18 can use this

  constraint c_default_txmit_delay18 {transmit_delay18 >= 0; transmit_delay18 < 20;}

  // These18 declarations18 implement the create() and get_type_name() as well18 as enable automation18 of the
  // transfer18 fields   
  `uvm_object_utils_begin(spi_transfer18)
    `uvm_field_int(transmit_delay18, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data18,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data18,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent18,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This18 requires for registration18 of the ptp_tx_frame18   
  function new(string name = "spi_transfer18");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer18

`endif

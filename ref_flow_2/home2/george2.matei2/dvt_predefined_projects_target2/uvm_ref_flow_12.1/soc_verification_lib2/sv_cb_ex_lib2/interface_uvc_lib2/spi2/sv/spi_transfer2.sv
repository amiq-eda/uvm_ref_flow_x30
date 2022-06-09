/*-------------------------------------------------------------------------
File2 name   : spi_transfer2.sv
Title2       : SPI2 SystemVerilog2 UVM UVC2
Project2     : SystemVerilog2 UVM Cluster2 Level2 Verification2
Created2     :
Description2 : 
Notes2       :  
---------------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef SPI_TRANSFER_SV2
`define SPI_TRANSFER_SV2

class spi_transfer2 extends uvm_sequence_item;

  rand int unsigned transmit_delay2;

  rand bit [31:0] transfer_data2;
  bit [31:0] receive_data2;

  string agent2 = "";        //updated my2 monitor2 - scoreboard2 can use this

  constraint c_default_txmit_delay2 {transmit_delay2 >= 0; transmit_delay2 < 20;}

  // These2 declarations2 implement the create() and get_type_name() as well2 as enable automation2 of the
  // transfer2 fields   
  `uvm_object_utils_begin(spi_transfer2)
    `uvm_field_int(transmit_delay2, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(transfer_data2,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(receive_data2,   UVM_ALL_ON + UVM_HEX)
    `uvm_field_string(agent2,       UVM_ALL_ON + UVM_NOCOMPARE)
  `uvm_object_utils_end

     
  // This2 requires for registration2 of the ptp_tx_frame2   
  function new(string name = "spi_transfer2");
	  super.new(name);
  endfunction 
   

endclass : spi_transfer2

`endif

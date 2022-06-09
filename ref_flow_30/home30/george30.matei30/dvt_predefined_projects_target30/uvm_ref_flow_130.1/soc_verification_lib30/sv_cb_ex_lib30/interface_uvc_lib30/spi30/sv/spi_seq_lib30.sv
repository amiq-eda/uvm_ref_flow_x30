/*-------------------------------------------------------------------------
File30 name   : spi_seq_lib30.sv
Title30       : SPI30 SystemVerilog30 UVM UVC30
Project30     : SystemVerilog30 UVM Cluster30 Level30 Verification30
Created30     :
Description30 : 
Notes30       :  
---------------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef SPI_SEQ_LIB_SV30
`define SPI_SEQ_LIB_SV30

class trans_seq30 extends uvm_sequence #(spi_transfer30);

  function new(string name="trans_seq30");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq30)    
  `uvm_declare_p_sequencer(spi_sequencer30)

  rand int unsigned transmit_del30 = 0;
  constraint transmit_del_ct30 { (transmit_del30 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ30", $psprintf("Doing trans_seq30 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay30 == transmit_del30;} )
  endtask
  
endclass : trans_seq30

class spi_incr_payload30 extends uvm_sequence #(spi_transfer30);

    rand int unsigned cnt_i30;
    rand bit [7:0] start_payload30;

    function new(string name="spi_incr_payload30");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload30)
   `uvm_declare_p_sequencer(spi_sequencer30)

    constraint count_ct30 {cnt_i30 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i30; i++)
      begin
        `uvm_do_with(req, {req.transfer_data30 == (start_payload30 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload30

`endif // SPI_SEQ_LIB_SV30


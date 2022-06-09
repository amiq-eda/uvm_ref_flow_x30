/*-------------------------------------------------------------------------
File27 name   : spi_seq_lib27.sv
Title27       : SPI27 SystemVerilog27 UVM UVC27
Project27     : SystemVerilog27 UVM Cluster27 Level27 Verification27
Created27     :
Description27 : 
Notes27       :  
---------------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef SPI_SEQ_LIB_SV27
`define SPI_SEQ_LIB_SV27

class trans_seq27 extends uvm_sequence #(spi_transfer27);

  function new(string name="trans_seq27");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq27)    
  `uvm_declare_p_sequencer(spi_sequencer27)

  rand int unsigned transmit_del27 = 0;
  constraint transmit_del_ct27 { (transmit_del27 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ27", $psprintf("Doing trans_seq27 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay27 == transmit_del27;} )
  endtask
  
endclass : trans_seq27

class spi_incr_payload27 extends uvm_sequence #(spi_transfer27);

    rand int unsigned cnt_i27;
    rand bit [7:0] start_payload27;

    function new(string name="spi_incr_payload27");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload27)
   `uvm_declare_p_sequencer(spi_sequencer27)

    constraint count_ct27 {cnt_i27 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i27; i++)
      begin
        `uvm_do_with(req, {req.transfer_data27 == (start_payload27 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload27

`endif // SPI_SEQ_LIB_SV27


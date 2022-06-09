/*-------------------------------------------------------------------------
File24 name   : spi_seq_lib24.sv
Title24       : SPI24 SystemVerilog24 UVM UVC24
Project24     : SystemVerilog24 UVM Cluster24 Level24 Verification24
Created24     :
Description24 : 
Notes24       :  
---------------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef SPI_SEQ_LIB_SV24
`define SPI_SEQ_LIB_SV24

class trans_seq24 extends uvm_sequence #(spi_transfer24);

  function new(string name="trans_seq24");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq24)    
  `uvm_declare_p_sequencer(spi_sequencer24)

  rand int unsigned transmit_del24 = 0;
  constraint transmit_del_ct24 { (transmit_del24 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ24", $psprintf("Doing trans_seq24 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay24 == transmit_del24;} )
  endtask
  
endclass : trans_seq24

class spi_incr_payload24 extends uvm_sequence #(spi_transfer24);

    rand int unsigned cnt_i24;
    rand bit [7:0] start_payload24;

    function new(string name="spi_incr_payload24");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload24)
   `uvm_declare_p_sequencer(spi_sequencer24)

    constraint count_ct24 {cnt_i24 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i24; i++)
      begin
        `uvm_do_with(req, {req.transfer_data24 == (start_payload24 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload24

`endif // SPI_SEQ_LIB_SV24


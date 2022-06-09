/*-------------------------------------------------------------------------
File9 name   : spi_seq_lib9.sv
Title9       : SPI9 SystemVerilog9 UVM UVC9
Project9     : SystemVerilog9 UVM Cluster9 Level9 Verification9
Created9     :
Description9 : 
Notes9       :  
---------------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef SPI_SEQ_LIB_SV9
`define SPI_SEQ_LIB_SV9

class trans_seq9 extends uvm_sequence #(spi_transfer9);

  function new(string name="trans_seq9");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq9)    
  `uvm_declare_p_sequencer(spi_sequencer9)

  rand int unsigned transmit_del9 = 0;
  constraint transmit_del_ct9 { (transmit_del9 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ9", $psprintf("Doing trans_seq9 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay9 == transmit_del9;} )
  endtask
  
endclass : trans_seq9

class spi_incr_payload9 extends uvm_sequence #(spi_transfer9);

    rand int unsigned cnt_i9;
    rand bit [7:0] start_payload9;

    function new(string name="spi_incr_payload9");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload9)
   `uvm_declare_p_sequencer(spi_sequencer9)

    constraint count_ct9 {cnt_i9 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i9; i++)
      begin
        `uvm_do_with(req, {req.transfer_data9 == (start_payload9 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload9

`endif // SPI_SEQ_LIB_SV9


/*-------------------------------------------------------------------------
File22 name   : spi_seq_lib22.sv
Title22       : SPI22 SystemVerilog22 UVM UVC22
Project22     : SystemVerilog22 UVM Cluster22 Level22 Verification22
Created22     :
Description22 : 
Notes22       :  
---------------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef SPI_SEQ_LIB_SV22
`define SPI_SEQ_LIB_SV22

class trans_seq22 extends uvm_sequence #(spi_transfer22);

  function new(string name="trans_seq22");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq22)    
  `uvm_declare_p_sequencer(spi_sequencer22)

  rand int unsigned transmit_del22 = 0;
  constraint transmit_del_ct22 { (transmit_del22 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ22", $psprintf("Doing trans_seq22 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay22 == transmit_del22;} )
  endtask
  
endclass : trans_seq22

class spi_incr_payload22 extends uvm_sequence #(spi_transfer22);

    rand int unsigned cnt_i22;
    rand bit [7:0] start_payload22;

    function new(string name="spi_incr_payload22");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload22)
   `uvm_declare_p_sequencer(spi_sequencer22)

    constraint count_ct22 {cnt_i22 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i22; i++)
      begin
        `uvm_do_with(req, {req.transfer_data22 == (start_payload22 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload22

`endif // SPI_SEQ_LIB_SV22


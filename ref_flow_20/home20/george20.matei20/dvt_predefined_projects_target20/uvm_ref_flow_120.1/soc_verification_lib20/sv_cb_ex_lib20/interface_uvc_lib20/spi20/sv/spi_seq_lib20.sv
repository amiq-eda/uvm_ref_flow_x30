/*-------------------------------------------------------------------------
File20 name   : spi_seq_lib20.sv
Title20       : SPI20 SystemVerilog20 UVM UVC20
Project20     : SystemVerilog20 UVM Cluster20 Level20 Verification20
Created20     :
Description20 : 
Notes20       :  
---------------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef SPI_SEQ_LIB_SV20
`define SPI_SEQ_LIB_SV20

class trans_seq20 extends uvm_sequence #(spi_transfer20);

  function new(string name="trans_seq20");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq20)    
  `uvm_declare_p_sequencer(spi_sequencer20)

  rand int unsigned transmit_del20 = 0;
  constraint transmit_del_ct20 { (transmit_del20 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ20", $psprintf("Doing trans_seq20 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay20 == transmit_del20;} )
  endtask
  
endclass : trans_seq20

class spi_incr_payload20 extends uvm_sequence #(spi_transfer20);

    rand int unsigned cnt_i20;
    rand bit [7:0] start_payload20;

    function new(string name="spi_incr_payload20");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload20)
   `uvm_declare_p_sequencer(spi_sequencer20)

    constraint count_ct20 {cnt_i20 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i20; i++)
      begin
        `uvm_do_with(req, {req.transfer_data20 == (start_payload20 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload20

`endif // SPI_SEQ_LIB_SV20


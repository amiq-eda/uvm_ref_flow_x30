/*-------------------------------------------------------------------------
File16 name   : spi_seq_lib16.sv
Title16       : SPI16 SystemVerilog16 UVM UVC16
Project16     : SystemVerilog16 UVM Cluster16 Level16 Verification16
Created16     :
Description16 : 
Notes16       :  
---------------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef SPI_SEQ_LIB_SV16
`define SPI_SEQ_LIB_SV16

class trans_seq16 extends uvm_sequence #(spi_transfer16);

  function new(string name="trans_seq16");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq16)    
  `uvm_declare_p_sequencer(spi_sequencer16)

  rand int unsigned transmit_del16 = 0;
  constraint transmit_del_ct16 { (transmit_del16 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ16", $psprintf("Doing trans_seq16 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay16 == transmit_del16;} )
  endtask
  
endclass : trans_seq16

class spi_incr_payload16 extends uvm_sequence #(spi_transfer16);

    rand int unsigned cnt_i16;
    rand bit [7:0] start_payload16;

    function new(string name="spi_incr_payload16");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload16)
   `uvm_declare_p_sequencer(spi_sequencer16)

    constraint count_ct16 {cnt_i16 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i16; i++)
      begin
        `uvm_do_with(req, {req.transfer_data16 == (start_payload16 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload16

`endif // SPI_SEQ_LIB_SV16


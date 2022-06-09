/*-------------------------------------------------------------------------
File6 name   : spi_seq_lib6.sv
Title6       : SPI6 SystemVerilog6 UVM UVC6
Project6     : SystemVerilog6 UVM Cluster6 Level6 Verification6
Created6     :
Description6 : 
Notes6       :  
---------------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef SPI_SEQ_LIB_SV6
`define SPI_SEQ_LIB_SV6

class trans_seq6 extends uvm_sequence #(spi_transfer6);

  function new(string name="trans_seq6");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq6)    
  `uvm_declare_p_sequencer(spi_sequencer6)

  rand int unsigned transmit_del6 = 0;
  constraint transmit_del_ct6 { (transmit_del6 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ6", $psprintf("Doing trans_seq6 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay6 == transmit_del6;} )
  endtask
  
endclass : trans_seq6

class spi_incr_payload6 extends uvm_sequence #(spi_transfer6);

    rand int unsigned cnt_i6;
    rand bit [7:0] start_payload6;

    function new(string name="spi_incr_payload6");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload6)
   `uvm_declare_p_sequencer(spi_sequencer6)

    constraint count_ct6 {cnt_i6 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i6; i++)
      begin
        `uvm_do_with(req, {req.transfer_data6 == (start_payload6 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload6

`endif // SPI_SEQ_LIB_SV6


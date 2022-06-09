/*-------------------------------------------------------------------------
File5 name   : spi_seq_lib5.sv
Title5       : SPI5 SystemVerilog5 UVM UVC5
Project5     : SystemVerilog5 UVM Cluster5 Level5 Verification5
Created5     :
Description5 : 
Notes5       :  
---------------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef SPI_SEQ_LIB_SV5
`define SPI_SEQ_LIB_SV5

class trans_seq5 extends uvm_sequence #(spi_transfer5);

  function new(string name="trans_seq5");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq5)    
  `uvm_declare_p_sequencer(spi_sequencer5)

  rand int unsigned transmit_del5 = 0;
  constraint transmit_del_ct5 { (transmit_del5 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ5", $psprintf("Doing trans_seq5 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay5 == transmit_del5;} )
  endtask
  
endclass : trans_seq5

class spi_incr_payload5 extends uvm_sequence #(spi_transfer5);

    rand int unsigned cnt_i5;
    rand bit [7:0] start_payload5;

    function new(string name="spi_incr_payload5");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload5)
   `uvm_declare_p_sequencer(spi_sequencer5)

    constraint count_ct5 {cnt_i5 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i5; i++)
      begin
        `uvm_do_with(req, {req.transfer_data5 == (start_payload5 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload5

`endif // SPI_SEQ_LIB_SV5


/*-------------------------------------------------------------------------
File2 name   : spi_seq_lib2.sv
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


`ifndef SPI_SEQ_LIB_SV2
`define SPI_SEQ_LIB_SV2

class trans_seq2 extends uvm_sequence #(spi_transfer2);

  function new(string name="trans_seq2");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq2)    
  `uvm_declare_p_sequencer(spi_sequencer2)

  rand int unsigned transmit_del2 = 0;
  constraint transmit_del_ct2 { (transmit_del2 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ2", $psprintf("Doing trans_seq2 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay2 == transmit_del2;} )
  endtask
  
endclass : trans_seq2

class spi_incr_payload2 extends uvm_sequence #(spi_transfer2);

    rand int unsigned cnt_i2;
    rand bit [7:0] start_payload2;

    function new(string name="spi_incr_payload2");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload2)
   `uvm_declare_p_sequencer(spi_sequencer2)

    constraint count_ct2 {cnt_i2 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i2; i++)
      begin
        `uvm_do_with(req, {req.transfer_data2 == (start_payload2 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload2

`endif // SPI_SEQ_LIB_SV2


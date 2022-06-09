/*-------------------------------------------------------------------------
File21 name   : spi_seq_lib21.sv
Title21       : SPI21 SystemVerilog21 UVM UVC21
Project21     : SystemVerilog21 UVM Cluster21 Level21 Verification21
Created21     :
Description21 : 
Notes21       :  
---------------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef SPI_SEQ_LIB_SV21
`define SPI_SEQ_LIB_SV21

class trans_seq21 extends uvm_sequence #(spi_transfer21);

  function new(string name="trans_seq21");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq21)    
  `uvm_declare_p_sequencer(spi_sequencer21)

  rand int unsigned transmit_del21 = 0;
  constraint transmit_del_ct21 { (transmit_del21 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ21", $psprintf("Doing trans_seq21 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay21 == transmit_del21;} )
  endtask
  
endclass : trans_seq21

class spi_incr_payload21 extends uvm_sequence #(spi_transfer21);

    rand int unsigned cnt_i21;
    rand bit [7:0] start_payload21;

    function new(string name="spi_incr_payload21");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload21)
   `uvm_declare_p_sequencer(spi_sequencer21)

    constraint count_ct21 {cnt_i21 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i21; i++)
      begin
        `uvm_do_with(req, {req.transfer_data21 == (start_payload21 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload21

`endif // SPI_SEQ_LIB_SV21


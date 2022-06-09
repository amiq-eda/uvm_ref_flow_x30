/*-------------------------------------------------------------------------
File23 name   : spi_seq_lib23.sv
Title23       : SPI23 SystemVerilog23 UVM UVC23
Project23     : SystemVerilog23 UVM Cluster23 Level23 Verification23
Created23     :
Description23 : 
Notes23       :  
---------------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef SPI_SEQ_LIB_SV23
`define SPI_SEQ_LIB_SV23

class trans_seq23 extends uvm_sequence #(spi_transfer23);

  function new(string name="trans_seq23");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq23)    
  `uvm_declare_p_sequencer(spi_sequencer23)

  rand int unsigned transmit_del23 = 0;
  constraint transmit_del_ct23 { (transmit_del23 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ23", $psprintf("Doing trans_seq23 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay23 == transmit_del23;} )
  endtask
  
endclass : trans_seq23

class spi_incr_payload23 extends uvm_sequence #(spi_transfer23);

    rand int unsigned cnt_i23;
    rand bit [7:0] start_payload23;

    function new(string name="spi_incr_payload23");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload23)
   `uvm_declare_p_sequencer(spi_sequencer23)

    constraint count_ct23 {cnt_i23 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i23; i++)
      begin
        `uvm_do_with(req, {req.transfer_data23 == (start_payload23 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload23

`endif // SPI_SEQ_LIB_SV23


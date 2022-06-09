/*-------------------------------------------------------------------------
File18 name   : spi_seq_lib18.sv
Title18       : SPI18 SystemVerilog18 UVM UVC18
Project18     : SystemVerilog18 UVM Cluster18 Level18 Verification18
Created18     :
Description18 : 
Notes18       :  
---------------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef SPI_SEQ_LIB_SV18
`define SPI_SEQ_LIB_SV18

class trans_seq18 extends uvm_sequence #(spi_transfer18);

  function new(string name="trans_seq18");
    super.new(name);
  endfunction
  
  `uvm_object_utils(trans_seq18)    
  `uvm_declare_p_sequencer(spi_sequencer18)

  rand int unsigned transmit_del18 = 0;
  constraint transmit_del_ct18 { (transmit_del18 <= 10); }

  virtual task body();
    `uvm_info("SPI_SEQ18", $psprintf("Doing trans_seq18 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay18 == transmit_del18;} )
  endtask
  
endclass : trans_seq18

class spi_incr_payload18 extends uvm_sequence #(spi_transfer18);

    rand int unsigned cnt_i18;
    rand bit [7:0] start_payload18;

    function new(string name="spi_incr_payload18");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(spi_incr_payload18)
   `uvm_declare_p_sequencer(spi_sequencer18)

    constraint count_ct18 {cnt_i18 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i18; i++)
      begin
        `uvm_do_with(req, {req.transfer_data18 == (start_payload18 +i*3)%256; })
      end
    endtask
endclass: spi_incr_payload18

`endif // SPI_SEQ_LIB_SV18


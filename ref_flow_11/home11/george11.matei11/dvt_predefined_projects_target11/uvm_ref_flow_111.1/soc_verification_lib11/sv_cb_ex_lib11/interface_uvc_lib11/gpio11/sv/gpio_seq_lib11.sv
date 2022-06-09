/*-------------------------------------------------------------------------
File11 name   : gpio_seq_lib11.sv
Title11       : GPIO11 SystemVerilog11 UVM UVC11
Project11     : SystemVerilog11 UVM Cluster11 Level11 Verification11
Created11     :
Description11 : 
Notes11       :  
---------------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV11
`define GPIO_SEQ_LIB_SV11

class gpio_simple_trans_seq11 extends uvm_sequence #(gpio_transfer11);

  function new(string name="gpio_simple_trans_seq11");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq11)    
  `uvm_declare_p_sequencer(gpio_sequencer11)

  rand int unsigned transmit_del11 = 0;
  constraint transmit_del_ct11 { (transmit_del11 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ11", $psprintf("Doing gpio_simple_trans_seq11 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay11 == transmit_del11;} )
  endtask
  
endclass : gpio_simple_trans_seq11

class gpio_multiple_simple_trans11 extends uvm_sequence #(gpio_transfer11);

    rand int unsigned cnt_i11;

    gpio_simple_trans_seq11 simple_trans11;

    function new(string name="gpio_multiple_simple_trans11");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans11)    
   `uvm_declare_p_sequencer(gpio_sequencer11)

    constraint count_ct11 {cnt_i11 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i11; i++)
      begin
        `uvm_do(simple_trans11)
      end
    endtask
endclass: gpio_multiple_simple_trans11

`endif // GPIO_SEQ_LIB_SV11


/*-------------------------------------------------------------------------
File19 name   : gpio_seq_lib19.sv
Title19       : GPIO19 SystemVerilog19 UVM UVC19
Project19     : SystemVerilog19 UVM Cluster19 Level19 Verification19
Created19     :
Description19 : 
Notes19       :  
---------------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV19
`define GPIO_SEQ_LIB_SV19

class gpio_simple_trans_seq19 extends uvm_sequence #(gpio_transfer19);

  function new(string name="gpio_simple_trans_seq19");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq19)    
  `uvm_declare_p_sequencer(gpio_sequencer19)

  rand int unsigned transmit_del19 = 0;
  constraint transmit_del_ct19 { (transmit_del19 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ19", $psprintf("Doing gpio_simple_trans_seq19 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay19 == transmit_del19;} )
  endtask
  
endclass : gpio_simple_trans_seq19

class gpio_multiple_simple_trans19 extends uvm_sequence #(gpio_transfer19);

    rand int unsigned cnt_i19;

    gpio_simple_trans_seq19 simple_trans19;

    function new(string name="gpio_multiple_simple_trans19");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans19)    
   `uvm_declare_p_sequencer(gpio_sequencer19)

    constraint count_ct19 {cnt_i19 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i19; i++)
      begin
        `uvm_do(simple_trans19)
      end
    endtask
endclass: gpio_multiple_simple_trans19

`endif // GPIO_SEQ_LIB_SV19


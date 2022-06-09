/*-------------------------------------------------------------------------
File13 name   : gpio_seq_lib13.sv
Title13       : GPIO13 SystemVerilog13 UVM UVC13
Project13     : SystemVerilog13 UVM Cluster13 Level13 Verification13
Created13     :
Description13 : 
Notes13       :  
---------------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV13
`define GPIO_SEQ_LIB_SV13

class gpio_simple_trans_seq13 extends uvm_sequence #(gpio_transfer13);

  function new(string name="gpio_simple_trans_seq13");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq13)    
  `uvm_declare_p_sequencer(gpio_sequencer13)

  rand int unsigned transmit_del13 = 0;
  constraint transmit_del_ct13 { (transmit_del13 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ13", $psprintf("Doing gpio_simple_trans_seq13 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay13 == transmit_del13;} )
  endtask
  
endclass : gpio_simple_trans_seq13

class gpio_multiple_simple_trans13 extends uvm_sequence #(gpio_transfer13);

    rand int unsigned cnt_i13;

    gpio_simple_trans_seq13 simple_trans13;

    function new(string name="gpio_multiple_simple_trans13");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans13)    
   `uvm_declare_p_sequencer(gpio_sequencer13)

    constraint count_ct13 {cnt_i13 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i13; i++)
      begin
        `uvm_do(simple_trans13)
      end
    endtask
endclass: gpio_multiple_simple_trans13

`endif // GPIO_SEQ_LIB_SV13


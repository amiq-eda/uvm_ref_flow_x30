/*-------------------------------------------------------------------------
File8 name   : gpio_seq_lib8.sv
Title8       : GPIO8 SystemVerilog8 UVM UVC8
Project8     : SystemVerilog8 UVM Cluster8 Level8 Verification8
Created8     :
Description8 : 
Notes8       :  
---------------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV8
`define GPIO_SEQ_LIB_SV8

class gpio_simple_trans_seq8 extends uvm_sequence #(gpio_transfer8);

  function new(string name="gpio_simple_trans_seq8");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq8)    
  `uvm_declare_p_sequencer(gpio_sequencer8)

  rand int unsigned transmit_del8 = 0;
  constraint transmit_del_ct8 { (transmit_del8 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ8", $psprintf("Doing gpio_simple_trans_seq8 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay8 == transmit_del8;} )
  endtask
  
endclass : gpio_simple_trans_seq8

class gpio_multiple_simple_trans8 extends uvm_sequence #(gpio_transfer8);

    rand int unsigned cnt_i8;

    gpio_simple_trans_seq8 simple_trans8;

    function new(string name="gpio_multiple_simple_trans8");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans8)    
   `uvm_declare_p_sequencer(gpio_sequencer8)

    constraint count_ct8 {cnt_i8 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i8; i++)
      begin
        `uvm_do(simple_trans8)
      end
    endtask
endclass: gpio_multiple_simple_trans8

`endif // GPIO_SEQ_LIB_SV8


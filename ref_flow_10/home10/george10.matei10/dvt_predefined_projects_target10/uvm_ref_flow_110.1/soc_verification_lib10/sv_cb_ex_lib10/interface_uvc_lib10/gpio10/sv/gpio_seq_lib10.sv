/*-------------------------------------------------------------------------
File10 name   : gpio_seq_lib10.sv
Title10       : GPIO10 SystemVerilog10 UVM UVC10
Project10     : SystemVerilog10 UVM Cluster10 Level10 Verification10
Created10     :
Description10 : 
Notes10       :  
---------------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV10
`define GPIO_SEQ_LIB_SV10

class gpio_simple_trans_seq10 extends uvm_sequence #(gpio_transfer10);

  function new(string name="gpio_simple_trans_seq10");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq10)    
  `uvm_declare_p_sequencer(gpio_sequencer10)

  rand int unsigned transmit_del10 = 0;
  constraint transmit_del_ct10 { (transmit_del10 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ10", $psprintf("Doing gpio_simple_trans_seq10 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay10 == transmit_del10;} )
  endtask
  
endclass : gpio_simple_trans_seq10

class gpio_multiple_simple_trans10 extends uvm_sequence #(gpio_transfer10);

    rand int unsigned cnt_i10;

    gpio_simple_trans_seq10 simple_trans10;

    function new(string name="gpio_multiple_simple_trans10");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans10)    
   `uvm_declare_p_sequencer(gpio_sequencer10)

    constraint count_ct10 {cnt_i10 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i10; i++)
      begin
        `uvm_do(simple_trans10)
      end
    endtask
endclass: gpio_multiple_simple_trans10

`endif // GPIO_SEQ_LIB_SV10


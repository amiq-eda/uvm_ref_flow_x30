/*-------------------------------------------------------------------------
File17 name   : gpio_seq_lib17.sv
Title17       : GPIO17 SystemVerilog17 UVM UVC17
Project17     : SystemVerilog17 UVM Cluster17 Level17 Verification17
Created17     :
Description17 : 
Notes17       :  
---------------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV17
`define GPIO_SEQ_LIB_SV17

class gpio_simple_trans_seq17 extends uvm_sequence #(gpio_transfer17);

  function new(string name="gpio_simple_trans_seq17");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq17)    
  `uvm_declare_p_sequencer(gpio_sequencer17)

  rand int unsigned transmit_del17 = 0;
  constraint transmit_del_ct17 { (transmit_del17 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ17", $psprintf("Doing gpio_simple_trans_seq17 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay17 == transmit_del17;} )
  endtask
  
endclass : gpio_simple_trans_seq17

class gpio_multiple_simple_trans17 extends uvm_sequence #(gpio_transfer17);

    rand int unsigned cnt_i17;

    gpio_simple_trans_seq17 simple_trans17;

    function new(string name="gpio_multiple_simple_trans17");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans17)    
   `uvm_declare_p_sequencer(gpio_sequencer17)

    constraint count_ct17 {cnt_i17 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i17; i++)
      begin
        `uvm_do(simple_trans17)
      end
    endtask
endclass: gpio_multiple_simple_trans17

`endif // GPIO_SEQ_LIB_SV17


/*-------------------------------------------------------------------------
File4 name   : gpio_seq_lib4.sv
Title4       : GPIO4 SystemVerilog4 UVM UVC4
Project4     : SystemVerilog4 UVM Cluster4 Level4 Verification4
Created4     :
Description4 : 
Notes4       :  
---------------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV4
`define GPIO_SEQ_LIB_SV4

class gpio_simple_trans_seq4 extends uvm_sequence #(gpio_transfer4);

  function new(string name="gpio_simple_trans_seq4");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq4)    
  `uvm_declare_p_sequencer(gpio_sequencer4)

  rand int unsigned transmit_del4 = 0;
  constraint transmit_del_ct4 { (transmit_del4 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ4", $psprintf("Doing gpio_simple_trans_seq4 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay4 == transmit_del4;} )
  endtask
  
endclass : gpio_simple_trans_seq4

class gpio_multiple_simple_trans4 extends uvm_sequence #(gpio_transfer4);

    rand int unsigned cnt_i4;

    gpio_simple_trans_seq4 simple_trans4;

    function new(string name="gpio_multiple_simple_trans4");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans4)    
   `uvm_declare_p_sequencer(gpio_sequencer4)

    constraint count_ct4 {cnt_i4 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i4; i++)
      begin
        `uvm_do(simple_trans4)
      end
    endtask
endclass: gpio_multiple_simple_trans4

`endif // GPIO_SEQ_LIB_SV4


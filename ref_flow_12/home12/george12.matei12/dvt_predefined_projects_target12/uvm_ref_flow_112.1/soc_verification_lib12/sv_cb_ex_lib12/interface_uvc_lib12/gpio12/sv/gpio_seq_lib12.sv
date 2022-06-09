/*-------------------------------------------------------------------------
File12 name   : gpio_seq_lib12.sv
Title12       : GPIO12 SystemVerilog12 UVM UVC12
Project12     : SystemVerilog12 UVM Cluster12 Level12 Verification12
Created12     :
Description12 : 
Notes12       :  
---------------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV12
`define GPIO_SEQ_LIB_SV12

class gpio_simple_trans_seq12 extends uvm_sequence #(gpio_transfer12);

  function new(string name="gpio_simple_trans_seq12");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq12)    
  `uvm_declare_p_sequencer(gpio_sequencer12)

  rand int unsigned transmit_del12 = 0;
  constraint transmit_del_ct12 { (transmit_del12 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ12", $psprintf("Doing gpio_simple_trans_seq12 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay12 == transmit_del12;} )
  endtask
  
endclass : gpio_simple_trans_seq12

class gpio_multiple_simple_trans12 extends uvm_sequence #(gpio_transfer12);

    rand int unsigned cnt_i12;

    gpio_simple_trans_seq12 simple_trans12;

    function new(string name="gpio_multiple_simple_trans12");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans12)    
   `uvm_declare_p_sequencer(gpio_sequencer12)

    constraint count_ct12 {cnt_i12 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i12; i++)
      begin
        `uvm_do(simple_trans12)
      end
    endtask
endclass: gpio_multiple_simple_trans12

`endif // GPIO_SEQ_LIB_SV12


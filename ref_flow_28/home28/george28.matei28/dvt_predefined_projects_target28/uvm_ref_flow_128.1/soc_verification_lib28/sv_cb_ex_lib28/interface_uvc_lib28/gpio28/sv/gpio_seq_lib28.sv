/*-------------------------------------------------------------------------
File28 name   : gpio_seq_lib28.sv
Title28       : GPIO28 SystemVerilog28 UVM UVC28
Project28     : SystemVerilog28 UVM Cluster28 Level28 Verification28
Created28     :
Description28 : 
Notes28       :  
---------------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV28
`define GPIO_SEQ_LIB_SV28

class gpio_simple_trans_seq28 extends uvm_sequence #(gpio_transfer28);

  function new(string name="gpio_simple_trans_seq28");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq28)    
  `uvm_declare_p_sequencer(gpio_sequencer28)

  rand int unsigned transmit_del28 = 0;
  constraint transmit_del_ct28 { (transmit_del28 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ28", $psprintf("Doing gpio_simple_trans_seq28 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay28 == transmit_del28;} )
  endtask
  
endclass : gpio_simple_trans_seq28

class gpio_multiple_simple_trans28 extends uvm_sequence #(gpio_transfer28);

    rand int unsigned cnt_i28;

    gpio_simple_trans_seq28 simple_trans28;

    function new(string name="gpio_multiple_simple_trans28");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans28)    
   `uvm_declare_p_sequencer(gpio_sequencer28)

    constraint count_ct28 {cnt_i28 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i28; i++)
      begin
        `uvm_do(simple_trans28)
      end
    endtask
endclass: gpio_multiple_simple_trans28

`endif // GPIO_SEQ_LIB_SV28


/*-------------------------------------------------------------------------
File23 name   : gpio_seq_lib23.sv
Title23       : GPIO23 SystemVerilog23 UVM UVC23
Project23     : SystemVerilog23 UVM Cluster23 Level23 Verification23
Created23     :
Description23 : 
Notes23       :  
---------------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV23
`define GPIO_SEQ_LIB_SV23

class gpio_simple_trans_seq23 extends uvm_sequence #(gpio_transfer23);

  function new(string name="gpio_simple_trans_seq23");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq23)    
  `uvm_declare_p_sequencer(gpio_sequencer23)

  rand int unsigned transmit_del23 = 0;
  constraint transmit_del_ct23 { (transmit_del23 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ23", $psprintf("Doing gpio_simple_trans_seq23 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay23 == transmit_del23;} )
  endtask
  
endclass : gpio_simple_trans_seq23

class gpio_multiple_simple_trans23 extends uvm_sequence #(gpio_transfer23);

    rand int unsigned cnt_i23;

    gpio_simple_trans_seq23 simple_trans23;

    function new(string name="gpio_multiple_simple_trans23");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans23)    
   `uvm_declare_p_sequencer(gpio_sequencer23)

    constraint count_ct23 {cnt_i23 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i23; i++)
      begin
        `uvm_do(simple_trans23)
      end
    endtask
endclass: gpio_multiple_simple_trans23

`endif // GPIO_SEQ_LIB_SV23


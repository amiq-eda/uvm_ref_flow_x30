/*-------------------------------------------------------------------------
File21 name   : gpio_seq_lib21.sv
Title21       : GPIO21 SystemVerilog21 UVM UVC21
Project21     : SystemVerilog21 UVM Cluster21 Level21 Verification21
Created21     :
Description21 : 
Notes21       :  
---------------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV21
`define GPIO_SEQ_LIB_SV21

class gpio_simple_trans_seq21 extends uvm_sequence #(gpio_transfer21);

  function new(string name="gpio_simple_trans_seq21");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq21)    
  `uvm_declare_p_sequencer(gpio_sequencer21)

  rand int unsigned transmit_del21 = 0;
  constraint transmit_del_ct21 { (transmit_del21 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ21", $psprintf("Doing gpio_simple_trans_seq21 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay21 == transmit_del21;} )
  endtask
  
endclass : gpio_simple_trans_seq21

class gpio_multiple_simple_trans21 extends uvm_sequence #(gpio_transfer21);

    rand int unsigned cnt_i21;

    gpio_simple_trans_seq21 simple_trans21;

    function new(string name="gpio_multiple_simple_trans21");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans21)    
   `uvm_declare_p_sequencer(gpio_sequencer21)

    constraint count_ct21 {cnt_i21 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i21; i++)
      begin
        `uvm_do(simple_trans21)
      end
    endtask
endclass: gpio_multiple_simple_trans21

`endif // GPIO_SEQ_LIB_SV21


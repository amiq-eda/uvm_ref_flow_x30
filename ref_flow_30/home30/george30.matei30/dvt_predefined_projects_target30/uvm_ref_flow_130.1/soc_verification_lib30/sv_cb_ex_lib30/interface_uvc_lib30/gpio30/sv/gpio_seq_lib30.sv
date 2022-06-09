/*-------------------------------------------------------------------------
File30 name   : gpio_seq_lib30.sv
Title30       : GPIO30 SystemVerilog30 UVM UVC30
Project30     : SystemVerilog30 UVM Cluster30 Level30 Verification30
Created30     :
Description30 : 
Notes30       :  
---------------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV30
`define GPIO_SEQ_LIB_SV30

class gpio_simple_trans_seq30 extends uvm_sequence #(gpio_transfer30);

  function new(string name="gpio_simple_trans_seq30");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq30)    
  `uvm_declare_p_sequencer(gpio_sequencer30)

  rand int unsigned transmit_del30 = 0;
  constraint transmit_del_ct30 { (transmit_del30 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ30", $psprintf("Doing gpio_simple_trans_seq30 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay30 == transmit_del30;} )
  endtask
  
endclass : gpio_simple_trans_seq30

class gpio_multiple_simple_trans30 extends uvm_sequence #(gpio_transfer30);

    rand int unsigned cnt_i30;

    gpio_simple_trans_seq30 simple_trans30;

    function new(string name="gpio_multiple_simple_trans30");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans30)    
   `uvm_declare_p_sequencer(gpio_sequencer30)

    constraint count_ct30 {cnt_i30 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i30; i++)
      begin
        `uvm_do(simple_trans30)
      end
    endtask
endclass: gpio_multiple_simple_trans30

`endif // GPIO_SEQ_LIB_SV30


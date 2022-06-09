/*-------------------------------------------------------------------------
File5 name   : gpio_seq_lib5.sv
Title5       : GPIO5 SystemVerilog5 UVM UVC5
Project5     : SystemVerilog5 UVM Cluster5 Level5 Verification5
Created5     :
Description5 : 
Notes5       :  
---------------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV5
`define GPIO_SEQ_LIB_SV5

class gpio_simple_trans_seq5 extends uvm_sequence #(gpio_transfer5);

  function new(string name="gpio_simple_trans_seq5");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq5)    
  `uvm_declare_p_sequencer(gpio_sequencer5)

  rand int unsigned transmit_del5 = 0;
  constraint transmit_del_ct5 { (transmit_del5 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ5", $psprintf("Doing gpio_simple_trans_seq5 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay5 == transmit_del5;} )
  endtask
  
endclass : gpio_simple_trans_seq5

class gpio_multiple_simple_trans5 extends uvm_sequence #(gpio_transfer5);

    rand int unsigned cnt_i5;

    gpio_simple_trans_seq5 simple_trans5;

    function new(string name="gpio_multiple_simple_trans5");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans5)    
   `uvm_declare_p_sequencer(gpio_sequencer5)

    constraint count_ct5 {cnt_i5 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i5; i++)
      begin
        `uvm_do(simple_trans5)
      end
    endtask
endclass: gpio_multiple_simple_trans5

`endif // GPIO_SEQ_LIB_SV5


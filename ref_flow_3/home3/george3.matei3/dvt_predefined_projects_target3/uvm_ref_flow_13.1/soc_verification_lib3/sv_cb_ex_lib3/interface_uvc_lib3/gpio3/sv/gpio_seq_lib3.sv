/*-------------------------------------------------------------------------
File3 name   : gpio_seq_lib3.sv
Title3       : GPIO3 SystemVerilog3 UVM UVC3
Project3     : SystemVerilog3 UVM Cluster3 Level3 Verification3
Created3     :
Description3 : 
Notes3       :  
---------------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV3
`define GPIO_SEQ_LIB_SV3

class gpio_simple_trans_seq3 extends uvm_sequence #(gpio_transfer3);

  function new(string name="gpio_simple_trans_seq3");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq3)    
  `uvm_declare_p_sequencer(gpio_sequencer3)

  rand int unsigned transmit_del3 = 0;
  constraint transmit_del_ct3 { (transmit_del3 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ3", $psprintf("Doing gpio_simple_trans_seq3 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay3 == transmit_del3;} )
  endtask
  
endclass : gpio_simple_trans_seq3

class gpio_multiple_simple_trans3 extends uvm_sequence #(gpio_transfer3);

    rand int unsigned cnt_i3;

    gpio_simple_trans_seq3 simple_trans3;

    function new(string name="gpio_multiple_simple_trans3");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans3)    
   `uvm_declare_p_sequencer(gpio_sequencer3)

    constraint count_ct3 {cnt_i3 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i3; i++)
      begin
        `uvm_do(simple_trans3)
      end
    endtask
endclass: gpio_multiple_simple_trans3

`endif // GPIO_SEQ_LIB_SV3


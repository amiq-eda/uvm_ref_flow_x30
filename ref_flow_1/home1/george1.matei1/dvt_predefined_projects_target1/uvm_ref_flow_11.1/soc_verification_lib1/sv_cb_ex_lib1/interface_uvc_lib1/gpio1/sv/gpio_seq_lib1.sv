/*-------------------------------------------------------------------------
File1 name   : gpio_seq_lib1.sv
Title1       : GPIO1 SystemVerilog1 UVM UVC1
Project1     : SystemVerilog1 UVM Cluster1 Level1 Verification1
Created1     :
Description1 : 
Notes1       :  
---------------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV1
`define GPIO_SEQ_LIB_SV1

class gpio_simple_trans_seq1 extends uvm_sequence #(gpio_transfer1);

  function new(string name="gpio_simple_trans_seq1");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq1)    
  `uvm_declare_p_sequencer(gpio_sequencer1)

  rand int unsigned transmit_del1 = 0;
  constraint transmit_del_ct1 { (transmit_del1 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ1", $psprintf("Doing gpio_simple_trans_seq1 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay1 == transmit_del1;} )
  endtask
  
endclass : gpio_simple_trans_seq1

class gpio_multiple_simple_trans1 extends uvm_sequence #(gpio_transfer1);

    rand int unsigned cnt_i1;

    gpio_simple_trans_seq1 simple_trans1;

    function new(string name="gpio_multiple_simple_trans1");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans1)    
   `uvm_declare_p_sequencer(gpio_sequencer1)

    constraint count_ct1 {cnt_i1 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i1; i++)
      begin
        `uvm_do(simple_trans1)
      end
    endtask
endclass: gpio_multiple_simple_trans1

`endif // GPIO_SEQ_LIB_SV1


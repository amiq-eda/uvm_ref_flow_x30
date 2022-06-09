/*-------------------------------------------------------------------------
File25 name   : gpio_seq_lib25.sv
Title25       : GPIO25 SystemVerilog25 UVM UVC25
Project25     : SystemVerilog25 UVM Cluster25 Level25 Verification25
Created25     :
Description25 : 
Notes25       :  
---------------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV25
`define GPIO_SEQ_LIB_SV25

class gpio_simple_trans_seq25 extends uvm_sequence #(gpio_transfer25);

  function new(string name="gpio_simple_trans_seq25");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq25)    
  `uvm_declare_p_sequencer(gpio_sequencer25)

  rand int unsigned transmit_del25 = 0;
  constraint transmit_del_ct25 { (transmit_del25 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ25", $psprintf("Doing gpio_simple_trans_seq25 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay25 == transmit_del25;} )
  endtask
  
endclass : gpio_simple_trans_seq25

class gpio_multiple_simple_trans25 extends uvm_sequence #(gpio_transfer25);

    rand int unsigned cnt_i25;

    gpio_simple_trans_seq25 simple_trans25;

    function new(string name="gpio_multiple_simple_trans25");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans25)    
   `uvm_declare_p_sequencer(gpio_sequencer25)

    constraint count_ct25 {cnt_i25 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i25; i++)
      begin
        `uvm_do(simple_trans25)
      end
    endtask
endclass: gpio_multiple_simple_trans25

`endif // GPIO_SEQ_LIB_SV25


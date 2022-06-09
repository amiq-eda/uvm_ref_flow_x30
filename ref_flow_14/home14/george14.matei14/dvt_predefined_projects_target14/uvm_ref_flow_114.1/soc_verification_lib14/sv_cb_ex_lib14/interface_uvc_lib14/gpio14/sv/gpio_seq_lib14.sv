/*-------------------------------------------------------------------------
File14 name   : gpio_seq_lib14.sv
Title14       : GPIO14 SystemVerilog14 UVM UVC14
Project14     : SystemVerilog14 UVM Cluster14 Level14 Verification14
Created14     :
Description14 : 
Notes14       :  
---------------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV14
`define GPIO_SEQ_LIB_SV14

class gpio_simple_trans_seq14 extends uvm_sequence #(gpio_transfer14);

  function new(string name="gpio_simple_trans_seq14");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq14)    
  `uvm_declare_p_sequencer(gpio_sequencer14)

  rand int unsigned transmit_del14 = 0;
  constraint transmit_del_ct14 { (transmit_del14 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ14", $psprintf("Doing gpio_simple_trans_seq14 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay14 == transmit_del14;} )
  endtask
  
endclass : gpio_simple_trans_seq14

class gpio_multiple_simple_trans14 extends uvm_sequence #(gpio_transfer14);

    rand int unsigned cnt_i14;

    gpio_simple_trans_seq14 simple_trans14;

    function new(string name="gpio_multiple_simple_trans14");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans14)    
   `uvm_declare_p_sequencer(gpio_sequencer14)

    constraint count_ct14 {cnt_i14 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i14; i++)
      begin
        `uvm_do(simple_trans14)
      end
    endtask
endclass: gpio_multiple_simple_trans14

`endif // GPIO_SEQ_LIB_SV14


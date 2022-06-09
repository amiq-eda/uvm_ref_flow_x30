/*-------------------------------------------------------------------------
File7 name   : gpio_seq_lib7.sv
Title7       : GPIO7 SystemVerilog7 UVM UVC7
Project7     : SystemVerilog7 UVM Cluster7 Level7 Verification7
Created7     :
Description7 : 
Notes7       :  
---------------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV7
`define GPIO_SEQ_LIB_SV7

class gpio_simple_trans_seq7 extends uvm_sequence #(gpio_transfer7);

  function new(string name="gpio_simple_trans_seq7");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq7)    
  `uvm_declare_p_sequencer(gpio_sequencer7)

  rand int unsigned transmit_del7 = 0;
  constraint transmit_del_ct7 { (transmit_del7 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ7", $psprintf("Doing gpio_simple_trans_seq7 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay7 == transmit_del7;} )
  endtask
  
endclass : gpio_simple_trans_seq7

class gpio_multiple_simple_trans7 extends uvm_sequence #(gpio_transfer7);

    rand int unsigned cnt_i7;

    gpio_simple_trans_seq7 simple_trans7;

    function new(string name="gpio_multiple_simple_trans7");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans7)    
   `uvm_declare_p_sequencer(gpio_sequencer7)

    constraint count_ct7 {cnt_i7 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i7; i++)
      begin
        `uvm_do(simple_trans7)
      end
    endtask
endclass: gpio_multiple_simple_trans7

`endif // GPIO_SEQ_LIB_SV7


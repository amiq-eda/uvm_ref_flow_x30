/*-------------------------------------------------------------------------
File15 name   : gpio_seq_lib15.sv
Title15       : GPIO15 SystemVerilog15 UVM UVC15
Project15     : SystemVerilog15 UVM Cluster15 Level15 Verification15
Created15     :
Description15 : 
Notes15       :  
---------------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV15
`define GPIO_SEQ_LIB_SV15

class gpio_simple_trans_seq15 extends uvm_sequence #(gpio_transfer15);

  function new(string name="gpio_simple_trans_seq15");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq15)    
  `uvm_declare_p_sequencer(gpio_sequencer15)

  rand int unsigned transmit_del15 = 0;
  constraint transmit_del_ct15 { (transmit_del15 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ15", $psprintf("Doing gpio_simple_trans_seq15 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay15 == transmit_del15;} )
  endtask
  
endclass : gpio_simple_trans_seq15

class gpio_multiple_simple_trans15 extends uvm_sequence #(gpio_transfer15);

    rand int unsigned cnt_i15;

    gpio_simple_trans_seq15 simple_trans15;

    function new(string name="gpio_multiple_simple_trans15");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans15)    
   `uvm_declare_p_sequencer(gpio_sequencer15)

    constraint count_ct15 {cnt_i15 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i15; i++)
      begin
        `uvm_do(simple_trans15)
      end
    endtask
endclass: gpio_multiple_simple_trans15

`endif // GPIO_SEQ_LIB_SV15


/*-------------------------------------------------------------------------
File26 name   : gpio_seq_lib26.sv
Title26       : GPIO26 SystemVerilog26 UVM UVC26
Project26     : SystemVerilog26 UVM Cluster26 Level26 Verification26
Created26     :
Description26 : 
Notes26       :  
---------------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV26
`define GPIO_SEQ_LIB_SV26

class gpio_simple_trans_seq26 extends uvm_sequence #(gpio_transfer26);

  function new(string name="gpio_simple_trans_seq26");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq26)    
  `uvm_declare_p_sequencer(gpio_sequencer26)

  rand int unsigned transmit_del26 = 0;
  constraint transmit_del_ct26 { (transmit_del26 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ26", $psprintf("Doing gpio_simple_trans_seq26 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay26 == transmit_del26;} )
  endtask
  
endclass : gpio_simple_trans_seq26

class gpio_multiple_simple_trans26 extends uvm_sequence #(gpio_transfer26);

    rand int unsigned cnt_i26;

    gpio_simple_trans_seq26 simple_trans26;

    function new(string name="gpio_multiple_simple_trans26");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans26)    
   `uvm_declare_p_sequencer(gpio_sequencer26)

    constraint count_ct26 {cnt_i26 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i26; i++)
      begin
        `uvm_do(simple_trans26)
      end
    endtask
endclass: gpio_multiple_simple_trans26

`endif // GPIO_SEQ_LIB_SV26


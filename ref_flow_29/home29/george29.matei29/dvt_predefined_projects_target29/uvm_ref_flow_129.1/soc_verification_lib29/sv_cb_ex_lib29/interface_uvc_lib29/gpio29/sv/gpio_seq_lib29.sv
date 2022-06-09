/*-------------------------------------------------------------------------
File29 name   : gpio_seq_lib29.sv
Title29       : GPIO29 SystemVerilog29 UVM UVC29
Project29     : SystemVerilog29 UVM Cluster29 Level29 Verification29
Created29     :
Description29 : 
Notes29       :  
---------------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef GPIO_SEQ_LIB_SV29
`define GPIO_SEQ_LIB_SV29

class gpio_simple_trans_seq29 extends uvm_sequence #(gpio_transfer29);

  function new(string name="gpio_simple_trans_seq29");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq29)    
  `uvm_declare_p_sequencer(gpio_sequencer29)

  rand int unsigned transmit_del29 = 0;
  constraint transmit_del_ct29 { (transmit_del29 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ29", $psprintf("Doing gpio_simple_trans_seq29 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay29 == transmit_del29;} )
  endtask
  
endclass : gpio_simple_trans_seq29

class gpio_multiple_simple_trans29 extends uvm_sequence #(gpio_transfer29);

    rand int unsigned cnt_i29;

    gpio_simple_trans_seq29 simple_trans29;

    function new(string name="gpio_multiple_simple_trans29");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans29)    
   `uvm_declare_p_sequencer(gpio_sequencer29)

    constraint count_ct29 {cnt_i29 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i29; i++)
      begin
        `uvm_do(simple_trans29)
      end
    endtask
endclass: gpio_multiple_simple_trans29

`endif // GPIO_SEQ_LIB_SV29


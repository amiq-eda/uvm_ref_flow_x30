/*-------------------------------------------------------------------------
File27 name   : gpio_reg_seq_lib27.sv
Title27       : REGMEM27 Sequence Library27
Project27     :
Created27     :
Description27 : This27 file implements27 regmem27 sequences
Notes27       :
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq27 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq27)

   function new(string name="gpio_cfg_reg_seq27");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst27;
   string gpio_rf27;

   gpio_regfile27 reg_model27;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf27, "gpio27%0d_rf", gpio_inst27);
      `uvm_info("ex_reg_rw_reg_seq27", 
        "complete random gpio27 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model27.bypass_mode27.write(status, data);
      reg_model27.direction_mode27.write(status, data);
      reg_model27.output_enable27.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq27


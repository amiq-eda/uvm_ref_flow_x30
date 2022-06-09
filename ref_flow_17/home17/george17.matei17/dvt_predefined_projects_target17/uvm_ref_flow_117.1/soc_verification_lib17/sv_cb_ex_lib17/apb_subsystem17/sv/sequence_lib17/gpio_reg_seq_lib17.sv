/*-------------------------------------------------------------------------
File17 name   : gpio_reg_seq_lib17.sv
Title17       : REGMEM17 Sequence Library17
Project17     :
Created17     :
Description17 : This17 file implements17 regmem17 sequences
Notes17       :
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq17 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq17)

   function new(string name="gpio_cfg_reg_seq17");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst17;
   string gpio_rf17;

   gpio_regfile17 reg_model17;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf17, "gpio17%0d_rf", gpio_inst17);
      `uvm_info("ex_reg_rw_reg_seq17", 
        "complete random gpio17 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model17.bypass_mode17.write(status, data);
      reg_model17.direction_mode17.write(status, data);
      reg_model17.output_enable17.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq17


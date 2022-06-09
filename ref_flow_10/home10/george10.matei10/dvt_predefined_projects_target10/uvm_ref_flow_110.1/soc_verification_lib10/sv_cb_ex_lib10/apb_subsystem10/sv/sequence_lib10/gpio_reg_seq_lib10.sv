/*-------------------------------------------------------------------------
File10 name   : gpio_reg_seq_lib10.sv
Title10       : REGMEM10 Sequence Library10
Project10     :
Created10     :
Description10 : This10 file implements10 regmem10 sequences
Notes10       :
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq10 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq10)

   function new(string name="gpio_cfg_reg_seq10");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst10;
   string gpio_rf10;

   gpio_regfile10 reg_model10;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf10, "gpio10%0d_rf", gpio_inst10);
      `uvm_info("ex_reg_rw_reg_seq10", 
        "complete random gpio10 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model10.bypass_mode10.write(status, data);
      reg_model10.direction_mode10.write(status, data);
      reg_model10.output_enable10.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq10


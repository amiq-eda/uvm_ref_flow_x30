/*-------------------------------------------------------------------------
File6 name   : gpio_reg_seq_lib6.sv
Title6       : REGMEM6 Sequence Library6
Project6     :
Created6     :
Description6 : This6 file implements6 regmem6 sequences
Notes6       :
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq6 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq6)

   function new(string name="gpio_cfg_reg_seq6");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst6;
   string gpio_rf6;

   gpio_regfile6 reg_model6;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf6, "gpio6%0d_rf", gpio_inst6);
      `uvm_info("ex_reg_rw_reg_seq6", 
        "complete random gpio6 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model6.bypass_mode6.write(status, data);
      reg_model6.direction_mode6.write(status, data);
      reg_model6.output_enable6.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq6


/*-------------------------------------------------------------------------
File11 name   : gpio_reg_seq_lib11.sv
Title11       : REGMEM11 Sequence Library11
Project11     :
Created11     :
Description11 : This11 file implements11 regmem11 sequences
Notes11       :
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq11 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq11)

   function new(string name="gpio_cfg_reg_seq11");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst11;
   string gpio_rf11;

   gpio_regfile11 reg_model11;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf11, "gpio11%0d_rf", gpio_inst11);
      `uvm_info("ex_reg_rw_reg_seq11", 
        "complete random gpio11 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model11.bypass_mode11.write(status, data);
      reg_model11.direction_mode11.write(status, data);
      reg_model11.output_enable11.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq11


/*-------------------------------------------------------------------------
File12 name   : gpio_reg_seq_lib12.sv
Title12       : REGMEM12 Sequence Library12
Project12     :
Created12     :
Description12 : This12 file implements12 regmem12 sequences
Notes12       :
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq12 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq12)

   function new(string name="gpio_cfg_reg_seq12");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst12;
   string gpio_rf12;

   gpio_regfile12 reg_model12;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf12, "gpio12%0d_rf", gpio_inst12);
      `uvm_info("ex_reg_rw_reg_seq12", 
        "complete random gpio12 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model12.bypass_mode12.write(status, data);
      reg_model12.direction_mode12.write(status, data);
      reg_model12.output_enable12.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq12


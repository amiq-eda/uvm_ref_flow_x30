/*-------------------------------------------------------------------------
File22 name   : gpio_reg_seq_lib22.sv
Title22       : REGMEM22 Sequence Library22
Project22     :
Created22     :
Description22 : This22 file implements22 regmem22 sequences
Notes22       :
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq22 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq22)

   function new(string name="gpio_cfg_reg_seq22");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst22;
   string gpio_rf22;

   gpio_regfile22 reg_model22;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf22, "gpio22%0d_rf", gpio_inst22);
      `uvm_info("ex_reg_rw_reg_seq22", 
        "complete random gpio22 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model22.bypass_mode22.write(status, data);
      reg_model22.direction_mode22.write(status, data);
      reg_model22.output_enable22.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq22


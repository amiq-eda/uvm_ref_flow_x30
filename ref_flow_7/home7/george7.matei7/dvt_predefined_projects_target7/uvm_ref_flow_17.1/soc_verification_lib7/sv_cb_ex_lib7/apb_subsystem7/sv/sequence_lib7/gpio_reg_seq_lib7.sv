/*-------------------------------------------------------------------------
File7 name   : gpio_reg_seq_lib7.sv
Title7       : REGMEM7 Sequence Library7
Project7     :
Created7     :
Description7 : This7 file implements7 regmem7 sequences
Notes7       :
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq7 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq7)

   function new(string name="gpio_cfg_reg_seq7");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst7;
   string gpio_rf7;

   gpio_regfile7 reg_model7;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf7, "gpio7%0d_rf", gpio_inst7);
      `uvm_info("ex_reg_rw_reg_seq7", 
        "complete random gpio7 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model7.bypass_mode7.write(status, data);
      reg_model7.direction_mode7.write(status, data);
      reg_model7.output_enable7.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq7


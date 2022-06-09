/*-------------------------------------------------------------------------
File24 name   : gpio_reg_seq_lib24.sv
Title24       : REGMEM24 Sequence Library24
Project24     :
Created24     :
Description24 : This24 file implements24 regmem24 sequences
Notes24       :
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq24 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq24)

   function new(string name="gpio_cfg_reg_seq24");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst24;
   string gpio_rf24;

   gpio_regfile24 reg_model24;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf24, "gpio24%0d_rf", gpio_inst24);
      `uvm_info("ex_reg_rw_reg_seq24", 
        "complete random gpio24 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model24.bypass_mode24.write(status, data);
      reg_model24.direction_mode24.write(status, data);
      reg_model24.output_enable24.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq24


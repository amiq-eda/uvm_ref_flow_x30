/*-------------------------------------------------------------------------
File8 name   : gpio_reg_seq_lib8.sv
Title8       : REGMEM8 Sequence Library8
Project8     :
Created8     :
Description8 : This8 file implements8 regmem8 sequences
Notes8       :
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq8 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq8)

   function new(string name="gpio_cfg_reg_seq8");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst8;
   string gpio_rf8;

   gpio_regfile8 reg_model8;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf8, "gpio8%0d_rf", gpio_inst8);
      `uvm_info("ex_reg_rw_reg_seq8", 
        "complete random gpio8 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model8.bypass_mode8.write(status, data);
      reg_model8.direction_mode8.write(status, data);
      reg_model8.output_enable8.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq8


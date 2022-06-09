/*-------------------------------------------------------------------------
File14 name   : gpio_reg_seq_lib14.sv
Title14       : REGMEM14 Sequence Library14
Project14     :
Created14     :
Description14 : This14 file implements14 regmem14 sequences
Notes14       :
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq14 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq14)

   function new(string name="gpio_cfg_reg_seq14");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst14;
   string gpio_rf14;

   gpio_regfile14 reg_model14;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf14, "gpio14%0d_rf", gpio_inst14);
      `uvm_info("ex_reg_rw_reg_seq14", 
        "complete random gpio14 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model14.bypass_mode14.write(status, data);
      reg_model14.direction_mode14.write(status, data);
      reg_model14.output_enable14.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq14


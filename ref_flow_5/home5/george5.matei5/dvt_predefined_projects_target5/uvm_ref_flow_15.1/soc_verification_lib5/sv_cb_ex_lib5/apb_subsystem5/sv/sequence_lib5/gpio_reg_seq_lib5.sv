/*-------------------------------------------------------------------------
File5 name   : gpio_reg_seq_lib5.sv
Title5       : REGMEM5 Sequence Library5
Project5     :
Created5     :
Description5 : This5 file implements5 regmem5 sequences
Notes5       :
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq5 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq5)

   function new(string name="gpio_cfg_reg_seq5");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst5;
   string gpio_rf5;

   gpio_regfile5 reg_model5;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf5, "gpio5%0d_rf", gpio_inst5);
      `uvm_info("ex_reg_rw_reg_seq5", 
        "complete random gpio5 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model5.bypass_mode5.write(status, data);
      reg_model5.direction_mode5.write(status, data);
      reg_model5.output_enable5.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq5


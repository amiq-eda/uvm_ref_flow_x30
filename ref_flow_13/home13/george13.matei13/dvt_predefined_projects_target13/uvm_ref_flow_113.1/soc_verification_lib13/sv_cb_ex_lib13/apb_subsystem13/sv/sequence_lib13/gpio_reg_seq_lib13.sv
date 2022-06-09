/*-------------------------------------------------------------------------
File13 name   : gpio_reg_seq_lib13.sv
Title13       : REGMEM13 Sequence Library13
Project13     :
Created13     :
Description13 : This13 file implements13 regmem13 sequences
Notes13       :
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq13 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq13)

   function new(string name="gpio_cfg_reg_seq13");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst13;
   string gpio_rf13;

   gpio_regfile13 reg_model13;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf13, "gpio13%0d_rf", gpio_inst13);
      `uvm_info("ex_reg_rw_reg_seq13", 
        "complete random gpio13 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model13.bypass_mode13.write(status, data);
      reg_model13.direction_mode13.write(status, data);
      reg_model13.output_enable13.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq13


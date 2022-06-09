/*-------------------------------------------------------------------------
File1 name   : gpio_reg_seq_lib1.sv
Title1       : REGMEM1 Sequence Library1
Project1     :
Created1     :
Description1 : This1 file implements1 regmem1 sequences
Notes1       :
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq1 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq1)

   function new(string name="gpio_cfg_reg_seq1");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst1;
   string gpio_rf1;

   gpio_regfile1 reg_model1;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf1, "gpio1%0d_rf", gpio_inst1);
      `uvm_info("ex_reg_rw_reg_seq1", 
        "complete random gpio1 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model1.bypass_mode1.write(status, data);
      reg_model1.direction_mode1.write(status, data);
      reg_model1.output_enable1.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq1


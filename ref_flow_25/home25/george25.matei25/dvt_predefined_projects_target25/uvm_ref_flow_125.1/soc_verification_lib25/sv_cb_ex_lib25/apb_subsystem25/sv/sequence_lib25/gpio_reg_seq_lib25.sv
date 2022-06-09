/*-------------------------------------------------------------------------
File25 name   : gpio_reg_seq_lib25.sv
Title25       : REGMEM25 Sequence Library25
Project25     :
Created25     :
Description25 : This25 file implements25 regmem25 sequences
Notes25       :
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq25 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq25)

   function new(string name="gpio_cfg_reg_seq25");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst25;
   string gpio_rf25;

   gpio_regfile25 reg_model25;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf25, "gpio25%0d_rf", gpio_inst25);
      `uvm_info("ex_reg_rw_reg_seq25", 
        "complete random gpio25 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model25.bypass_mode25.write(status, data);
      reg_model25.direction_mode25.write(status, data);
      reg_model25.output_enable25.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq25


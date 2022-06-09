/*-------------------------------------------------------------------------
File28 name   : gpio_reg_seq_lib28.sv
Title28       : REGMEM28 Sequence Library28
Project28     :
Created28     :
Description28 : This28 file implements28 regmem28 sequences
Notes28       :
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq28 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq28)

   function new(string name="gpio_cfg_reg_seq28");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst28;
   string gpio_rf28;

   gpio_regfile28 reg_model28;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf28, "gpio28%0d_rf", gpio_inst28);
      `uvm_info("ex_reg_rw_reg_seq28", 
        "complete random gpio28 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model28.bypass_mode28.write(status, data);
      reg_model28.direction_mode28.write(status, data);
      reg_model28.output_enable28.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq28


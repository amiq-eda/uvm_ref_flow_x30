/*-------------------------------------------------------------------------
File21 name   : gpio_reg_seq_lib21.sv
Title21       : REGMEM21 Sequence Library21
Project21     :
Created21     :
Description21 : This21 file implements21 regmem21 sequences
Notes21       :
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq21 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq21)

   function new(string name="gpio_cfg_reg_seq21");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst21;
   string gpio_rf21;

   gpio_regfile21 reg_model21;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf21, "gpio21%0d_rf", gpio_inst21);
      `uvm_info("ex_reg_rw_reg_seq21", 
        "complete random gpio21 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model21.bypass_mode21.write(status, data);
      reg_model21.direction_mode21.write(status, data);
      reg_model21.output_enable21.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq21


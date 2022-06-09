/*-------------------------------------------------------------------------
File29 name   : gpio_reg_seq_lib29.sv
Title29       : REGMEM29 Sequence Library29
Project29     :
Created29     :
Description29 : This29 file implements29 regmem29 sequences
Notes29       :
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq29 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq29)

   function new(string name="gpio_cfg_reg_seq29");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst29;
   string gpio_rf29;

   gpio_regfile29 reg_model29;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf29, "gpio29%0d_rf", gpio_inst29);
      `uvm_info("ex_reg_rw_reg_seq29", 
        "complete random gpio29 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model29.bypass_mode29.write(status, data);
      reg_model29.direction_mode29.write(status, data);
      reg_model29.output_enable29.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq29


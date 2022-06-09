/*-------------------------------------------------------------------------
File23 name   : gpio_reg_seq_lib23.sv
Title23       : REGMEM23 Sequence Library23
Project23     :
Created23     :
Description23 : This23 file implements23 regmem23 sequences
Notes23       :
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq23 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq23)

   function new(string name="gpio_cfg_reg_seq23");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst23;
   string gpio_rf23;

   gpio_regfile23 reg_model23;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf23, "gpio23%0d_rf", gpio_inst23);
      `uvm_info("ex_reg_rw_reg_seq23", 
        "complete random gpio23 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model23.bypass_mode23.write(status, data);
      reg_model23.direction_mode23.write(status, data);
      reg_model23.output_enable23.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq23


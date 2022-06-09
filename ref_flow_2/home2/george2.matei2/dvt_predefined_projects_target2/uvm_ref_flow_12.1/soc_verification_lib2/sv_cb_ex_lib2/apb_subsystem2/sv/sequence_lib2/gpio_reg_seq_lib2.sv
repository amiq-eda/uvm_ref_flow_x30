/*-------------------------------------------------------------------------
File2 name   : gpio_reg_seq_lib2.sv
Title2       : REGMEM2 Sequence Library2
Project2     :
Created2     :
Description2 : This2 file implements2 regmem2 sequences
Notes2       :
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
 
class gpio_cfg_reg_seq2 extends uvm_sequence;

   `uvm_object_utils(gpio_cfg_reg_seq2)

   function new(string name="gpio_cfg_reg_seq2");
      super.new(name);
   endfunction : new
 
   rand bit [31:0] data;
   rand int gpio_inst2;
   string gpio_rf2;

   gpio_regfile2 reg_model2;

   virtual task body();
     uvm_status_e status;
      $sformat(gpio_rf2, "gpio2%0d_rf", gpio_inst2);
      `uvm_info("ex_reg_rw_reg_seq2", 
        "complete random gpio2 configuration register sequence starting...", UVM_MEDIUM)
      #200;
      reg_model2.bypass_mode2.write(status, data);
      reg_model2.direction_mode2.write(status, data);
      reg_model2.output_enable2.write(status, data);
   endtask

endclass : gpio_cfg_reg_seq2


/*-------------------------------------------------------------------------
File9 name   : spi_reg_seq_lib9.sv
Title9       : REGMEM9 Sequence Library9
Project9     :
Created9     :
Description9 : This9 file implements9 regmem9 sequences
Notes9       :
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq9 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq9)

   function new(string name="spi_cfg_reg_seq9");
      super.new(name);
   endfunction // new
 
   rand int spi_inst9;
   string spi_rf9;

   spi_regfile9 reg_model9;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf9, "spi9%0d_rf", spi_inst9);
      `uvm_info("ex_reg_rw_reg_seq9", 
        $psprintf("complete random spi9 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model9.spi_ctrl9.write(status, 16'h3E08);
      reg_model9.spi_divider9.write(status, 16'b1);
      reg_model9.spi_ss9.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq9

class spi_en_tx_reg_seq9 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq9)

   function new(string name="spi_en_tx_reg_seq9");
      super.new(name);
   endfunction // new
 
   rand int spi_inst9;
   string spi_rf9;

   spi_regfile9 reg_model9;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf9, "spi9%0d_rf", spi_inst9);
      `uvm_info("ex_reg_rw_reg_seq9", 
        $psprintf("complete random spi9 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model9.spi_ctrl9.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq9


/*-------------------------------------------------------------------------
File22 name   : spi_reg_seq_lib22.sv
Title22       : REGMEM22 Sequence Library22
Project22     :
Created22     :
Description22 : This22 file implements22 regmem22 sequences
Notes22       :
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq22 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq22)

   function new(string name="spi_cfg_reg_seq22");
      super.new(name);
   endfunction // new
 
   rand int spi_inst22;
   string spi_rf22;

   spi_regfile22 reg_model22;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf22, "spi22%0d_rf", spi_inst22);
      `uvm_info("ex_reg_rw_reg_seq22", 
        $psprintf("complete random spi22 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model22.spi_ctrl22.write(status, 16'h3E08);
      reg_model22.spi_divider22.write(status, 16'b1);
      reg_model22.spi_ss22.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq22

class spi_en_tx_reg_seq22 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq22)

   function new(string name="spi_en_tx_reg_seq22");
      super.new(name);
   endfunction // new
 
   rand int spi_inst22;
   string spi_rf22;

   spi_regfile22 reg_model22;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf22, "spi22%0d_rf", spi_inst22);
      `uvm_info("ex_reg_rw_reg_seq22", 
        $psprintf("complete random spi22 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model22.spi_ctrl22.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq22


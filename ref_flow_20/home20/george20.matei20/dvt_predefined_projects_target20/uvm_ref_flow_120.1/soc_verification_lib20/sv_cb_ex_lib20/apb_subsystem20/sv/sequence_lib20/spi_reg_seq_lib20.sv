/*-------------------------------------------------------------------------
File20 name   : spi_reg_seq_lib20.sv
Title20       : REGMEM20 Sequence Library20
Project20     :
Created20     :
Description20 : This20 file implements20 regmem20 sequences
Notes20       :
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq20 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq20)

   function new(string name="spi_cfg_reg_seq20");
      super.new(name);
   endfunction // new
 
   rand int spi_inst20;
   string spi_rf20;

   spi_regfile20 reg_model20;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf20, "spi20%0d_rf", spi_inst20);
      `uvm_info("ex_reg_rw_reg_seq20", 
        $psprintf("complete random spi20 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model20.spi_ctrl20.write(status, 16'h3E08);
      reg_model20.spi_divider20.write(status, 16'b1);
      reg_model20.spi_ss20.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq20

class spi_en_tx_reg_seq20 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq20)

   function new(string name="spi_en_tx_reg_seq20");
      super.new(name);
   endfunction // new
 
   rand int spi_inst20;
   string spi_rf20;

   spi_regfile20 reg_model20;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf20, "spi20%0d_rf", spi_inst20);
      `uvm_info("ex_reg_rw_reg_seq20", 
        $psprintf("complete random spi20 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model20.spi_ctrl20.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq20


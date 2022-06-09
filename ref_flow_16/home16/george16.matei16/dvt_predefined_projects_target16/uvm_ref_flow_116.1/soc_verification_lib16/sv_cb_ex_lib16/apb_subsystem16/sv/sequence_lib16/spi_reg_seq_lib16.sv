/*-------------------------------------------------------------------------
File16 name   : spi_reg_seq_lib16.sv
Title16       : REGMEM16 Sequence Library16
Project16     :
Created16     :
Description16 : This16 file implements16 regmem16 sequences
Notes16       :
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq16 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq16)

   function new(string name="spi_cfg_reg_seq16");
      super.new(name);
   endfunction // new
 
   rand int spi_inst16;
   string spi_rf16;

   spi_regfile16 reg_model16;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf16, "spi16%0d_rf", spi_inst16);
      `uvm_info("ex_reg_rw_reg_seq16", 
        $psprintf("complete random spi16 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model16.spi_ctrl16.write(status, 16'h3E08);
      reg_model16.spi_divider16.write(status, 16'b1);
      reg_model16.spi_ss16.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq16

class spi_en_tx_reg_seq16 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq16)

   function new(string name="spi_en_tx_reg_seq16");
      super.new(name);
   endfunction // new
 
   rand int spi_inst16;
   string spi_rf16;

   spi_regfile16 reg_model16;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf16, "spi16%0d_rf", spi_inst16);
      `uvm_info("ex_reg_rw_reg_seq16", 
        $psprintf("complete random spi16 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model16.spi_ctrl16.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq16


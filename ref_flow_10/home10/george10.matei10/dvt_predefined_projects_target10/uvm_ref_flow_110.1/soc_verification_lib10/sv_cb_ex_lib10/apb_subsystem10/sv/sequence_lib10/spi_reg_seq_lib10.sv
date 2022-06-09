/*-------------------------------------------------------------------------
File10 name   : spi_reg_seq_lib10.sv
Title10       : REGMEM10 Sequence Library10
Project10     :
Created10     :
Description10 : This10 file implements10 regmem10 sequences
Notes10       :
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq10 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq10)

   function new(string name="spi_cfg_reg_seq10");
      super.new(name);
   endfunction // new
 
   rand int spi_inst10;
   string spi_rf10;

   spi_regfile10 reg_model10;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf10, "spi10%0d_rf", spi_inst10);
      `uvm_info("ex_reg_rw_reg_seq10", 
        $psprintf("complete random spi10 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model10.spi_ctrl10.write(status, 16'h3E08);
      reg_model10.spi_divider10.write(status, 16'b1);
      reg_model10.spi_ss10.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq10

class spi_en_tx_reg_seq10 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq10)

   function new(string name="spi_en_tx_reg_seq10");
      super.new(name);
   endfunction // new
 
   rand int spi_inst10;
   string spi_rf10;

   spi_regfile10 reg_model10;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf10, "spi10%0d_rf", spi_inst10);
      `uvm_info("ex_reg_rw_reg_seq10", 
        $psprintf("complete random spi10 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model10.spi_ctrl10.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq10


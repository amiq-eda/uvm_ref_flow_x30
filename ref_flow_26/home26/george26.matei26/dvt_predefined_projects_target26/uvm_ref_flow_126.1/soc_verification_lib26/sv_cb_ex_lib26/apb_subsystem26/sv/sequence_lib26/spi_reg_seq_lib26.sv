/*-------------------------------------------------------------------------
File26 name   : spi_reg_seq_lib26.sv
Title26       : REGMEM26 Sequence Library26
Project26     :
Created26     :
Description26 : This26 file implements26 regmem26 sequences
Notes26       :
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq26 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq26)

   function new(string name="spi_cfg_reg_seq26");
      super.new(name);
   endfunction // new
 
   rand int spi_inst26;
   string spi_rf26;

   spi_regfile26 reg_model26;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf26, "spi26%0d_rf", spi_inst26);
      `uvm_info("ex_reg_rw_reg_seq26", 
        $psprintf("complete random spi26 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model26.spi_ctrl26.write(status, 16'h3E08);
      reg_model26.spi_divider26.write(status, 16'b1);
      reg_model26.spi_ss26.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq26

class spi_en_tx_reg_seq26 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq26)

   function new(string name="spi_en_tx_reg_seq26");
      super.new(name);
   endfunction // new
 
   rand int spi_inst26;
   string spi_rf26;

   spi_regfile26 reg_model26;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf26, "spi26%0d_rf", spi_inst26);
      `uvm_info("ex_reg_rw_reg_seq26", 
        $psprintf("complete random spi26 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model26.spi_ctrl26.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq26


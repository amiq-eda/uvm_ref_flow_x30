/*-------------------------------------------------------------------------
File15 name   : spi_reg_seq_lib15.sv
Title15       : REGMEM15 Sequence Library15
Project15     :
Created15     :
Description15 : This15 file implements15 regmem15 sequences
Notes15       :
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq15 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq15)

   function new(string name="spi_cfg_reg_seq15");
      super.new(name);
   endfunction // new
 
   rand int spi_inst15;
   string spi_rf15;

   spi_regfile15 reg_model15;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf15, "spi15%0d_rf", spi_inst15);
      `uvm_info("ex_reg_rw_reg_seq15", 
        $psprintf("complete random spi15 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model15.spi_ctrl15.write(status, 16'h3E08);
      reg_model15.spi_divider15.write(status, 16'b1);
      reg_model15.spi_ss15.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq15

class spi_en_tx_reg_seq15 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq15)

   function new(string name="spi_en_tx_reg_seq15");
      super.new(name);
   endfunction // new
 
   rand int spi_inst15;
   string spi_rf15;

   spi_regfile15 reg_model15;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf15, "spi15%0d_rf", spi_inst15);
      `uvm_info("ex_reg_rw_reg_seq15", 
        $psprintf("complete random spi15 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model15.spi_ctrl15.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq15


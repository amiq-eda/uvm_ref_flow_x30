/*-------------------------------------------------------------------------
File14 name   : spi_reg_seq_lib14.sv
Title14       : REGMEM14 Sequence Library14
Project14     :
Created14     :
Description14 : This14 file implements14 regmem14 sequences
Notes14       :
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq14 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq14)

   function new(string name="spi_cfg_reg_seq14");
      super.new(name);
   endfunction // new
 
   rand int spi_inst14;
   string spi_rf14;

   spi_regfile14 reg_model14;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf14, "spi14%0d_rf", spi_inst14);
      `uvm_info("ex_reg_rw_reg_seq14", 
        $psprintf("complete random spi14 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model14.spi_ctrl14.write(status, 16'h3E08);
      reg_model14.spi_divider14.write(status, 16'b1);
      reg_model14.spi_ss14.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq14

class spi_en_tx_reg_seq14 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq14)

   function new(string name="spi_en_tx_reg_seq14");
      super.new(name);
   endfunction // new
 
   rand int spi_inst14;
   string spi_rf14;

   spi_regfile14 reg_model14;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf14, "spi14%0d_rf", spi_inst14);
      `uvm_info("ex_reg_rw_reg_seq14", 
        $psprintf("complete random spi14 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model14.spi_ctrl14.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq14


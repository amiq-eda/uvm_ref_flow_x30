/*-------------------------------------------------------------------------
File17 name   : spi_reg_seq_lib17.sv
Title17       : REGMEM17 Sequence Library17
Project17     :
Created17     :
Description17 : This17 file implements17 regmem17 sequences
Notes17       :
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq17 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq17)

   function new(string name="spi_cfg_reg_seq17");
      super.new(name);
   endfunction // new
 
   rand int spi_inst17;
   string spi_rf17;

   spi_regfile17 reg_model17;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf17, "spi17%0d_rf", spi_inst17);
      `uvm_info("ex_reg_rw_reg_seq17", 
        $psprintf("complete random spi17 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model17.spi_ctrl17.write(status, 16'h3E08);
      reg_model17.spi_divider17.write(status, 16'b1);
      reg_model17.spi_ss17.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq17

class spi_en_tx_reg_seq17 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq17)

   function new(string name="spi_en_tx_reg_seq17");
      super.new(name);
   endfunction // new
 
   rand int spi_inst17;
   string spi_rf17;

   spi_regfile17 reg_model17;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf17, "spi17%0d_rf", spi_inst17);
      `uvm_info("ex_reg_rw_reg_seq17", 
        $psprintf("complete random spi17 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model17.spi_ctrl17.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq17


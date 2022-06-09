/*-------------------------------------------------------------------------
File27 name   : spi_reg_seq_lib27.sv
Title27       : REGMEM27 Sequence Library27
Project27     :
Created27     :
Description27 : This27 file implements27 regmem27 sequences
Notes27       :
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq27 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq27)

   function new(string name="spi_cfg_reg_seq27");
      super.new(name);
   endfunction // new
 
   rand int spi_inst27;
   string spi_rf27;

   spi_regfile27 reg_model27;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf27, "spi27%0d_rf", spi_inst27);
      `uvm_info("ex_reg_rw_reg_seq27", 
        $psprintf("complete random spi27 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model27.spi_ctrl27.write(status, 16'h3E08);
      reg_model27.spi_divider27.write(status, 16'b1);
      reg_model27.spi_ss27.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq27

class spi_en_tx_reg_seq27 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq27)

   function new(string name="spi_en_tx_reg_seq27");
      super.new(name);
   endfunction // new
 
   rand int spi_inst27;
   string spi_rf27;

   spi_regfile27 reg_model27;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf27, "spi27%0d_rf", spi_inst27);
      `uvm_info("ex_reg_rw_reg_seq27", 
        $psprintf("complete random spi27 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model27.spi_ctrl27.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq27


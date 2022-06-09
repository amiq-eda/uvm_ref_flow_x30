/*-------------------------------------------------------------------------
File8 name   : spi_reg_seq_lib8.sv
Title8       : REGMEM8 Sequence Library8
Project8     :
Created8     :
Description8 : This8 file implements8 regmem8 sequences
Notes8       :
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq8 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq8)

   function new(string name="spi_cfg_reg_seq8");
      super.new(name);
   endfunction // new
 
   rand int spi_inst8;
   string spi_rf8;

   spi_regfile8 reg_model8;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf8, "spi8%0d_rf", spi_inst8);
      `uvm_info("ex_reg_rw_reg_seq8", 
        $psprintf("complete random spi8 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model8.spi_ctrl8.write(status, 16'h3E08);
      reg_model8.spi_divider8.write(status, 16'b1);
      reg_model8.spi_ss8.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq8

class spi_en_tx_reg_seq8 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq8)

   function new(string name="spi_en_tx_reg_seq8");
      super.new(name);
   endfunction // new
 
   rand int spi_inst8;
   string spi_rf8;

   spi_regfile8 reg_model8;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf8, "spi8%0d_rf", spi_inst8);
      `uvm_info("ex_reg_rw_reg_seq8", 
        $psprintf("complete random spi8 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model8.spi_ctrl8.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq8


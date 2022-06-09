/*-------------------------------------------------------------------------
File24 name   : spi_reg_seq_lib24.sv
Title24       : REGMEM24 Sequence Library24
Project24     :
Created24     :
Description24 : This24 file implements24 regmem24 sequences
Notes24       :
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq24 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq24)

   function new(string name="spi_cfg_reg_seq24");
      super.new(name);
   endfunction // new
 
   rand int spi_inst24;
   string spi_rf24;

   spi_regfile24 reg_model24;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf24, "spi24%0d_rf", spi_inst24);
      `uvm_info("ex_reg_rw_reg_seq24", 
        $psprintf("complete random spi24 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model24.spi_ctrl24.write(status, 16'h3E08);
      reg_model24.spi_divider24.write(status, 16'b1);
      reg_model24.spi_ss24.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq24

class spi_en_tx_reg_seq24 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq24)

   function new(string name="spi_en_tx_reg_seq24");
      super.new(name);
   endfunction // new
 
   rand int spi_inst24;
   string spi_rf24;

   spi_regfile24 reg_model24;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf24, "spi24%0d_rf", spi_inst24);
      `uvm_info("ex_reg_rw_reg_seq24", 
        $psprintf("complete random spi24 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model24.spi_ctrl24.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq24


/*-------------------------------------------------------------------------
File3 name   : spi_reg_seq_lib3.sv
Title3       : REGMEM3 Sequence Library3
Project3     :
Created3     :
Description3 : This3 file implements3 regmem3 sequences
Notes3       :
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq3 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq3)

   function new(string name="spi_cfg_reg_seq3");
      super.new(name);
   endfunction // new
 
   rand int spi_inst3;
   string spi_rf3;

   spi_regfile3 reg_model3;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf3, "spi3%0d_rf", spi_inst3);
      `uvm_info("ex_reg_rw_reg_seq3", 
        $psprintf("complete random spi3 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model3.spi_ctrl3.write(status, 16'h3E08);
      reg_model3.spi_divider3.write(status, 16'b1);
      reg_model3.spi_ss3.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq3

class spi_en_tx_reg_seq3 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq3)

   function new(string name="spi_en_tx_reg_seq3");
      super.new(name);
   endfunction // new
 
   rand int spi_inst3;
   string spi_rf3;

   spi_regfile3 reg_model3;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf3, "spi3%0d_rf", spi_inst3);
      `uvm_info("ex_reg_rw_reg_seq3", 
        $psprintf("complete random spi3 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model3.spi_ctrl3.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq3


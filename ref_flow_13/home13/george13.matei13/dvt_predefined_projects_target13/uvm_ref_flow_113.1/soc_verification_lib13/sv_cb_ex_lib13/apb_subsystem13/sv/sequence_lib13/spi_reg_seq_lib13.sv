/*-------------------------------------------------------------------------
File13 name   : spi_reg_seq_lib13.sv
Title13       : REGMEM13 Sequence Library13
Project13     :
Created13     :
Description13 : This13 file implements13 regmem13 sequences
Notes13       :
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq13 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq13)

   function new(string name="spi_cfg_reg_seq13");
      super.new(name);
   endfunction // new
 
   rand int spi_inst13;
   string spi_rf13;

   spi_regfile13 reg_model13;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf13, "spi13%0d_rf", spi_inst13);
      `uvm_info("ex_reg_rw_reg_seq13", 
        $psprintf("complete random spi13 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model13.spi_ctrl13.write(status, 16'h3E08);
      reg_model13.spi_divider13.write(status, 16'b1);
      reg_model13.spi_ss13.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq13

class spi_en_tx_reg_seq13 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq13)

   function new(string name="spi_en_tx_reg_seq13");
      super.new(name);
   endfunction // new
 
   rand int spi_inst13;
   string spi_rf13;

   spi_regfile13 reg_model13;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf13, "spi13%0d_rf", spi_inst13);
      `uvm_info("ex_reg_rw_reg_seq13", 
        $psprintf("complete random spi13 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model13.spi_ctrl13.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq13


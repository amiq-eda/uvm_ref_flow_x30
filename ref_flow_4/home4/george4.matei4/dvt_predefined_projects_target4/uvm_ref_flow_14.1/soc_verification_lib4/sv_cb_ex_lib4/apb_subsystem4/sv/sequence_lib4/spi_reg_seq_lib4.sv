/*-------------------------------------------------------------------------
File4 name   : spi_reg_seq_lib4.sv
Title4       : REGMEM4 Sequence Library4
Project4     :
Created4     :
Description4 : This4 file implements4 regmem4 sequences
Notes4       :
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq4 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq4)

   function new(string name="spi_cfg_reg_seq4");
      super.new(name);
   endfunction // new
 
   rand int spi_inst4;
   string spi_rf4;

   spi_regfile4 reg_model4;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf4, "spi4%0d_rf", spi_inst4);
      `uvm_info("ex_reg_rw_reg_seq4", 
        $psprintf("complete random spi4 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model4.spi_ctrl4.write(status, 16'h3E08);
      reg_model4.spi_divider4.write(status, 16'b1);
      reg_model4.spi_ss4.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq4

class spi_en_tx_reg_seq4 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq4)

   function new(string name="spi_en_tx_reg_seq4");
      super.new(name);
   endfunction // new
 
   rand int spi_inst4;
   string spi_rf4;

   spi_regfile4 reg_model4;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf4, "spi4%0d_rf", spi_inst4);
      `uvm_info("ex_reg_rw_reg_seq4", 
        $psprintf("complete random spi4 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model4.spi_ctrl4.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq4


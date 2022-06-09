/*-------------------------------------------------------------------------
File12 name   : spi_reg_seq_lib12.sv
Title12       : REGMEM12 Sequence Library12
Project12     :
Created12     :
Description12 : This12 file implements12 regmem12 sequences
Notes12       :
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq12 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq12)

   function new(string name="spi_cfg_reg_seq12");
      super.new(name);
   endfunction // new
 
   rand int spi_inst12;
   string spi_rf12;

   spi_regfile12 reg_model12;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf12, "spi12%0d_rf", spi_inst12);
      `uvm_info("ex_reg_rw_reg_seq12", 
        $psprintf("complete random spi12 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model12.spi_ctrl12.write(status, 16'h3E08);
      reg_model12.spi_divider12.write(status, 16'b1);
      reg_model12.spi_ss12.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq12

class spi_en_tx_reg_seq12 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq12)

   function new(string name="spi_en_tx_reg_seq12");
      super.new(name);
   endfunction // new
 
   rand int spi_inst12;
   string spi_rf12;

   spi_regfile12 reg_model12;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf12, "spi12%0d_rf", spi_inst12);
      `uvm_info("ex_reg_rw_reg_seq12", 
        $psprintf("complete random spi12 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model12.spi_ctrl12.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq12


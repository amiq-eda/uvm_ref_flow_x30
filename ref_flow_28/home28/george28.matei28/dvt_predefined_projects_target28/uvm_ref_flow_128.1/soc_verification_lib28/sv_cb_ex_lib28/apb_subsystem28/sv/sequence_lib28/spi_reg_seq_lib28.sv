/*-------------------------------------------------------------------------
File28 name   : spi_reg_seq_lib28.sv
Title28       : REGMEM28 Sequence Library28
Project28     :
Created28     :
Description28 : This28 file implements28 regmem28 sequences
Notes28       :
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq28 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq28)

   function new(string name="spi_cfg_reg_seq28");
      super.new(name);
   endfunction // new
 
   rand int spi_inst28;
   string spi_rf28;

   spi_regfile28 reg_model28;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf28, "spi28%0d_rf", spi_inst28);
      `uvm_info("ex_reg_rw_reg_seq28", 
        $psprintf("complete random spi28 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model28.spi_ctrl28.write(status, 16'h3E08);
      reg_model28.spi_divider28.write(status, 16'b1);
      reg_model28.spi_ss28.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq28

class spi_en_tx_reg_seq28 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq28)

   function new(string name="spi_en_tx_reg_seq28");
      super.new(name);
   endfunction // new
 
   rand int spi_inst28;
   string spi_rf28;

   spi_regfile28 reg_model28;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf28, "spi28%0d_rf", spi_inst28);
      `uvm_info("ex_reg_rw_reg_seq28", 
        $psprintf("complete random spi28 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model28.spi_ctrl28.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq28


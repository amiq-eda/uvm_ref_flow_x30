/*-------------------------------------------------------------------------
File30 name   : spi_reg_seq_lib30.sv
Title30       : REGMEM30 Sequence Library30
Project30     :
Created30     :
Description30 : This30 file implements30 regmem30 sequences
Notes30       :
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq30 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq30)

   function new(string name="spi_cfg_reg_seq30");
      super.new(name);
   endfunction // new
 
   rand int spi_inst30;
   string spi_rf30;

   spi_regfile30 reg_model30;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf30, "spi30%0d_rf", spi_inst30);
      `uvm_info("ex_reg_rw_reg_seq30", 
        $psprintf("complete random spi30 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model30.spi_ctrl30.write(status, 16'h3E08);
      reg_model30.spi_divider30.write(status, 16'b1);
      reg_model30.spi_ss30.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq30

class spi_en_tx_reg_seq30 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq30)

   function new(string name="spi_en_tx_reg_seq30");
      super.new(name);
   endfunction // new
 
   rand int spi_inst30;
   string spi_rf30;

   spi_regfile30 reg_model30;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf30, "spi30%0d_rf", spi_inst30);
      `uvm_info("ex_reg_rw_reg_seq30", 
        $psprintf("complete random spi30 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model30.spi_ctrl30.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq30


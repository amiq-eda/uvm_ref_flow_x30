/*-------------------------------------------------------------------------
File29 name   : spi_reg_seq_lib29.sv
Title29       : REGMEM29 Sequence Library29
Project29     :
Created29     :
Description29 : This29 file implements29 regmem29 sequences
Notes29       :
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq29 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq29)

   function new(string name="spi_cfg_reg_seq29");
      super.new(name);
   endfunction // new
 
   rand int spi_inst29;
   string spi_rf29;

   spi_regfile29 reg_model29;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf29, "spi29%0d_rf", spi_inst29);
      `uvm_info("ex_reg_rw_reg_seq29", 
        $psprintf("complete random spi29 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model29.spi_ctrl29.write(status, 16'h3E08);
      reg_model29.spi_divider29.write(status, 16'b1);
      reg_model29.spi_ss29.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq29

class spi_en_tx_reg_seq29 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq29)

   function new(string name="spi_en_tx_reg_seq29");
      super.new(name);
   endfunction // new
 
   rand int spi_inst29;
   string spi_rf29;

   spi_regfile29 reg_model29;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf29, "spi29%0d_rf", spi_inst29);
      `uvm_info("ex_reg_rw_reg_seq29", 
        $psprintf("complete random spi29 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model29.spi_ctrl29.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq29


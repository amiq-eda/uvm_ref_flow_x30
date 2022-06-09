/*-------------------------------------------------------------------------
File2 name   : spi_reg_seq_lib2.sv
Title2       : REGMEM2 Sequence Library2
Project2     :
Created2     :
Description2 : This2 file implements2 regmem2 sequences
Notes2       :
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq2 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq2)

   function new(string name="spi_cfg_reg_seq2");
      super.new(name);
   endfunction // new
 
   rand int spi_inst2;
   string spi_rf2;

   spi_regfile2 reg_model2;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf2, "spi2%0d_rf", spi_inst2);
      `uvm_info("ex_reg_rw_reg_seq2", 
        $psprintf("complete random spi2 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model2.spi_ctrl2.write(status, 16'h3E08);
      reg_model2.spi_divider2.write(status, 16'b1);
      reg_model2.spi_ss2.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq2

class spi_en_tx_reg_seq2 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq2)

   function new(string name="spi_en_tx_reg_seq2");
      super.new(name);
   endfunction // new
 
   rand int spi_inst2;
   string spi_rf2;

   spi_regfile2 reg_model2;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf2, "spi2%0d_rf", spi_inst2);
      `uvm_info("ex_reg_rw_reg_seq2", 
        $psprintf("complete random spi2 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model2.spi_ctrl2.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq2


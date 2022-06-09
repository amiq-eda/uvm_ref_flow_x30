/*-------------------------------------------------------------------------
File21 name   : spi_reg_seq_lib21.sv
Title21       : REGMEM21 Sequence Library21
Project21     :
Created21     :
Description21 : This21 file implements21 regmem21 sequences
Notes21       :
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq21 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq21)

   function new(string name="spi_cfg_reg_seq21");
      super.new(name);
   endfunction // new
 
   rand int spi_inst21;
   string spi_rf21;

   spi_regfile21 reg_model21;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf21, "spi21%0d_rf", spi_inst21);
      `uvm_info("ex_reg_rw_reg_seq21", 
        $psprintf("complete random spi21 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model21.spi_ctrl21.write(status, 16'h3E08);
      reg_model21.spi_divider21.write(status, 16'b1);
      reg_model21.spi_ss21.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq21

class spi_en_tx_reg_seq21 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq21)

   function new(string name="spi_en_tx_reg_seq21");
      super.new(name);
   endfunction // new
 
   rand int spi_inst21;
   string spi_rf21;

   spi_regfile21 reg_model21;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf21, "spi21%0d_rf", spi_inst21);
      `uvm_info("ex_reg_rw_reg_seq21", 
        $psprintf("complete random spi21 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model21.spi_ctrl21.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq21


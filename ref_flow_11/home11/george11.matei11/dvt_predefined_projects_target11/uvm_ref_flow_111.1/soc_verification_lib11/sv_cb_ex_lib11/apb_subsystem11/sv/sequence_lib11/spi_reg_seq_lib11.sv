/*-------------------------------------------------------------------------
File11 name   : spi_reg_seq_lib11.sv
Title11       : REGMEM11 Sequence Library11
Project11     :
Created11     :
Description11 : This11 file implements11 regmem11 sequences
Notes11       :
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq11 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq11)

   function new(string name="spi_cfg_reg_seq11");
      super.new(name);
   endfunction // new
 
   rand int spi_inst11;
   string spi_rf11;

   spi_regfile11 reg_model11;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf11, "spi11%0d_rf", spi_inst11);
      `uvm_info("ex_reg_rw_reg_seq11", 
        $psprintf("complete random spi11 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model11.spi_ctrl11.write(status, 16'h3E08);
      reg_model11.spi_divider11.write(status, 16'b1);
      reg_model11.spi_ss11.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq11

class spi_en_tx_reg_seq11 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq11)

   function new(string name="spi_en_tx_reg_seq11");
      super.new(name);
   endfunction // new
 
   rand int spi_inst11;
   string spi_rf11;

   spi_regfile11 reg_model11;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf11, "spi11%0d_rf", spi_inst11);
      `uvm_info("ex_reg_rw_reg_seq11", 
        $psprintf("complete random spi11 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model11.spi_ctrl11.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq11


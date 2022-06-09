/*-------------------------------------------------------------------------
File19 name   : spi_reg_seq_lib19.sv
Title19       : REGMEM19 Sequence Library19
Project19     :
Created19     :
Description19 : This19 file implements19 regmem19 sequences
Notes19       :
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq19 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq19)

   function new(string name="spi_cfg_reg_seq19");
      super.new(name);
   endfunction // new
 
   rand int spi_inst19;
   string spi_rf19;

   spi_regfile19 reg_model19;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf19, "spi19%0d_rf", spi_inst19);
      `uvm_info("ex_reg_rw_reg_seq19", 
        $psprintf("complete random spi19 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model19.spi_ctrl19.write(status, 16'h3E08);
      reg_model19.spi_divider19.write(status, 16'b1);
      reg_model19.spi_ss19.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq19

class spi_en_tx_reg_seq19 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq19)

   function new(string name="spi_en_tx_reg_seq19");
      super.new(name);
   endfunction // new
 
   rand int spi_inst19;
   string spi_rf19;

   spi_regfile19 reg_model19;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf19, "spi19%0d_rf", spi_inst19);
      `uvm_info("ex_reg_rw_reg_seq19", 
        $psprintf("complete random spi19 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model19.spi_ctrl19.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq19


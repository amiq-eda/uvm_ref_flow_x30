/*-------------------------------------------------------------------------
File18 name   : spi_reg_seq_lib18.sv
Title18       : REGMEM18 Sequence Library18
Project18     :
Created18     :
Description18 : This18 file implements18 regmem18 sequences
Notes18       :
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------
 
class spi_cfg_reg_seq18 extends uvm_sequence;

   `uvm_object_utils(spi_cfg_reg_seq18)

   function new(string name="spi_cfg_reg_seq18");
      super.new(name);
   endfunction // new
 
   rand int spi_inst18;
   string spi_rf18;

   spi_regfile18 reg_model18;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf18, "spi18%0d_rf", spi_inst18);
      `uvm_info("ex_reg_rw_reg_seq18", 
        $psprintf("complete random spi18 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model18.spi_ctrl18.write(status, 16'h3E08);
      reg_model18.spi_divider18.write(status, 16'b1);
      reg_model18.spi_ss18.write(status, 8'b1);
      #50;
   endtask

endclass : spi_cfg_reg_seq18

class spi_en_tx_reg_seq18 extends uvm_sequence;

   `uvm_object_utils(spi_en_tx_reg_seq18)

   function new(string name="spi_en_tx_reg_seq18");
      super.new(name);
   endfunction // new
 
   rand int spi_inst18;
   string spi_rf18;

   spi_regfile18 reg_model18;

   virtual task body();
     uvm_status_e status;
      $sformat(spi_rf18, "spi18%0d_rf", spi_inst18);
      `uvm_info("ex_reg_rw_reg_seq18", 
        $psprintf("complete random spi18 configuration register sequence starting..."), UVM_MEDIUM)
      #200;
      reg_model18.spi_ctrl18.write(status, 16'h3F08);
      #50;
   endtask

endclass : spi_en_tx_reg_seq18


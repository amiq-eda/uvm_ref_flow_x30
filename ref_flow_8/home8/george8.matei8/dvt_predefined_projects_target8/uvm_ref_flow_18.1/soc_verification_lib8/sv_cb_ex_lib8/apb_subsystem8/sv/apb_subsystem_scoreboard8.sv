/*-------------------------------------------------------------------------
File8 name   : apb_subsystem_scoreboard8.sv
Title8       : AHB8 - SPI8 Scoreboard8
Project8     :
Created8     :
Description8 : Scoreboard8 for data integrity8 check between AHB8 UVC8 and SPI8 UVC8
Notes8       : Two8 similar8 scoreboards8 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb8)
`uvm_analysis_imp_decl(_spi8)

class spi2ahb_scbd8 extends uvm_scoreboard;
  bit [7:0] data_to_ahb8[$];
  bit [7:0] temp18;

  spi_pkg8::spi_csr_s8 csr8;
  apb_pkg8::apb_slave_config8 slave_cfg8;

  `uvm_component_utils(spi2ahb_scbd8)

  uvm_analysis_imp_ahb8 #(ahb_pkg8::ahb_transfer8, spi2ahb_scbd8) ahb_match8;
  uvm_analysis_imp_spi8 #(spi_pkg8::spi_transfer8, spi2ahb_scbd8) spi_add8;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add8  = new("spi_add8", this);
    ahb_match8 = new("ahb_match8", this);
  endfunction : new

  // implement SPI8 Tx8 analysis8 port from reference model
  virtual function void write_spi8(spi_pkg8::spi_transfer8 transfer8);
    data_to_ahb8.push_back(transfer8.transfer_data8[7:0]);	
  endfunction : write_spi8
     
  // implement APB8 READ analysis8 port from reference model
  virtual function void write_ahb8(input ahb_pkg8::ahb_transfer8 transfer8);

    if ((transfer8.address ==   (slave_cfg8.start_address8 + `SPI_RX0_REG8)) && (transfer8.direction8.name() == "READ"))
      begin
        temp18 = data_to_ahb8.pop_front();
       
        if (temp18 == transfer8.data[7:0]) 
          `uvm_info("SCRBD8", $psprintf("####### PASS8 : AHB8 RECEIVED8 CORRECT8 DATA8 from %s  expected = %h, received8 = %h", slave_cfg8.name, temp18, transfer8.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL8 : AHB8 RECEIVED8 WRONG8 DATA8 from %s", slave_cfg8.name))
          `uvm_info("SCRBD8", $psprintf("expected = %h, received8 = %h", temp18, transfer8.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb8
   
  function void assign_csr8(spi_pkg8::spi_csr_s8 csr_setting8);
    csr8 = csr_setting8;
  endfunction : assign_csr8

endclass : spi2ahb_scbd8

class ahb2spi_scbd8 extends uvm_scoreboard;
  bit [7:0] data_from_ahb8[$];

  bit [7:0] temp18;
  bit [7:0] mask;

  spi_pkg8::spi_csr_s8 csr8;
  apb_pkg8::apb_slave_config8 slave_cfg8;

  `uvm_component_utils(ahb2spi_scbd8)
  uvm_analysis_imp_ahb8 #(ahb_pkg8::ahb_transfer8, ahb2spi_scbd8) ahb_add8;
  uvm_analysis_imp_spi8 #(spi_pkg8::spi_transfer8, ahb2spi_scbd8) spi_match8;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match8 = new("spi_match8", this);
    ahb_add8    = new("ahb_add8", this);
  endfunction : new
   
  // implement AHB8 WRITE analysis8 port from reference model
  virtual function void write_ahb8(input ahb_pkg8::ahb_transfer8 transfer8);
    if ((transfer8.address ==  (slave_cfg8.start_address8 + `SPI_TX0_REG8)) && (transfer8.direction8.name() == "WRITE")) 
        data_from_ahb8.push_back(transfer8.data[7:0]);
  endfunction : write_ahb8
   
  // implement SPI8 Rx8 analysis8 port from reference model
  virtual function void write_spi8( spi_pkg8::spi_transfer8 transfer8);
    mask = calc_mask8();
    temp18 = data_from_ahb8.pop_front();

    if ((temp18 & mask) == transfer8.receive_data8[7:0])
      `uvm_info("SCRBD8", $psprintf("####### PASS8 : %s RECEIVED8 CORRECT8 DATA8 expected = %h, received8 = %h", slave_cfg8.name, (temp18 & mask), transfer8.receive_data8), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL8 : %s RECEIVED8 WRONG8 DATA8", slave_cfg8.name))
      `uvm_info("SCRBD8", $psprintf("expected = %h, received8 = %h", temp18, transfer8.receive_data8), UVM_MEDIUM)
    end
  endfunction : write_spi8
   
  function void assign_csr8(spi_pkg8::spi_csr_s8 csr_setting8);
     csr8 = csr_setting8;
  endfunction : assign_csr8
   
  function bit[31:0] calc_mask8();
    case (csr8.data_size8)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask8

endclass : ahb2spi_scbd8


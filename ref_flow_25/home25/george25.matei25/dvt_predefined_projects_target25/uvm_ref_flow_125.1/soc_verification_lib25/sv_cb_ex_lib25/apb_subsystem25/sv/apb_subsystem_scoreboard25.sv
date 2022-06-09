/*-------------------------------------------------------------------------
File25 name   : apb_subsystem_scoreboard25.sv
Title25       : AHB25 - SPI25 Scoreboard25
Project25     :
Created25     :
Description25 : Scoreboard25 for data integrity25 check between AHB25 UVC25 and SPI25 UVC25
Notes25       : Two25 similar25 scoreboards25 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb25)
`uvm_analysis_imp_decl(_spi25)

class spi2ahb_scbd25 extends uvm_scoreboard;
  bit [7:0] data_to_ahb25[$];
  bit [7:0] temp125;

  spi_pkg25::spi_csr_s25 csr25;
  apb_pkg25::apb_slave_config25 slave_cfg25;

  `uvm_component_utils(spi2ahb_scbd25)

  uvm_analysis_imp_ahb25 #(ahb_pkg25::ahb_transfer25, spi2ahb_scbd25) ahb_match25;
  uvm_analysis_imp_spi25 #(spi_pkg25::spi_transfer25, spi2ahb_scbd25) spi_add25;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add25  = new("spi_add25", this);
    ahb_match25 = new("ahb_match25", this);
  endfunction : new

  // implement SPI25 Tx25 analysis25 port from reference model
  virtual function void write_spi25(spi_pkg25::spi_transfer25 transfer25);
    data_to_ahb25.push_back(transfer25.transfer_data25[7:0]);	
  endfunction : write_spi25
     
  // implement APB25 READ analysis25 port from reference model
  virtual function void write_ahb25(input ahb_pkg25::ahb_transfer25 transfer25);

    if ((transfer25.address ==   (slave_cfg25.start_address25 + `SPI_RX0_REG25)) && (transfer25.direction25.name() == "READ"))
      begin
        temp125 = data_to_ahb25.pop_front();
       
        if (temp125 == transfer25.data[7:0]) 
          `uvm_info("SCRBD25", $psprintf("####### PASS25 : AHB25 RECEIVED25 CORRECT25 DATA25 from %s  expected = %h, received25 = %h", slave_cfg25.name, temp125, transfer25.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL25 : AHB25 RECEIVED25 WRONG25 DATA25 from %s", slave_cfg25.name))
          `uvm_info("SCRBD25", $psprintf("expected = %h, received25 = %h", temp125, transfer25.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb25
   
  function void assign_csr25(spi_pkg25::spi_csr_s25 csr_setting25);
    csr25 = csr_setting25;
  endfunction : assign_csr25

endclass : spi2ahb_scbd25

class ahb2spi_scbd25 extends uvm_scoreboard;
  bit [7:0] data_from_ahb25[$];

  bit [7:0] temp125;
  bit [7:0] mask;

  spi_pkg25::spi_csr_s25 csr25;
  apb_pkg25::apb_slave_config25 slave_cfg25;

  `uvm_component_utils(ahb2spi_scbd25)
  uvm_analysis_imp_ahb25 #(ahb_pkg25::ahb_transfer25, ahb2spi_scbd25) ahb_add25;
  uvm_analysis_imp_spi25 #(spi_pkg25::spi_transfer25, ahb2spi_scbd25) spi_match25;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match25 = new("spi_match25", this);
    ahb_add25    = new("ahb_add25", this);
  endfunction : new
   
  // implement AHB25 WRITE analysis25 port from reference model
  virtual function void write_ahb25(input ahb_pkg25::ahb_transfer25 transfer25);
    if ((transfer25.address ==  (slave_cfg25.start_address25 + `SPI_TX0_REG25)) && (transfer25.direction25.name() == "WRITE")) 
        data_from_ahb25.push_back(transfer25.data[7:0]);
  endfunction : write_ahb25
   
  // implement SPI25 Rx25 analysis25 port from reference model
  virtual function void write_spi25( spi_pkg25::spi_transfer25 transfer25);
    mask = calc_mask25();
    temp125 = data_from_ahb25.pop_front();

    if ((temp125 & mask) == transfer25.receive_data25[7:0])
      `uvm_info("SCRBD25", $psprintf("####### PASS25 : %s RECEIVED25 CORRECT25 DATA25 expected = %h, received25 = %h", slave_cfg25.name, (temp125 & mask), transfer25.receive_data25), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL25 : %s RECEIVED25 WRONG25 DATA25", slave_cfg25.name))
      `uvm_info("SCRBD25", $psprintf("expected = %h, received25 = %h", temp125, transfer25.receive_data25), UVM_MEDIUM)
    end
  endfunction : write_spi25
   
  function void assign_csr25(spi_pkg25::spi_csr_s25 csr_setting25);
     csr25 = csr_setting25;
  endfunction : assign_csr25
   
  function bit[31:0] calc_mask25();
    case (csr25.data_size25)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask25

endclass : ahb2spi_scbd25


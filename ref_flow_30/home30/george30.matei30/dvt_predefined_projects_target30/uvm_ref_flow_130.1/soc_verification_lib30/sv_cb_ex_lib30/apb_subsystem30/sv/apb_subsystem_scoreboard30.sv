/*-------------------------------------------------------------------------
File30 name   : apb_subsystem_scoreboard30.sv
Title30       : AHB30 - SPI30 Scoreboard30
Project30     :
Created30     :
Description30 : Scoreboard30 for data integrity30 check between AHB30 UVC30 and SPI30 UVC30
Notes30       : Two30 similar30 scoreboards30 one for read and one for write
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
`uvm_analysis_imp_decl(_ahb30)
`uvm_analysis_imp_decl(_spi30)

class spi2ahb_scbd30 extends uvm_scoreboard;
  bit [7:0] data_to_ahb30[$];
  bit [7:0] temp130;

  spi_pkg30::spi_csr_s30 csr30;
  apb_pkg30::apb_slave_config30 slave_cfg30;

  `uvm_component_utils(spi2ahb_scbd30)

  uvm_analysis_imp_ahb30 #(ahb_pkg30::ahb_transfer30, spi2ahb_scbd30) ahb_match30;
  uvm_analysis_imp_spi30 #(spi_pkg30::spi_transfer30, spi2ahb_scbd30) spi_add30;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add30  = new("spi_add30", this);
    ahb_match30 = new("ahb_match30", this);
  endfunction : new

  // implement SPI30 Tx30 analysis30 port from reference model
  virtual function void write_spi30(spi_pkg30::spi_transfer30 transfer30);
    data_to_ahb30.push_back(transfer30.transfer_data30[7:0]);	
  endfunction : write_spi30
     
  // implement APB30 READ analysis30 port from reference model
  virtual function void write_ahb30(input ahb_pkg30::ahb_transfer30 transfer30);

    if ((transfer30.address ==   (slave_cfg30.start_address30 + `SPI_RX0_REG30)) && (transfer30.direction30.name() == "READ"))
      begin
        temp130 = data_to_ahb30.pop_front();
       
        if (temp130 == transfer30.data[7:0]) 
          `uvm_info("SCRBD30", $psprintf("####### PASS30 : AHB30 RECEIVED30 CORRECT30 DATA30 from %s  expected = %h, received30 = %h", slave_cfg30.name, temp130, transfer30.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL30 : AHB30 RECEIVED30 WRONG30 DATA30 from %s", slave_cfg30.name))
          `uvm_info("SCRBD30", $psprintf("expected = %h, received30 = %h", temp130, transfer30.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb30
   
  function void assign_csr30(spi_pkg30::spi_csr_s30 csr_setting30);
    csr30 = csr_setting30;
  endfunction : assign_csr30

endclass : spi2ahb_scbd30

class ahb2spi_scbd30 extends uvm_scoreboard;
  bit [7:0] data_from_ahb30[$];

  bit [7:0] temp130;
  bit [7:0] mask;

  spi_pkg30::spi_csr_s30 csr30;
  apb_pkg30::apb_slave_config30 slave_cfg30;

  `uvm_component_utils(ahb2spi_scbd30)
  uvm_analysis_imp_ahb30 #(ahb_pkg30::ahb_transfer30, ahb2spi_scbd30) ahb_add30;
  uvm_analysis_imp_spi30 #(spi_pkg30::spi_transfer30, ahb2spi_scbd30) spi_match30;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match30 = new("spi_match30", this);
    ahb_add30    = new("ahb_add30", this);
  endfunction : new
   
  // implement AHB30 WRITE analysis30 port from reference model
  virtual function void write_ahb30(input ahb_pkg30::ahb_transfer30 transfer30);
    if ((transfer30.address ==  (slave_cfg30.start_address30 + `SPI_TX0_REG30)) && (transfer30.direction30.name() == "WRITE")) 
        data_from_ahb30.push_back(transfer30.data[7:0]);
  endfunction : write_ahb30
   
  // implement SPI30 Rx30 analysis30 port from reference model
  virtual function void write_spi30( spi_pkg30::spi_transfer30 transfer30);
    mask = calc_mask30();
    temp130 = data_from_ahb30.pop_front();

    if ((temp130 & mask) == transfer30.receive_data30[7:0])
      `uvm_info("SCRBD30", $psprintf("####### PASS30 : %s RECEIVED30 CORRECT30 DATA30 expected = %h, received30 = %h", slave_cfg30.name, (temp130 & mask), transfer30.receive_data30), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL30 : %s RECEIVED30 WRONG30 DATA30", slave_cfg30.name))
      `uvm_info("SCRBD30", $psprintf("expected = %h, received30 = %h", temp130, transfer30.receive_data30), UVM_MEDIUM)
    end
  endfunction : write_spi30
   
  function void assign_csr30(spi_pkg30::spi_csr_s30 csr_setting30);
     csr30 = csr_setting30;
  endfunction : assign_csr30
   
  function bit[31:0] calc_mask30();
    case (csr30.data_size30)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask30

endclass : ahb2spi_scbd30


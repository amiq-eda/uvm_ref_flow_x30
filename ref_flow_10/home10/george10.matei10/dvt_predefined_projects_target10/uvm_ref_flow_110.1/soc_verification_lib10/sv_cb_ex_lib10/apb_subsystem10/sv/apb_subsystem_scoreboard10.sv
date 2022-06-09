/*-------------------------------------------------------------------------
File10 name   : apb_subsystem_scoreboard10.sv
Title10       : AHB10 - SPI10 Scoreboard10
Project10     :
Created10     :
Description10 : Scoreboard10 for data integrity10 check between AHB10 UVC10 and SPI10 UVC10
Notes10       : Two10 similar10 scoreboards10 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb10)
`uvm_analysis_imp_decl(_spi10)

class spi2ahb_scbd10 extends uvm_scoreboard;
  bit [7:0] data_to_ahb10[$];
  bit [7:0] temp110;

  spi_pkg10::spi_csr_s10 csr10;
  apb_pkg10::apb_slave_config10 slave_cfg10;

  `uvm_component_utils(spi2ahb_scbd10)

  uvm_analysis_imp_ahb10 #(ahb_pkg10::ahb_transfer10, spi2ahb_scbd10) ahb_match10;
  uvm_analysis_imp_spi10 #(spi_pkg10::spi_transfer10, spi2ahb_scbd10) spi_add10;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add10  = new("spi_add10", this);
    ahb_match10 = new("ahb_match10", this);
  endfunction : new

  // implement SPI10 Tx10 analysis10 port from reference model
  virtual function void write_spi10(spi_pkg10::spi_transfer10 transfer10);
    data_to_ahb10.push_back(transfer10.transfer_data10[7:0]);	
  endfunction : write_spi10
     
  // implement APB10 READ analysis10 port from reference model
  virtual function void write_ahb10(input ahb_pkg10::ahb_transfer10 transfer10);

    if ((transfer10.address ==   (slave_cfg10.start_address10 + `SPI_RX0_REG10)) && (transfer10.direction10.name() == "READ"))
      begin
        temp110 = data_to_ahb10.pop_front();
       
        if (temp110 == transfer10.data[7:0]) 
          `uvm_info("SCRBD10", $psprintf("####### PASS10 : AHB10 RECEIVED10 CORRECT10 DATA10 from %s  expected = %h, received10 = %h", slave_cfg10.name, temp110, transfer10.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL10 : AHB10 RECEIVED10 WRONG10 DATA10 from %s", slave_cfg10.name))
          `uvm_info("SCRBD10", $psprintf("expected = %h, received10 = %h", temp110, transfer10.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb10
   
  function void assign_csr10(spi_pkg10::spi_csr_s10 csr_setting10);
    csr10 = csr_setting10;
  endfunction : assign_csr10

endclass : spi2ahb_scbd10

class ahb2spi_scbd10 extends uvm_scoreboard;
  bit [7:0] data_from_ahb10[$];

  bit [7:0] temp110;
  bit [7:0] mask;

  spi_pkg10::spi_csr_s10 csr10;
  apb_pkg10::apb_slave_config10 slave_cfg10;

  `uvm_component_utils(ahb2spi_scbd10)
  uvm_analysis_imp_ahb10 #(ahb_pkg10::ahb_transfer10, ahb2spi_scbd10) ahb_add10;
  uvm_analysis_imp_spi10 #(spi_pkg10::spi_transfer10, ahb2spi_scbd10) spi_match10;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match10 = new("spi_match10", this);
    ahb_add10    = new("ahb_add10", this);
  endfunction : new
   
  // implement AHB10 WRITE analysis10 port from reference model
  virtual function void write_ahb10(input ahb_pkg10::ahb_transfer10 transfer10);
    if ((transfer10.address ==  (slave_cfg10.start_address10 + `SPI_TX0_REG10)) && (transfer10.direction10.name() == "WRITE")) 
        data_from_ahb10.push_back(transfer10.data[7:0]);
  endfunction : write_ahb10
   
  // implement SPI10 Rx10 analysis10 port from reference model
  virtual function void write_spi10( spi_pkg10::spi_transfer10 transfer10);
    mask = calc_mask10();
    temp110 = data_from_ahb10.pop_front();

    if ((temp110 & mask) == transfer10.receive_data10[7:0])
      `uvm_info("SCRBD10", $psprintf("####### PASS10 : %s RECEIVED10 CORRECT10 DATA10 expected = %h, received10 = %h", slave_cfg10.name, (temp110 & mask), transfer10.receive_data10), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL10 : %s RECEIVED10 WRONG10 DATA10", slave_cfg10.name))
      `uvm_info("SCRBD10", $psprintf("expected = %h, received10 = %h", temp110, transfer10.receive_data10), UVM_MEDIUM)
    end
  endfunction : write_spi10
   
  function void assign_csr10(spi_pkg10::spi_csr_s10 csr_setting10);
     csr10 = csr_setting10;
  endfunction : assign_csr10
   
  function bit[31:0] calc_mask10();
    case (csr10.data_size10)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask10

endclass : ahb2spi_scbd10


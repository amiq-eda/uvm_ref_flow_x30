/*-------------------------------------------------------------------------
File24 name   : apb_subsystem_scoreboard24.sv
Title24       : AHB24 - SPI24 Scoreboard24
Project24     :
Created24     :
Description24 : Scoreboard24 for data integrity24 check between AHB24 UVC24 and SPI24 UVC24
Notes24       : Two24 similar24 scoreboards24 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb24)
`uvm_analysis_imp_decl(_spi24)

class spi2ahb_scbd24 extends uvm_scoreboard;
  bit [7:0] data_to_ahb24[$];
  bit [7:0] temp124;

  spi_pkg24::spi_csr_s24 csr24;
  apb_pkg24::apb_slave_config24 slave_cfg24;

  `uvm_component_utils(spi2ahb_scbd24)

  uvm_analysis_imp_ahb24 #(ahb_pkg24::ahb_transfer24, spi2ahb_scbd24) ahb_match24;
  uvm_analysis_imp_spi24 #(spi_pkg24::spi_transfer24, spi2ahb_scbd24) spi_add24;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add24  = new("spi_add24", this);
    ahb_match24 = new("ahb_match24", this);
  endfunction : new

  // implement SPI24 Tx24 analysis24 port from reference model
  virtual function void write_spi24(spi_pkg24::spi_transfer24 transfer24);
    data_to_ahb24.push_back(transfer24.transfer_data24[7:0]);	
  endfunction : write_spi24
     
  // implement APB24 READ analysis24 port from reference model
  virtual function void write_ahb24(input ahb_pkg24::ahb_transfer24 transfer24);

    if ((transfer24.address ==   (slave_cfg24.start_address24 + `SPI_RX0_REG24)) && (transfer24.direction24.name() == "READ"))
      begin
        temp124 = data_to_ahb24.pop_front();
       
        if (temp124 == transfer24.data[7:0]) 
          `uvm_info("SCRBD24", $psprintf("####### PASS24 : AHB24 RECEIVED24 CORRECT24 DATA24 from %s  expected = %h, received24 = %h", slave_cfg24.name, temp124, transfer24.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL24 : AHB24 RECEIVED24 WRONG24 DATA24 from %s", slave_cfg24.name))
          `uvm_info("SCRBD24", $psprintf("expected = %h, received24 = %h", temp124, transfer24.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb24
   
  function void assign_csr24(spi_pkg24::spi_csr_s24 csr_setting24);
    csr24 = csr_setting24;
  endfunction : assign_csr24

endclass : spi2ahb_scbd24

class ahb2spi_scbd24 extends uvm_scoreboard;
  bit [7:0] data_from_ahb24[$];

  bit [7:0] temp124;
  bit [7:0] mask;

  spi_pkg24::spi_csr_s24 csr24;
  apb_pkg24::apb_slave_config24 slave_cfg24;

  `uvm_component_utils(ahb2spi_scbd24)
  uvm_analysis_imp_ahb24 #(ahb_pkg24::ahb_transfer24, ahb2spi_scbd24) ahb_add24;
  uvm_analysis_imp_spi24 #(spi_pkg24::spi_transfer24, ahb2spi_scbd24) spi_match24;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match24 = new("spi_match24", this);
    ahb_add24    = new("ahb_add24", this);
  endfunction : new
   
  // implement AHB24 WRITE analysis24 port from reference model
  virtual function void write_ahb24(input ahb_pkg24::ahb_transfer24 transfer24);
    if ((transfer24.address ==  (slave_cfg24.start_address24 + `SPI_TX0_REG24)) && (transfer24.direction24.name() == "WRITE")) 
        data_from_ahb24.push_back(transfer24.data[7:0]);
  endfunction : write_ahb24
   
  // implement SPI24 Rx24 analysis24 port from reference model
  virtual function void write_spi24( spi_pkg24::spi_transfer24 transfer24);
    mask = calc_mask24();
    temp124 = data_from_ahb24.pop_front();

    if ((temp124 & mask) == transfer24.receive_data24[7:0])
      `uvm_info("SCRBD24", $psprintf("####### PASS24 : %s RECEIVED24 CORRECT24 DATA24 expected = %h, received24 = %h", slave_cfg24.name, (temp124 & mask), transfer24.receive_data24), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL24 : %s RECEIVED24 WRONG24 DATA24", slave_cfg24.name))
      `uvm_info("SCRBD24", $psprintf("expected = %h, received24 = %h", temp124, transfer24.receive_data24), UVM_MEDIUM)
    end
  endfunction : write_spi24
   
  function void assign_csr24(spi_pkg24::spi_csr_s24 csr_setting24);
     csr24 = csr_setting24;
  endfunction : assign_csr24
   
  function bit[31:0] calc_mask24();
    case (csr24.data_size24)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask24

endclass : ahb2spi_scbd24


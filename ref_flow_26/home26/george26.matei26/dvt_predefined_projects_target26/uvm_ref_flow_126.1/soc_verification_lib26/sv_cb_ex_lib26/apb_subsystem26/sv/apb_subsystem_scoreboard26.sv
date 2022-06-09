/*-------------------------------------------------------------------------
File26 name   : apb_subsystem_scoreboard26.sv
Title26       : AHB26 - SPI26 Scoreboard26
Project26     :
Created26     :
Description26 : Scoreboard26 for data integrity26 check between AHB26 UVC26 and SPI26 UVC26
Notes26       : Two26 similar26 scoreboards26 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb26)
`uvm_analysis_imp_decl(_spi26)

class spi2ahb_scbd26 extends uvm_scoreboard;
  bit [7:0] data_to_ahb26[$];
  bit [7:0] temp126;

  spi_pkg26::spi_csr_s26 csr26;
  apb_pkg26::apb_slave_config26 slave_cfg26;

  `uvm_component_utils(spi2ahb_scbd26)

  uvm_analysis_imp_ahb26 #(ahb_pkg26::ahb_transfer26, spi2ahb_scbd26) ahb_match26;
  uvm_analysis_imp_spi26 #(spi_pkg26::spi_transfer26, spi2ahb_scbd26) spi_add26;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add26  = new("spi_add26", this);
    ahb_match26 = new("ahb_match26", this);
  endfunction : new

  // implement SPI26 Tx26 analysis26 port from reference model
  virtual function void write_spi26(spi_pkg26::spi_transfer26 transfer26);
    data_to_ahb26.push_back(transfer26.transfer_data26[7:0]);	
  endfunction : write_spi26
     
  // implement APB26 READ analysis26 port from reference model
  virtual function void write_ahb26(input ahb_pkg26::ahb_transfer26 transfer26);

    if ((transfer26.address ==   (slave_cfg26.start_address26 + `SPI_RX0_REG26)) && (transfer26.direction26.name() == "READ"))
      begin
        temp126 = data_to_ahb26.pop_front();
       
        if (temp126 == transfer26.data[7:0]) 
          `uvm_info("SCRBD26", $psprintf("####### PASS26 : AHB26 RECEIVED26 CORRECT26 DATA26 from %s  expected = %h, received26 = %h", slave_cfg26.name, temp126, transfer26.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL26 : AHB26 RECEIVED26 WRONG26 DATA26 from %s", slave_cfg26.name))
          `uvm_info("SCRBD26", $psprintf("expected = %h, received26 = %h", temp126, transfer26.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb26
   
  function void assign_csr26(spi_pkg26::spi_csr_s26 csr_setting26);
    csr26 = csr_setting26;
  endfunction : assign_csr26

endclass : spi2ahb_scbd26

class ahb2spi_scbd26 extends uvm_scoreboard;
  bit [7:0] data_from_ahb26[$];

  bit [7:0] temp126;
  bit [7:0] mask;

  spi_pkg26::spi_csr_s26 csr26;
  apb_pkg26::apb_slave_config26 slave_cfg26;

  `uvm_component_utils(ahb2spi_scbd26)
  uvm_analysis_imp_ahb26 #(ahb_pkg26::ahb_transfer26, ahb2spi_scbd26) ahb_add26;
  uvm_analysis_imp_spi26 #(spi_pkg26::spi_transfer26, ahb2spi_scbd26) spi_match26;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match26 = new("spi_match26", this);
    ahb_add26    = new("ahb_add26", this);
  endfunction : new
   
  // implement AHB26 WRITE analysis26 port from reference model
  virtual function void write_ahb26(input ahb_pkg26::ahb_transfer26 transfer26);
    if ((transfer26.address ==  (slave_cfg26.start_address26 + `SPI_TX0_REG26)) && (transfer26.direction26.name() == "WRITE")) 
        data_from_ahb26.push_back(transfer26.data[7:0]);
  endfunction : write_ahb26
   
  // implement SPI26 Rx26 analysis26 port from reference model
  virtual function void write_spi26( spi_pkg26::spi_transfer26 transfer26);
    mask = calc_mask26();
    temp126 = data_from_ahb26.pop_front();

    if ((temp126 & mask) == transfer26.receive_data26[7:0])
      `uvm_info("SCRBD26", $psprintf("####### PASS26 : %s RECEIVED26 CORRECT26 DATA26 expected = %h, received26 = %h", slave_cfg26.name, (temp126 & mask), transfer26.receive_data26), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL26 : %s RECEIVED26 WRONG26 DATA26", slave_cfg26.name))
      `uvm_info("SCRBD26", $psprintf("expected = %h, received26 = %h", temp126, transfer26.receive_data26), UVM_MEDIUM)
    end
  endfunction : write_spi26
   
  function void assign_csr26(spi_pkg26::spi_csr_s26 csr_setting26);
     csr26 = csr_setting26;
  endfunction : assign_csr26
   
  function bit[31:0] calc_mask26();
    case (csr26.data_size26)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask26

endclass : ahb2spi_scbd26


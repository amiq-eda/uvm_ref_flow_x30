/*-------------------------------------------------------------------------
File20 name   : apb_subsystem_scoreboard20.sv
Title20       : AHB20 - SPI20 Scoreboard20
Project20     :
Created20     :
Description20 : Scoreboard20 for data integrity20 check between AHB20 UVC20 and SPI20 UVC20
Notes20       : Two20 similar20 scoreboards20 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb20)
`uvm_analysis_imp_decl(_spi20)

class spi2ahb_scbd20 extends uvm_scoreboard;
  bit [7:0] data_to_ahb20[$];
  bit [7:0] temp120;

  spi_pkg20::spi_csr_s20 csr20;
  apb_pkg20::apb_slave_config20 slave_cfg20;

  `uvm_component_utils(spi2ahb_scbd20)

  uvm_analysis_imp_ahb20 #(ahb_pkg20::ahb_transfer20, spi2ahb_scbd20) ahb_match20;
  uvm_analysis_imp_spi20 #(spi_pkg20::spi_transfer20, spi2ahb_scbd20) spi_add20;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add20  = new("spi_add20", this);
    ahb_match20 = new("ahb_match20", this);
  endfunction : new

  // implement SPI20 Tx20 analysis20 port from reference model
  virtual function void write_spi20(spi_pkg20::spi_transfer20 transfer20);
    data_to_ahb20.push_back(transfer20.transfer_data20[7:0]);	
  endfunction : write_spi20
     
  // implement APB20 READ analysis20 port from reference model
  virtual function void write_ahb20(input ahb_pkg20::ahb_transfer20 transfer20);

    if ((transfer20.address ==   (slave_cfg20.start_address20 + `SPI_RX0_REG20)) && (transfer20.direction20.name() == "READ"))
      begin
        temp120 = data_to_ahb20.pop_front();
       
        if (temp120 == transfer20.data[7:0]) 
          `uvm_info("SCRBD20", $psprintf("####### PASS20 : AHB20 RECEIVED20 CORRECT20 DATA20 from %s  expected = %h, received20 = %h", slave_cfg20.name, temp120, transfer20.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL20 : AHB20 RECEIVED20 WRONG20 DATA20 from %s", slave_cfg20.name))
          `uvm_info("SCRBD20", $psprintf("expected = %h, received20 = %h", temp120, transfer20.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb20
   
  function void assign_csr20(spi_pkg20::spi_csr_s20 csr_setting20);
    csr20 = csr_setting20;
  endfunction : assign_csr20

endclass : spi2ahb_scbd20

class ahb2spi_scbd20 extends uvm_scoreboard;
  bit [7:0] data_from_ahb20[$];

  bit [7:0] temp120;
  bit [7:0] mask;

  spi_pkg20::spi_csr_s20 csr20;
  apb_pkg20::apb_slave_config20 slave_cfg20;

  `uvm_component_utils(ahb2spi_scbd20)
  uvm_analysis_imp_ahb20 #(ahb_pkg20::ahb_transfer20, ahb2spi_scbd20) ahb_add20;
  uvm_analysis_imp_spi20 #(spi_pkg20::spi_transfer20, ahb2spi_scbd20) spi_match20;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match20 = new("spi_match20", this);
    ahb_add20    = new("ahb_add20", this);
  endfunction : new
   
  // implement AHB20 WRITE analysis20 port from reference model
  virtual function void write_ahb20(input ahb_pkg20::ahb_transfer20 transfer20);
    if ((transfer20.address ==  (slave_cfg20.start_address20 + `SPI_TX0_REG20)) && (transfer20.direction20.name() == "WRITE")) 
        data_from_ahb20.push_back(transfer20.data[7:0]);
  endfunction : write_ahb20
   
  // implement SPI20 Rx20 analysis20 port from reference model
  virtual function void write_spi20( spi_pkg20::spi_transfer20 transfer20);
    mask = calc_mask20();
    temp120 = data_from_ahb20.pop_front();

    if ((temp120 & mask) == transfer20.receive_data20[7:0])
      `uvm_info("SCRBD20", $psprintf("####### PASS20 : %s RECEIVED20 CORRECT20 DATA20 expected = %h, received20 = %h", slave_cfg20.name, (temp120 & mask), transfer20.receive_data20), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL20 : %s RECEIVED20 WRONG20 DATA20", slave_cfg20.name))
      `uvm_info("SCRBD20", $psprintf("expected = %h, received20 = %h", temp120, transfer20.receive_data20), UVM_MEDIUM)
    end
  endfunction : write_spi20
   
  function void assign_csr20(spi_pkg20::spi_csr_s20 csr_setting20);
     csr20 = csr_setting20;
  endfunction : assign_csr20
   
  function bit[31:0] calc_mask20();
    case (csr20.data_size20)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask20

endclass : ahb2spi_scbd20


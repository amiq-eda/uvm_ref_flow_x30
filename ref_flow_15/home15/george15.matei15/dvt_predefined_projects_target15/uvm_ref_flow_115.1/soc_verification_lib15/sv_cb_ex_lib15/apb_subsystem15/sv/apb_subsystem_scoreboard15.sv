/*-------------------------------------------------------------------------
File15 name   : apb_subsystem_scoreboard15.sv
Title15       : AHB15 - SPI15 Scoreboard15
Project15     :
Created15     :
Description15 : Scoreboard15 for data integrity15 check between AHB15 UVC15 and SPI15 UVC15
Notes15       : Two15 similar15 scoreboards15 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb15)
`uvm_analysis_imp_decl(_spi15)

class spi2ahb_scbd15 extends uvm_scoreboard;
  bit [7:0] data_to_ahb15[$];
  bit [7:0] temp115;

  spi_pkg15::spi_csr_s15 csr15;
  apb_pkg15::apb_slave_config15 slave_cfg15;

  `uvm_component_utils(spi2ahb_scbd15)

  uvm_analysis_imp_ahb15 #(ahb_pkg15::ahb_transfer15, spi2ahb_scbd15) ahb_match15;
  uvm_analysis_imp_spi15 #(spi_pkg15::spi_transfer15, spi2ahb_scbd15) spi_add15;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add15  = new("spi_add15", this);
    ahb_match15 = new("ahb_match15", this);
  endfunction : new

  // implement SPI15 Tx15 analysis15 port from reference model
  virtual function void write_spi15(spi_pkg15::spi_transfer15 transfer15);
    data_to_ahb15.push_back(transfer15.transfer_data15[7:0]);	
  endfunction : write_spi15
     
  // implement APB15 READ analysis15 port from reference model
  virtual function void write_ahb15(input ahb_pkg15::ahb_transfer15 transfer15);

    if ((transfer15.address ==   (slave_cfg15.start_address15 + `SPI_RX0_REG15)) && (transfer15.direction15.name() == "READ"))
      begin
        temp115 = data_to_ahb15.pop_front();
       
        if (temp115 == transfer15.data[7:0]) 
          `uvm_info("SCRBD15", $psprintf("####### PASS15 : AHB15 RECEIVED15 CORRECT15 DATA15 from %s  expected = %h, received15 = %h", slave_cfg15.name, temp115, transfer15.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL15 : AHB15 RECEIVED15 WRONG15 DATA15 from %s", slave_cfg15.name))
          `uvm_info("SCRBD15", $psprintf("expected = %h, received15 = %h", temp115, transfer15.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb15
   
  function void assign_csr15(spi_pkg15::spi_csr_s15 csr_setting15);
    csr15 = csr_setting15;
  endfunction : assign_csr15

endclass : spi2ahb_scbd15

class ahb2spi_scbd15 extends uvm_scoreboard;
  bit [7:0] data_from_ahb15[$];

  bit [7:0] temp115;
  bit [7:0] mask;

  spi_pkg15::spi_csr_s15 csr15;
  apb_pkg15::apb_slave_config15 slave_cfg15;

  `uvm_component_utils(ahb2spi_scbd15)
  uvm_analysis_imp_ahb15 #(ahb_pkg15::ahb_transfer15, ahb2spi_scbd15) ahb_add15;
  uvm_analysis_imp_spi15 #(spi_pkg15::spi_transfer15, ahb2spi_scbd15) spi_match15;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match15 = new("spi_match15", this);
    ahb_add15    = new("ahb_add15", this);
  endfunction : new
   
  // implement AHB15 WRITE analysis15 port from reference model
  virtual function void write_ahb15(input ahb_pkg15::ahb_transfer15 transfer15);
    if ((transfer15.address ==  (slave_cfg15.start_address15 + `SPI_TX0_REG15)) && (transfer15.direction15.name() == "WRITE")) 
        data_from_ahb15.push_back(transfer15.data[7:0]);
  endfunction : write_ahb15
   
  // implement SPI15 Rx15 analysis15 port from reference model
  virtual function void write_spi15( spi_pkg15::spi_transfer15 transfer15);
    mask = calc_mask15();
    temp115 = data_from_ahb15.pop_front();

    if ((temp115 & mask) == transfer15.receive_data15[7:0])
      `uvm_info("SCRBD15", $psprintf("####### PASS15 : %s RECEIVED15 CORRECT15 DATA15 expected = %h, received15 = %h", slave_cfg15.name, (temp115 & mask), transfer15.receive_data15), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL15 : %s RECEIVED15 WRONG15 DATA15", slave_cfg15.name))
      `uvm_info("SCRBD15", $psprintf("expected = %h, received15 = %h", temp115, transfer15.receive_data15), UVM_MEDIUM)
    end
  endfunction : write_spi15
   
  function void assign_csr15(spi_pkg15::spi_csr_s15 csr_setting15);
     csr15 = csr_setting15;
  endfunction : assign_csr15
   
  function bit[31:0] calc_mask15();
    case (csr15.data_size15)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask15

endclass : ahb2spi_scbd15


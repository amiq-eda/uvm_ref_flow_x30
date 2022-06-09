/*-------------------------------------------------------------------------
File16 name   : apb_subsystem_scoreboard16.sv
Title16       : AHB16 - SPI16 Scoreboard16
Project16     :
Created16     :
Description16 : Scoreboard16 for data integrity16 check between AHB16 UVC16 and SPI16 UVC16
Notes16       : Two16 similar16 scoreboards16 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb16)
`uvm_analysis_imp_decl(_spi16)

class spi2ahb_scbd16 extends uvm_scoreboard;
  bit [7:0] data_to_ahb16[$];
  bit [7:0] temp116;

  spi_pkg16::spi_csr_s16 csr16;
  apb_pkg16::apb_slave_config16 slave_cfg16;

  `uvm_component_utils(spi2ahb_scbd16)

  uvm_analysis_imp_ahb16 #(ahb_pkg16::ahb_transfer16, spi2ahb_scbd16) ahb_match16;
  uvm_analysis_imp_spi16 #(spi_pkg16::spi_transfer16, spi2ahb_scbd16) spi_add16;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add16  = new("spi_add16", this);
    ahb_match16 = new("ahb_match16", this);
  endfunction : new

  // implement SPI16 Tx16 analysis16 port from reference model
  virtual function void write_spi16(spi_pkg16::spi_transfer16 transfer16);
    data_to_ahb16.push_back(transfer16.transfer_data16[7:0]);	
  endfunction : write_spi16
     
  // implement APB16 READ analysis16 port from reference model
  virtual function void write_ahb16(input ahb_pkg16::ahb_transfer16 transfer16);

    if ((transfer16.address ==   (slave_cfg16.start_address16 + `SPI_RX0_REG16)) && (transfer16.direction16.name() == "READ"))
      begin
        temp116 = data_to_ahb16.pop_front();
       
        if (temp116 == transfer16.data[7:0]) 
          `uvm_info("SCRBD16", $psprintf("####### PASS16 : AHB16 RECEIVED16 CORRECT16 DATA16 from %s  expected = %h, received16 = %h", slave_cfg16.name, temp116, transfer16.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL16 : AHB16 RECEIVED16 WRONG16 DATA16 from %s", slave_cfg16.name))
          `uvm_info("SCRBD16", $psprintf("expected = %h, received16 = %h", temp116, transfer16.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb16
   
  function void assign_csr16(spi_pkg16::spi_csr_s16 csr_setting16);
    csr16 = csr_setting16;
  endfunction : assign_csr16

endclass : spi2ahb_scbd16

class ahb2spi_scbd16 extends uvm_scoreboard;
  bit [7:0] data_from_ahb16[$];

  bit [7:0] temp116;
  bit [7:0] mask;

  spi_pkg16::spi_csr_s16 csr16;
  apb_pkg16::apb_slave_config16 slave_cfg16;

  `uvm_component_utils(ahb2spi_scbd16)
  uvm_analysis_imp_ahb16 #(ahb_pkg16::ahb_transfer16, ahb2spi_scbd16) ahb_add16;
  uvm_analysis_imp_spi16 #(spi_pkg16::spi_transfer16, ahb2spi_scbd16) spi_match16;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match16 = new("spi_match16", this);
    ahb_add16    = new("ahb_add16", this);
  endfunction : new
   
  // implement AHB16 WRITE analysis16 port from reference model
  virtual function void write_ahb16(input ahb_pkg16::ahb_transfer16 transfer16);
    if ((transfer16.address ==  (slave_cfg16.start_address16 + `SPI_TX0_REG16)) && (transfer16.direction16.name() == "WRITE")) 
        data_from_ahb16.push_back(transfer16.data[7:0]);
  endfunction : write_ahb16
   
  // implement SPI16 Rx16 analysis16 port from reference model
  virtual function void write_spi16( spi_pkg16::spi_transfer16 transfer16);
    mask = calc_mask16();
    temp116 = data_from_ahb16.pop_front();

    if ((temp116 & mask) == transfer16.receive_data16[7:0])
      `uvm_info("SCRBD16", $psprintf("####### PASS16 : %s RECEIVED16 CORRECT16 DATA16 expected = %h, received16 = %h", slave_cfg16.name, (temp116 & mask), transfer16.receive_data16), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL16 : %s RECEIVED16 WRONG16 DATA16", slave_cfg16.name))
      `uvm_info("SCRBD16", $psprintf("expected = %h, received16 = %h", temp116, transfer16.receive_data16), UVM_MEDIUM)
    end
  endfunction : write_spi16
   
  function void assign_csr16(spi_pkg16::spi_csr_s16 csr_setting16);
     csr16 = csr_setting16;
  endfunction : assign_csr16
   
  function bit[31:0] calc_mask16();
    case (csr16.data_size16)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask16

endclass : ahb2spi_scbd16


/*-------------------------------------------------------------------------
File7 name   : apb_subsystem_scoreboard7.sv
Title7       : AHB7 - SPI7 Scoreboard7
Project7     :
Created7     :
Description7 : Scoreboard7 for data integrity7 check between AHB7 UVC7 and SPI7 UVC7
Notes7       : Two7 similar7 scoreboards7 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb7)
`uvm_analysis_imp_decl(_spi7)

class spi2ahb_scbd7 extends uvm_scoreboard;
  bit [7:0] data_to_ahb7[$];
  bit [7:0] temp17;

  spi_pkg7::spi_csr_s7 csr7;
  apb_pkg7::apb_slave_config7 slave_cfg7;

  `uvm_component_utils(spi2ahb_scbd7)

  uvm_analysis_imp_ahb7 #(ahb_pkg7::ahb_transfer7, spi2ahb_scbd7) ahb_match7;
  uvm_analysis_imp_spi7 #(spi_pkg7::spi_transfer7, spi2ahb_scbd7) spi_add7;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add7  = new("spi_add7", this);
    ahb_match7 = new("ahb_match7", this);
  endfunction : new

  // implement SPI7 Tx7 analysis7 port from reference model
  virtual function void write_spi7(spi_pkg7::spi_transfer7 transfer7);
    data_to_ahb7.push_back(transfer7.transfer_data7[7:0]);	
  endfunction : write_spi7
     
  // implement APB7 READ analysis7 port from reference model
  virtual function void write_ahb7(input ahb_pkg7::ahb_transfer7 transfer7);

    if ((transfer7.address ==   (slave_cfg7.start_address7 + `SPI_RX0_REG7)) && (transfer7.direction7.name() == "READ"))
      begin
        temp17 = data_to_ahb7.pop_front();
       
        if (temp17 == transfer7.data[7:0]) 
          `uvm_info("SCRBD7", $psprintf("####### PASS7 : AHB7 RECEIVED7 CORRECT7 DATA7 from %s  expected = %h, received7 = %h", slave_cfg7.name, temp17, transfer7.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL7 : AHB7 RECEIVED7 WRONG7 DATA7 from %s", slave_cfg7.name))
          `uvm_info("SCRBD7", $psprintf("expected = %h, received7 = %h", temp17, transfer7.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb7
   
  function void assign_csr7(spi_pkg7::spi_csr_s7 csr_setting7);
    csr7 = csr_setting7;
  endfunction : assign_csr7

endclass : spi2ahb_scbd7

class ahb2spi_scbd7 extends uvm_scoreboard;
  bit [7:0] data_from_ahb7[$];

  bit [7:0] temp17;
  bit [7:0] mask;

  spi_pkg7::spi_csr_s7 csr7;
  apb_pkg7::apb_slave_config7 slave_cfg7;

  `uvm_component_utils(ahb2spi_scbd7)
  uvm_analysis_imp_ahb7 #(ahb_pkg7::ahb_transfer7, ahb2spi_scbd7) ahb_add7;
  uvm_analysis_imp_spi7 #(spi_pkg7::spi_transfer7, ahb2spi_scbd7) spi_match7;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match7 = new("spi_match7", this);
    ahb_add7    = new("ahb_add7", this);
  endfunction : new
   
  // implement AHB7 WRITE analysis7 port from reference model
  virtual function void write_ahb7(input ahb_pkg7::ahb_transfer7 transfer7);
    if ((transfer7.address ==  (slave_cfg7.start_address7 + `SPI_TX0_REG7)) && (transfer7.direction7.name() == "WRITE")) 
        data_from_ahb7.push_back(transfer7.data[7:0]);
  endfunction : write_ahb7
   
  // implement SPI7 Rx7 analysis7 port from reference model
  virtual function void write_spi7( spi_pkg7::spi_transfer7 transfer7);
    mask = calc_mask7();
    temp17 = data_from_ahb7.pop_front();

    if ((temp17 & mask) == transfer7.receive_data7[7:0])
      `uvm_info("SCRBD7", $psprintf("####### PASS7 : %s RECEIVED7 CORRECT7 DATA7 expected = %h, received7 = %h", slave_cfg7.name, (temp17 & mask), transfer7.receive_data7), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL7 : %s RECEIVED7 WRONG7 DATA7", slave_cfg7.name))
      `uvm_info("SCRBD7", $psprintf("expected = %h, received7 = %h", temp17, transfer7.receive_data7), UVM_MEDIUM)
    end
  endfunction : write_spi7
   
  function void assign_csr7(spi_pkg7::spi_csr_s7 csr_setting7);
     csr7 = csr_setting7;
  endfunction : assign_csr7
   
  function bit[31:0] calc_mask7();
    case (csr7.data_size7)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask7

endclass : ahb2spi_scbd7


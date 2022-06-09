/*-------------------------------------------------------------------------
File3 name   : apb_subsystem_scoreboard3.sv
Title3       : AHB3 - SPI3 Scoreboard3
Project3     :
Created3     :
Description3 : Scoreboard3 for data integrity3 check between AHB3 UVC3 and SPI3 UVC3
Notes3       : Two3 similar3 scoreboards3 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb3)
`uvm_analysis_imp_decl(_spi3)

class spi2ahb_scbd3 extends uvm_scoreboard;
  bit [7:0] data_to_ahb3[$];
  bit [7:0] temp13;

  spi_pkg3::spi_csr_s3 csr3;
  apb_pkg3::apb_slave_config3 slave_cfg3;

  `uvm_component_utils(spi2ahb_scbd3)

  uvm_analysis_imp_ahb3 #(ahb_pkg3::ahb_transfer3, spi2ahb_scbd3) ahb_match3;
  uvm_analysis_imp_spi3 #(spi_pkg3::spi_transfer3, spi2ahb_scbd3) spi_add3;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add3  = new("spi_add3", this);
    ahb_match3 = new("ahb_match3", this);
  endfunction : new

  // implement SPI3 Tx3 analysis3 port from reference model
  virtual function void write_spi3(spi_pkg3::spi_transfer3 transfer3);
    data_to_ahb3.push_back(transfer3.transfer_data3[7:0]);	
  endfunction : write_spi3
     
  // implement APB3 READ analysis3 port from reference model
  virtual function void write_ahb3(input ahb_pkg3::ahb_transfer3 transfer3);

    if ((transfer3.address ==   (slave_cfg3.start_address3 + `SPI_RX0_REG3)) && (transfer3.direction3.name() == "READ"))
      begin
        temp13 = data_to_ahb3.pop_front();
       
        if (temp13 == transfer3.data[7:0]) 
          `uvm_info("SCRBD3", $psprintf("####### PASS3 : AHB3 RECEIVED3 CORRECT3 DATA3 from %s  expected = %h, received3 = %h", slave_cfg3.name, temp13, transfer3.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL3 : AHB3 RECEIVED3 WRONG3 DATA3 from %s", slave_cfg3.name))
          `uvm_info("SCRBD3", $psprintf("expected = %h, received3 = %h", temp13, transfer3.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb3
   
  function void assign_csr3(spi_pkg3::spi_csr_s3 csr_setting3);
    csr3 = csr_setting3;
  endfunction : assign_csr3

endclass : spi2ahb_scbd3

class ahb2spi_scbd3 extends uvm_scoreboard;
  bit [7:0] data_from_ahb3[$];

  bit [7:0] temp13;
  bit [7:0] mask;

  spi_pkg3::spi_csr_s3 csr3;
  apb_pkg3::apb_slave_config3 slave_cfg3;

  `uvm_component_utils(ahb2spi_scbd3)
  uvm_analysis_imp_ahb3 #(ahb_pkg3::ahb_transfer3, ahb2spi_scbd3) ahb_add3;
  uvm_analysis_imp_spi3 #(spi_pkg3::spi_transfer3, ahb2spi_scbd3) spi_match3;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match3 = new("spi_match3", this);
    ahb_add3    = new("ahb_add3", this);
  endfunction : new
   
  // implement AHB3 WRITE analysis3 port from reference model
  virtual function void write_ahb3(input ahb_pkg3::ahb_transfer3 transfer3);
    if ((transfer3.address ==  (slave_cfg3.start_address3 + `SPI_TX0_REG3)) && (transfer3.direction3.name() == "WRITE")) 
        data_from_ahb3.push_back(transfer3.data[7:0]);
  endfunction : write_ahb3
   
  // implement SPI3 Rx3 analysis3 port from reference model
  virtual function void write_spi3( spi_pkg3::spi_transfer3 transfer3);
    mask = calc_mask3();
    temp13 = data_from_ahb3.pop_front();

    if ((temp13 & mask) == transfer3.receive_data3[7:0])
      `uvm_info("SCRBD3", $psprintf("####### PASS3 : %s RECEIVED3 CORRECT3 DATA3 expected = %h, received3 = %h", slave_cfg3.name, (temp13 & mask), transfer3.receive_data3), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL3 : %s RECEIVED3 WRONG3 DATA3", slave_cfg3.name))
      `uvm_info("SCRBD3", $psprintf("expected = %h, received3 = %h", temp13, transfer3.receive_data3), UVM_MEDIUM)
    end
  endfunction : write_spi3
   
  function void assign_csr3(spi_pkg3::spi_csr_s3 csr_setting3);
     csr3 = csr_setting3;
  endfunction : assign_csr3
   
  function bit[31:0] calc_mask3();
    case (csr3.data_size3)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask3

endclass : ahb2spi_scbd3


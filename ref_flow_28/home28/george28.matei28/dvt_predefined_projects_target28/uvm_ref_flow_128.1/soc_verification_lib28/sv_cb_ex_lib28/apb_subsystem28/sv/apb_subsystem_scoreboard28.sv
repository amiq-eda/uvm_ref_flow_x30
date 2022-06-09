/*-------------------------------------------------------------------------
File28 name   : apb_subsystem_scoreboard28.sv
Title28       : AHB28 - SPI28 Scoreboard28
Project28     :
Created28     :
Description28 : Scoreboard28 for data integrity28 check between AHB28 UVC28 and SPI28 UVC28
Notes28       : Two28 similar28 scoreboards28 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb28)
`uvm_analysis_imp_decl(_spi28)

class spi2ahb_scbd28 extends uvm_scoreboard;
  bit [7:0] data_to_ahb28[$];
  bit [7:0] temp128;

  spi_pkg28::spi_csr_s28 csr28;
  apb_pkg28::apb_slave_config28 slave_cfg28;

  `uvm_component_utils(spi2ahb_scbd28)

  uvm_analysis_imp_ahb28 #(ahb_pkg28::ahb_transfer28, spi2ahb_scbd28) ahb_match28;
  uvm_analysis_imp_spi28 #(spi_pkg28::spi_transfer28, spi2ahb_scbd28) spi_add28;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add28  = new("spi_add28", this);
    ahb_match28 = new("ahb_match28", this);
  endfunction : new

  // implement SPI28 Tx28 analysis28 port from reference model
  virtual function void write_spi28(spi_pkg28::spi_transfer28 transfer28);
    data_to_ahb28.push_back(transfer28.transfer_data28[7:0]);	
  endfunction : write_spi28
     
  // implement APB28 READ analysis28 port from reference model
  virtual function void write_ahb28(input ahb_pkg28::ahb_transfer28 transfer28);

    if ((transfer28.address ==   (slave_cfg28.start_address28 + `SPI_RX0_REG28)) && (transfer28.direction28.name() == "READ"))
      begin
        temp128 = data_to_ahb28.pop_front();
       
        if (temp128 == transfer28.data[7:0]) 
          `uvm_info("SCRBD28", $psprintf("####### PASS28 : AHB28 RECEIVED28 CORRECT28 DATA28 from %s  expected = %h, received28 = %h", slave_cfg28.name, temp128, transfer28.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL28 : AHB28 RECEIVED28 WRONG28 DATA28 from %s", slave_cfg28.name))
          `uvm_info("SCRBD28", $psprintf("expected = %h, received28 = %h", temp128, transfer28.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb28
   
  function void assign_csr28(spi_pkg28::spi_csr_s28 csr_setting28);
    csr28 = csr_setting28;
  endfunction : assign_csr28

endclass : spi2ahb_scbd28

class ahb2spi_scbd28 extends uvm_scoreboard;
  bit [7:0] data_from_ahb28[$];

  bit [7:0] temp128;
  bit [7:0] mask;

  spi_pkg28::spi_csr_s28 csr28;
  apb_pkg28::apb_slave_config28 slave_cfg28;

  `uvm_component_utils(ahb2spi_scbd28)
  uvm_analysis_imp_ahb28 #(ahb_pkg28::ahb_transfer28, ahb2spi_scbd28) ahb_add28;
  uvm_analysis_imp_spi28 #(spi_pkg28::spi_transfer28, ahb2spi_scbd28) spi_match28;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match28 = new("spi_match28", this);
    ahb_add28    = new("ahb_add28", this);
  endfunction : new
   
  // implement AHB28 WRITE analysis28 port from reference model
  virtual function void write_ahb28(input ahb_pkg28::ahb_transfer28 transfer28);
    if ((transfer28.address ==  (slave_cfg28.start_address28 + `SPI_TX0_REG28)) && (transfer28.direction28.name() == "WRITE")) 
        data_from_ahb28.push_back(transfer28.data[7:0]);
  endfunction : write_ahb28
   
  // implement SPI28 Rx28 analysis28 port from reference model
  virtual function void write_spi28( spi_pkg28::spi_transfer28 transfer28);
    mask = calc_mask28();
    temp128 = data_from_ahb28.pop_front();

    if ((temp128 & mask) == transfer28.receive_data28[7:0])
      `uvm_info("SCRBD28", $psprintf("####### PASS28 : %s RECEIVED28 CORRECT28 DATA28 expected = %h, received28 = %h", slave_cfg28.name, (temp128 & mask), transfer28.receive_data28), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL28 : %s RECEIVED28 WRONG28 DATA28", slave_cfg28.name))
      `uvm_info("SCRBD28", $psprintf("expected = %h, received28 = %h", temp128, transfer28.receive_data28), UVM_MEDIUM)
    end
  endfunction : write_spi28
   
  function void assign_csr28(spi_pkg28::spi_csr_s28 csr_setting28);
     csr28 = csr_setting28;
  endfunction : assign_csr28
   
  function bit[31:0] calc_mask28();
    case (csr28.data_size28)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask28

endclass : ahb2spi_scbd28


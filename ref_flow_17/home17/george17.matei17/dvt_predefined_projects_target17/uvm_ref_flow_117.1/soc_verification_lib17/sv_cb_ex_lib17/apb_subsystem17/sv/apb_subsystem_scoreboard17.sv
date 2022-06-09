/*-------------------------------------------------------------------------
File17 name   : apb_subsystem_scoreboard17.sv
Title17       : AHB17 - SPI17 Scoreboard17
Project17     :
Created17     :
Description17 : Scoreboard17 for data integrity17 check between AHB17 UVC17 and SPI17 UVC17
Notes17       : Two17 similar17 scoreboards17 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb17)
`uvm_analysis_imp_decl(_spi17)

class spi2ahb_scbd17 extends uvm_scoreboard;
  bit [7:0] data_to_ahb17[$];
  bit [7:0] temp117;

  spi_pkg17::spi_csr_s17 csr17;
  apb_pkg17::apb_slave_config17 slave_cfg17;

  `uvm_component_utils(spi2ahb_scbd17)

  uvm_analysis_imp_ahb17 #(ahb_pkg17::ahb_transfer17, spi2ahb_scbd17) ahb_match17;
  uvm_analysis_imp_spi17 #(spi_pkg17::spi_transfer17, spi2ahb_scbd17) spi_add17;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add17  = new("spi_add17", this);
    ahb_match17 = new("ahb_match17", this);
  endfunction : new

  // implement SPI17 Tx17 analysis17 port from reference model
  virtual function void write_spi17(spi_pkg17::spi_transfer17 transfer17);
    data_to_ahb17.push_back(transfer17.transfer_data17[7:0]);	
  endfunction : write_spi17
     
  // implement APB17 READ analysis17 port from reference model
  virtual function void write_ahb17(input ahb_pkg17::ahb_transfer17 transfer17);

    if ((transfer17.address ==   (slave_cfg17.start_address17 + `SPI_RX0_REG17)) && (transfer17.direction17.name() == "READ"))
      begin
        temp117 = data_to_ahb17.pop_front();
       
        if (temp117 == transfer17.data[7:0]) 
          `uvm_info("SCRBD17", $psprintf("####### PASS17 : AHB17 RECEIVED17 CORRECT17 DATA17 from %s  expected = %h, received17 = %h", slave_cfg17.name, temp117, transfer17.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL17 : AHB17 RECEIVED17 WRONG17 DATA17 from %s", slave_cfg17.name))
          `uvm_info("SCRBD17", $psprintf("expected = %h, received17 = %h", temp117, transfer17.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb17
   
  function void assign_csr17(spi_pkg17::spi_csr_s17 csr_setting17);
    csr17 = csr_setting17;
  endfunction : assign_csr17

endclass : spi2ahb_scbd17

class ahb2spi_scbd17 extends uvm_scoreboard;
  bit [7:0] data_from_ahb17[$];

  bit [7:0] temp117;
  bit [7:0] mask;

  spi_pkg17::spi_csr_s17 csr17;
  apb_pkg17::apb_slave_config17 slave_cfg17;

  `uvm_component_utils(ahb2spi_scbd17)
  uvm_analysis_imp_ahb17 #(ahb_pkg17::ahb_transfer17, ahb2spi_scbd17) ahb_add17;
  uvm_analysis_imp_spi17 #(spi_pkg17::spi_transfer17, ahb2spi_scbd17) spi_match17;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match17 = new("spi_match17", this);
    ahb_add17    = new("ahb_add17", this);
  endfunction : new
   
  // implement AHB17 WRITE analysis17 port from reference model
  virtual function void write_ahb17(input ahb_pkg17::ahb_transfer17 transfer17);
    if ((transfer17.address ==  (slave_cfg17.start_address17 + `SPI_TX0_REG17)) && (transfer17.direction17.name() == "WRITE")) 
        data_from_ahb17.push_back(transfer17.data[7:0]);
  endfunction : write_ahb17
   
  // implement SPI17 Rx17 analysis17 port from reference model
  virtual function void write_spi17( spi_pkg17::spi_transfer17 transfer17);
    mask = calc_mask17();
    temp117 = data_from_ahb17.pop_front();

    if ((temp117 & mask) == transfer17.receive_data17[7:0])
      `uvm_info("SCRBD17", $psprintf("####### PASS17 : %s RECEIVED17 CORRECT17 DATA17 expected = %h, received17 = %h", slave_cfg17.name, (temp117 & mask), transfer17.receive_data17), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL17 : %s RECEIVED17 WRONG17 DATA17", slave_cfg17.name))
      `uvm_info("SCRBD17", $psprintf("expected = %h, received17 = %h", temp117, transfer17.receive_data17), UVM_MEDIUM)
    end
  endfunction : write_spi17
   
  function void assign_csr17(spi_pkg17::spi_csr_s17 csr_setting17);
     csr17 = csr_setting17;
  endfunction : assign_csr17
   
  function bit[31:0] calc_mask17();
    case (csr17.data_size17)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask17

endclass : ahb2spi_scbd17


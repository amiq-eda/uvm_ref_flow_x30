/*-------------------------------------------------------------------------
File4 name   : apb_subsystem_scoreboard4.sv
Title4       : AHB4 - SPI4 Scoreboard4
Project4     :
Created4     :
Description4 : Scoreboard4 for data integrity4 check between AHB4 UVC4 and SPI4 UVC4
Notes4       : Two4 similar4 scoreboards4 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb4)
`uvm_analysis_imp_decl(_spi4)

class spi2ahb_scbd4 extends uvm_scoreboard;
  bit [7:0] data_to_ahb4[$];
  bit [7:0] temp14;

  spi_pkg4::spi_csr_s4 csr4;
  apb_pkg4::apb_slave_config4 slave_cfg4;

  `uvm_component_utils(spi2ahb_scbd4)

  uvm_analysis_imp_ahb4 #(ahb_pkg4::ahb_transfer4, spi2ahb_scbd4) ahb_match4;
  uvm_analysis_imp_spi4 #(spi_pkg4::spi_transfer4, spi2ahb_scbd4) spi_add4;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add4  = new("spi_add4", this);
    ahb_match4 = new("ahb_match4", this);
  endfunction : new

  // implement SPI4 Tx4 analysis4 port from reference model
  virtual function void write_spi4(spi_pkg4::spi_transfer4 transfer4);
    data_to_ahb4.push_back(transfer4.transfer_data4[7:0]);	
  endfunction : write_spi4
     
  // implement APB4 READ analysis4 port from reference model
  virtual function void write_ahb4(input ahb_pkg4::ahb_transfer4 transfer4);

    if ((transfer4.address ==   (slave_cfg4.start_address4 + `SPI_RX0_REG4)) && (transfer4.direction4.name() == "READ"))
      begin
        temp14 = data_to_ahb4.pop_front();
       
        if (temp14 == transfer4.data[7:0]) 
          `uvm_info("SCRBD4", $psprintf("####### PASS4 : AHB4 RECEIVED4 CORRECT4 DATA4 from %s  expected = %h, received4 = %h", slave_cfg4.name, temp14, transfer4.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL4 : AHB4 RECEIVED4 WRONG4 DATA4 from %s", slave_cfg4.name))
          `uvm_info("SCRBD4", $psprintf("expected = %h, received4 = %h", temp14, transfer4.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb4
   
  function void assign_csr4(spi_pkg4::spi_csr_s4 csr_setting4);
    csr4 = csr_setting4;
  endfunction : assign_csr4

endclass : spi2ahb_scbd4

class ahb2spi_scbd4 extends uvm_scoreboard;
  bit [7:0] data_from_ahb4[$];

  bit [7:0] temp14;
  bit [7:0] mask;

  spi_pkg4::spi_csr_s4 csr4;
  apb_pkg4::apb_slave_config4 slave_cfg4;

  `uvm_component_utils(ahb2spi_scbd4)
  uvm_analysis_imp_ahb4 #(ahb_pkg4::ahb_transfer4, ahb2spi_scbd4) ahb_add4;
  uvm_analysis_imp_spi4 #(spi_pkg4::spi_transfer4, ahb2spi_scbd4) spi_match4;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match4 = new("spi_match4", this);
    ahb_add4    = new("ahb_add4", this);
  endfunction : new
   
  // implement AHB4 WRITE analysis4 port from reference model
  virtual function void write_ahb4(input ahb_pkg4::ahb_transfer4 transfer4);
    if ((transfer4.address ==  (slave_cfg4.start_address4 + `SPI_TX0_REG4)) && (transfer4.direction4.name() == "WRITE")) 
        data_from_ahb4.push_back(transfer4.data[7:0]);
  endfunction : write_ahb4
   
  // implement SPI4 Rx4 analysis4 port from reference model
  virtual function void write_spi4( spi_pkg4::spi_transfer4 transfer4);
    mask = calc_mask4();
    temp14 = data_from_ahb4.pop_front();

    if ((temp14 & mask) == transfer4.receive_data4[7:0])
      `uvm_info("SCRBD4", $psprintf("####### PASS4 : %s RECEIVED4 CORRECT4 DATA4 expected = %h, received4 = %h", slave_cfg4.name, (temp14 & mask), transfer4.receive_data4), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL4 : %s RECEIVED4 WRONG4 DATA4", slave_cfg4.name))
      `uvm_info("SCRBD4", $psprintf("expected = %h, received4 = %h", temp14, transfer4.receive_data4), UVM_MEDIUM)
    end
  endfunction : write_spi4
   
  function void assign_csr4(spi_pkg4::spi_csr_s4 csr_setting4);
     csr4 = csr_setting4;
  endfunction : assign_csr4
   
  function bit[31:0] calc_mask4();
    case (csr4.data_size4)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask4

endclass : ahb2spi_scbd4


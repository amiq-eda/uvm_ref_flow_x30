/*-------------------------------------------------------------------------
File23 name   : apb_subsystem_scoreboard23.sv
Title23       : AHB23 - SPI23 Scoreboard23
Project23     :
Created23     :
Description23 : Scoreboard23 for data integrity23 check between AHB23 UVC23 and SPI23 UVC23
Notes23       : Two23 similar23 scoreboards23 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb23)
`uvm_analysis_imp_decl(_spi23)

class spi2ahb_scbd23 extends uvm_scoreboard;
  bit [7:0] data_to_ahb23[$];
  bit [7:0] temp123;

  spi_pkg23::spi_csr_s23 csr23;
  apb_pkg23::apb_slave_config23 slave_cfg23;

  `uvm_component_utils(spi2ahb_scbd23)

  uvm_analysis_imp_ahb23 #(ahb_pkg23::ahb_transfer23, spi2ahb_scbd23) ahb_match23;
  uvm_analysis_imp_spi23 #(spi_pkg23::spi_transfer23, spi2ahb_scbd23) spi_add23;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add23  = new("spi_add23", this);
    ahb_match23 = new("ahb_match23", this);
  endfunction : new

  // implement SPI23 Tx23 analysis23 port from reference model
  virtual function void write_spi23(spi_pkg23::spi_transfer23 transfer23);
    data_to_ahb23.push_back(transfer23.transfer_data23[7:0]);	
  endfunction : write_spi23
     
  // implement APB23 READ analysis23 port from reference model
  virtual function void write_ahb23(input ahb_pkg23::ahb_transfer23 transfer23);

    if ((transfer23.address ==   (slave_cfg23.start_address23 + `SPI_RX0_REG23)) && (transfer23.direction23.name() == "READ"))
      begin
        temp123 = data_to_ahb23.pop_front();
       
        if (temp123 == transfer23.data[7:0]) 
          `uvm_info("SCRBD23", $psprintf("####### PASS23 : AHB23 RECEIVED23 CORRECT23 DATA23 from %s  expected = %h, received23 = %h", slave_cfg23.name, temp123, transfer23.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL23 : AHB23 RECEIVED23 WRONG23 DATA23 from %s", slave_cfg23.name))
          `uvm_info("SCRBD23", $psprintf("expected = %h, received23 = %h", temp123, transfer23.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb23
   
  function void assign_csr23(spi_pkg23::spi_csr_s23 csr_setting23);
    csr23 = csr_setting23;
  endfunction : assign_csr23

endclass : spi2ahb_scbd23

class ahb2spi_scbd23 extends uvm_scoreboard;
  bit [7:0] data_from_ahb23[$];

  bit [7:0] temp123;
  bit [7:0] mask;

  spi_pkg23::spi_csr_s23 csr23;
  apb_pkg23::apb_slave_config23 slave_cfg23;

  `uvm_component_utils(ahb2spi_scbd23)
  uvm_analysis_imp_ahb23 #(ahb_pkg23::ahb_transfer23, ahb2spi_scbd23) ahb_add23;
  uvm_analysis_imp_spi23 #(spi_pkg23::spi_transfer23, ahb2spi_scbd23) spi_match23;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match23 = new("spi_match23", this);
    ahb_add23    = new("ahb_add23", this);
  endfunction : new
   
  // implement AHB23 WRITE analysis23 port from reference model
  virtual function void write_ahb23(input ahb_pkg23::ahb_transfer23 transfer23);
    if ((transfer23.address ==  (slave_cfg23.start_address23 + `SPI_TX0_REG23)) && (transfer23.direction23.name() == "WRITE")) 
        data_from_ahb23.push_back(transfer23.data[7:0]);
  endfunction : write_ahb23
   
  // implement SPI23 Rx23 analysis23 port from reference model
  virtual function void write_spi23( spi_pkg23::spi_transfer23 transfer23);
    mask = calc_mask23();
    temp123 = data_from_ahb23.pop_front();

    if ((temp123 & mask) == transfer23.receive_data23[7:0])
      `uvm_info("SCRBD23", $psprintf("####### PASS23 : %s RECEIVED23 CORRECT23 DATA23 expected = %h, received23 = %h", slave_cfg23.name, (temp123 & mask), transfer23.receive_data23), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL23 : %s RECEIVED23 WRONG23 DATA23", slave_cfg23.name))
      `uvm_info("SCRBD23", $psprintf("expected = %h, received23 = %h", temp123, transfer23.receive_data23), UVM_MEDIUM)
    end
  endfunction : write_spi23
   
  function void assign_csr23(spi_pkg23::spi_csr_s23 csr_setting23);
     csr23 = csr_setting23;
  endfunction : assign_csr23
   
  function bit[31:0] calc_mask23();
    case (csr23.data_size23)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask23

endclass : ahb2spi_scbd23


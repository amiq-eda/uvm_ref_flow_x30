/*-------------------------------------------------------------------------
File27 name   : apb_subsystem_scoreboard27.sv
Title27       : AHB27 - SPI27 Scoreboard27
Project27     :
Created27     :
Description27 : Scoreboard27 for data integrity27 check between AHB27 UVC27 and SPI27 UVC27
Notes27       : Two27 similar27 scoreboards27 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb27)
`uvm_analysis_imp_decl(_spi27)

class spi2ahb_scbd27 extends uvm_scoreboard;
  bit [7:0] data_to_ahb27[$];
  bit [7:0] temp127;

  spi_pkg27::spi_csr_s27 csr27;
  apb_pkg27::apb_slave_config27 slave_cfg27;

  `uvm_component_utils(spi2ahb_scbd27)

  uvm_analysis_imp_ahb27 #(ahb_pkg27::ahb_transfer27, spi2ahb_scbd27) ahb_match27;
  uvm_analysis_imp_spi27 #(spi_pkg27::spi_transfer27, spi2ahb_scbd27) spi_add27;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add27  = new("spi_add27", this);
    ahb_match27 = new("ahb_match27", this);
  endfunction : new

  // implement SPI27 Tx27 analysis27 port from reference model
  virtual function void write_spi27(spi_pkg27::spi_transfer27 transfer27);
    data_to_ahb27.push_back(transfer27.transfer_data27[7:0]);	
  endfunction : write_spi27
     
  // implement APB27 READ analysis27 port from reference model
  virtual function void write_ahb27(input ahb_pkg27::ahb_transfer27 transfer27);

    if ((transfer27.address ==   (slave_cfg27.start_address27 + `SPI_RX0_REG27)) && (transfer27.direction27.name() == "READ"))
      begin
        temp127 = data_to_ahb27.pop_front();
       
        if (temp127 == transfer27.data[7:0]) 
          `uvm_info("SCRBD27", $psprintf("####### PASS27 : AHB27 RECEIVED27 CORRECT27 DATA27 from %s  expected = %h, received27 = %h", slave_cfg27.name, temp127, transfer27.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL27 : AHB27 RECEIVED27 WRONG27 DATA27 from %s", slave_cfg27.name))
          `uvm_info("SCRBD27", $psprintf("expected = %h, received27 = %h", temp127, transfer27.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb27
   
  function void assign_csr27(spi_pkg27::spi_csr_s27 csr_setting27);
    csr27 = csr_setting27;
  endfunction : assign_csr27

endclass : spi2ahb_scbd27

class ahb2spi_scbd27 extends uvm_scoreboard;
  bit [7:0] data_from_ahb27[$];

  bit [7:0] temp127;
  bit [7:0] mask;

  spi_pkg27::spi_csr_s27 csr27;
  apb_pkg27::apb_slave_config27 slave_cfg27;

  `uvm_component_utils(ahb2spi_scbd27)
  uvm_analysis_imp_ahb27 #(ahb_pkg27::ahb_transfer27, ahb2spi_scbd27) ahb_add27;
  uvm_analysis_imp_spi27 #(spi_pkg27::spi_transfer27, ahb2spi_scbd27) spi_match27;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match27 = new("spi_match27", this);
    ahb_add27    = new("ahb_add27", this);
  endfunction : new
   
  // implement AHB27 WRITE analysis27 port from reference model
  virtual function void write_ahb27(input ahb_pkg27::ahb_transfer27 transfer27);
    if ((transfer27.address ==  (slave_cfg27.start_address27 + `SPI_TX0_REG27)) && (transfer27.direction27.name() == "WRITE")) 
        data_from_ahb27.push_back(transfer27.data[7:0]);
  endfunction : write_ahb27
   
  // implement SPI27 Rx27 analysis27 port from reference model
  virtual function void write_spi27( spi_pkg27::spi_transfer27 transfer27);
    mask = calc_mask27();
    temp127 = data_from_ahb27.pop_front();

    if ((temp127 & mask) == transfer27.receive_data27[7:0])
      `uvm_info("SCRBD27", $psprintf("####### PASS27 : %s RECEIVED27 CORRECT27 DATA27 expected = %h, received27 = %h", slave_cfg27.name, (temp127 & mask), transfer27.receive_data27), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL27 : %s RECEIVED27 WRONG27 DATA27", slave_cfg27.name))
      `uvm_info("SCRBD27", $psprintf("expected = %h, received27 = %h", temp127, transfer27.receive_data27), UVM_MEDIUM)
    end
  endfunction : write_spi27
   
  function void assign_csr27(spi_pkg27::spi_csr_s27 csr_setting27);
     csr27 = csr_setting27;
  endfunction : assign_csr27
   
  function bit[31:0] calc_mask27();
    case (csr27.data_size27)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask27

endclass : ahb2spi_scbd27


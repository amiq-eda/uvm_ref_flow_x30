/*-------------------------------------------------------------------------
File9 name   : apb_subsystem_scoreboard9.sv
Title9       : AHB9 - SPI9 Scoreboard9
Project9     :
Created9     :
Description9 : Scoreboard9 for data integrity9 check between AHB9 UVC9 and SPI9 UVC9
Notes9       : Two9 similar9 scoreboards9 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb9)
`uvm_analysis_imp_decl(_spi9)

class spi2ahb_scbd9 extends uvm_scoreboard;
  bit [7:0] data_to_ahb9[$];
  bit [7:0] temp19;

  spi_pkg9::spi_csr_s9 csr9;
  apb_pkg9::apb_slave_config9 slave_cfg9;

  `uvm_component_utils(spi2ahb_scbd9)

  uvm_analysis_imp_ahb9 #(ahb_pkg9::ahb_transfer9, spi2ahb_scbd9) ahb_match9;
  uvm_analysis_imp_spi9 #(spi_pkg9::spi_transfer9, spi2ahb_scbd9) spi_add9;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add9  = new("spi_add9", this);
    ahb_match9 = new("ahb_match9", this);
  endfunction : new

  // implement SPI9 Tx9 analysis9 port from reference model
  virtual function void write_spi9(spi_pkg9::spi_transfer9 transfer9);
    data_to_ahb9.push_back(transfer9.transfer_data9[7:0]);	
  endfunction : write_spi9
     
  // implement APB9 READ analysis9 port from reference model
  virtual function void write_ahb9(input ahb_pkg9::ahb_transfer9 transfer9);

    if ((transfer9.address ==   (slave_cfg9.start_address9 + `SPI_RX0_REG9)) && (transfer9.direction9.name() == "READ"))
      begin
        temp19 = data_to_ahb9.pop_front();
       
        if (temp19 == transfer9.data[7:0]) 
          `uvm_info("SCRBD9", $psprintf("####### PASS9 : AHB9 RECEIVED9 CORRECT9 DATA9 from %s  expected = %h, received9 = %h", slave_cfg9.name, temp19, transfer9.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL9 : AHB9 RECEIVED9 WRONG9 DATA9 from %s", slave_cfg9.name))
          `uvm_info("SCRBD9", $psprintf("expected = %h, received9 = %h", temp19, transfer9.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb9
   
  function void assign_csr9(spi_pkg9::spi_csr_s9 csr_setting9);
    csr9 = csr_setting9;
  endfunction : assign_csr9

endclass : spi2ahb_scbd9

class ahb2spi_scbd9 extends uvm_scoreboard;
  bit [7:0] data_from_ahb9[$];

  bit [7:0] temp19;
  bit [7:0] mask;

  spi_pkg9::spi_csr_s9 csr9;
  apb_pkg9::apb_slave_config9 slave_cfg9;

  `uvm_component_utils(ahb2spi_scbd9)
  uvm_analysis_imp_ahb9 #(ahb_pkg9::ahb_transfer9, ahb2spi_scbd9) ahb_add9;
  uvm_analysis_imp_spi9 #(spi_pkg9::spi_transfer9, ahb2spi_scbd9) spi_match9;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match9 = new("spi_match9", this);
    ahb_add9    = new("ahb_add9", this);
  endfunction : new
   
  // implement AHB9 WRITE analysis9 port from reference model
  virtual function void write_ahb9(input ahb_pkg9::ahb_transfer9 transfer9);
    if ((transfer9.address ==  (slave_cfg9.start_address9 + `SPI_TX0_REG9)) && (transfer9.direction9.name() == "WRITE")) 
        data_from_ahb9.push_back(transfer9.data[7:0]);
  endfunction : write_ahb9
   
  // implement SPI9 Rx9 analysis9 port from reference model
  virtual function void write_spi9( spi_pkg9::spi_transfer9 transfer9);
    mask = calc_mask9();
    temp19 = data_from_ahb9.pop_front();

    if ((temp19 & mask) == transfer9.receive_data9[7:0])
      `uvm_info("SCRBD9", $psprintf("####### PASS9 : %s RECEIVED9 CORRECT9 DATA9 expected = %h, received9 = %h", slave_cfg9.name, (temp19 & mask), transfer9.receive_data9), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL9 : %s RECEIVED9 WRONG9 DATA9", slave_cfg9.name))
      `uvm_info("SCRBD9", $psprintf("expected = %h, received9 = %h", temp19, transfer9.receive_data9), UVM_MEDIUM)
    end
  endfunction : write_spi9
   
  function void assign_csr9(spi_pkg9::spi_csr_s9 csr_setting9);
     csr9 = csr_setting9;
  endfunction : assign_csr9
   
  function bit[31:0] calc_mask9();
    case (csr9.data_size9)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask9

endclass : ahb2spi_scbd9


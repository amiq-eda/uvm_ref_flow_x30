/*-------------------------------------------------------------------------
File18 name   : apb_subsystem_scoreboard18.sv
Title18       : AHB18 - SPI18 Scoreboard18
Project18     :
Created18     :
Description18 : Scoreboard18 for data integrity18 check between AHB18 UVC18 and SPI18 UVC18
Notes18       : Two18 similar18 scoreboards18 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb18)
`uvm_analysis_imp_decl(_spi18)

class spi2ahb_scbd18 extends uvm_scoreboard;
  bit [7:0] data_to_ahb18[$];
  bit [7:0] temp118;

  spi_pkg18::spi_csr_s18 csr18;
  apb_pkg18::apb_slave_config18 slave_cfg18;

  `uvm_component_utils(spi2ahb_scbd18)

  uvm_analysis_imp_ahb18 #(ahb_pkg18::ahb_transfer18, spi2ahb_scbd18) ahb_match18;
  uvm_analysis_imp_spi18 #(spi_pkg18::spi_transfer18, spi2ahb_scbd18) spi_add18;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add18  = new("spi_add18", this);
    ahb_match18 = new("ahb_match18", this);
  endfunction : new

  // implement SPI18 Tx18 analysis18 port from reference model
  virtual function void write_spi18(spi_pkg18::spi_transfer18 transfer18);
    data_to_ahb18.push_back(transfer18.transfer_data18[7:0]);	
  endfunction : write_spi18
     
  // implement APB18 READ analysis18 port from reference model
  virtual function void write_ahb18(input ahb_pkg18::ahb_transfer18 transfer18);

    if ((transfer18.address ==   (slave_cfg18.start_address18 + `SPI_RX0_REG18)) && (transfer18.direction18.name() == "READ"))
      begin
        temp118 = data_to_ahb18.pop_front();
       
        if (temp118 == transfer18.data[7:0]) 
          `uvm_info("SCRBD18", $psprintf("####### PASS18 : AHB18 RECEIVED18 CORRECT18 DATA18 from %s  expected = %h, received18 = %h", slave_cfg18.name, temp118, transfer18.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL18 : AHB18 RECEIVED18 WRONG18 DATA18 from %s", slave_cfg18.name))
          `uvm_info("SCRBD18", $psprintf("expected = %h, received18 = %h", temp118, transfer18.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb18
   
  function void assign_csr18(spi_pkg18::spi_csr_s18 csr_setting18);
    csr18 = csr_setting18;
  endfunction : assign_csr18

endclass : spi2ahb_scbd18

class ahb2spi_scbd18 extends uvm_scoreboard;
  bit [7:0] data_from_ahb18[$];

  bit [7:0] temp118;
  bit [7:0] mask;

  spi_pkg18::spi_csr_s18 csr18;
  apb_pkg18::apb_slave_config18 slave_cfg18;

  `uvm_component_utils(ahb2spi_scbd18)
  uvm_analysis_imp_ahb18 #(ahb_pkg18::ahb_transfer18, ahb2spi_scbd18) ahb_add18;
  uvm_analysis_imp_spi18 #(spi_pkg18::spi_transfer18, ahb2spi_scbd18) spi_match18;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match18 = new("spi_match18", this);
    ahb_add18    = new("ahb_add18", this);
  endfunction : new
   
  // implement AHB18 WRITE analysis18 port from reference model
  virtual function void write_ahb18(input ahb_pkg18::ahb_transfer18 transfer18);
    if ((transfer18.address ==  (slave_cfg18.start_address18 + `SPI_TX0_REG18)) && (transfer18.direction18.name() == "WRITE")) 
        data_from_ahb18.push_back(transfer18.data[7:0]);
  endfunction : write_ahb18
   
  // implement SPI18 Rx18 analysis18 port from reference model
  virtual function void write_spi18( spi_pkg18::spi_transfer18 transfer18);
    mask = calc_mask18();
    temp118 = data_from_ahb18.pop_front();

    if ((temp118 & mask) == transfer18.receive_data18[7:0])
      `uvm_info("SCRBD18", $psprintf("####### PASS18 : %s RECEIVED18 CORRECT18 DATA18 expected = %h, received18 = %h", slave_cfg18.name, (temp118 & mask), transfer18.receive_data18), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL18 : %s RECEIVED18 WRONG18 DATA18", slave_cfg18.name))
      `uvm_info("SCRBD18", $psprintf("expected = %h, received18 = %h", temp118, transfer18.receive_data18), UVM_MEDIUM)
    end
  endfunction : write_spi18
   
  function void assign_csr18(spi_pkg18::spi_csr_s18 csr_setting18);
     csr18 = csr_setting18;
  endfunction : assign_csr18
   
  function bit[31:0] calc_mask18();
    case (csr18.data_size18)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask18

endclass : ahb2spi_scbd18


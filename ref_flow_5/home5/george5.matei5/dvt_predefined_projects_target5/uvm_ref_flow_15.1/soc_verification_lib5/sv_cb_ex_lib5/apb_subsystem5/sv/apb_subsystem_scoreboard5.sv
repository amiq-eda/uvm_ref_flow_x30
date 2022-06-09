/*-------------------------------------------------------------------------
File5 name   : apb_subsystem_scoreboard5.sv
Title5       : AHB5 - SPI5 Scoreboard5
Project5     :
Created5     :
Description5 : Scoreboard5 for data integrity5 check between AHB5 UVC5 and SPI5 UVC5
Notes5       : Two5 similar5 scoreboards5 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb5)
`uvm_analysis_imp_decl(_spi5)

class spi2ahb_scbd5 extends uvm_scoreboard;
  bit [7:0] data_to_ahb5[$];
  bit [7:0] temp15;

  spi_pkg5::spi_csr_s5 csr5;
  apb_pkg5::apb_slave_config5 slave_cfg5;

  `uvm_component_utils(spi2ahb_scbd5)

  uvm_analysis_imp_ahb5 #(ahb_pkg5::ahb_transfer5, spi2ahb_scbd5) ahb_match5;
  uvm_analysis_imp_spi5 #(spi_pkg5::spi_transfer5, spi2ahb_scbd5) spi_add5;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add5  = new("spi_add5", this);
    ahb_match5 = new("ahb_match5", this);
  endfunction : new

  // implement SPI5 Tx5 analysis5 port from reference model
  virtual function void write_spi5(spi_pkg5::spi_transfer5 transfer5);
    data_to_ahb5.push_back(transfer5.transfer_data5[7:0]);	
  endfunction : write_spi5
     
  // implement APB5 READ analysis5 port from reference model
  virtual function void write_ahb5(input ahb_pkg5::ahb_transfer5 transfer5);

    if ((transfer5.address ==   (slave_cfg5.start_address5 + `SPI_RX0_REG5)) && (transfer5.direction5.name() == "READ"))
      begin
        temp15 = data_to_ahb5.pop_front();
       
        if (temp15 == transfer5.data[7:0]) 
          `uvm_info("SCRBD5", $psprintf("####### PASS5 : AHB5 RECEIVED5 CORRECT5 DATA5 from %s  expected = %h, received5 = %h", slave_cfg5.name, temp15, transfer5.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL5 : AHB5 RECEIVED5 WRONG5 DATA5 from %s", slave_cfg5.name))
          `uvm_info("SCRBD5", $psprintf("expected = %h, received5 = %h", temp15, transfer5.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb5
   
  function void assign_csr5(spi_pkg5::spi_csr_s5 csr_setting5);
    csr5 = csr_setting5;
  endfunction : assign_csr5

endclass : spi2ahb_scbd5

class ahb2spi_scbd5 extends uvm_scoreboard;
  bit [7:0] data_from_ahb5[$];

  bit [7:0] temp15;
  bit [7:0] mask;

  spi_pkg5::spi_csr_s5 csr5;
  apb_pkg5::apb_slave_config5 slave_cfg5;

  `uvm_component_utils(ahb2spi_scbd5)
  uvm_analysis_imp_ahb5 #(ahb_pkg5::ahb_transfer5, ahb2spi_scbd5) ahb_add5;
  uvm_analysis_imp_spi5 #(spi_pkg5::spi_transfer5, ahb2spi_scbd5) spi_match5;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match5 = new("spi_match5", this);
    ahb_add5    = new("ahb_add5", this);
  endfunction : new
   
  // implement AHB5 WRITE analysis5 port from reference model
  virtual function void write_ahb5(input ahb_pkg5::ahb_transfer5 transfer5);
    if ((transfer5.address ==  (slave_cfg5.start_address5 + `SPI_TX0_REG5)) && (transfer5.direction5.name() == "WRITE")) 
        data_from_ahb5.push_back(transfer5.data[7:0]);
  endfunction : write_ahb5
   
  // implement SPI5 Rx5 analysis5 port from reference model
  virtual function void write_spi5( spi_pkg5::spi_transfer5 transfer5);
    mask = calc_mask5();
    temp15 = data_from_ahb5.pop_front();

    if ((temp15 & mask) == transfer5.receive_data5[7:0])
      `uvm_info("SCRBD5", $psprintf("####### PASS5 : %s RECEIVED5 CORRECT5 DATA5 expected = %h, received5 = %h", slave_cfg5.name, (temp15 & mask), transfer5.receive_data5), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL5 : %s RECEIVED5 WRONG5 DATA5", slave_cfg5.name))
      `uvm_info("SCRBD5", $psprintf("expected = %h, received5 = %h", temp15, transfer5.receive_data5), UVM_MEDIUM)
    end
  endfunction : write_spi5
   
  function void assign_csr5(spi_pkg5::spi_csr_s5 csr_setting5);
     csr5 = csr_setting5;
  endfunction : assign_csr5
   
  function bit[31:0] calc_mask5();
    case (csr5.data_size5)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask5

endclass : ahb2spi_scbd5


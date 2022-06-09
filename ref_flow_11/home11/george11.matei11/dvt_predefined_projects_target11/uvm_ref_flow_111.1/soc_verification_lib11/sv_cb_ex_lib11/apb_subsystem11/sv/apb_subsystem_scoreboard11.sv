/*-------------------------------------------------------------------------
File11 name   : apb_subsystem_scoreboard11.sv
Title11       : AHB11 - SPI11 Scoreboard11
Project11     :
Created11     :
Description11 : Scoreboard11 for data integrity11 check between AHB11 UVC11 and SPI11 UVC11
Notes11       : Two11 similar11 scoreboards11 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb11)
`uvm_analysis_imp_decl(_spi11)

class spi2ahb_scbd11 extends uvm_scoreboard;
  bit [7:0] data_to_ahb11[$];
  bit [7:0] temp111;

  spi_pkg11::spi_csr_s11 csr11;
  apb_pkg11::apb_slave_config11 slave_cfg11;

  `uvm_component_utils(spi2ahb_scbd11)

  uvm_analysis_imp_ahb11 #(ahb_pkg11::ahb_transfer11, spi2ahb_scbd11) ahb_match11;
  uvm_analysis_imp_spi11 #(spi_pkg11::spi_transfer11, spi2ahb_scbd11) spi_add11;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add11  = new("spi_add11", this);
    ahb_match11 = new("ahb_match11", this);
  endfunction : new

  // implement SPI11 Tx11 analysis11 port from reference model
  virtual function void write_spi11(spi_pkg11::spi_transfer11 transfer11);
    data_to_ahb11.push_back(transfer11.transfer_data11[7:0]);	
  endfunction : write_spi11
     
  // implement APB11 READ analysis11 port from reference model
  virtual function void write_ahb11(input ahb_pkg11::ahb_transfer11 transfer11);

    if ((transfer11.address ==   (slave_cfg11.start_address11 + `SPI_RX0_REG11)) && (transfer11.direction11.name() == "READ"))
      begin
        temp111 = data_to_ahb11.pop_front();
       
        if (temp111 == transfer11.data[7:0]) 
          `uvm_info("SCRBD11", $psprintf("####### PASS11 : AHB11 RECEIVED11 CORRECT11 DATA11 from %s  expected = %h, received11 = %h", slave_cfg11.name, temp111, transfer11.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL11 : AHB11 RECEIVED11 WRONG11 DATA11 from %s", slave_cfg11.name))
          `uvm_info("SCRBD11", $psprintf("expected = %h, received11 = %h", temp111, transfer11.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb11
   
  function void assign_csr11(spi_pkg11::spi_csr_s11 csr_setting11);
    csr11 = csr_setting11;
  endfunction : assign_csr11

endclass : spi2ahb_scbd11

class ahb2spi_scbd11 extends uvm_scoreboard;
  bit [7:0] data_from_ahb11[$];

  bit [7:0] temp111;
  bit [7:0] mask;

  spi_pkg11::spi_csr_s11 csr11;
  apb_pkg11::apb_slave_config11 slave_cfg11;

  `uvm_component_utils(ahb2spi_scbd11)
  uvm_analysis_imp_ahb11 #(ahb_pkg11::ahb_transfer11, ahb2spi_scbd11) ahb_add11;
  uvm_analysis_imp_spi11 #(spi_pkg11::spi_transfer11, ahb2spi_scbd11) spi_match11;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match11 = new("spi_match11", this);
    ahb_add11    = new("ahb_add11", this);
  endfunction : new
   
  // implement AHB11 WRITE analysis11 port from reference model
  virtual function void write_ahb11(input ahb_pkg11::ahb_transfer11 transfer11);
    if ((transfer11.address ==  (slave_cfg11.start_address11 + `SPI_TX0_REG11)) && (transfer11.direction11.name() == "WRITE")) 
        data_from_ahb11.push_back(transfer11.data[7:0]);
  endfunction : write_ahb11
   
  // implement SPI11 Rx11 analysis11 port from reference model
  virtual function void write_spi11( spi_pkg11::spi_transfer11 transfer11);
    mask = calc_mask11();
    temp111 = data_from_ahb11.pop_front();

    if ((temp111 & mask) == transfer11.receive_data11[7:0])
      `uvm_info("SCRBD11", $psprintf("####### PASS11 : %s RECEIVED11 CORRECT11 DATA11 expected = %h, received11 = %h", slave_cfg11.name, (temp111 & mask), transfer11.receive_data11), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL11 : %s RECEIVED11 WRONG11 DATA11", slave_cfg11.name))
      `uvm_info("SCRBD11", $psprintf("expected = %h, received11 = %h", temp111, transfer11.receive_data11), UVM_MEDIUM)
    end
  endfunction : write_spi11
   
  function void assign_csr11(spi_pkg11::spi_csr_s11 csr_setting11);
     csr11 = csr_setting11;
  endfunction : assign_csr11
   
  function bit[31:0] calc_mask11();
    case (csr11.data_size11)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask11

endclass : ahb2spi_scbd11


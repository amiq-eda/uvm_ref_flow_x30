/*-------------------------------------------------------------------------
File6 name   : apb_subsystem_scoreboard6.sv
Title6       : AHB6 - SPI6 Scoreboard6
Project6     :
Created6     :
Description6 : Scoreboard6 for data integrity6 check between AHB6 UVC6 and SPI6 UVC6
Notes6       : Two6 similar6 scoreboards6 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb6)
`uvm_analysis_imp_decl(_spi6)

class spi2ahb_scbd6 extends uvm_scoreboard;
  bit [7:0] data_to_ahb6[$];
  bit [7:0] temp16;

  spi_pkg6::spi_csr_s6 csr6;
  apb_pkg6::apb_slave_config6 slave_cfg6;

  `uvm_component_utils(spi2ahb_scbd6)

  uvm_analysis_imp_ahb6 #(ahb_pkg6::ahb_transfer6, spi2ahb_scbd6) ahb_match6;
  uvm_analysis_imp_spi6 #(spi_pkg6::spi_transfer6, spi2ahb_scbd6) spi_add6;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add6  = new("spi_add6", this);
    ahb_match6 = new("ahb_match6", this);
  endfunction : new

  // implement SPI6 Tx6 analysis6 port from reference model
  virtual function void write_spi6(spi_pkg6::spi_transfer6 transfer6);
    data_to_ahb6.push_back(transfer6.transfer_data6[7:0]);	
  endfunction : write_spi6
     
  // implement APB6 READ analysis6 port from reference model
  virtual function void write_ahb6(input ahb_pkg6::ahb_transfer6 transfer6);

    if ((transfer6.address ==   (slave_cfg6.start_address6 + `SPI_RX0_REG6)) && (transfer6.direction6.name() == "READ"))
      begin
        temp16 = data_to_ahb6.pop_front();
       
        if (temp16 == transfer6.data[7:0]) 
          `uvm_info("SCRBD6", $psprintf("####### PASS6 : AHB6 RECEIVED6 CORRECT6 DATA6 from %s  expected = %h, received6 = %h", slave_cfg6.name, temp16, transfer6.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL6 : AHB6 RECEIVED6 WRONG6 DATA6 from %s", slave_cfg6.name))
          `uvm_info("SCRBD6", $psprintf("expected = %h, received6 = %h", temp16, transfer6.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb6
   
  function void assign_csr6(spi_pkg6::spi_csr_s6 csr_setting6);
    csr6 = csr_setting6;
  endfunction : assign_csr6

endclass : spi2ahb_scbd6

class ahb2spi_scbd6 extends uvm_scoreboard;
  bit [7:0] data_from_ahb6[$];

  bit [7:0] temp16;
  bit [7:0] mask;

  spi_pkg6::spi_csr_s6 csr6;
  apb_pkg6::apb_slave_config6 slave_cfg6;

  `uvm_component_utils(ahb2spi_scbd6)
  uvm_analysis_imp_ahb6 #(ahb_pkg6::ahb_transfer6, ahb2spi_scbd6) ahb_add6;
  uvm_analysis_imp_spi6 #(spi_pkg6::spi_transfer6, ahb2spi_scbd6) spi_match6;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match6 = new("spi_match6", this);
    ahb_add6    = new("ahb_add6", this);
  endfunction : new
   
  // implement AHB6 WRITE analysis6 port from reference model
  virtual function void write_ahb6(input ahb_pkg6::ahb_transfer6 transfer6);
    if ((transfer6.address ==  (slave_cfg6.start_address6 + `SPI_TX0_REG6)) && (transfer6.direction6.name() == "WRITE")) 
        data_from_ahb6.push_back(transfer6.data[7:0]);
  endfunction : write_ahb6
   
  // implement SPI6 Rx6 analysis6 port from reference model
  virtual function void write_spi6( spi_pkg6::spi_transfer6 transfer6);
    mask = calc_mask6();
    temp16 = data_from_ahb6.pop_front();

    if ((temp16 & mask) == transfer6.receive_data6[7:0])
      `uvm_info("SCRBD6", $psprintf("####### PASS6 : %s RECEIVED6 CORRECT6 DATA6 expected = %h, received6 = %h", slave_cfg6.name, (temp16 & mask), transfer6.receive_data6), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL6 : %s RECEIVED6 WRONG6 DATA6", slave_cfg6.name))
      `uvm_info("SCRBD6", $psprintf("expected = %h, received6 = %h", temp16, transfer6.receive_data6), UVM_MEDIUM)
    end
  endfunction : write_spi6
   
  function void assign_csr6(spi_pkg6::spi_csr_s6 csr_setting6);
     csr6 = csr_setting6;
  endfunction : assign_csr6
   
  function bit[31:0] calc_mask6();
    case (csr6.data_size6)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask6

endclass : ahb2spi_scbd6


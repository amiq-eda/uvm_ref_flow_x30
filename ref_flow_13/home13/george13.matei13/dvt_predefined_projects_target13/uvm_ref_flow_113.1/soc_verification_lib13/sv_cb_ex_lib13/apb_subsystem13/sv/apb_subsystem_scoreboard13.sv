/*-------------------------------------------------------------------------
File13 name   : apb_subsystem_scoreboard13.sv
Title13       : AHB13 - SPI13 Scoreboard13
Project13     :
Created13     :
Description13 : Scoreboard13 for data integrity13 check between AHB13 UVC13 and SPI13 UVC13
Notes13       : Two13 similar13 scoreboards13 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb13)
`uvm_analysis_imp_decl(_spi13)

class spi2ahb_scbd13 extends uvm_scoreboard;
  bit [7:0] data_to_ahb13[$];
  bit [7:0] temp113;

  spi_pkg13::spi_csr_s13 csr13;
  apb_pkg13::apb_slave_config13 slave_cfg13;

  `uvm_component_utils(spi2ahb_scbd13)

  uvm_analysis_imp_ahb13 #(ahb_pkg13::ahb_transfer13, spi2ahb_scbd13) ahb_match13;
  uvm_analysis_imp_spi13 #(spi_pkg13::spi_transfer13, spi2ahb_scbd13) spi_add13;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add13  = new("spi_add13", this);
    ahb_match13 = new("ahb_match13", this);
  endfunction : new

  // implement SPI13 Tx13 analysis13 port from reference model
  virtual function void write_spi13(spi_pkg13::spi_transfer13 transfer13);
    data_to_ahb13.push_back(transfer13.transfer_data13[7:0]);	
  endfunction : write_spi13
     
  // implement APB13 READ analysis13 port from reference model
  virtual function void write_ahb13(input ahb_pkg13::ahb_transfer13 transfer13);

    if ((transfer13.address ==   (slave_cfg13.start_address13 + `SPI_RX0_REG13)) && (transfer13.direction13.name() == "READ"))
      begin
        temp113 = data_to_ahb13.pop_front();
       
        if (temp113 == transfer13.data[7:0]) 
          `uvm_info("SCRBD13", $psprintf("####### PASS13 : AHB13 RECEIVED13 CORRECT13 DATA13 from %s  expected = %h, received13 = %h", slave_cfg13.name, temp113, transfer13.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL13 : AHB13 RECEIVED13 WRONG13 DATA13 from %s", slave_cfg13.name))
          `uvm_info("SCRBD13", $psprintf("expected = %h, received13 = %h", temp113, transfer13.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb13
   
  function void assign_csr13(spi_pkg13::spi_csr_s13 csr_setting13);
    csr13 = csr_setting13;
  endfunction : assign_csr13

endclass : spi2ahb_scbd13

class ahb2spi_scbd13 extends uvm_scoreboard;
  bit [7:0] data_from_ahb13[$];

  bit [7:0] temp113;
  bit [7:0] mask;

  spi_pkg13::spi_csr_s13 csr13;
  apb_pkg13::apb_slave_config13 slave_cfg13;

  `uvm_component_utils(ahb2spi_scbd13)
  uvm_analysis_imp_ahb13 #(ahb_pkg13::ahb_transfer13, ahb2spi_scbd13) ahb_add13;
  uvm_analysis_imp_spi13 #(spi_pkg13::spi_transfer13, ahb2spi_scbd13) spi_match13;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match13 = new("spi_match13", this);
    ahb_add13    = new("ahb_add13", this);
  endfunction : new
   
  // implement AHB13 WRITE analysis13 port from reference model
  virtual function void write_ahb13(input ahb_pkg13::ahb_transfer13 transfer13);
    if ((transfer13.address ==  (slave_cfg13.start_address13 + `SPI_TX0_REG13)) && (transfer13.direction13.name() == "WRITE")) 
        data_from_ahb13.push_back(transfer13.data[7:0]);
  endfunction : write_ahb13
   
  // implement SPI13 Rx13 analysis13 port from reference model
  virtual function void write_spi13( spi_pkg13::spi_transfer13 transfer13);
    mask = calc_mask13();
    temp113 = data_from_ahb13.pop_front();

    if ((temp113 & mask) == transfer13.receive_data13[7:0])
      `uvm_info("SCRBD13", $psprintf("####### PASS13 : %s RECEIVED13 CORRECT13 DATA13 expected = %h, received13 = %h", slave_cfg13.name, (temp113 & mask), transfer13.receive_data13), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL13 : %s RECEIVED13 WRONG13 DATA13", slave_cfg13.name))
      `uvm_info("SCRBD13", $psprintf("expected = %h, received13 = %h", temp113, transfer13.receive_data13), UVM_MEDIUM)
    end
  endfunction : write_spi13
   
  function void assign_csr13(spi_pkg13::spi_csr_s13 csr_setting13);
     csr13 = csr_setting13;
  endfunction : assign_csr13
   
  function bit[31:0] calc_mask13();
    case (csr13.data_size13)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask13

endclass : ahb2spi_scbd13


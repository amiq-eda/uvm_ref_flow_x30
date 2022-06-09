/*-------------------------------------------------------------------------
File29 name   : apb_subsystem_scoreboard29.sv
Title29       : AHB29 - SPI29 Scoreboard29
Project29     :
Created29     :
Description29 : Scoreboard29 for data integrity29 check between AHB29 UVC29 and SPI29 UVC29
Notes29       : Two29 similar29 scoreboards29 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb29)
`uvm_analysis_imp_decl(_spi29)

class spi2ahb_scbd29 extends uvm_scoreboard;
  bit [7:0] data_to_ahb29[$];
  bit [7:0] temp129;

  spi_pkg29::spi_csr_s29 csr29;
  apb_pkg29::apb_slave_config29 slave_cfg29;

  `uvm_component_utils(spi2ahb_scbd29)

  uvm_analysis_imp_ahb29 #(ahb_pkg29::ahb_transfer29, spi2ahb_scbd29) ahb_match29;
  uvm_analysis_imp_spi29 #(spi_pkg29::spi_transfer29, spi2ahb_scbd29) spi_add29;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add29  = new("spi_add29", this);
    ahb_match29 = new("ahb_match29", this);
  endfunction : new

  // implement SPI29 Tx29 analysis29 port from reference model
  virtual function void write_spi29(spi_pkg29::spi_transfer29 transfer29);
    data_to_ahb29.push_back(transfer29.transfer_data29[7:0]);	
  endfunction : write_spi29
     
  // implement APB29 READ analysis29 port from reference model
  virtual function void write_ahb29(input ahb_pkg29::ahb_transfer29 transfer29);

    if ((transfer29.address ==   (slave_cfg29.start_address29 + `SPI_RX0_REG29)) && (transfer29.direction29.name() == "READ"))
      begin
        temp129 = data_to_ahb29.pop_front();
       
        if (temp129 == transfer29.data[7:0]) 
          `uvm_info("SCRBD29", $psprintf("####### PASS29 : AHB29 RECEIVED29 CORRECT29 DATA29 from %s  expected = %h, received29 = %h", slave_cfg29.name, temp129, transfer29.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL29 : AHB29 RECEIVED29 WRONG29 DATA29 from %s", slave_cfg29.name))
          `uvm_info("SCRBD29", $psprintf("expected = %h, received29 = %h", temp129, transfer29.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb29
   
  function void assign_csr29(spi_pkg29::spi_csr_s29 csr_setting29);
    csr29 = csr_setting29;
  endfunction : assign_csr29

endclass : spi2ahb_scbd29

class ahb2spi_scbd29 extends uvm_scoreboard;
  bit [7:0] data_from_ahb29[$];

  bit [7:0] temp129;
  bit [7:0] mask;

  spi_pkg29::spi_csr_s29 csr29;
  apb_pkg29::apb_slave_config29 slave_cfg29;

  `uvm_component_utils(ahb2spi_scbd29)
  uvm_analysis_imp_ahb29 #(ahb_pkg29::ahb_transfer29, ahb2spi_scbd29) ahb_add29;
  uvm_analysis_imp_spi29 #(spi_pkg29::spi_transfer29, ahb2spi_scbd29) spi_match29;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match29 = new("spi_match29", this);
    ahb_add29    = new("ahb_add29", this);
  endfunction : new
   
  // implement AHB29 WRITE analysis29 port from reference model
  virtual function void write_ahb29(input ahb_pkg29::ahb_transfer29 transfer29);
    if ((transfer29.address ==  (slave_cfg29.start_address29 + `SPI_TX0_REG29)) && (transfer29.direction29.name() == "WRITE")) 
        data_from_ahb29.push_back(transfer29.data[7:0]);
  endfunction : write_ahb29
   
  // implement SPI29 Rx29 analysis29 port from reference model
  virtual function void write_spi29( spi_pkg29::spi_transfer29 transfer29);
    mask = calc_mask29();
    temp129 = data_from_ahb29.pop_front();

    if ((temp129 & mask) == transfer29.receive_data29[7:0])
      `uvm_info("SCRBD29", $psprintf("####### PASS29 : %s RECEIVED29 CORRECT29 DATA29 expected = %h, received29 = %h", slave_cfg29.name, (temp129 & mask), transfer29.receive_data29), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL29 : %s RECEIVED29 WRONG29 DATA29", slave_cfg29.name))
      `uvm_info("SCRBD29", $psprintf("expected = %h, received29 = %h", temp129, transfer29.receive_data29), UVM_MEDIUM)
    end
  endfunction : write_spi29
   
  function void assign_csr29(spi_pkg29::spi_csr_s29 csr_setting29);
     csr29 = csr_setting29;
  endfunction : assign_csr29
   
  function bit[31:0] calc_mask29();
    case (csr29.data_size29)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask29

endclass : ahb2spi_scbd29


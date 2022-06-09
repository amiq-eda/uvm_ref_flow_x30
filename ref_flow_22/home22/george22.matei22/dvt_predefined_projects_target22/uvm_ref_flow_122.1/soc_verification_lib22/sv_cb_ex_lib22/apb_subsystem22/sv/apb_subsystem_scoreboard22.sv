/*-------------------------------------------------------------------------
File22 name   : apb_subsystem_scoreboard22.sv
Title22       : AHB22 - SPI22 Scoreboard22
Project22     :
Created22     :
Description22 : Scoreboard22 for data integrity22 check between AHB22 UVC22 and SPI22 UVC22
Notes22       : Two22 similar22 scoreboards22 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb22)
`uvm_analysis_imp_decl(_spi22)

class spi2ahb_scbd22 extends uvm_scoreboard;
  bit [7:0] data_to_ahb22[$];
  bit [7:0] temp122;

  spi_pkg22::spi_csr_s22 csr22;
  apb_pkg22::apb_slave_config22 slave_cfg22;

  `uvm_component_utils(spi2ahb_scbd22)

  uvm_analysis_imp_ahb22 #(ahb_pkg22::ahb_transfer22, spi2ahb_scbd22) ahb_match22;
  uvm_analysis_imp_spi22 #(spi_pkg22::spi_transfer22, spi2ahb_scbd22) spi_add22;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add22  = new("spi_add22", this);
    ahb_match22 = new("ahb_match22", this);
  endfunction : new

  // implement SPI22 Tx22 analysis22 port from reference model
  virtual function void write_spi22(spi_pkg22::spi_transfer22 transfer22);
    data_to_ahb22.push_back(transfer22.transfer_data22[7:0]);	
  endfunction : write_spi22
     
  // implement APB22 READ analysis22 port from reference model
  virtual function void write_ahb22(input ahb_pkg22::ahb_transfer22 transfer22);

    if ((transfer22.address ==   (slave_cfg22.start_address22 + `SPI_RX0_REG22)) && (transfer22.direction22.name() == "READ"))
      begin
        temp122 = data_to_ahb22.pop_front();
       
        if (temp122 == transfer22.data[7:0]) 
          `uvm_info("SCRBD22", $psprintf("####### PASS22 : AHB22 RECEIVED22 CORRECT22 DATA22 from %s  expected = %h, received22 = %h", slave_cfg22.name, temp122, transfer22.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL22 : AHB22 RECEIVED22 WRONG22 DATA22 from %s", slave_cfg22.name))
          `uvm_info("SCRBD22", $psprintf("expected = %h, received22 = %h", temp122, transfer22.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb22
   
  function void assign_csr22(spi_pkg22::spi_csr_s22 csr_setting22);
    csr22 = csr_setting22;
  endfunction : assign_csr22

endclass : spi2ahb_scbd22

class ahb2spi_scbd22 extends uvm_scoreboard;
  bit [7:0] data_from_ahb22[$];

  bit [7:0] temp122;
  bit [7:0] mask;

  spi_pkg22::spi_csr_s22 csr22;
  apb_pkg22::apb_slave_config22 slave_cfg22;

  `uvm_component_utils(ahb2spi_scbd22)
  uvm_analysis_imp_ahb22 #(ahb_pkg22::ahb_transfer22, ahb2spi_scbd22) ahb_add22;
  uvm_analysis_imp_spi22 #(spi_pkg22::spi_transfer22, ahb2spi_scbd22) spi_match22;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match22 = new("spi_match22", this);
    ahb_add22    = new("ahb_add22", this);
  endfunction : new
   
  // implement AHB22 WRITE analysis22 port from reference model
  virtual function void write_ahb22(input ahb_pkg22::ahb_transfer22 transfer22);
    if ((transfer22.address ==  (slave_cfg22.start_address22 + `SPI_TX0_REG22)) && (transfer22.direction22.name() == "WRITE")) 
        data_from_ahb22.push_back(transfer22.data[7:0]);
  endfunction : write_ahb22
   
  // implement SPI22 Rx22 analysis22 port from reference model
  virtual function void write_spi22( spi_pkg22::spi_transfer22 transfer22);
    mask = calc_mask22();
    temp122 = data_from_ahb22.pop_front();

    if ((temp122 & mask) == transfer22.receive_data22[7:0])
      `uvm_info("SCRBD22", $psprintf("####### PASS22 : %s RECEIVED22 CORRECT22 DATA22 expected = %h, received22 = %h", slave_cfg22.name, (temp122 & mask), transfer22.receive_data22), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL22 : %s RECEIVED22 WRONG22 DATA22", slave_cfg22.name))
      `uvm_info("SCRBD22", $psprintf("expected = %h, received22 = %h", temp122, transfer22.receive_data22), UVM_MEDIUM)
    end
  endfunction : write_spi22
   
  function void assign_csr22(spi_pkg22::spi_csr_s22 csr_setting22);
     csr22 = csr_setting22;
  endfunction : assign_csr22
   
  function bit[31:0] calc_mask22();
    case (csr22.data_size22)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask22

endclass : ahb2spi_scbd22


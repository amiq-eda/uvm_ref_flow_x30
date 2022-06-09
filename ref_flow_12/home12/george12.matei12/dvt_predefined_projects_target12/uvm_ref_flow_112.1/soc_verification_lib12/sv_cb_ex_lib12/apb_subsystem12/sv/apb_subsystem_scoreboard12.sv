/*-------------------------------------------------------------------------
File12 name   : apb_subsystem_scoreboard12.sv
Title12       : AHB12 - SPI12 Scoreboard12
Project12     :
Created12     :
Description12 : Scoreboard12 for data integrity12 check between AHB12 UVC12 and SPI12 UVC12
Notes12       : Two12 similar12 scoreboards12 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb12)
`uvm_analysis_imp_decl(_spi12)

class spi2ahb_scbd12 extends uvm_scoreboard;
  bit [7:0] data_to_ahb12[$];
  bit [7:0] temp112;

  spi_pkg12::spi_csr_s12 csr12;
  apb_pkg12::apb_slave_config12 slave_cfg12;

  `uvm_component_utils(spi2ahb_scbd12)

  uvm_analysis_imp_ahb12 #(ahb_pkg12::ahb_transfer12, spi2ahb_scbd12) ahb_match12;
  uvm_analysis_imp_spi12 #(spi_pkg12::spi_transfer12, spi2ahb_scbd12) spi_add12;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add12  = new("spi_add12", this);
    ahb_match12 = new("ahb_match12", this);
  endfunction : new

  // implement SPI12 Tx12 analysis12 port from reference model
  virtual function void write_spi12(spi_pkg12::spi_transfer12 transfer12);
    data_to_ahb12.push_back(transfer12.transfer_data12[7:0]);	
  endfunction : write_spi12
     
  // implement APB12 READ analysis12 port from reference model
  virtual function void write_ahb12(input ahb_pkg12::ahb_transfer12 transfer12);

    if ((transfer12.address ==   (slave_cfg12.start_address12 + `SPI_RX0_REG12)) && (transfer12.direction12.name() == "READ"))
      begin
        temp112 = data_to_ahb12.pop_front();
       
        if (temp112 == transfer12.data[7:0]) 
          `uvm_info("SCRBD12", $psprintf("####### PASS12 : AHB12 RECEIVED12 CORRECT12 DATA12 from %s  expected = %h, received12 = %h", slave_cfg12.name, temp112, transfer12.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL12 : AHB12 RECEIVED12 WRONG12 DATA12 from %s", slave_cfg12.name))
          `uvm_info("SCRBD12", $psprintf("expected = %h, received12 = %h", temp112, transfer12.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb12
   
  function void assign_csr12(spi_pkg12::spi_csr_s12 csr_setting12);
    csr12 = csr_setting12;
  endfunction : assign_csr12

endclass : spi2ahb_scbd12

class ahb2spi_scbd12 extends uvm_scoreboard;
  bit [7:0] data_from_ahb12[$];

  bit [7:0] temp112;
  bit [7:0] mask;

  spi_pkg12::spi_csr_s12 csr12;
  apb_pkg12::apb_slave_config12 slave_cfg12;

  `uvm_component_utils(ahb2spi_scbd12)
  uvm_analysis_imp_ahb12 #(ahb_pkg12::ahb_transfer12, ahb2spi_scbd12) ahb_add12;
  uvm_analysis_imp_spi12 #(spi_pkg12::spi_transfer12, ahb2spi_scbd12) spi_match12;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match12 = new("spi_match12", this);
    ahb_add12    = new("ahb_add12", this);
  endfunction : new
   
  // implement AHB12 WRITE analysis12 port from reference model
  virtual function void write_ahb12(input ahb_pkg12::ahb_transfer12 transfer12);
    if ((transfer12.address ==  (slave_cfg12.start_address12 + `SPI_TX0_REG12)) && (transfer12.direction12.name() == "WRITE")) 
        data_from_ahb12.push_back(transfer12.data[7:0]);
  endfunction : write_ahb12
   
  // implement SPI12 Rx12 analysis12 port from reference model
  virtual function void write_spi12( spi_pkg12::spi_transfer12 transfer12);
    mask = calc_mask12();
    temp112 = data_from_ahb12.pop_front();

    if ((temp112 & mask) == transfer12.receive_data12[7:0])
      `uvm_info("SCRBD12", $psprintf("####### PASS12 : %s RECEIVED12 CORRECT12 DATA12 expected = %h, received12 = %h", slave_cfg12.name, (temp112 & mask), transfer12.receive_data12), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL12 : %s RECEIVED12 WRONG12 DATA12", slave_cfg12.name))
      `uvm_info("SCRBD12", $psprintf("expected = %h, received12 = %h", temp112, transfer12.receive_data12), UVM_MEDIUM)
    end
  endfunction : write_spi12
   
  function void assign_csr12(spi_pkg12::spi_csr_s12 csr_setting12);
     csr12 = csr_setting12;
  endfunction : assign_csr12
   
  function bit[31:0] calc_mask12();
    case (csr12.data_size12)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask12

endclass : ahb2spi_scbd12


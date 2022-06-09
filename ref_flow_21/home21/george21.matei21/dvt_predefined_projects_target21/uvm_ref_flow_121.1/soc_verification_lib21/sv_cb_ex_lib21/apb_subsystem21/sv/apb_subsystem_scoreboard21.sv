/*-------------------------------------------------------------------------
File21 name   : apb_subsystem_scoreboard21.sv
Title21       : AHB21 - SPI21 Scoreboard21
Project21     :
Created21     :
Description21 : Scoreboard21 for data integrity21 check between AHB21 UVC21 and SPI21 UVC21
Notes21       : Two21 similar21 scoreboards21 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb21)
`uvm_analysis_imp_decl(_spi21)

class spi2ahb_scbd21 extends uvm_scoreboard;
  bit [7:0] data_to_ahb21[$];
  bit [7:0] temp121;

  spi_pkg21::spi_csr_s21 csr21;
  apb_pkg21::apb_slave_config21 slave_cfg21;

  `uvm_component_utils(spi2ahb_scbd21)

  uvm_analysis_imp_ahb21 #(ahb_pkg21::ahb_transfer21, spi2ahb_scbd21) ahb_match21;
  uvm_analysis_imp_spi21 #(spi_pkg21::spi_transfer21, spi2ahb_scbd21) spi_add21;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add21  = new("spi_add21", this);
    ahb_match21 = new("ahb_match21", this);
  endfunction : new

  // implement SPI21 Tx21 analysis21 port from reference model
  virtual function void write_spi21(spi_pkg21::spi_transfer21 transfer21);
    data_to_ahb21.push_back(transfer21.transfer_data21[7:0]);	
  endfunction : write_spi21
     
  // implement APB21 READ analysis21 port from reference model
  virtual function void write_ahb21(input ahb_pkg21::ahb_transfer21 transfer21);

    if ((transfer21.address ==   (slave_cfg21.start_address21 + `SPI_RX0_REG21)) && (transfer21.direction21.name() == "READ"))
      begin
        temp121 = data_to_ahb21.pop_front();
       
        if (temp121 == transfer21.data[7:0]) 
          `uvm_info("SCRBD21", $psprintf("####### PASS21 : AHB21 RECEIVED21 CORRECT21 DATA21 from %s  expected = %h, received21 = %h", slave_cfg21.name, temp121, transfer21.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL21 : AHB21 RECEIVED21 WRONG21 DATA21 from %s", slave_cfg21.name))
          `uvm_info("SCRBD21", $psprintf("expected = %h, received21 = %h", temp121, transfer21.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb21
   
  function void assign_csr21(spi_pkg21::spi_csr_s21 csr_setting21);
    csr21 = csr_setting21;
  endfunction : assign_csr21

endclass : spi2ahb_scbd21

class ahb2spi_scbd21 extends uvm_scoreboard;
  bit [7:0] data_from_ahb21[$];

  bit [7:0] temp121;
  bit [7:0] mask;

  spi_pkg21::spi_csr_s21 csr21;
  apb_pkg21::apb_slave_config21 slave_cfg21;

  `uvm_component_utils(ahb2spi_scbd21)
  uvm_analysis_imp_ahb21 #(ahb_pkg21::ahb_transfer21, ahb2spi_scbd21) ahb_add21;
  uvm_analysis_imp_spi21 #(spi_pkg21::spi_transfer21, ahb2spi_scbd21) spi_match21;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match21 = new("spi_match21", this);
    ahb_add21    = new("ahb_add21", this);
  endfunction : new
   
  // implement AHB21 WRITE analysis21 port from reference model
  virtual function void write_ahb21(input ahb_pkg21::ahb_transfer21 transfer21);
    if ((transfer21.address ==  (slave_cfg21.start_address21 + `SPI_TX0_REG21)) && (transfer21.direction21.name() == "WRITE")) 
        data_from_ahb21.push_back(transfer21.data[7:0]);
  endfunction : write_ahb21
   
  // implement SPI21 Rx21 analysis21 port from reference model
  virtual function void write_spi21( spi_pkg21::spi_transfer21 transfer21);
    mask = calc_mask21();
    temp121 = data_from_ahb21.pop_front();

    if ((temp121 & mask) == transfer21.receive_data21[7:0])
      `uvm_info("SCRBD21", $psprintf("####### PASS21 : %s RECEIVED21 CORRECT21 DATA21 expected = %h, received21 = %h", slave_cfg21.name, (temp121 & mask), transfer21.receive_data21), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL21 : %s RECEIVED21 WRONG21 DATA21", slave_cfg21.name))
      `uvm_info("SCRBD21", $psprintf("expected = %h, received21 = %h", temp121, transfer21.receive_data21), UVM_MEDIUM)
    end
  endfunction : write_spi21
   
  function void assign_csr21(spi_pkg21::spi_csr_s21 csr_setting21);
     csr21 = csr_setting21;
  endfunction : assign_csr21
   
  function bit[31:0] calc_mask21();
    case (csr21.data_size21)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask21

endclass : ahb2spi_scbd21


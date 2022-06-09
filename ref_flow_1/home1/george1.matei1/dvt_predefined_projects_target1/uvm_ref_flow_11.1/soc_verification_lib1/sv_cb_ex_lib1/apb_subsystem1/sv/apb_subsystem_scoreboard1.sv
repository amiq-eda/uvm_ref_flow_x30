/*-------------------------------------------------------------------------
File1 name   : apb_subsystem_scoreboard1.sv
Title1       : AHB1 - SPI1 Scoreboard1
Project1     :
Created1     :
Description1 : Scoreboard1 for data integrity1 check between AHB1 UVC1 and SPI1 UVC1
Notes1       : Two1 similar1 scoreboards1 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb1)
`uvm_analysis_imp_decl(_spi1)

class spi2ahb_scbd1 extends uvm_scoreboard;
  bit [7:0] data_to_ahb1[$];
  bit [7:0] temp11;

  spi_pkg1::spi_csr_s1 csr1;
  apb_pkg1::apb_slave_config1 slave_cfg1;

  `uvm_component_utils(spi2ahb_scbd1)

  uvm_analysis_imp_ahb1 #(ahb_pkg1::ahb_transfer1, spi2ahb_scbd1) ahb_match1;
  uvm_analysis_imp_spi1 #(spi_pkg1::spi_transfer1, spi2ahb_scbd1) spi_add1;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add1  = new("spi_add1", this);
    ahb_match1 = new("ahb_match1", this);
  endfunction : new

  // implement SPI1 Tx1 analysis1 port from reference model
  virtual function void write_spi1(spi_pkg1::spi_transfer1 transfer1);
    data_to_ahb1.push_back(transfer1.transfer_data1[7:0]);	
  endfunction : write_spi1
     
  // implement APB1 READ analysis1 port from reference model
  virtual function void write_ahb1(input ahb_pkg1::ahb_transfer1 transfer1);

    if ((transfer1.address ==   (slave_cfg1.start_address1 + `SPI_RX0_REG1)) && (transfer1.direction1.name() == "READ"))
      begin
        temp11 = data_to_ahb1.pop_front();
       
        if (temp11 == transfer1.data[7:0]) 
          `uvm_info("SCRBD1", $psprintf("####### PASS1 : AHB1 RECEIVED1 CORRECT1 DATA1 from %s  expected = %h, received1 = %h", slave_cfg1.name, temp11, transfer1.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL1 : AHB1 RECEIVED1 WRONG1 DATA1 from %s", slave_cfg1.name))
          `uvm_info("SCRBD1", $psprintf("expected = %h, received1 = %h", temp11, transfer1.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb1
   
  function void assign_csr1(spi_pkg1::spi_csr_s1 csr_setting1);
    csr1 = csr_setting1;
  endfunction : assign_csr1

endclass : spi2ahb_scbd1

class ahb2spi_scbd1 extends uvm_scoreboard;
  bit [7:0] data_from_ahb1[$];

  bit [7:0] temp11;
  bit [7:0] mask;

  spi_pkg1::spi_csr_s1 csr1;
  apb_pkg1::apb_slave_config1 slave_cfg1;

  `uvm_component_utils(ahb2spi_scbd1)
  uvm_analysis_imp_ahb1 #(ahb_pkg1::ahb_transfer1, ahb2spi_scbd1) ahb_add1;
  uvm_analysis_imp_spi1 #(spi_pkg1::spi_transfer1, ahb2spi_scbd1) spi_match1;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match1 = new("spi_match1", this);
    ahb_add1    = new("ahb_add1", this);
  endfunction : new
   
  // implement AHB1 WRITE analysis1 port from reference model
  virtual function void write_ahb1(input ahb_pkg1::ahb_transfer1 transfer1);
    if ((transfer1.address ==  (slave_cfg1.start_address1 + `SPI_TX0_REG1)) && (transfer1.direction1.name() == "WRITE")) 
        data_from_ahb1.push_back(transfer1.data[7:0]);
  endfunction : write_ahb1
   
  // implement SPI1 Rx1 analysis1 port from reference model
  virtual function void write_spi1( spi_pkg1::spi_transfer1 transfer1);
    mask = calc_mask1();
    temp11 = data_from_ahb1.pop_front();

    if ((temp11 & mask) == transfer1.receive_data1[7:0])
      `uvm_info("SCRBD1", $psprintf("####### PASS1 : %s RECEIVED1 CORRECT1 DATA1 expected = %h, received1 = %h", slave_cfg1.name, (temp11 & mask), transfer1.receive_data1), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL1 : %s RECEIVED1 WRONG1 DATA1", slave_cfg1.name))
      `uvm_info("SCRBD1", $psprintf("expected = %h, received1 = %h", temp11, transfer1.receive_data1), UVM_MEDIUM)
    end
  endfunction : write_spi1
   
  function void assign_csr1(spi_pkg1::spi_csr_s1 csr_setting1);
     csr1 = csr_setting1;
  endfunction : assign_csr1
   
  function bit[31:0] calc_mask1();
    case (csr1.data_size1)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask1

endclass : ahb2spi_scbd1


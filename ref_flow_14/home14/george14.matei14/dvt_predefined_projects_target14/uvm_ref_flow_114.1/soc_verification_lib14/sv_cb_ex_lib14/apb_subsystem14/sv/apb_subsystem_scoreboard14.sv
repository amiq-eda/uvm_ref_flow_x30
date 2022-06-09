/*-------------------------------------------------------------------------
File14 name   : apb_subsystem_scoreboard14.sv
Title14       : AHB14 - SPI14 Scoreboard14
Project14     :
Created14     :
Description14 : Scoreboard14 for data integrity14 check between AHB14 UVC14 and SPI14 UVC14
Notes14       : Two14 similar14 scoreboards14 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb14)
`uvm_analysis_imp_decl(_spi14)

class spi2ahb_scbd14 extends uvm_scoreboard;
  bit [7:0] data_to_ahb14[$];
  bit [7:0] temp114;

  spi_pkg14::spi_csr_s14 csr14;
  apb_pkg14::apb_slave_config14 slave_cfg14;

  `uvm_component_utils(spi2ahb_scbd14)

  uvm_analysis_imp_ahb14 #(ahb_pkg14::ahb_transfer14, spi2ahb_scbd14) ahb_match14;
  uvm_analysis_imp_spi14 #(spi_pkg14::spi_transfer14, spi2ahb_scbd14) spi_add14;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add14  = new("spi_add14", this);
    ahb_match14 = new("ahb_match14", this);
  endfunction : new

  // implement SPI14 Tx14 analysis14 port from reference model
  virtual function void write_spi14(spi_pkg14::spi_transfer14 transfer14);
    data_to_ahb14.push_back(transfer14.transfer_data14[7:0]);	
  endfunction : write_spi14
     
  // implement APB14 READ analysis14 port from reference model
  virtual function void write_ahb14(input ahb_pkg14::ahb_transfer14 transfer14);

    if ((transfer14.address ==   (slave_cfg14.start_address14 + `SPI_RX0_REG14)) && (transfer14.direction14.name() == "READ"))
      begin
        temp114 = data_to_ahb14.pop_front();
       
        if (temp114 == transfer14.data[7:0]) 
          `uvm_info("SCRBD14", $psprintf("####### PASS14 : AHB14 RECEIVED14 CORRECT14 DATA14 from %s  expected = %h, received14 = %h", slave_cfg14.name, temp114, transfer14.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL14 : AHB14 RECEIVED14 WRONG14 DATA14 from %s", slave_cfg14.name))
          `uvm_info("SCRBD14", $psprintf("expected = %h, received14 = %h", temp114, transfer14.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb14
   
  function void assign_csr14(spi_pkg14::spi_csr_s14 csr_setting14);
    csr14 = csr_setting14;
  endfunction : assign_csr14

endclass : spi2ahb_scbd14

class ahb2spi_scbd14 extends uvm_scoreboard;
  bit [7:0] data_from_ahb14[$];

  bit [7:0] temp114;
  bit [7:0] mask;

  spi_pkg14::spi_csr_s14 csr14;
  apb_pkg14::apb_slave_config14 slave_cfg14;

  `uvm_component_utils(ahb2spi_scbd14)
  uvm_analysis_imp_ahb14 #(ahb_pkg14::ahb_transfer14, ahb2spi_scbd14) ahb_add14;
  uvm_analysis_imp_spi14 #(spi_pkg14::spi_transfer14, ahb2spi_scbd14) spi_match14;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match14 = new("spi_match14", this);
    ahb_add14    = new("ahb_add14", this);
  endfunction : new
   
  // implement AHB14 WRITE analysis14 port from reference model
  virtual function void write_ahb14(input ahb_pkg14::ahb_transfer14 transfer14);
    if ((transfer14.address ==  (slave_cfg14.start_address14 + `SPI_TX0_REG14)) && (transfer14.direction14.name() == "WRITE")) 
        data_from_ahb14.push_back(transfer14.data[7:0]);
  endfunction : write_ahb14
   
  // implement SPI14 Rx14 analysis14 port from reference model
  virtual function void write_spi14( spi_pkg14::spi_transfer14 transfer14);
    mask = calc_mask14();
    temp114 = data_from_ahb14.pop_front();

    if ((temp114 & mask) == transfer14.receive_data14[7:0])
      `uvm_info("SCRBD14", $psprintf("####### PASS14 : %s RECEIVED14 CORRECT14 DATA14 expected = %h, received14 = %h", slave_cfg14.name, (temp114 & mask), transfer14.receive_data14), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL14 : %s RECEIVED14 WRONG14 DATA14", slave_cfg14.name))
      `uvm_info("SCRBD14", $psprintf("expected = %h, received14 = %h", temp114, transfer14.receive_data14), UVM_MEDIUM)
    end
  endfunction : write_spi14
   
  function void assign_csr14(spi_pkg14::spi_csr_s14 csr_setting14);
     csr14 = csr_setting14;
  endfunction : assign_csr14
   
  function bit[31:0] calc_mask14();
    case (csr14.data_size14)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask14

endclass : ahb2spi_scbd14


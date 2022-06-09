/*-------------------------------------------------------------------------
File2 name   : apb_subsystem_scoreboard2.sv
Title2       : AHB2 - SPI2 Scoreboard2
Project2     :
Created2     :
Description2 : Scoreboard2 for data integrity2 check between AHB2 UVC2 and SPI2 UVC2
Notes2       : Two2 similar2 scoreboards2 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb2)
`uvm_analysis_imp_decl(_spi2)

class spi2ahb_scbd2 extends uvm_scoreboard;
  bit [7:0] data_to_ahb2[$];
  bit [7:0] temp12;

  spi_pkg2::spi_csr_s2 csr2;
  apb_pkg2::apb_slave_config2 slave_cfg2;

  `uvm_component_utils(spi2ahb_scbd2)

  uvm_analysis_imp_ahb2 #(ahb_pkg2::ahb_transfer2, spi2ahb_scbd2) ahb_match2;
  uvm_analysis_imp_spi2 #(spi_pkg2::spi_transfer2, spi2ahb_scbd2) spi_add2;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add2  = new("spi_add2", this);
    ahb_match2 = new("ahb_match2", this);
  endfunction : new

  // implement SPI2 Tx2 analysis2 port from reference model
  virtual function void write_spi2(spi_pkg2::spi_transfer2 transfer2);
    data_to_ahb2.push_back(transfer2.transfer_data2[7:0]);	
  endfunction : write_spi2
     
  // implement APB2 READ analysis2 port from reference model
  virtual function void write_ahb2(input ahb_pkg2::ahb_transfer2 transfer2);

    if ((transfer2.address ==   (slave_cfg2.start_address2 + `SPI_RX0_REG2)) && (transfer2.direction2.name() == "READ"))
      begin
        temp12 = data_to_ahb2.pop_front();
       
        if (temp12 == transfer2.data[7:0]) 
          `uvm_info("SCRBD2", $psprintf("####### PASS2 : AHB2 RECEIVED2 CORRECT2 DATA2 from %s  expected = %h, received2 = %h", slave_cfg2.name, temp12, transfer2.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL2 : AHB2 RECEIVED2 WRONG2 DATA2 from %s", slave_cfg2.name))
          `uvm_info("SCRBD2", $psprintf("expected = %h, received2 = %h", temp12, transfer2.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb2
   
  function void assign_csr2(spi_pkg2::spi_csr_s2 csr_setting2);
    csr2 = csr_setting2;
  endfunction : assign_csr2

endclass : spi2ahb_scbd2

class ahb2spi_scbd2 extends uvm_scoreboard;
  bit [7:0] data_from_ahb2[$];

  bit [7:0] temp12;
  bit [7:0] mask;

  spi_pkg2::spi_csr_s2 csr2;
  apb_pkg2::apb_slave_config2 slave_cfg2;

  `uvm_component_utils(ahb2spi_scbd2)
  uvm_analysis_imp_ahb2 #(ahb_pkg2::ahb_transfer2, ahb2spi_scbd2) ahb_add2;
  uvm_analysis_imp_spi2 #(spi_pkg2::spi_transfer2, ahb2spi_scbd2) spi_match2;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match2 = new("spi_match2", this);
    ahb_add2    = new("ahb_add2", this);
  endfunction : new
   
  // implement AHB2 WRITE analysis2 port from reference model
  virtual function void write_ahb2(input ahb_pkg2::ahb_transfer2 transfer2);
    if ((transfer2.address ==  (slave_cfg2.start_address2 + `SPI_TX0_REG2)) && (transfer2.direction2.name() == "WRITE")) 
        data_from_ahb2.push_back(transfer2.data[7:0]);
  endfunction : write_ahb2
   
  // implement SPI2 Rx2 analysis2 port from reference model
  virtual function void write_spi2( spi_pkg2::spi_transfer2 transfer2);
    mask = calc_mask2();
    temp12 = data_from_ahb2.pop_front();

    if ((temp12 & mask) == transfer2.receive_data2[7:0])
      `uvm_info("SCRBD2", $psprintf("####### PASS2 : %s RECEIVED2 CORRECT2 DATA2 expected = %h, received2 = %h", slave_cfg2.name, (temp12 & mask), transfer2.receive_data2), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL2 : %s RECEIVED2 WRONG2 DATA2", slave_cfg2.name))
      `uvm_info("SCRBD2", $psprintf("expected = %h, received2 = %h", temp12, transfer2.receive_data2), UVM_MEDIUM)
    end
  endfunction : write_spi2
   
  function void assign_csr2(spi_pkg2::spi_csr_s2 csr_setting2);
     csr2 = csr_setting2;
  endfunction : assign_csr2
   
  function bit[31:0] calc_mask2();
    case (csr2.data_size2)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask2

endclass : ahb2spi_scbd2


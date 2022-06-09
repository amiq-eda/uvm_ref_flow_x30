/*-------------------------------------------------------------------------
File19 name   : apb_subsystem_scoreboard19.sv
Title19       : AHB19 - SPI19 Scoreboard19
Project19     :
Created19     :
Description19 : Scoreboard19 for data integrity19 check between AHB19 UVC19 and SPI19 UVC19
Notes19       : Two19 similar19 scoreboards19 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------
`uvm_analysis_imp_decl(_ahb19)
`uvm_analysis_imp_decl(_spi19)

class spi2ahb_scbd19 extends uvm_scoreboard;
  bit [7:0] data_to_ahb19[$];
  bit [7:0] temp119;

  spi_pkg19::spi_csr_s19 csr19;
  apb_pkg19::apb_slave_config19 slave_cfg19;

  `uvm_component_utils(spi2ahb_scbd19)

  uvm_analysis_imp_ahb19 #(ahb_pkg19::ahb_transfer19, spi2ahb_scbd19) ahb_match19;
  uvm_analysis_imp_spi19 #(spi_pkg19::spi_transfer19, spi2ahb_scbd19) spi_add19;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_add19  = new("spi_add19", this);
    ahb_match19 = new("ahb_match19", this);
  endfunction : new

  // implement SPI19 Tx19 analysis19 port from reference model
  virtual function void write_spi19(spi_pkg19::spi_transfer19 transfer19);
    data_to_ahb19.push_back(transfer19.transfer_data19[7:0]);	
  endfunction : write_spi19
     
  // implement APB19 READ analysis19 port from reference model
  virtual function void write_ahb19(input ahb_pkg19::ahb_transfer19 transfer19);

    if ((transfer19.address ==   (slave_cfg19.start_address19 + `SPI_RX0_REG19)) && (transfer19.direction19.name() == "READ"))
      begin
        temp119 = data_to_ahb19.pop_front();
       
        if (temp119 == transfer19.data[7:0]) 
          `uvm_info("SCRBD19", $psprintf("####### PASS19 : AHB19 RECEIVED19 CORRECT19 DATA19 from %s  expected = %h, received19 = %h", slave_cfg19.name, temp119, transfer19.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL19 : AHB19 RECEIVED19 WRONG19 DATA19 from %s", slave_cfg19.name))
          `uvm_info("SCRBD19", $psprintf("expected = %h, received19 = %h", temp119, transfer19.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb19
   
  function void assign_csr19(spi_pkg19::spi_csr_s19 csr_setting19);
    csr19 = csr_setting19;
  endfunction : assign_csr19

endclass : spi2ahb_scbd19

class ahb2spi_scbd19 extends uvm_scoreboard;
  bit [7:0] data_from_ahb19[$];

  bit [7:0] temp119;
  bit [7:0] mask;

  spi_pkg19::spi_csr_s19 csr19;
  apb_pkg19::apb_slave_config19 slave_cfg19;

  `uvm_component_utils(ahb2spi_scbd19)
  uvm_analysis_imp_ahb19 #(ahb_pkg19::ahb_transfer19, ahb2spi_scbd19) ahb_add19;
  uvm_analysis_imp_spi19 #(spi_pkg19::spi_transfer19, ahb2spi_scbd19) spi_match19;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    spi_match19 = new("spi_match19", this);
    ahb_add19    = new("ahb_add19", this);
  endfunction : new
   
  // implement AHB19 WRITE analysis19 port from reference model
  virtual function void write_ahb19(input ahb_pkg19::ahb_transfer19 transfer19);
    if ((transfer19.address ==  (slave_cfg19.start_address19 + `SPI_TX0_REG19)) && (transfer19.direction19.name() == "WRITE")) 
        data_from_ahb19.push_back(transfer19.data[7:0]);
  endfunction : write_ahb19
   
  // implement SPI19 Rx19 analysis19 port from reference model
  virtual function void write_spi19( spi_pkg19::spi_transfer19 transfer19);
    mask = calc_mask19();
    temp119 = data_from_ahb19.pop_front();

    if ((temp119 & mask) == transfer19.receive_data19[7:0])
      `uvm_info("SCRBD19", $psprintf("####### PASS19 : %s RECEIVED19 CORRECT19 DATA19 expected = %h, received19 = %h", slave_cfg19.name, (temp119 & mask), transfer19.receive_data19), UVM_MEDIUM)
    else begin
      `uvm_error(get_type_name(), $psprintf("####### FAIL19 : %s RECEIVED19 WRONG19 DATA19", slave_cfg19.name))
      `uvm_info("SCRBD19", $psprintf("expected = %h, received19 = %h", temp119, transfer19.receive_data19), UVM_MEDIUM)
    end
  endfunction : write_spi19
   
  function void assign_csr19(spi_pkg19::spi_csr_s19 csr_setting19);
     csr19 = csr_setting19;
  endfunction : assign_csr19
   
  function bit[31:0] calc_mask19();
    case (csr19.data_size19)
      8: return 32'h00FF;
      16: return 32'h00FFFF;
      24: return 32'h00FFFFFF;
      32: return 32'hFFFFFFFF;
      default: return 8'hFF;
    endcase
  endfunction : calc_mask19

endclass : ahb2spi_scbd19


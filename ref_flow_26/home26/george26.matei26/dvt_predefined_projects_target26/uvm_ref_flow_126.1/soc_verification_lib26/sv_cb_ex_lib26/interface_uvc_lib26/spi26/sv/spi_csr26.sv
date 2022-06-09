/*-------------------------------------------------------------------------
File26 name   : spi_csr26.sv
Title26       : SPI26 SystemVerilog26 UVM UVC26
Project26     : SystemVerilog26 UVM Cluster26 Level26 Verification26
Created26     :
Description26 : 
Notes26       :  
---------------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV26
`define SPI_CSR_SV26

typedef struct packed {
  bit [7:0] n_ss_out26;
  bit [6:0] transfer_data_size26;
  bit [15:0] baud_rate_divisor26;
  bit tx_clk_phase26;
  bit rx_clk_phase26;
  bit mode_select26;

  bit tx_fifo_underflow26;
  bit rx_fifo_full26; 
  bit rx_fifo_not_empty26;
  bit tx_fifo_full26;
  bit tx_fifo_not_empty26;
  bit mode_fault26;
  bit rx_fifo_overrun26;

  bit spi_enable26;

  bit [7:0] d_btwn_slave_sel26;
  bit [7:0] d_btwn_word26;
  bit [7:0] d_btwn_senable_word26;

  int data_size26;
  } spi_csr_s26;

class spi_csr26 extends uvm_object;

  spi_csr_s26 csr_s26;

  //randomize SPI26 CSR26 fields
  rand bit [7:0] n_ss_out26;
  rand bit [6:0] transfer_data_size26;
  rand bit [15:0] baud_rate_divisor26;
  rand bit tx_clk_phase26;
  rand bit rx_clk_phase26;
  rand bit mode_select26;

  rand bit [7:0] d_btwn_slave_sel26;
  rand bit [7:0] d_btwn_word26;
  rand bit [7:0] d_btwn_senable_word26;

  rand bit spi_enable26;

  int data_size26;

  // this is a default constraint that could be overriden26
  // Constrain26 randomisation26 of configuration based on UVC26/RTL26 capabilities26
  constraint c_default_config26 {
    n_ss_out26           == 8'b01;
    transfer_data_size26 == 7'b0001000;
    baud_rate_divisor26  == 16'b0001;
    tx_clk_phase26       == 1'b0;
    rx_clk_phase26       == 1'b0;
    mode_select26        == 1'b1;

    d_btwn_slave_sel26   == 8'h00;
    d_btwn_word26        == 8'h00;
    d_btwn_senable_word26== 8'h00;

    spi_enable26         == 1'b1;
  }

  // These26 declarations26 implement the create() and get_type_name() as well26 as enable automation26 of the
  // transfer26 fields   
  `uvm_object_utils_begin(spi_csr26)
    `uvm_field_int(n_ss_out26,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size26,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor26,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase26,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase26,        UVM_ALL_ON)
    `uvm_field_int(mode_select26,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel26,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word26,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word26, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable26,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This26 requires for registration26 of the ptp_tx_frame26   
  function new(string name = "spi_csr26");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int26();
    Copycfg_struct26();
  endfunction 

  // function to convert the 2 bit transfer_data_size26 to integer
  function void get_data_size_as_int26();
    case(transfer_data_size26)
      16'b00 : data_size26 = 128;
      default : data_size26 = int'(transfer_data_size26);
    endcase
     `uvm_info("SPI26 CSR26", $psprintf("data size is %d", data_size26), UVM_MEDIUM)
  endfunction : get_data_size_as_int26
    
  function void Copycfg_struct26();
    csr_s26.n_ss_out26            = n_ss_out26;
    csr_s26.transfer_data_size26  = transfer_data_size26;
    csr_s26.baud_rate_divisor26   = baud_rate_divisor26;
    csr_s26.tx_clk_phase26        = tx_clk_phase26;
    csr_s26.rx_clk_phase26        = rx_clk_phase26;
    csr_s26.mode_select26         = mode_select26;

    csr_s26.d_btwn_slave_sel26     = d_btwn_slave_sel26;
    csr_s26.d_btwn_word26          = d_btwn_word26;
    csr_s26.d_btwn_senable_word26  = d_btwn_senable_word26;

    csr_s26.spi_enable26      = spi_enable26;

    csr_s26.data_size26      = data_size26;
  endfunction

endclass : spi_csr26

`endif


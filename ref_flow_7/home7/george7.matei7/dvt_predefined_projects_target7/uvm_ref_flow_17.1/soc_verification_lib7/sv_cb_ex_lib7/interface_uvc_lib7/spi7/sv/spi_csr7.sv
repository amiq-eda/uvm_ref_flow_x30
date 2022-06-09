/*-------------------------------------------------------------------------
File7 name   : spi_csr7.sv
Title7       : SPI7 SystemVerilog7 UVM UVC7
Project7     : SystemVerilog7 UVM Cluster7 Level7 Verification7
Created7     :
Description7 : 
Notes7       :  
---------------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV7
`define SPI_CSR_SV7

typedef struct packed {
  bit [7:0] n_ss_out7;
  bit [6:0] transfer_data_size7;
  bit [15:0] baud_rate_divisor7;
  bit tx_clk_phase7;
  bit rx_clk_phase7;
  bit mode_select7;

  bit tx_fifo_underflow7;
  bit rx_fifo_full7; 
  bit rx_fifo_not_empty7;
  bit tx_fifo_full7;
  bit tx_fifo_not_empty7;
  bit mode_fault7;
  bit rx_fifo_overrun7;

  bit spi_enable7;

  bit [7:0] d_btwn_slave_sel7;
  bit [7:0] d_btwn_word7;
  bit [7:0] d_btwn_senable_word7;

  int data_size7;
  } spi_csr_s7;

class spi_csr7 extends uvm_object;

  spi_csr_s7 csr_s7;

  //randomize SPI7 CSR7 fields
  rand bit [7:0] n_ss_out7;
  rand bit [6:0] transfer_data_size7;
  rand bit [15:0] baud_rate_divisor7;
  rand bit tx_clk_phase7;
  rand bit rx_clk_phase7;
  rand bit mode_select7;

  rand bit [7:0] d_btwn_slave_sel7;
  rand bit [7:0] d_btwn_word7;
  rand bit [7:0] d_btwn_senable_word7;

  rand bit spi_enable7;

  int data_size7;

  // this is a default constraint that could be overriden7
  // Constrain7 randomisation7 of configuration based on UVC7/RTL7 capabilities7
  constraint c_default_config7 {
    n_ss_out7           == 8'b01;
    transfer_data_size7 == 7'b0001000;
    baud_rate_divisor7  == 16'b0001;
    tx_clk_phase7       == 1'b0;
    rx_clk_phase7       == 1'b0;
    mode_select7        == 1'b1;

    d_btwn_slave_sel7   == 8'h00;
    d_btwn_word7        == 8'h00;
    d_btwn_senable_word7== 8'h00;

    spi_enable7         == 1'b1;
  }

  // These7 declarations7 implement the create() and get_type_name() as well7 as enable automation7 of the
  // transfer7 fields   
  `uvm_object_utils_begin(spi_csr7)
    `uvm_field_int(n_ss_out7,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size7,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor7,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase7,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase7,        UVM_ALL_ON)
    `uvm_field_int(mode_select7,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel7,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word7,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word7, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable7,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This7 requires for registration7 of the ptp_tx_frame7   
  function new(string name = "spi_csr7");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int7();
    Copycfg_struct7();
  endfunction 

  // function to convert the 2 bit transfer_data_size7 to integer
  function void get_data_size_as_int7();
    case(transfer_data_size7)
      16'b00 : data_size7 = 128;
      default : data_size7 = int'(transfer_data_size7);
    endcase
     `uvm_info("SPI7 CSR7", $psprintf("data size is %d", data_size7), UVM_MEDIUM)
  endfunction : get_data_size_as_int7
    
  function void Copycfg_struct7();
    csr_s7.n_ss_out7            = n_ss_out7;
    csr_s7.transfer_data_size7  = transfer_data_size7;
    csr_s7.baud_rate_divisor7   = baud_rate_divisor7;
    csr_s7.tx_clk_phase7        = tx_clk_phase7;
    csr_s7.rx_clk_phase7        = rx_clk_phase7;
    csr_s7.mode_select7         = mode_select7;

    csr_s7.d_btwn_slave_sel7     = d_btwn_slave_sel7;
    csr_s7.d_btwn_word7          = d_btwn_word7;
    csr_s7.d_btwn_senable_word7  = d_btwn_senable_word7;

    csr_s7.spi_enable7      = spi_enable7;

    csr_s7.data_size7      = data_size7;
  endfunction

endclass : spi_csr7

`endif


/*-------------------------------------------------------------------------
File24 name   : spi_csr24.sv
Title24       : SPI24 SystemVerilog24 UVM UVC24
Project24     : SystemVerilog24 UVM Cluster24 Level24 Verification24
Created24     :
Description24 : 
Notes24       :  
---------------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV24
`define SPI_CSR_SV24

typedef struct packed {
  bit [7:0] n_ss_out24;
  bit [6:0] transfer_data_size24;
  bit [15:0] baud_rate_divisor24;
  bit tx_clk_phase24;
  bit rx_clk_phase24;
  bit mode_select24;

  bit tx_fifo_underflow24;
  bit rx_fifo_full24; 
  bit rx_fifo_not_empty24;
  bit tx_fifo_full24;
  bit tx_fifo_not_empty24;
  bit mode_fault24;
  bit rx_fifo_overrun24;

  bit spi_enable24;

  bit [7:0] d_btwn_slave_sel24;
  bit [7:0] d_btwn_word24;
  bit [7:0] d_btwn_senable_word24;

  int data_size24;
  } spi_csr_s24;

class spi_csr24 extends uvm_object;

  spi_csr_s24 csr_s24;

  //randomize SPI24 CSR24 fields
  rand bit [7:0] n_ss_out24;
  rand bit [6:0] transfer_data_size24;
  rand bit [15:0] baud_rate_divisor24;
  rand bit tx_clk_phase24;
  rand bit rx_clk_phase24;
  rand bit mode_select24;

  rand bit [7:0] d_btwn_slave_sel24;
  rand bit [7:0] d_btwn_word24;
  rand bit [7:0] d_btwn_senable_word24;

  rand bit spi_enable24;

  int data_size24;

  // this is a default constraint that could be overriden24
  // Constrain24 randomisation24 of configuration based on UVC24/RTL24 capabilities24
  constraint c_default_config24 {
    n_ss_out24           == 8'b01;
    transfer_data_size24 == 7'b0001000;
    baud_rate_divisor24  == 16'b0001;
    tx_clk_phase24       == 1'b0;
    rx_clk_phase24       == 1'b0;
    mode_select24        == 1'b1;

    d_btwn_slave_sel24   == 8'h00;
    d_btwn_word24        == 8'h00;
    d_btwn_senable_word24== 8'h00;

    spi_enable24         == 1'b1;
  }

  // These24 declarations24 implement the create() and get_type_name() as well24 as enable automation24 of the
  // transfer24 fields   
  `uvm_object_utils_begin(spi_csr24)
    `uvm_field_int(n_ss_out24,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size24,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor24,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase24,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase24,        UVM_ALL_ON)
    `uvm_field_int(mode_select24,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel24,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word24,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word24, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable24,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This24 requires for registration24 of the ptp_tx_frame24   
  function new(string name = "spi_csr24");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int24();
    Copycfg_struct24();
  endfunction 

  // function to convert the 2 bit transfer_data_size24 to integer
  function void get_data_size_as_int24();
    case(transfer_data_size24)
      16'b00 : data_size24 = 128;
      default : data_size24 = int'(transfer_data_size24);
    endcase
     `uvm_info("SPI24 CSR24", $psprintf("data size is %d", data_size24), UVM_MEDIUM)
  endfunction : get_data_size_as_int24
    
  function void Copycfg_struct24();
    csr_s24.n_ss_out24            = n_ss_out24;
    csr_s24.transfer_data_size24  = transfer_data_size24;
    csr_s24.baud_rate_divisor24   = baud_rate_divisor24;
    csr_s24.tx_clk_phase24        = tx_clk_phase24;
    csr_s24.rx_clk_phase24        = rx_clk_phase24;
    csr_s24.mode_select24         = mode_select24;

    csr_s24.d_btwn_slave_sel24     = d_btwn_slave_sel24;
    csr_s24.d_btwn_word24          = d_btwn_word24;
    csr_s24.d_btwn_senable_word24  = d_btwn_senable_word24;

    csr_s24.spi_enable24      = spi_enable24;

    csr_s24.data_size24      = data_size24;
  endfunction

endclass : spi_csr24

`endif


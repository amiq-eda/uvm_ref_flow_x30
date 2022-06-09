/*-------------------------------------------------------------------------
File10 name   : spi_csr10.sv
Title10       : SPI10 SystemVerilog10 UVM UVC10
Project10     : SystemVerilog10 UVM Cluster10 Level10 Verification10
Created10     :
Description10 : 
Notes10       :  
---------------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV10
`define SPI_CSR_SV10

typedef struct packed {
  bit [7:0] n_ss_out10;
  bit [6:0] transfer_data_size10;
  bit [15:0] baud_rate_divisor10;
  bit tx_clk_phase10;
  bit rx_clk_phase10;
  bit mode_select10;

  bit tx_fifo_underflow10;
  bit rx_fifo_full10; 
  bit rx_fifo_not_empty10;
  bit tx_fifo_full10;
  bit tx_fifo_not_empty10;
  bit mode_fault10;
  bit rx_fifo_overrun10;

  bit spi_enable10;

  bit [7:0] d_btwn_slave_sel10;
  bit [7:0] d_btwn_word10;
  bit [7:0] d_btwn_senable_word10;

  int data_size10;
  } spi_csr_s10;

class spi_csr10 extends uvm_object;

  spi_csr_s10 csr_s10;

  //randomize SPI10 CSR10 fields
  rand bit [7:0] n_ss_out10;
  rand bit [6:0] transfer_data_size10;
  rand bit [15:0] baud_rate_divisor10;
  rand bit tx_clk_phase10;
  rand bit rx_clk_phase10;
  rand bit mode_select10;

  rand bit [7:0] d_btwn_slave_sel10;
  rand bit [7:0] d_btwn_word10;
  rand bit [7:0] d_btwn_senable_word10;

  rand bit spi_enable10;

  int data_size10;

  // this is a default constraint that could be overriden10
  // Constrain10 randomisation10 of configuration based on UVC10/RTL10 capabilities10
  constraint c_default_config10 {
    n_ss_out10           == 8'b01;
    transfer_data_size10 == 7'b0001000;
    baud_rate_divisor10  == 16'b0001;
    tx_clk_phase10       == 1'b0;
    rx_clk_phase10       == 1'b0;
    mode_select10        == 1'b1;

    d_btwn_slave_sel10   == 8'h00;
    d_btwn_word10        == 8'h00;
    d_btwn_senable_word10== 8'h00;

    spi_enable10         == 1'b1;
  }

  // These10 declarations10 implement the create() and get_type_name() as well10 as enable automation10 of the
  // transfer10 fields   
  `uvm_object_utils_begin(spi_csr10)
    `uvm_field_int(n_ss_out10,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size10,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor10,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase10,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase10,        UVM_ALL_ON)
    `uvm_field_int(mode_select10,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel10,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word10,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word10, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable10,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This10 requires for registration10 of the ptp_tx_frame10   
  function new(string name = "spi_csr10");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int10();
    Copycfg_struct10();
  endfunction 

  // function to convert the 2 bit transfer_data_size10 to integer
  function void get_data_size_as_int10();
    case(transfer_data_size10)
      16'b00 : data_size10 = 128;
      default : data_size10 = int'(transfer_data_size10);
    endcase
     `uvm_info("SPI10 CSR10", $psprintf("data size is %d", data_size10), UVM_MEDIUM)
  endfunction : get_data_size_as_int10
    
  function void Copycfg_struct10();
    csr_s10.n_ss_out10            = n_ss_out10;
    csr_s10.transfer_data_size10  = transfer_data_size10;
    csr_s10.baud_rate_divisor10   = baud_rate_divisor10;
    csr_s10.tx_clk_phase10        = tx_clk_phase10;
    csr_s10.rx_clk_phase10        = rx_clk_phase10;
    csr_s10.mode_select10         = mode_select10;

    csr_s10.d_btwn_slave_sel10     = d_btwn_slave_sel10;
    csr_s10.d_btwn_word10          = d_btwn_word10;
    csr_s10.d_btwn_senable_word10  = d_btwn_senable_word10;

    csr_s10.spi_enable10      = spi_enable10;

    csr_s10.data_size10      = data_size10;
  endfunction

endclass : spi_csr10

`endif


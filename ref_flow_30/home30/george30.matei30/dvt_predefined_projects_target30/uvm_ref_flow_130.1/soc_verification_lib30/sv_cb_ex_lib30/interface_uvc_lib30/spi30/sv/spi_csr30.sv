/*-------------------------------------------------------------------------
File30 name   : spi_csr30.sv
Title30       : SPI30 SystemVerilog30 UVM UVC30
Project30     : SystemVerilog30 UVM Cluster30 Level30 Verification30
Created30     :
Description30 : 
Notes30       :  
---------------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV30
`define SPI_CSR_SV30

typedef struct packed {
  bit [7:0] n_ss_out30;
  bit [6:0] transfer_data_size30;
  bit [15:0] baud_rate_divisor30;
  bit tx_clk_phase30;
  bit rx_clk_phase30;
  bit mode_select30;

  bit tx_fifo_underflow30;
  bit rx_fifo_full30; 
  bit rx_fifo_not_empty30;
  bit tx_fifo_full30;
  bit tx_fifo_not_empty30;
  bit mode_fault30;
  bit rx_fifo_overrun30;

  bit spi_enable30;

  bit [7:0] d_btwn_slave_sel30;
  bit [7:0] d_btwn_word30;
  bit [7:0] d_btwn_senable_word30;

  int data_size30;
  } spi_csr_s30;

class spi_csr30 extends uvm_object;

  spi_csr_s30 csr_s30;

  //randomize SPI30 CSR30 fields
  rand bit [7:0] n_ss_out30;
  rand bit [6:0] transfer_data_size30;
  rand bit [15:0] baud_rate_divisor30;
  rand bit tx_clk_phase30;
  rand bit rx_clk_phase30;
  rand bit mode_select30;

  rand bit [7:0] d_btwn_slave_sel30;
  rand bit [7:0] d_btwn_word30;
  rand bit [7:0] d_btwn_senable_word30;

  rand bit spi_enable30;

  int data_size30;

  // this is a default constraint that could be overriden30
  // Constrain30 randomisation30 of configuration based on UVC30/RTL30 capabilities30
  constraint c_default_config30 {
    n_ss_out30           == 8'b01;
    transfer_data_size30 == 7'b0001000;
    baud_rate_divisor30  == 16'b0001;
    tx_clk_phase30       == 1'b0;
    rx_clk_phase30       == 1'b0;
    mode_select30        == 1'b1;

    d_btwn_slave_sel30   == 8'h00;
    d_btwn_word30        == 8'h00;
    d_btwn_senable_word30== 8'h00;

    spi_enable30         == 1'b1;
  }

  // These30 declarations30 implement the create() and get_type_name() as well30 as enable automation30 of the
  // transfer30 fields   
  `uvm_object_utils_begin(spi_csr30)
    `uvm_field_int(n_ss_out30,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size30,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor30,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase30,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase30,        UVM_ALL_ON)
    `uvm_field_int(mode_select30,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel30,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word30,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word30, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable30,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This30 requires for registration30 of the ptp_tx_frame30   
  function new(string name = "spi_csr30");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int30();
    Copycfg_struct30();
  endfunction 

  // function to convert the 2 bit transfer_data_size30 to integer
  function void get_data_size_as_int30();
    case(transfer_data_size30)
      16'b00 : data_size30 = 128;
      default : data_size30 = int'(transfer_data_size30);
    endcase
     `uvm_info("SPI30 CSR30", $psprintf("data size is %d", data_size30), UVM_MEDIUM)
  endfunction : get_data_size_as_int30
    
  function void Copycfg_struct30();
    csr_s30.n_ss_out30            = n_ss_out30;
    csr_s30.transfer_data_size30  = transfer_data_size30;
    csr_s30.baud_rate_divisor30   = baud_rate_divisor30;
    csr_s30.tx_clk_phase30        = tx_clk_phase30;
    csr_s30.rx_clk_phase30        = rx_clk_phase30;
    csr_s30.mode_select30         = mode_select30;

    csr_s30.d_btwn_slave_sel30     = d_btwn_slave_sel30;
    csr_s30.d_btwn_word30          = d_btwn_word30;
    csr_s30.d_btwn_senable_word30  = d_btwn_senable_word30;

    csr_s30.spi_enable30      = spi_enable30;

    csr_s30.data_size30      = data_size30;
  endfunction

endclass : spi_csr30

`endif


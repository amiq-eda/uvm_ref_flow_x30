/*-------------------------------------------------------------------------
File8 name   : spi_csr8.sv
Title8       : SPI8 SystemVerilog8 UVM UVC8
Project8     : SystemVerilog8 UVM Cluster8 Level8 Verification8
Created8     :
Description8 : 
Notes8       :  
---------------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV8
`define SPI_CSR_SV8

typedef struct packed {
  bit [7:0] n_ss_out8;
  bit [6:0] transfer_data_size8;
  bit [15:0] baud_rate_divisor8;
  bit tx_clk_phase8;
  bit rx_clk_phase8;
  bit mode_select8;

  bit tx_fifo_underflow8;
  bit rx_fifo_full8; 
  bit rx_fifo_not_empty8;
  bit tx_fifo_full8;
  bit tx_fifo_not_empty8;
  bit mode_fault8;
  bit rx_fifo_overrun8;

  bit spi_enable8;

  bit [7:0] d_btwn_slave_sel8;
  bit [7:0] d_btwn_word8;
  bit [7:0] d_btwn_senable_word8;

  int data_size8;
  } spi_csr_s8;

class spi_csr8 extends uvm_object;

  spi_csr_s8 csr_s8;

  //randomize SPI8 CSR8 fields
  rand bit [7:0] n_ss_out8;
  rand bit [6:0] transfer_data_size8;
  rand bit [15:0] baud_rate_divisor8;
  rand bit tx_clk_phase8;
  rand bit rx_clk_phase8;
  rand bit mode_select8;

  rand bit [7:0] d_btwn_slave_sel8;
  rand bit [7:0] d_btwn_word8;
  rand bit [7:0] d_btwn_senable_word8;

  rand bit spi_enable8;

  int data_size8;

  // this is a default constraint that could be overriden8
  // Constrain8 randomisation8 of configuration based on UVC8/RTL8 capabilities8
  constraint c_default_config8 {
    n_ss_out8           == 8'b01;
    transfer_data_size8 == 7'b0001000;
    baud_rate_divisor8  == 16'b0001;
    tx_clk_phase8       == 1'b0;
    rx_clk_phase8       == 1'b0;
    mode_select8        == 1'b1;

    d_btwn_slave_sel8   == 8'h00;
    d_btwn_word8        == 8'h00;
    d_btwn_senable_word8== 8'h00;

    spi_enable8         == 1'b1;
  }

  // These8 declarations8 implement the create() and get_type_name() as well8 as enable automation8 of the
  // transfer8 fields   
  `uvm_object_utils_begin(spi_csr8)
    `uvm_field_int(n_ss_out8,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size8,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor8,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase8,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase8,        UVM_ALL_ON)
    `uvm_field_int(mode_select8,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel8,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word8,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word8, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable8,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This8 requires for registration8 of the ptp_tx_frame8   
  function new(string name = "spi_csr8");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int8();
    Copycfg_struct8();
  endfunction 

  // function to convert the 2 bit transfer_data_size8 to integer
  function void get_data_size_as_int8();
    case(transfer_data_size8)
      16'b00 : data_size8 = 128;
      default : data_size8 = int'(transfer_data_size8);
    endcase
     `uvm_info("SPI8 CSR8", $psprintf("data size is %d", data_size8), UVM_MEDIUM)
  endfunction : get_data_size_as_int8
    
  function void Copycfg_struct8();
    csr_s8.n_ss_out8            = n_ss_out8;
    csr_s8.transfer_data_size8  = transfer_data_size8;
    csr_s8.baud_rate_divisor8   = baud_rate_divisor8;
    csr_s8.tx_clk_phase8        = tx_clk_phase8;
    csr_s8.rx_clk_phase8        = rx_clk_phase8;
    csr_s8.mode_select8         = mode_select8;

    csr_s8.d_btwn_slave_sel8     = d_btwn_slave_sel8;
    csr_s8.d_btwn_word8          = d_btwn_word8;
    csr_s8.d_btwn_senable_word8  = d_btwn_senable_word8;

    csr_s8.spi_enable8      = spi_enable8;

    csr_s8.data_size8      = data_size8;
  endfunction

endclass : spi_csr8

`endif


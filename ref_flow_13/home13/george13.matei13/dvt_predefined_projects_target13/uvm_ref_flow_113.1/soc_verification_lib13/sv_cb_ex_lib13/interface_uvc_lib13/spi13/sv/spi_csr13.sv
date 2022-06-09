/*-------------------------------------------------------------------------
File13 name   : spi_csr13.sv
Title13       : SPI13 SystemVerilog13 UVM UVC13
Project13     : SystemVerilog13 UVM Cluster13 Level13 Verification13
Created13     :
Description13 : 
Notes13       :  
---------------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV13
`define SPI_CSR_SV13

typedef struct packed {
  bit [7:0] n_ss_out13;
  bit [6:0] transfer_data_size13;
  bit [15:0] baud_rate_divisor13;
  bit tx_clk_phase13;
  bit rx_clk_phase13;
  bit mode_select13;

  bit tx_fifo_underflow13;
  bit rx_fifo_full13; 
  bit rx_fifo_not_empty13;
  bit tx_fifo_full13;
  bit tx_fifo_not_empty13;
  bit mode_fault13;
  bit rx_fifo_overrun13;

  bit spi_enable13;

  bit [7:0] d_btwn_slave_sel13;
  bit [7:0] d_btwn_word13;
  bit [7:0] d_btwn_senable_word13;

  int data_size13;
  } spi_csr_s13;

class spi_csr13 extends uvm_object;

  spi_csr_s13 csr_s13;

  //randomize SPI13 CSR13 fields
  rand bit [7:0] n_ss_out13;
  rand bit [6:0] transfer_data_size13;
  rand bit [15:0] baud_rate_divisor13;
  rand bit tx_clk_phase13;
  rand bit rx_clk_phase13;
  rand bit mode_select13;

  rand bit [7:0] d_btwn_slave_sel13;
  rand bit [7:0] d_btwn_word13;
  rand bit [7:0] d_btwn_senable_word13;

  rand bit spi_enable13;

  int data_size13;

  // this is a default constraint that could be overriden13
  // Constrain13 randomisation13 of configuration based on UVC13/RTL13 capabilities13
  constraint c_default_config13 {
    n_ss_out13           == 8'b01;
    transfer_data_size13 == 7'b0001000;
    baud_rate_divisor13  == 16'b0001;
    tx_clk_phase13       == 1'b0;
    rx_clk_phase13       == 1'b0;
    mode_select13        == 1'b1;

    d_btwn_slave_sel13   == 8'h00;
    d_btwn_word13        == 8'h00;
    d_btwn_senable_word13== 8'h00;

    spi_enable13         == 1'b1;
  }

  // These13 declarations13 implement the create() and get_type_name() as well13 as enable automation13 of the
  // transfer13 fields   
  `uvm_object_utils_begin(spi_csr13)
    `uvm_field_int(n_ss_out13,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size13,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor13,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase13,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase13,        UVM_ALL_ON)
    `uvm_field_int(mode_select13,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel13,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word13,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word13, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable13,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This13 requires for registration13 of the ptp_tx_frame13   
  function new(string name = "spi_csr13");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int13();
    Copycfg_struct13();
  endfunction 

  // function to convert the 2 bit transfer_data_size13 to integer
  function void get_data_size_as_int13();
    case(transfer_data_size13)
      16'b00 : data_size13 = 128;
      default : data_size13 = int'(transfer_data_size13);
    endcase
     `uvm_info("SPI13 CSR13", $psprintf("data size is %d", data_size13), UVM_MEDIUM)
  endfunction : get_data_size_as_int13
    
  function void Copycfg_struct13();
    csr_s13.n_ss_out13            = n_ss_out13;
    csr_s13.transfer_data_size13  = transfer_data_size13;
    csr_s13.baud_rate_divisor13   = baud_rate_divisor13;
    csr_s13.tx_clk_phase13        = tx_clk_phase13;
    csr_s13.rx_clk_phase13        = rx_clk_phase13;
    csr_s13.mode_select13         = mode_select13;

    csr_s13.d_btwn_slave_sel13     = d_btwn_slave_sel13;
    csr_s13.d_btwn_word13          = d_btwn_word13;
    csr_s13.d_btwn_senable_word13  = d_btwn_senable_word13;

    csr_s13.spi_enable13      = spi_enable13;

    csr_s13.data_size13      = data_size13;
  endfunction

endclass : spi_csr13

`endif


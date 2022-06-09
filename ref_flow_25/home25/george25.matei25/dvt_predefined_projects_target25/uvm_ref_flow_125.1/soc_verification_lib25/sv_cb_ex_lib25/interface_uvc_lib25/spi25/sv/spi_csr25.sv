/*-------------------------------------------------------------------------
File25 name   : spi_csr25.sv
Title25       : SPI25 SystemVerilog25 UVM UVC25
Project25     : SystemVerilog25 UVM Cluster25 Level25 Verification25
Created25     :
Description25 : 
Notes25       :  
---------------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV25
`define SPI_CSR_SV25

typedef struct packed {
  bit [7:0] n_ss_out25;
  bit [6:0] transfer_data_size25;
  bit [15:0] baud_rate_divisor25;
  bit tx_clk_phase25;
  bit rx_clk_phase25;
  bit mode_select25;

  bit tx_fifo_underflow25;
  bit rx_fifo_full25; 
  bit rx_fifo_not_empty25;
  bit tx_fifo_full25;
  bit tx_fifo_not_empty25;
  bit mode_fault25;
  bit rx_fifo_overrun25;

  bit spi_enable25;

  bit [7:0] d_btwn_slave_sel25;
  bit [7:0] d_btwn_word25;
  bit [7:0] d_btwn_senable_word25;

  int data_size25;
  } spi_csr_s25;

class spi_csr25 extends uvm_object;

  spi_csr_s25 csr_s25;

  //randomize SPI25 CSR25 fields
  rand bit [7:0] n_ss_out25;
  rand bit [6:0] transfer_data_size25;
  rand bit [15:0] baud_rate_divisor25;
  rand bit tx_clk_phase25;
  rand bit rx_clk_phase25;
  rand bit mode_select25;

  rand bit [7:0] d_btwn_slave_sel25;
  rand bit [7:0] d_btwn_word25;
  rand bit [7:0] d_btwn_senable_word25;

  rand bit spi_enable25;

  int data_size25;

  // this is a default constraint that could be overriden25
  // Constrain25 randomisation25 of configuration based on UVC25/RTL25 capabilities25
  constraint c_default_config25 {
    n_ss_out25           == 8'b01;
    transfer_data_size25 == 7'b0001000;
    baud_rate_divisor25  == 16'b0001;
    tx_clk_phase25       == 1'b0;
    rx_clk_phase25       == 1'b0;
    mode_select25        == 1'b1;

    d_btwn_slave_sel25   == 8'h00;
    d_btwn_word25        == 8'h00;
    d_btwn_senable_word25== 8'h00;

    spi_enable25         == 1'b1;
  }

  // These25 declarations25 implement the create() and get_type_name() as well25 as enable automation25 of the
  // transfer25 fields   
  `uvm_object_utils_begin(spi_csr25)
    `uvm_field_int(n_ss_out25,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size25,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor25,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase25,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase25,        UVM_ALL_ON)
    `uvm_field_int(mode_select25,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel25,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word25,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word25, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable25,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This25 requires for registration25 of the ptp_tx_frame25   
  function new(string name = "spi_csr25");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int25();
    Copycfg_struct25();
  endfunction 

  // function to convert the 2 bit transfer_data_size25 to integer
  function void get_data_size_as_int25();
    case(transfer_data_size25)
      16'b00 : data_size25 = 128;
      default : data_size25 = int'(transfer_data_size25);
    endcase
     `uvm_info("SPI25 CSR25", $psprintf("data size is %d", data_size25), UVM_MEDIUM)
  endfunction : get_data_size_as_int25
    
  function void Copycfg_struct25();
    csr_s25.n_ss_out25            = n_ss_out25;
    csr_s25.transfer_data_size25  = transfer_data_size25;
    csr_s25.baud_rate_divisor25   = baud_rate_divisor25;
    csr_s25.tx_clk_phase25        = tx_clk_phase25;
    csr_s25.rx_clk_phase25        = rx_clk_phase25;
    csr_s25.mode_select25         = mode_select25;

    csr_s25.d_btwn_slave_sel25     = d_btwn_slave_sel25;
    csr_s25.d_btwn_word25          = d_btwn_word25;
    csr_s25.d_btwn_senable_word25  = d_btwn_senable_word25;

    csr_s25.spi_enable25      = spi_enable25;

    csr_s25.data_size25      = data_size25;
  endfunction

endclass : spi_csr25

`endif


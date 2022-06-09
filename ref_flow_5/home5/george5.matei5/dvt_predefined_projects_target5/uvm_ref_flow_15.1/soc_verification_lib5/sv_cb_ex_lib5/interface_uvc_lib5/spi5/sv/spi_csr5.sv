/*-------------------------------------------------------------------------
File5 name   : spi_csr5.sv
Title5       : SPI5 SystemVerilog5 UVM UVC5
Project5     : SystemVerilog5 UVM Cluster5 Level5 Verification5
Created5     :
Description5 : 
Notes5       :  
---------------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV5
`define SPI_CSR_SV5

typedef struct packed {
  bit [7:0] n_ss_out5;
  bit [6:0] transfer_data_size5;
  bit [15:0] baud_rate_divisor5;
  bit tx_clk_phase5;
  bit rx_clk_phase5;
  bit mode_select5;

  bit tx_fifo_underflow5;
  bit rx_fifo_full5; 
  bit rx_fifo_not_empty5;
  bit tx_fifo_full5;
  bit tx_fifo_not_empty5;
  bit mode_fault5;
  bit rx_fifo_overrun5;

  bit spi_enable5;

  bit [7:0] d_btwn_slave_sel5;
  bit [7:0] d_btwn_word5;
  bit [7:0] d_btwn_senable_word5;

  int data_size5;
  } spi_csr_s5;

class spi_csr5 extends uvm_object;

  spi_csr_s5 csr_s5;

  //randomize SPI5 CSR5 fields
  rand bit [7:0] n_ss_out5;
  rand bit [6:0] transfer_data_size5;
  rand bit [15:0] baud_rate_divisor5;
  rand bit tx_clk_phase5;
  rand bit rx_clk_phase5;
  rand bit mode_select5;

  rand bit [7:0] d_btwn_slave_sel5;
  rand bit [7:0] d_btwn_word5;
  rand bit [7:0] d_btwn_senable_word5;

  rand bit spi_enable5;

  int data_size5;

  // this is a default constraint that could be overriden5
  // Constrain5 randomisation5 of configuration based on UVC5/RTL5 capabilities5
  constraint c_default_config5 {
    n_ss_out5           == 8'b01;
    transfer_data_size5 == 7'b0001000;
    baud_rate_divisor5  == 16'b0001;
    tx_clk_phase5       == 1'b0;
    rx_clk_phase5       == 1'b0;
    mode_select5        == 1'b1;

    d_btwn_slave_sel5   == 8'h00;
    d_btwn_word5        == 8'h00;
    d_btwn_senable_word5== 8'h00;

    spi_enable5         == 1'b1;
  }

  // These5 declarations5 implement the create() and get_type_name() as well5 as enable automation5 of the
  // transfer5 fields   
  `uvm_object_utils_begin(spi_csr5)
    `uvm_field_int(n_ss_out5,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size5,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor5,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase5,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase5,        UVM_ALL_ON)
    `uvm_field_int(mode_select5,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel5,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word5,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word5, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable5,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This5 requires for registration5 of the ptp_tx_frame5   
  function new(string name = "spi_csr5");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int5();
    Copycfg_struct5();
  endfunction 

  // function to convert the 2 bit transfer_data_size5 to integer
  function void get_data_size_as_int5();
    case(transfer_data_size5)
      16'b00 : data_size5 = 128;
      default : data_size5 = int'(transfer_data_size5);
    endcase
     `uvm_info("SPI5 CSR5", $psprintf("data size is %d", data_size5), UVM_MEDIUM)
  endfunction : get_data_size_as_int5
    
  function void Copycfg_struct5();
    csr_s5.n_ss_out5            = n_ss_out5;
    csr_s5.transfer_data_size5  = transfer_data_size5;
    csr_s5.baud_rate_divisor5   = baud_rate_divisor5;
    csr_s5.tx_clk_phase5        = tx_clk_phase5;
    csr_s5.rx_clk_phase5        = rx_clk_phase5;
    csr_s5.mode_select5         = mode_select5;

    csr_s5.d_btwn_slave_sel5     = d_btwn_slave_sel5;
    csr_s5.d_btwn_word5          = d_btwn_word5;
    csr_s5.d_btwn_senable_word5  = d_btwn_senable_word5;

    csr_s5.spi_enable5      = spi_enable5;

    csr_s5.data_size5      = data_size5;
  endfunction

endclass : spi_csr5

`endif


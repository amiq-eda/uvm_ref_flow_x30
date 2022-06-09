/*-------------------------------------------------------------------------
File14 name   : spi_csr14.sv
Title14       : SPI14 SystemVerilog14 UVM UVC14
Project14     : SystemVerilog14 UVM Cluster14 Level14 Verification14
Created14     :
Description14 : 
Notes14       :  
---------------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV14
`define SPI_CSR_SV14

typedef struct packed {
  bit [7:0] n_ss_out14;
  bit [6:0] transfer_data_size14;
  bit [15:0] baud_rate_divisor14;
  bit tx_clk_phase14;
  bit rx_clk_phase14;
  bit mode_select14;

  bit tx_fifo_underflow14;
  bit rx_fifo_full14; 
  bit rx_fifo_not_empty14;
  bit tx_fifo_full14;
  bit tx_fifo_not_empty14;
  bit mode_fault14;
  bit rx_fifo_overrun14;

  bit spi_enable14;

  bit [7:0] d_btwn_slave_sel14;
  bit [7:0] d_btwn_word14;
  bit [7:0] d_btwn_senable_word14;

  int data_size14;
  } spi_csr_s14;

class spi_csr14 extends uvm_object;

  spi_csr_s14 csr_s14;

  //randomize SPI14 CSR14 fields
  rand bit [7:0] n_ss_out14;
  rand bit [6:0] transfer_data_size14;
  rand bit [15:0] baud_rate_divisor14;
  rand bit tx_clk_phase14;
  rand bit rx_clk_phase14;
  rand bit mode_select14;

  rand bit [7:0] d_btwn_slave_sel14;
  rand bit [7:0] d_btwn_word14;
  rand bit [7:0] d_btwn_senable_word14;

  rand bit spi_enable14;

  int data_size14;

  // this is a default constraint that could be overriden14
  // Constrain14 randomisation14 of configuration based on UVC14/RTL14 capabilities14
  constraint c_default_config14 {
    n_ss_out14           == 8'b01;
    transfer_data_size14 == 7'b0001000;
    baud_rate_divisor14  == 16'b0001;
    tx_clk_phase14       == 1'b0;
    rx_clk_phase14       == 1'b0;
    mode_select14        == 1'b1;

    d_btwn_slave_sel14   == 8'h00;
    d_btwn_word14        == 8'h00;
    d_btwn_senable_word14== 8'h00;

    spi_enable14         == 1'b1;
  }

  // These14 declarations14 implement the create() and get_type_name() as well14 as enable automation14 of the
  // transfer14 fields   
  `uvm_object_utils_begin(spi_csr14)
    `uvm_field_int(n_ss_out14,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size14,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor14,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase14,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase14,        UVM_ALL_ON)
    `uvm_field_int(mode_select14,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel14,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word14,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word14, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable14,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This14 requires for registration14 of the ptp_tx_frame14   
  function new(string name = "spi_csr14");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int14();
    Copycfg_struct14();
  endfunction 

  // function to convert the 2 bit transfer_data_size14 to integer
  function void get_data_size_as_int14();
    case(transfer_data_size14)
      16'b00 : data_size14 = 128;
      default : data_size14 = int'(transfer_data_size14);
    endcase
     `uvm_info("SPI14 CSR14", $psprintf("data size is %d", data_size14), UVM_MEDIUM)
  endfunction : get_data_size_as_int14
    
  function void Copycfg_struct14();
    csr_s14.n_ss_out14            = n_ss_out14;
    csr_s14.transfer_data_size14  = transfer_data_size14;
    csr_s14.baud_rate_divisor14   = baud_rate_divisor14;
    csr_s14.tx_clk_phase14        = tx_clk_phase14;
    csr_s14.rx_clk_phase14        = rx_clk_phase14;
    csr_s14.mode_select14         = mode_select14;

    csr_s14.d_btwn_slave_sel14     = d_btwn_slave_sel14;
    csr_s14.d_btwn_word14          = d_btwn_word14;
    csr_s14.d_btwn_senable_word14  = d_btwn_senable_word14;

    csr_s14.spi_enable14      = spi_enable14;

    csr_s14.data_size14      = data_size14;
  endfunction

endclass : spi_csr14

`endif


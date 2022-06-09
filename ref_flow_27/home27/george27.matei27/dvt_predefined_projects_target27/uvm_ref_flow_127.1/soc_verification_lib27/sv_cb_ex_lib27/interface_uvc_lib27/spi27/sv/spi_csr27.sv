/*-------------------------------------------------------------------------
File27 name   : spi_csr27.sv
Title27       : SPI27 SystemVerilog27 UVM UVC27
Project27     : SystemVerilog27 UVM Cluster27 Level27 Verification27
Created27     :
Description27 : 
Notes27       :  
---------------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV27
`define SPI_CSR_SV27

typedef struct packed {
  bit [7:0] n_ss_out27;
  bit [6:0] transfer_data_size27;
  bit [15:0] baud_rate_divisor27;
  bit tx_clk_phase27;
  bit rx_clk_phase27;
  bit mode_select27;

  bit tx_fifo_underflow27;
  bit rx_fifo_full27; 
  bit rx_fifo_not_empty27;
  bit tx_fifo_full27;
  bit tx_fifo_not_empty27;
  bit mode_fault27;
  bit rx_fifo_overrun27;

  bit spi_enable27;

  bit [7:0] d_btwn_slave_sel27;
  bit [7:0] d_btwn_word27;
  bit [7:0] d_btwn_senable_word27;

  int data_size27;
  } spi_csr_s27;

class spi_csr27 extends uvm_object;

  spi_csr_s27 csr_s27;

  //randomize SPI27 CSR27 fields
  rand bit [7:0] n_ss_out27;
  rand bit [6:0] transfer_data_size27;
  rand bit [15:0] baud_rate_divisor27;
  rand bit tx_clk_phase27;
  rand bit rx_clk_phase27;
  rand bit mode_select27;

  rand bit [7:0] d_btwn_slave_sel27;
  rand bit [7:0] d_btwn_word27;
  rand bit [7:0] d_btwn_senable_word27;

  rand bit spi_enable27;

  int data_size27;

  // this is a default constraint that could be overriden27
  // Constrain27 randomisation27 of configuration based on UVC27/RTL27 capabilities27
  constraint c_default_config27 {
    n_ss_out27           == 8'b01;
    transfer_data_size27 == 7'b0001000;
    baud_rate_divisor27  == 16'b0001;
    tx_clk_phase27       == 1'b0;
    rx_clk_phase27       == 1'b0;
    mode_select27        == 1'b1;

    d_btwn_slave_sel27   == 8'h00;
    d_btwn_word27        == 8'h00;
    d_btwn_senable_word27== 8'h00;

    spi_enable27         == 1'b1;
  }

  // These27 declarations27 implement the create() and get_type_name() as well27 as enable automation27 of the
  // transfer27 fields   
  `uvm_object_utils_begin(spi_csr27)
    `uvm_field_int(n_ss_out27,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size27,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor27,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase27,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase27,        UVM_ALL_ON)
    `uvm_field_int(mode_select27,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel27,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word27,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word27, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable27,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This27 requires for registration27 of the ptp_tx_frame27   
  function new(string name = "spi_csr27");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int27();
    Copycfg_struct27();
  endfunction 

  // function to convert the 2 bit transfer_data_size27 to integer
  function void get_data_size_as_int27();
    case(transfer_data_size27)
      16'b00 : data_size27 = 128;
      default : data_size27 = int'(transfer_data_size27);
    endcase
     `uvm_info("SPI27 CSR27", $psprintf("data size is %d", data_size27), UVM_MEDIUM)
  endfunction : get_data_size_as_int27
    
  function void Copycfg_struct27();
    csr_s27.n_ss_out27            = n_ss_out27;
    csr_s27.transfer_data_size27  = transfer_data_size27;
    csr_s27.baud_rate_divisor27   = baud_rate_divisor27;
    csr_s27.tx_clk_phase27        = tx_clk_phase27;
    csr_s27.rx_clk_phase27        = rx_clk_phase27;
    csr_s27.mode_select27         = mode_select27;

    csr_s27.d_btwn_slave_sel27     = d_btwn_slave_sel27;
    csr_s27.d_btwn_word27          = d_btwn_word27;
    csr_s27.d_btwn_senable_word27  = d_btwn_senable_word27;

    csr_s27.spi_enable27      = spi_enable27;

    csr_s27.data_size27      = data_size27;
  endfunction

endclass : spi_csr27

`endif


/*-------------------------------------------------------------------------
File28 name   : spi_csr28.sv
Title28       : SPI28 SystemVerilog28 UVM UVC28
Project28     : SystemVerilog28 UVM Cluster28 Level28 Verification28
Created28     :
Description28 : 
Notes28       :  
---------------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV28
`define SPI_CSR_SV28

typedef struct packed {
  bit [7:0] n_ss_out28;
  bit [6:0] transfer_data_size28;
  bit [15:0] baud_rate_divisor28;
  bit tx_clk_phase28;
  bit rx_clk_phase28;
  bit mode_select28;

  bit tx_fifo_underflow28;
  bit rx_fifo_full28; 
  bit rx_fifo_not_empty28;
  bit tx_fifo_full28;
  bit tx_fifo_not_empty28;
  bit mode_fault28;
  bit rx_fifo_overrun28;

  bit spi_enable28;

  bit [7:0] d_btwn_slave_sel28;
  bit [7:0] d_btwn_word28;
  bit [7:0] d_btwn_senable_word28;

  int data_size28;
  } spi_csr_s28;

class spi_csr28 extends uvm_object;

  spi_csr_s28 csr_s28;

  //randomize SPI28 CSR28 fields
  rand bit [7:0] n_ss_out28;
  rand bit [6:0] transfer_data_size28;
  rand bit [15:0] baud_rate_divisor28;
  rand bit tx_clk_phase28;
  rand bit rx_clk_phase28;
  rand bit mode_select28;

  rand bit [7:0] d_btwn_slave_sel28;
  rand bit [7:0] d_btwn_word28;
  rand bit [7:0] d_btwn_senable_word28;

  rand bit spi_enable28;

  int data_size28;

  // this is a default constraint that could be overriden28
  // Constrain28 randomisation28 of configuration based on UVC28/RTL28 capabilities28
  constraint c_default_config28 {
    n_ss_out28           == 8'b01;
    transfer_data_size28 == 7'b0001000;
    baud_rate_divisor28  == 16'b0001;
    tx_clk_phase28       == 1'b0;
    rx_clk_phase28       == 1'b0;
    mode_select28        == 1'b1;

    d_btwn_slave_sel28   == 8'h00;
    d_btwn_word28        == 8'h00;
    d_btwn_senable_word28== 8'h00;

    spi_enable28         == 1'b1;
  }

  // These28 declarations28 implement the create() and get_type_name() as well28 as enable automation28 of the
  // transfer28 fields   
  `uvm_object_utils_begin(spi_csr28)
    `uvm_field_int(n_ss_out28,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size28,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor28,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase28,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase28,        UVM_ALL_ON)
    `uvm_field_int(mode_select28,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel28,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word28,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word28, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable28,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This28 requires for registration28 of the ptp_tx_frame28   
  function new(string name = "spi_csr28");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int28();
    Copycfg_struct28();
  endfunction 

  // function to convert the 2 bit transfer_data_size28 to integer
  function void get_data_size_as_int28();
    case(transfer_data_size28)
      16'b00 : data_size28 = 128;
      default : data_size28 = int'(transfer_data_size28);
    endcase
     `uvm_info("SPI28 CSR28", $psprintf("data size is %d", data_size28), UVM_MEDIUM)
  endfunction : get_data_size_as_int28
    
  function void Copycfg_struct28();
    csr_s28.n_ss_out28            = n_ss_out28;
    csr_s28.transfer_data_size28  = transfer_data_size28;
    csr_s28.baud_rate_divisor28   = baud_rate_divisor28;
    csr_s28.tx_clk_phase28        = tx_clk_phase28;
    csr_s28.rx_clk_phase28        = rx_clk_phase28;
    csr_s28.mode_select28         = mode_select28;

    csr_s28.d_btwn_slave_sel28     = d_btwn_slave_sel28;
    csr_s28.d_btwn_word28          = d_btwn_word28;
    csr_s28.d_btwn_senable_word28  = d_btwn_senable_word28;

    csr_s28.spi_enable28      = spi_enable28;

    csr_s28.data_size28      = data_size28;
  endfunction

endclass : spi_csr28

`endif


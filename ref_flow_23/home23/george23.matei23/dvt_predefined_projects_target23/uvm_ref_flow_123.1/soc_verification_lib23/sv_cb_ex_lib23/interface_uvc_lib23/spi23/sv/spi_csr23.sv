/*-------------------------------------------------------------------------
File23 name   : spi_csr23.sv
Title23       : SPI23 SystemVerilog23 UVM UVC23
Project23     : SystemVerilog23 UVM Cluster23 Level23 Verification23
Created23     :
Description23 : 
Notes23       :  
---------------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV23
`define SPI_CSR_SV23

typedef struct packed {
  bit [7:0] n_ss_out23;
  bit [6:0] transfer_data_size23;
  bit [15:0] baud_rate_divisor23;
  bit tx_clk_phase23;
  bit rx_clk_phase23;
  bit mode_select23;

  bit tx_fifo_underflow23;
  bit rx_fifo_full23; 
  bit rx_fifo_not_empty23;
  bit tx_fifo_full23;
  bit tx_fifo_not_empty23;
  bit mode_fault23;
  bit rx_fifo_overrun23;

  bit spi_enable23;

  bit [7:0] d_btwn_slave_sel23;
  bit [7:0] d_btwn_word23;
  bit [7:0] d_btwn_senable_word23;

  int data_size23;
  } spi_csr_s23;

class spi_csr23 extends uvm_object;

  spi_csr_s23 csr_s23;

  //randomize SPI23 CSR23 fields
  rand bit [7:0] n_ss_out23;
  rand bit [6:0] transfer_data_size23;
  rand bit [15:0] baud_rate_divisor23;
  rand bit tx_clk_phase23;
  rand bit rx_clk_phase23;
  rand bit mode_select23;

  rand bit [7:0] d_btwn_slave_sel23;
  rand bit [7:0] d_btwn_word23;
  rand bit [7:0] d_btwn_senable_word23;

  rand bit spi_enable23;

  int data_size23;

  // this is a default constraint that could be overriden23
  // Constrain23 randomisation23 of configuration based on UVC23/RTL23 capabilities23
  constraint c_default_config23 {
    n_ss_out23           == 8'b01;
    transfer_data_size23 == 7'b0001000;
    baud_rate_divisor23  == 16'b0001;
    tx_clk_phase23       == 1'b0;
    rx_clk_phase23       == 1'b0;
    mode_select23        == 1'b1;

    d_btwn_slave_sel23   == 8'h00;
    d_btwn_word23        == 8'h00;
    d_btwn_senable_word23== 8'h00;

    spi_enable23         == 1'b1;
  }

  // These23 declarations23 implement the create() and get_type_name() as well23 as enable automation23 of the
  // transfer23 fields   
  `uvm_object_utils_begin(spi_csr23)
    `uvm_field_int(n_ss_out23,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size23,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor23,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase23,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase23,        UVM_ALL_ON)
    `uvm_field_int(mode_select23,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel23,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word23,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word23, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable23,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This23 requires for registration23 of the ptp_tx_frame23   
  function new(string name = "spi_csr23");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int23();
    Copycfg_struct23();
  endfunction 

  // function to convert the 2 bit transfer_data_size23 to integer
  function void get_data_size_as_int23();
    case(transfer_data_size23)
      16'b00 : data_size23 = 128;
      default : data_size23 = int'(transfer_data_size23);
    endcase
     `uvm_info("SPI23 CSR23", $psprintf("data size is %d", data_size23), UVM_MEDIUM)
  endfunction : get_data_size_as_int23
    
  function void Copycfg_struct23();
    csr_s23.n_ss_out23            = n_ss_out23;
    csr_s23.transfer_data_size23  = transfer_data_size23;
    csr_s23.baud_rate_divisor23   = baud_rate_divisor23;
    csr_s23.tx_clk_phase23        = tx_clk_phase23;
    csr_s23.rx_clk_phase23        = rx_clk_phase23;
    csr_s23.mode_select23         = mode_select23;

    csr_s23.d_btwn_slave_sel23     = d_btwn_slave_sel23;
    csr_s23.d_btwn_word23          = d_btwn_word23;
    csr_s23.d_btwn_senable_word23  = d_btwn_senable_word23;

    csr_s23.spi_enable23      = spi_enable23;

    csr_s23.data_size23      = data_size23;
  endfunction

endclass : spi_csr23

`endif


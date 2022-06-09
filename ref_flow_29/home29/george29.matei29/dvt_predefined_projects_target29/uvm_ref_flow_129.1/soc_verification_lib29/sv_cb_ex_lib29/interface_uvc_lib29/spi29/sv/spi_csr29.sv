/*-------------------------------------------------------------------------
File29 name   : spi_csr29.sv
Title29       : SPI29 SystemVerilog29 UVM UVC29
Project29     : SystemVerilog29 UVM Cluster29 Level29 Verification29
Created29     :
Description29 : 
Notes29       :  
---------------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV29
`define SPI_CSR_SV29

typedef struct packed {
  bit [7:0] n_ss_out29;
  bit [6:0] transfer_data_size29;
  bit [15:0] baud_rate_divisor29;
  bit tx_clk_phase29;
  bit rx_clk_phase29;
  bit mode_select29;

  bit tx_fifo_underflow29;
  bit rx_fifo_full29; 
  bit rx_fifo_not_empty29;
  bit tx_fifo_full29;
  bit tx_fifo_not_empty29;
  bit mode_fault29;
  bit rx_fifo_overrun29;

  bit spi_enable29;

  bit [7:0] d_btwn_slave_sel29;
  bit [7:0] d_btwn_word29;
  bit [7:0] d_btwn_senable_word29;

  int data_size29;
  } spi_csr_s29;

class spi_csr29 extends uvm_object;

  spi_csr_s29 csr_s29;

  //randomize SPI29 CSR29 fields
  rand bit [7:0] n_ss_out29;
  rand bit [6:0] transfer_data_size29;
  rand bit [15:0] baud_rate_divisor29;
  rand bit tx_clk_phase29;
  rand bit rx_clk_phase29;
  rand bit mode_select29;

  rand bit [7:0] d_btwn_slave_sel29;
  rand bit [7:0] d_btwn_word29;
  rand bit [7:0] d_btwn_senable_word29;

  rand bit spi_enable29;

  int data_size29;

  // this is a default constraint that could be overriden29
  // Constrain29 randomisation29 of configuration based on UVC29/RTL29 capabilities29
  constraint c_default_config29 {
    n_ss_out29           == 8'b01;
    transfer_data_size29 == 7'b0001000;
    baud_rate_divisor29  == 16'b0001;
    tx_clk_phase29       == 1'b0;
    rx_clk_phase29       == 1'b0;
    mode_select29        == 1'b1;

    d_btwn_slave_sel29   == 8'h00;
    d_btwn_word29        == 8'h00;
    d_btwn_senable_word29== 8'h00;

    spi_enable29         == 1'b1;
  }

  // These29 declarations29 implement the create() and get_type_name() as well29 as enable automation29 of the
  // transfer29 fields   
  `uvm_object_utils_begin(spi_csr29)
    `uvm_field_int(n_ss_out29,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size29,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor29,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase29,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase29,        UVM_ALL_ON)
    `uvm_field_int(mode_select29,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel29,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word29,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word29, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable29,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This29 requires for registration29 of the ptp_tx_frame29   
  function new(string name = "spi_csr29");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int29();
    Copycfg_struct29();
  endfunction 

  // function to convert the 2 bit transfer_data_size29 to integer
  function void get_data_size_as_int29();
    case(transfer_data_size29)
      16'b00 : data_size29 = 128;
      default : data_size29 = int'(transfer_data_size29);
    endcase
     `uvm_info("SPI29 CSR29", $psprintf("data size is %d", data_size29), UVM_MEDIUM)
  endfunction : get_data_size_as_int29
    
  function void Copycfg_struct29();
    csr_s29.n_ss_out29            = n_ss_out29;
    csr_s29.transfer_data_size29  = transfer_data_size29;
    csr_s29.baud_rate_divisor29   = baud_rate_divisor29;
    csr_s29.tx_clk_phase29        = tx_clk_phase29;
    csr_s29.rx_clk_phase29        = rx_clk_phase29;
    csr_s29.mode_select29         = mode_select29;

    csr_s29.d_btwn_slave_sel29     = d_btwn_slave_sel29;
    csr_s29.d_btwn_word29          = d_btwn_word29;
    csr_s29.d_btwn_senable_word29  = d_btwn_senable_word29;

    csr_s29.spi_enable29      = spi_enable29;

    csr_s29.data_size29      = data_size29;
  endfunction

endclass : spi_csr29

`endif


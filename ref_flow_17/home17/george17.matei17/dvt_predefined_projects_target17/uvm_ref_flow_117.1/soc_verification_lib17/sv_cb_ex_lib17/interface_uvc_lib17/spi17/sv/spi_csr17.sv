/*-------------------------------------------------------------------------
File17 name   : spi_csr17.sv
Title17       : SPI17 SystemVerilog17 UVM UVC17
Project17     : SystemVerilog17 UVM Cluster17 Level17 Verification17
Created17     :
Description17 : 
Notes17       :  
---------------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV17
`define SPI_CSR_SV17

typedef struct packed {
  bit [7:0] n_ss_out17;
  bit [6:0] transfer_data_size17;
  bit [15:0] baud_rate_divisor17;
  bit tx_clk_phase17;
  bit rx_clk_phase17;
  bit mode_select17;

  bit tx_fifo_underflow17;
  bit rx_fifo_full17; 
  bit rx_fifo_not_empty17;
  bit tx_fifo_full17;
  bit tx_fifo_not_empty17;
  bit mode_fault17;
  bit rx_fifo_overrun17;

  bit spi_enable17;

  bit [7:0] d_btwn_slave_sel17;
  bit [7:0] d_btwn_word17;
  bit [7:0] d_btwn_senable_word17;

  int data_size17;
  } spi_csr_s17;

class spi_csr17 extends uvm_object;

  spi_csr_s17 csr_s17;

  //randomize SPI17 CSR17 fields
  rand bit [7:0] n_ss_out17;
  rand bit [6:0] transfer_data_size17;
  rand bit [15:0] baud_rate_divisor17;
  rand bit tx_clk_phase17;
  rand bit rx_clk_phase17;
  rand bit mode_select17;

  rand bit [7:0] d_btwn_slave_sel17;
  rand bit [7:0] d_btwn_word17;
  rand bit [7:0] d_btwn_senable_word17;

  rand bit spi_enable17;

  int data_size17;

  // this is a default constraint that could be overriden17
  // Constrain17 randomisation17 of configuration based on UVC17/RTL17 capabilities17
  constraint c_default_config17 {
    n_ss_out17           == 8'b01;
    transfer_data_size17 == 7'b0001000;
    baud_rate_divisor17  == 16'b0001;
    tx_clk_phase17       == 1'b0;
    rx_clk_phase17       == 1'b0;
    mode_select17        == 1'b1;

    d_btwn_slave_sel17   == 8'h00;
    d_btwn_word17        == 8'h00;
    d_btwn_senable_word17== 8'h00;

    spi_enable17         == 1'b1;
  }

  // These17 declarations17 implement the create() and get_type_name() as well17 as enable automation17 of the
  // transfer17 fields   
  `uvm_object_utils_begin(spi_csr17)
    `uvm_field_int(n_ss_out17,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size17,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor17,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase17,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase17,        UVM_ALL_ON)
    `uvm_field_int(mode_select17,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel17,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word17,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word17, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable17,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This17 requires for registration17 of the ptp_tx_frame17   
  function new(string name = "spi_csr17");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int17();
    Copycfg_struct17();
  endfunction 

  // function to convert the 2 bit transfer_data_size17 to integer
  function void get_data_size_as_int17();
    case(transfer_data_size17)
      16'b00 : data_size17 = 128;
      default : data_size17 = int'(transfer_data_size17);
    endcase
     `uvm_info("SPI17 CSR17", $psprintf("data size is %d", data_size17), UVM_MEDIUM)
  endfunction : get_data_size_as_int17
    
  function void Copycfg_struct17();
    csr_s17.n_ss_out17            = n_ss_out17;
    csr_s17.transfer_data_size17  = transfer_data_size17;
    csr_s17.baud_rate_divisor17   = baud_rate_divisor17;
    csr_s17.tx_clk_phase17        = tx_clk_phase17;
    csr_s17.rx_clk_phase17        = rx_clk_phase17;
    csr_s17.mode_select17         = mode_select17;

    csr_s17.d_btwn_slave_sel17     = d_btwn_slave_sel17;
    csr_s17.d_btwn_word17          = d_btwn_word17;
    csr_s17.d_btwn_senable_word17  = d_btwn_senable_word17;

    csr_s17.spi_enable17      = spi_enable17;

    csr_s17.data_size17      = data_size17;
  endfunction

endclass : spi_csr17

`endif


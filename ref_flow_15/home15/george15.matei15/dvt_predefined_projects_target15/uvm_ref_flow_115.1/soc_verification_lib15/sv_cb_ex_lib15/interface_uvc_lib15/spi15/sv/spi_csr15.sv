/*-------------------------------------------------------------------------
File15 name   : spi_csr15.sv
Title15       : SPI15 SystemVerilog15 UVM UVC15
Project15     : SystemVerilog15 UVM Cluster15 Level15 Verification15
Created15     :
Description15 : 
Notes15       :  
---------------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV15
`define SPI_CSR_SV15

typedef struct packed {
  bit [7:0] n_ss_out15;
  bit [6:0] transfer_data_size15;
  bit [15:0] baud_rate_divisor15;
  bit tx_clk_phase15;
  bit rx_clk_phase15;
  bit mode_select15;

  bit tx_fifo_underflow15;
  bit rx_fifo_full15; 
  bit rx_fifo_not_empty15;
  bit tx_fifo_full15;
  bit tx_fifo_not_empty15;
  bit mode_fault15;
  bit rx_fifo_overrun15;

  bit spi_enable15;

  bit [7:0] d_btwn_slave_sel15;
  bit [7:0] d_btwn_word15;
  bit [7:0] d_btwn_senable_word15;

  int data_size15;
  } spi_csr_s15;

class spi_csr15 extends uvm_object;

  spi_csr_s15 csr_s15;

  //randomize SPI15 CSR15 fields
  rand bit [7:0] n_ss_out15;
  rand bit [6:0] transfer_data_size15;
  rand bit [15:0] baud_rate_divisor15;
  rand bit tx_clk_phase15;
  rand bit rx_clk_phase15;
  rand bit mode_select15;

  rand bit [7:0] d_btwn_slave_sel15;
  rand bit [7:0] d_btwn_word15;
  rand bit [7:0] d_btwn_senable_word15;

  rand bit spi_enable15;

  int data_size15;

  // this is a default constraint that could be overriden15
  // Constrain15 randomisation15 of configuration based on UVC15/RTL15 capabilities15
  constraint c_default_config15 {
    n_ss_out15           == 8'b01;
    transfer_data_size15 == 7'b0001000;
    baud_rate_divisor15  == 16'b0001;
    tx_clk_phase15       == 1'b0;
    rx_clk_phase15       == 1'b0;
    mode_select15        == 1'b1;

    d_btwn_slave_sel15   == 8'h00;
    d_btwn_word15        == 8'h00;
    d_btwn_senable_word15== 8'h00;

    spi_enable15         == 1'b1;
  }

  // These15 declarations15 implement the create() and get_type_name() as well15 as enable automation15 of the
  // transfer15 fields   
  `uvm_object_utils_begin(spi_csr15)
    `uvm_field_int(n_ss_out15,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size15,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor15,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase15,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase15,        UVM_ALL_ON)
    `uvm_field_int(mode_select15,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel15,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word15,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word15, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable15,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This15 requires for registration15 of the ptp_tx_frame15   
  function new(string name = "spi_csr15");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int15();
    Copycfg_struct15();
  endfunction 

  // function to convert the 2 bit transfer_data_size15 to integer
  function void get_data_size_as_int15();
    case(transfer_data_size15)
      16'b00 : data_size15 = 128;
      default : data_size15 = int'(transfer_data_size15);
    endcase
     `uvm_info("SPI15 CSR15", $psprintf("data size is %d", data_size15), UVM_MEDIUM)
  endfunction : get_data_size_as_int15
    
  function void Copycfg_struct15();
    csr_s15.n_ss_out15            = n_ss_out15;
    csr_s15.transfer_data_size15  = transfer_data_size15;
    csr_s15.baud_rate_divisor15   = baud_rate_divisor15;
    csr_s15.tx_clk_phase15        = tx_clk_phase15;
    csr_s15.rx_clk_phase15        = rx_clk_phase15;
    csr_s15.mode_select15         = mode_select15;

    csr_s15.d_btwn_slave_sel15     = d_btwn_slave_sel15;
    csr_s15.d_btwn_word15          = d_btwn_word15;
    csr_s15.d_btwn_senable_word15  = d_btwn_senable_word15;

    csr_s15.spi_enable15      = spi_enable15;

    csr_s15.data_size15      = data_size15;
  endfunction

endclass : spi_csr15

`endif


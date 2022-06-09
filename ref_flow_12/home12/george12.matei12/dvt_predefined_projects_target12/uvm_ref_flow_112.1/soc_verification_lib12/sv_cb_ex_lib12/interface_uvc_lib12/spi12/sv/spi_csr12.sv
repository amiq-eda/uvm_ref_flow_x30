/*-------------------------------------------------------------------------
File12 name   : spi_csr12.sv
Title12       : SPI12 SystemVerilog12 UVM UVC12
Project12     : SystemVerilog12 UVM Cluster12 Level12 Verification12
Created12     :
Description12 : 
Notes12       :  
---------------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV12
`define SPI_CSR_SV12

typedef struct packed {
  bit [7:0] n_ss_out12;
  bit [6:0] transfer_data_size12;
  bit [15:0] baud_rate_divisor12;
  bit tx_clk_phase12;
  bit rx_clk_phase12;
  bit mode_select12;

  bit tx_fifo_underflow12;
  bit rx_fifo_full12; 
  bit rx_fifo_not_empty12;
  bit tx_fifo_full12;
  bit tx_fifo_not_empty12;
  bit mode_fault12;
  bit rx_fifo_overrun12;

  bit spi_enable12;

  bit [7:0] d_btwn_slave_sel12;
  bit [7:0] d_btwn_word12;
  bit [7:0] d_btwn_senable_word12;

  int data_size12;
  } spi_csr_s12;

class spi_csr12 extends uvm_object;

  spi_csr_s12 csr_s12;

  //randomize SPI12 CSR12 fields
  rand bit [7:0] n_ss_out12;
  rand bit [6:0] transfer_data_size12;
  rand bit [15:0] baud_rate_divisor12;
  rand bit tx_clk_phase12;
  rand bit rx_clk_phase12;
  rand bit mode_select12;

  rand bit [7:0] d_btwn_slave_sel12;
  rand bit [7:0] d_btwn_word12;
  rand bit [7:0] d_btwn_senable_word12;

  rand bit spi_enable12;

  int data_size12;

  // this is a default constraint that could be overriden12
  // Constrain12 randomisation12 of configuration based on UVC12/RTL12 capabilities12
  constraint c_default_config12 {
    n_ss_out12           == 8'b01;
    transfer_data_size12 == 7'b0001000;
    baud_rate_divisor12  == 16'b0001;
    tx_clk_phase12       == 1'b0;
    rx_clk_phase12       == 1'b0;
    mode_select12        == 1'b1;

    d_btwn_slave_sel12   == 8'h00;
    d_btwn_word12        == 8'h00;
    d_btwn_senable_word12== 8'h00;

    spi_enable12         == 1'b1;
  }

  // These12 declarations12 implement the create() and get_type_name() as well12 as enable automation12 of the
  // transfer12 fields   
  `uvm_object_utils_begin(spi_csr12)
    `uvm_field_int(n_ss_out12,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size12,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor12,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase12,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase12,        UVM_ALL_ON)
    `uvm_field_int(mode_select12,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel12,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word12,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word12, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable12,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This12 requires for registration12 of the ptp_tx_frame12   
  function new(string name = "spi_csr12");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int12();
    Copycfg_struct12();
  endfunction 

  // function to convert the 2 bit transfer_data_size12 to integer
  function void get_data_size_as_int12();
    case(transfer_data_size12)
      16'b00 : data_size12 = 128;
      default : data_size12 = int'(transfer_data_size12);
    endcase
     `uvm_info("SPI12 CSR12", $psprintf("data size is %d", data_size12), UVM_MEDIUM)
  endfunction : get_data_size_as_int12
    
  function void Copycfg_struct12();
    csr_s12.n_ss_out12            = n_ss_out12;
    csr_s12.transfer_data_size12  = transfer_data_size12;
    csr_s12.baud_rate_divisor12   = baud_rate_divisor12;
    csr_s12.tx_clk_phase12        = tx_clk_phase12;
    csr_s12.rx_clk_phase12        = rx_clk_phase12;
    csr_s12.mode_select12         = mode_select12;

    csr_s12.d_btwn_slave_sel12     = d_btwn_slave_sel12;
    csr_s12.d_btwn_word12          = d_btwn_word12;
    csr_s12.d_btwn_senable_word12  = d_btwn_senable_word12;

    csr_s12.spi_enable12      = spi_enable12;

    csr_s12.data_size12      = data_size12;
  endfunction

endclass : spi_csr12

`endif


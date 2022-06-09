/*-------------------------------------------------------------------------
File11 name   : spi_csr11.sv
Title11       : SPI11 SystemVerilog11 UVM UVC11
Project11     : SystemVerilog11 UVM Cluster11 Level11 Verification11
Created11     :
Description11 : 
Notes11       :  
---------------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV11
`define SPI_CSR_SV11

typedef struct packed {
  bit [7:0] n_ss_out11;
  bit [6:0] transfer_data_size11;
  bit [15:0] baud_rate_divisor11;
  bit tx_clk_phase11;
  bit rx_clk_phase11;
  bit mode_select11;

  bit tx_fifo_underflow11;
  bit rx_fifo_full11; 
  bit rx_fifo_not_empty11;
  bit tx_fifo_full11;
  bit tx_fifo_not_empty11;
  bit mode_fault11;
  bit rx_fifo_overrun11;

  bit spi_enable11;

  bit [7:0] d_btwn_slave_sel11;
  bit [7:0] d_btwn_word11;
  bit [7:0] d_btwn_senable_word11;

  int data_size11;
  } spi_csr_s11;

class spi_csr11 extends uvm_object;

  spi_csr_s11 csr_s11;

  //randomize SPI11 CSR11 fields
  rand bit [7:0] n_ss_out11;
  rand bit [6:0] transfer_data_size11;
  rand bit [15:0] baud_rate_divisor11;
  rand bit tx_clk_phase11;
  rand bit rx_clk_phase11;
  rand bit mode_select11;

  rand bit [7:0] d_btwn_slave_sel11;
  rand bit [7:0] d_btwn_word11;
  rand bit [7:0] d_btwn_senable_word11;

  rand bit spi_enable11;

  int data_size11;

  // this is a default constraint that could be overriden11
  // Constrain11 randomisation11 of configuration based on UVC11/RTL11 capabilities11
  constraint c_default_config11 {
    n_ss_out11           == 8'b01;
    transfer_data_size11 == 7'b0001000;
    baud_rate_divisor11  == 16'b0001;
    tx_clk_phase11       == 1'b0;
    rx_clk_phase11       == 1'b0;
    mode_select11        == 1'b1;

    d_btwn_slave_sel11   == 8'h00;
    d_btwn_word11        == 8'h00;
    d_btwn_senable_word11== 8'h00;

    spi_enable11         == 1'b1;
  }

  // These11 declarations11 implement the create() and get_type_name() as well11 as enable automation11 of the
  // transfer11 fields   
  `uvm_object_utils_begin(spi_csr11)
    `uvm_field_int(n_ss_out11,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size11,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor11,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase11,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase11,        UVM_ALL_ON)
    `uvm_field_int(mode_select11,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel11,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word11,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word11, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable11,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This11 requires for registration11 of the ptp_tx_frame11   
  function new(string name = "spi_csr11");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int11();
    Copycfg_struct11();
  endfunction 

  // function to convert the 2 bit transfer_data_size11 to integer
  function void get_data_size_as_int11();
    case(transfer_data_size11)
      16'b00 : data_size11 = 128;
      default : data_size11 = int'(transfer_data_size11);
    endcase
     `uvm_info("SPI11 CSR11", $psprintf("data size is %d", data_size11), UVM_MEDIUM)
  endfunction : get_data_size_as_int11
    
  function void Copycfg_struct11();
    csr_s11.n_ss_out11            = n_ss_out11;
    csr_s11.transfer_data_size11  = transfer_data_size11;
    csr_s11.baud_rate_divisor11   = baud_rate_divisor11;
    csr_s11.tx_clk_phase11        = tx_clk_phase11;
    csr_s11.rx_clk_phase11        = rx_clk_phase11;
    csr_s11.mode_select11         = mode_select11;

    csr_s11.d_btwn_slave_sel11     = d_btwn_slave_sel11;
    csr_s11.d_btwn_word11          = d_btwn_word11;
    csr_s11.d_btwn_senable_word11  = d_btwn_senable_word11;

    csr_s11.spi_enable11      = spi_enable11;

    csr_s11.data_size11      = data_size11;
  endfunction

endclass : spi_csr11

`endif


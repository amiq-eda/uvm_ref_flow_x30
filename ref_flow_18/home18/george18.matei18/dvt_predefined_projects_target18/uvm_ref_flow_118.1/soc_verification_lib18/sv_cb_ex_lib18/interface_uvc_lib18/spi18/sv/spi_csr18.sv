/*-------------------------------------------------------------------------
File18 name   : spi_csr18.sv
Title18       : SPI18 SystemVerilog18 UVM UVC18
Project18     : SystemVerilog18 UVM Cluster18 Level18 Verification18
Created18     :
Description18 : 
Notes18       :  
---------------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV18
`define SPI_CSR_SV18

typedef struct packed {
  bit [7:0] n_ss_out18;
  bit [6:0] transfer_data_size18;
  bit [15:0] baud_rate_divisor18;
  bit tx_clk_phase18;
  bit rx_clk_phase18;
  bit mode_select18;

  bit tx_fifo_underflow18;
  bit rx_fifo_full18; 
  bit rx_fifo_not_empty18;
  bit tx_fifo_full18;
  bit tx_fifo_not_empty18;
  bit mode_fault18;
  bit rx_fifo_overrun18;

  bit spi_enable18;

  bit [7:0] d_btwn_slave_sel18;
  bit [7:0] d_btwn_word18;
  bit [7:0] d_btwn_senable_word18;

  int data_size18;
  } spi_csr_s18;

class spi_csr18 extends uvm_object;

  spi_csr_s18 csr_s18;

  //randomize SPI18 CSR18 fields
  rand bit [7:0] n_ss_out18;
  rand bit [6:0] transfer_data_size18;
  rand bit [15:0] baud_rate_divisor18;
  rand bit tx_clk_phase18;
  rand bit rx_clk_phase18;
  rand bit mode_select18;

  rand bit [7:0] d_btwn_slave_sel18;
  rand bit [7:0] d_btwn_word18;
  rand bit [7:0] d_btwn_senable_word18;

  rand bit spi_enable18;

  int data_size18;

  // this is a default constraint that could be overriden18
  // Constrain18 randomisation18 of configuration based on UVC18/RTL18 capabilities18
  constraint c_default_config18 {
    n_ss_out18           == 8'b01;
    transfer_data_size18 == 7'b0001000;
    baud_rate_divisor18  == 16'b0001;
    tx_clk_phase18       == 1'b0;
    rx_clk_phase18       == 1'b0;
    mode_select18        == 1'b1;

    d_btwn_slave_sel18   == 8'h00;
    d_btwn_word18        == 8'h00;
    d_btwn_senable_word18== 8'h00;

    spi_enable18         == 1'b1;
  }

  // These18 declarations18 implement the create() and get_type_name() as well18 as enable automation18 of the
  // transfer18 fields   
  `uvm_object_utils_begin(spi_csr18)
    `uvm_field_int(n_ss_out18,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size18,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor18,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase18,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase18,        UVM_ALL_ON)
    `uvm_field_int(mode_select18,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel18,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word18,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word18, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable18,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This18 requires for registration18 of the ptp_tx_frame18   
  function new(string name = "spi_csr18");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int18();
    Copycfg_struct18();
  endfunction 

  // function to convert the 2 bit transfer_data_size18 to integer
  function void get_data_size_as_int18();
    case(transfer_data_size18)
      16'b00 : data_size18 = 128;
      default : data_size18 = int'(transfer_data_size18);
    endcase
     `uvm_info("SPI18 CSR18", $psprintf("data size is %d", data_size18), UVM_MEDIUM)
  endfunction : get_data_size_as_int18
    
  function void Copycfg_struct18();
    csr_s18.n_ss_out18            = n_ss_out18;
    csr_s18.transfer_data_size18  = transfer_data_size18;
    csr_s18.baud_rate_divisor18   = baud_rate_divisor18;
    csr_s18.tx_clk_phase18        = tx_clk_phase18;
    csr_s18.rx_clk_phase18        = rx_clk_phase18;
    csr_s18.mode_select18         = mode_select18;

    csr_s18.d_btwn_slave_sel18     = d_btwn_slave_sel18;
    csr_s18.d_btwn_word18          = d_btwn_word18;
    csr_s18.d_btwn_senable_word18  = d_btwn_senable_word18;

    csr_s18.spi_enable18      = spi_enable18;

    csr_s18.data_size18      = data_size18;
  endfunction

endclass : spi_csr18

`endif


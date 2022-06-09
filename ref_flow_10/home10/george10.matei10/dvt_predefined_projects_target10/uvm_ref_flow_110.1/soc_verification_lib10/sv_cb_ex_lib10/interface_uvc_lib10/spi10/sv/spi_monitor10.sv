/*-------------------------------------------------------------------------
File10 name   : spi_monitor10.sv
Title10       : SPI10 SystemVerilog10 UVM UVC10
Project10     : SystemVerilog10 UVM Cluster10 Level10 Verification10
Created10     :
Description10 : 
Notes10       :  
---------------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV10
`define SPI_MONITOR_SV10

class spi_monitor10 extends uvm_monitor;

  // This10 property is the virtual interfaced10 needed for this component to
  // view10 HDL signals10. 
  virtual interface spi_if10 spi_if10;

  spi_csr_s10 csr_s10;

  // Agent10 Id10
  protected int agent_id10;

  // The following10 bit is used to control10 whether10 coverage10 is
  // done both in the monitor10 class and the interface.
  bit coverage_enable10 = 1;

  uvm_analysis_port #(spi_transfer10) item_collected_port10;

  // The following10 property holds10 the transaction information currently
  // begin captured10 (by the collect_receive_data10 and collect_transmit_data10 methods10).
  protected spi_transfer10 trans_collected10;

  // Events10 needed to trigger covergroups10
  protected event cov_transaction10;

  event new_transfer_started10;
  event new_bit_started10;

  // Transfer10 collected10 covergroup
  covergroup cov_trans_cg10 @cov_transaction10;
    option.per_instance = 1;
    trans_mode10 : coverpoint csr_s10.mode_select10;
    trans_cpha10 : coverpoint csr_s10.tx_clk_phase10;
    trans_size10 : coverpoint csr_s10.transfer_data_size10 {
      bins sizes10[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes10 = default; }
    trans_txdata10 : coverpoint trans_collected10.transfer_data10 {
      option.auto_bin_max = 8; }
    trans_rxdata10 : coverpoint trans_collected10.receive_data10 {
      option.auto_bin_max = 8; }
    trans_modeXsize10 : cross trans_mode10, trans_size10;
  endgroup : cov_trans_cg10

  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor10)
    `uvm_field_int(agent_id10, UVM_ALL_ON)
    `uvm_field_int(coverage_enable10, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg10 = new();
    cov_trans_cg10.set_inst_name("spi_cov_trans_cg10");
    item_collected_port10 = new("item_collected_port10", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if10)::get(this, "", "spi_if10", spi_if10))
   `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".spi_if10"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions10();
    join
  endtask : run_phase

  // collect_transactions10
  virtual protected task collect_transactions10();
    forever begin
      @(negedge spi_if10.sig_n_ss_in10);
      trans_collected10 = new();
      -> new_transfer_started10;
      if (m_parent != null)
        trans_collected10.agent10 = m_parent.get_name();
      collect_transfer10();
      if (coverage_enable10)
         -> cov_transaction10;
      item_collected_port10.write(trans_collected10);
    end
  endtask : collect_transactions10

  // collect_transfer10
  virtual protected task collect_transfer10();
    void'(this.begin_tr(trans_collected10));
    if (csr_s10.tx_clk_phase10 == 0) begin
      `uvm_info("SPI_MON10", $psprintf("tx_clk_phase10 is %d", csr_s10.tx_clk_phase10), UVM_HIGH)
      for (int i = 0; i < csr_s10.data_size10; i++) begin
        @(negedge spi_if10.sig_sclk_in10);
        -> new_bit_started10;
        if (csr_s10.mode_select10 == 1) begin     //DUT MASTER10 mode, OVC10 Slave10 mode
          trans_collected10.receive_data10[i] = spi_if10.sig_si10;
          `uvm_info("SPI_MON10", $psprintf("received10 data in mode_select10 1 is %h", trans_collected10.receive_data10), UVM_HIGH)
        end else begin
          trans_collected10.receive_data10[i] = spi_if10.sig_mi10;
          `uvm_info("SPI_MON10", $psprintf("received10 data in mode_select10 0 is %h", trans_collected10.receive_data10), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON10", $psprintf("tx_clk_phase10 is %d", csr_s10.tx_clk_phase10), UVM_HIGH)
      for (int i = 0; i < csr_s10.data_size10; i++) begin
        @(posedge spi_if10.sig_sclk_in10);
        -> new_bit_started10;
        if (csr_s10.mode_select10 == 1) begin     //DUT MASTER10 mode, OVC10 Slave10 mode
          trans_collected10.receive_data10[i] = spi_if10.sig_si10;
          `uvm_info("SPI_MON10", $psprintf("received10 data in mode_select10 1 is %h", trans_collected10.receive_data10), UVM_HIGH)
        end else begin
          trans_collected10.receive_data10[i] = spi_if10.sig_mi10;
          `uvm_info("SPI_MON10", $psprintf("received10 data in mode_select10 0 is %h", trans_collected10.receive_data10), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON10", $psprintf("Transfer10 collected10 :\n%s", trans_collected10.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected10);
  endtask : collect_transfer10

endclass : spi_monitor10

`endif // SPI_MONITOR_SV10


/*-------------------------------------------------------------------------
File24 name   : spi_monitor24.sv
Title24       : SPI24 SystemVerilog24 UVM UVC24
Project24     : SystemVerilog24 UVM Cluster24 Level24 Verification24
Created24     :
Description24 : 
Notes24       :  
---------------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV24
`define SPI_MONITOR_SV24

class spi_monitor24 extends uvm_monitor;

  // This24 property is the virtual interfaced24 needed for this component to
  // view24 HDL signals24. 
  virtual interface spi_if24 spi_if24;

  spi_csr_s24 csr_s24;

  // Agent24 Id24
  protected int agent_id24;

  // The following24 bit is used to control24 whether24 coverage24 is
  // done both in the monitor24 class and the interface.
  bit coverage_enable24 = 1;

  uvm_analysis_port #(spi_transfer24) item_collected_port24;

  // The following24 property holds24 the transaction information currently
  // begin captured24 (by the collect_receive_data24 and collect_transmit_data24 methods24).
  protected spi_transfer24 trans_collected24;

  // Events24 needed to trigger covergroups24
  protected event cov_transaction24;

  event new_transfer_started24;
  event new_bit_started24;

  // Transfer24 collected24 covergroup
  covergroup cov_trans_cg24 @cov_transaction24;
    option.per_instance = 1;
    trans_mode24 : coverpoint csr_s24.mode_select24;
    trans_cpha24 : coverpoint csr_s24.tx_clk_phase24;
    trans_size24 : coverpoint csr_s24.transfer_data_size24 {
      bins sizes24[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes24 = default; }
    trans_txdata24 : coverpoint trans_collected24.transfer_data24 {
      option.auto_bin_max = 8; }
    trans_rxdata24 : coverpoint trans_collected24.receive_data24 {
      option.auto_bin_max = 8; }
    trans_modeXsize24 : cross trans_mode24, trans_size24;
  endgroup : cov_trans_cg24

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor24)
    `uvm_field_int(agent_id24, UVM_ALL_ON)
    `uvm_field_int(coverage_enable24, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg24 = new();
    cov_trans_cg24.set_inst_name("spi_cov_trans_cg24");
    item_collected_port24 = new("item_collected_port24", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if24)::get(this, "", "spi_if24", spi_if24))
   `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".spi_if24"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions24();
    join
  endtask : run_phase

  // collect_transactions24
  virtual protected task collect_transactions24();
    forever begin
      @(negedge spi_if24.sig_n_ss_in24);
      trans_collected24 = new();
      -> new_transfer_started24;
      if (m_parent != null)
        trans_collected24.agent24 = m_parent.get_name();
      collect_transfer24();
      if (coverage_enable24)
         -> cov_transaction24;
      item_collected_port24.write(trans_collected24);
    end
  endtask : collect_transactions24

  // collect_transfer24
  virtual protected task collect_transfer24();
    void'(this.begin_tr(trans_collected24));
    if (csr_s24.tx_clk_phase24 == 0) begin
      `uvm_info("SPI_MON24", $psprintf("tx_clk_phase24 is %d", csr_s24.tx_clk_phase24), UVM_HIGH)
      for (int i = 0; i < csr_s24.data_size24; i++) begin
        @(negedge spi_if24.sig_sclk_in24);
        -> new_bit_started24;
        if (csr_s24.mode_select24 == 1) begin     //DUT MASTER24 mode, OVC24 Slave24 mode
          trans_collected24.receive_data24[i] = spi_if24.sig_si24;
          `uvm_info("SPI_MON24", $psprintf("received24 data in mode_select24 1 is %h", trans_collected24.receive_data24), UVM_HIGH)
        end else begin
          trans_collected24.receive_data24[i] = spi_if24.sig_mi24;
          `uvm_info("SPI_MON24", $psprintf("received24 data in mode_select24 0 is %h", trans_collected24.receive_data24), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON24", $psprintf("tx_clk_phase24 is %d", csr_s24.tx_clk_phase24), UVM_HIGH)
      for (int i = 0; i < csr_s24.data_size24; i++) begin
        @(posedge spi_if24.sig_sclk_in24);
        -> new_bit_started24;
        if (csr_s24.mode_select24 == 1) begin     //DUT MASTER24 mode, OVC24 Slave24 mode
          trans_collected24.receive_data24[i] = spi_if24.sig_si24;
          `uvm_info("SPI_MON24", $psprintf("received24 data in mode_select24 1 is %h", trans_collected24.receive_data24), UVM_HIGH)
        end else begin
          trans_collected24.receive_data24[i] = spi_if24.sig_mi24;
          `uvm_info("SPI_MON24", $psprintf("received24 data in mode_select24 0 is %h", trans_collected24.receive_data24), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON24", $psprintf("Transfer24 collected24 :\n%s", trans_collected24.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected24);
  endtask : collect_transfer24

endclass : spi_monitor24

`endif // SPI_MONITOR_SV24


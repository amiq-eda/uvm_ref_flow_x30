/*-------------------------------------------------------------------------
File25 name   : spi_monitor25.sv
Title25       : SPI25 SystemVerilog25 UVM UVC25
Project25     : SystemVerilog25 UVM Cluster25 Level25 Verification25
Created25     :
Description25 : 
Notes25       :  
---------------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV25
`define SPI_MONITOR_SV25

class spi_monitor25 extends uvm_monitor;

  // This25 property is the virtual interfaced25 needed for this component to
  // view25 HDL signals25. 
  virtual interface spi_if25 spi_if25;

  spi_csr_s25 csr_s25;

  // Agent25 Id25
  protected int agent_id25;

  // The following25 bit is used to control25 whether25 coverage25 is
  // done both in the monitor25 class and the interface.
  bit coverage_enable25 = 1;

  uvm_analysis_port #(spi_transfer25) item_collected_port25;

  // The following25 property holds25 the transaction information currently
  // begin captured25 (by the collect_receive_data25 and collect_transmit_data25 methods25).
  protected spi_transfer25 trans_collected25;

  // Events25 needed to trigger covergroups25
  protected event cov_transaction25;

  event new_transfer_started25;
  event new_bit_started25;

  // Transfer25 collected25 covergroup
  covergroup cov_trans_cg25 @cov_transaction25;
    option.per_instance = 1;
    trans_mode25 : coverpoint csr_s25.mode_select25;
    trans_cpha25 : coverpoint csr_s25.tx_clk_phase25;
    trans_size25 : coverpoint csr_s25.transfer_data_size25 {
      bins sizes25[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes25 = default; }
    trans_txdata25 : coverpoint trans_collected25.transfer_data25 {
      option.auto_bin_max = 8; }
    trans_rxdata25 : coverpoint trans_collected25.receive_data25 {
      option.auto_bin_max = 8; }
    trans_modeXsize25 : cross trans_mode25, trans_size25;
  endgroup : cov_trans_cg25

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor25)
    `uvm_field_int(agent_id25, UVM_ALL_ON)
    `uvm_field_int(coverage_enable25, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg25 = new();
    cov_trans_cg25.set_inst_name("spi_cov_trans_cg25");
    item_collected_port25 = new("item_collected_port25", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if25)::get(this, "", "spi_if25", spi_if25))
   `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".spi_if25"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions25();
    join
  endtask : run_phase

  // collect_transactions25
  virtual protected task collect_transactions25();
    forever begin
      @(negedge spi_if25.sig_n_ss_in25);
      trans_collected25 = new();
      -> new_transfer_started25;
      if (m_parent != null)
        trans_collected25.agent25 = m_parent.get_name();
      collect_transfer25();
      if (coverage_enable25)
         -> cov_transaction25;
      item_collected_port25.write(trans_collected25);
    end
  endtask : collect_transactions25

  // collect_transfer25
  virtual protected task collect_transfer25();
    void'(this.begin_tr(trans_collected25));
    if (csr_s25.tx_clk_phase25 == 0) begin
      `uvm_info("SPI_MON25", $psprintf("tx_clk_phase25 is %d", csr_s25.tx_clk_phase25), UVM_HIGH)
      for (int i = 0; i < csr_s25.data_size25; i++) begin
        @(negedge spi_if25.sig_sclk_in25);
        -> new_bit_started25;
        if (csr_s25.mode_select25 == 1) begin     //DUT MASTER25 mode, OVC25 Slave25 mode
          trans_collected25.receive_data25[i] = spi_if25.sig_si25;
          `uvm_info("SPI_MON25", $psprintf("received25 data in mode_select25 1 is %h", trans_collected25.receive_data25), UVM_HIGH)
        end else begin
          trans_collected25.receive_data25[i] = spi_if25.sig_mi25;
          `uvm_info("SPI_MON25", $psprintf("received25 data in mode_select25 0 is %h", trans_collected25.receive_data25), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON25", $psprintf("tx_clk_phase25 is %d", csr_s25.tx_clk_phase25), UVM_HIGH)
      for (int i = 0; i < csr_s25.data_size25; i++) begin
        @(posedge spi_if25.sig_sclk_in25);
        -> new_bit_started25;
        if (csr_s25.mode_select25 == 1) begin     //DUT MASTER25 mode, OVC25 Slave25 mode
          trans_collected25.receive_data25[i] = spi_if25.sig_si25;
          `uvm_info("SPI_MON25", $psprintf("received25 data in mode_select25 1 is %h", trans_collected25.receive_data25), UVM_HIGH)
        end else begin
          trans_collected25.receive_data25[i] = spi_if25.sig_mi25;
          `uvm_info("SPI_MON25", $psprintf("received25 data in mode_select25 0 is %h", trans_collected25.receive_data25), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON25", $psprintf("Transfer25 collected25 :\n%s", trans_collected25.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected25);
  endtask : collect_transfer25

endclass : spi_monitor25

`endif // SPI_MONITOR_SV25


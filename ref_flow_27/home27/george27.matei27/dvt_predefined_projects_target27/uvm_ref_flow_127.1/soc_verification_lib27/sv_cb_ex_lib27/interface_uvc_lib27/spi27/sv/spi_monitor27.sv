/*-------------------------------------------------------------------------
File27 name   : spi_monitor27.sv
Title27       : SPI27 SystemVerilog27 UVM UVC27
Project27     : SystemVerilog27 UVM Cluster27 Level27 Verification27
Created27     :
Description27 : 
Notes27       :  
---------------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV27
`define SPI_MONITOR_SV27

class spi_monitor27 extends uvm_monitor;

  // This27 property is the virtual interfaced27 needed for this component to
  // view27 HDL signals27. 
  virtual interface spi_if27 spi_if27;

  spi_csr_s27 csr_s27;

  // Agent27 Id27
  protected int agent_id27;

  // The following27 bit is used to control27 whether27 coverage27 is
  // done both in the monitor27 class and the interface.
  bit coverage_enable27 = 1;

  uvm_analysis_port #(spi_transfer27) item_collected_port27;

  // The following27 property holds27 the transaction information currently
  // begin captured27 (by the collect_receive_data27 and collect_transmit_data27 methods27).
  protected spi_transfer27 trans_collected27;

  // Events27 needed to trigger covergroups27
  protected event cov_transaction27;

  event new_transfer_started27;
  event new_bit_started27;

  // Transfer27 collected27 covergroup
  covergroup cov_trans_cg27 @cov_transaction27;
    option.per_instance = 1;
    trans_mode27 : coverpoint csr_s27.mode_select27;
    trans_cpha27 : coverpoint csr_s27.tx_clk_phase27;
    trans_size27 : coverpoint csr_s27.transfer_data_size27 {
      bins sizes27[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes27 = default; }
    trans_txdata27 : coverpoint trans_collected27.transfer_data27 {
      option.auto_bin_max = 8; }
    trans_rxdata27 : coverpoint trans_collected27.receive_data27 {
      option.auto_bin_max = 8; }
    trans_modeXsize27 : cross trans_mode27, trans_size27;
  endgroup : cov_trans_cg27

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor27)
    `uvm_field_int(agent_id27, UVM_ALL_ON)
    `uvm_field_int(coverage_enable27, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg27 = new();
    cov_trans_cg27.set_inst_name("spi_cov_trans_cg27");
    item_collected_port27 = new("item_collected_port27", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if27)::get(this, "", "spi_if27", spi_if27))
   `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".spi_if27"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions27();
    join
  endtask : run_phase

  // collect_transactions27
  virtual protected task collect_transactions27();
    forever begin
      @(negedge spi_if27.sig_n_ss_in27);
      trans_collected27 = new();
      -> new_transfer_started27;
      if (m_parent != null)
        trans_collected27.agent27 = m_parent.get_name();
      collect_transfer27();
      if (coverage_enable27)
         -> cov_transaction27;
      item_collected_port27.write(trans_collected27);
    end
  endtask : collect_transactions27

  // collect_transfer27
  virtual protected task collect_transfer27();
    void'(this.begin_tr(trans_collected27));
    if (csr_s27.tx_clk_phase27 == 0) begin
      `uvm_info("SPI_MON27", $psprintf("tx_clk_phase27 is %d", csr_s27.tx_clk_phase27), UVM_HIGH)
      for (int i = 0; i < csr_s27.data_size27; i++) begin
        @(negedge spi_if27.sig_sclk_in27);
        -> new_bit_started27;
        if (csr_s27.mode_select27 == 1) begin     //DUT MASTER27 mode, OVC27 Slave27 mode
          trans_collected27.receive_data27[i] = spi_if27.sig_si27;
          `uvm_info("SPI_MON27", $psprintf("received27 data in mode_select27 1 is %h", trans_collected27.receive_data27), UVM_HIGH)
        end else begin
          trans_collected27.receive_data27[i] = spi_if27.sig_mi27;
          `uvm_info("SPI_MON27", $psprintf("received27 data in mode_select27 0 is %h", trans_collected27.receive_data27), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON27", $psprintf("tx_clk_phase27 is %d", csr_s27.tx_clk_phase27), UVM_HIGH)
      for (int i = 0; i < csr_s27.data_size27; i++) begin
        @(posedge spi_if27.sig_sclk_in27);
        -> new_bit_started27;
        if (csr_s27.mode_select27 == 1) begin     //DUT MASTER27 mode, OVC27 Slave27 mode
          trans_collected27.receive_data27[i] = spi_if27.sig_si27;
          `uvm_info("SPI_MON27", $psprintf("received27 data in mode_select27 1 is %h", trans_collected27.receive_data27), UVM_HIGH)
        end else begin
          trans_collected27.receive_data27[i] = spi_if27.sig_mi27;
          `uvm_info("SPI_MON27", $psprintf("received27 data in mode_select27 0 is %h", trans_collected27.receive_data27), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON27", $psprintf("Transfer27 collected27 :\n%s", trans_collected27.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected27);
  endtask : collect_transfer27

endclass : spi_monitor27

`endif // SPI_MONITOR_SV27


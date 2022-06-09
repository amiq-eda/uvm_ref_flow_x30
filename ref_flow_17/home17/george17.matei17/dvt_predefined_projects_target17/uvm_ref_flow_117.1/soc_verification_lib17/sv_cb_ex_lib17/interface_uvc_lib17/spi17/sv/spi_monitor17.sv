/*-------------------------------------------------------------------------
File17 name   : spi_monitor17.sv
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


`ifndef SPI_MONITOR_SV17
`define SPI_MONITOR_SV17

class spi_monitor17 extends uvm_monitor;

  // This17 property is the virtual interfaced17 needed for this component to
  // view17 HDL signals17. 
  virtual interface spi_if17 spi_if17;

  spi_csr_s17 csr_s17;

  // Agent17 Id17
  protected int agent_id17;

  // The following17 bit is used to control17 whether17 coverage17 is
  // done both in the monitor17 class and the interface.
  bit coverage_enable17 = 1;

  uvm_analysis_port #(spi_transfer17) item_collected_port17;

  // The following17 property holds17 the transaction information currently
  // begin captured17 (by the collect_receive_data17 and collect_transmit_data17 methods17).
  protected spi_transfer17 trans_collected17;

  // Events17 needed to trigger covergroups17
  protected event cov_transaction17;

  event new_transfer_started17;
  event new_bit_started17;

  // Transfer17 collected17 covergroup
  covergroup cov_trans_cg17 @cov_transaction17;
    option.per_instance = 1;
    trans_mode17 : coverpoint csr_s17.mode_select17;
    trans_cpha17 : coverpoint csr_s17.tx_clk_phase17;
    trans_size17 : coverpoint csr_s17.transfer_data_size17 {
      bins sizes17[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes17 = default; }
    trans_txdata17 : coverpoint trans_collected17.transfer_data17 {
      option.auto_bin_max = 8; }
    trans_rxdata17 : coverpoint trans_collected17.receive_data17 {
      option.auto_bin_max = 8; }
    trans_modeXsize17 : cross trans_mode17, trans_size17;
  endgroup : cov_trans_cg17

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor17)
    `uvm_field_int(agent_id17, UVM_ALL_ON)
    `uvm_field_int(coverage_enable17, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg17 = new();
    cov_trans_cg17.set_inst_name("spi_cov_trans_cg17");
    item_collected_port17 = new("item_collected_port17", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if17)::get(this, "", "spi_if17", spi_if17))
   `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".spi_if17"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions17();
    join
  endtask : run_phase

  // collect_transactions17
  virtual protected task collect_transactions17();
    forever begin
      @(negedge spi_if17.sig_n_ss_in17);
      trans_collected17 = new();
      -> new_transfer_started17;
      if (m_parent != null)
        trans_collected17.agent17 = m_parent.get_name();
      collect_transfer17();
      if (coverage_enable17)
         -> cov_transaction17;
      item_collected_port17.write(trans_collected17);
    end
  endtask : collect_transactions17

  // collect_transfer17
  virtual protected task collect_transfer17();
    void'(this.begin_tr(trans_collected17));
    if (csr_s17.tx_clk_phase17 == 0) begin
      `uvm_info("SPI_MON17", $psprintf("tx_clk_phase17 is %d", csr_s17.tx_clk_phase17), UVM_HIGH)
      for (int i = 0; i < csr_s17.data_size17; i++) begin
        @(negedge spi_if17.sig_sclk_in17);
        -> new_bit_started17;
        if (csr_s17.mode_select17 == 1) begin     //DUT MASTER17 mode, OVC17 Slave17 mode
          trans_collected17.receive_data17[i] = spi_if17.sig_si17;
          `uvm_info("SPI_MON17", $psprintf("received17 data in mode_select17 1 is %h", trans_collected17.receive_data17), UVM_HIGH)
        end else begin
          trans_collected17.receive_data17[i] = spi_if17.sig_mi17;
          `uvm_info("SPI_MON17", $psprintf("received17 data in mode_select17 0 is %h", trans_collected17.receive_data17), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON17", $psprintf("tx_clk_phase17 is %d", csr_s17.tx_clk_phase17), UVM_HIGH)
      for (int i = 0; i < csr_s17.data_size17; i++) begin
        @(posedge spi_if17.sig_sclk_in17);
        -> new_bit_started17;
        if (csr_s17.mode_select17 == 1) begin     //DUT MASTER17 mode, OVC17 Slave17 mode
          trans_collected17.receive_data17[i] = spi_if17.sig_si17;
          `uvm_info("SPI_MON17", $psprintf("received17 data in mode_select17 1 is %h", trans_collected17.receive_data17), UVM_HIGH)
        end else begin
          trans_collected17.receive_data17[i] = spi_if17.sig_mi17;
          `uvm_info("SPI_MON17", $psprintf("received17 data in mode_select17 0 is %h", trans_collected17.receive_data17), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON17", $psprintf("Transfer17 collected17 :\n%s", trans_collected17.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected17);
  endtask : collect_transfer17

endclass : spi_monitor17

`endif // SPI_MONITOR_SV17


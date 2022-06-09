/*-------------------------------------------------------------------------
File15 name   : spi_monitor15.sv
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


`ifndef SPI_MONITOR_SV15
`define SPI_MONITOR_SV15

class spi_monitor15 extends uvm_monitor;

  // This15 property is the virtual interfaced15 needed for this component to
  // view15 HDL signals15. 
  virtual interface spi_if15 spi_if15;

  spi_csr_s15 csr_s15;

  // Agent15 Id15
  protected int agent_id15;

  // The following15 bit is used to control15 whether15 coverage15 is
  // done both in the monitor15 class and the interface.
  bit coverage_enable15 = 1;

  uvm_analysis_port #(spi_transfer15) item_collected_port15;

  // The following15 property holds15 the transaction information currently
  // begin captured15 (by the collect_receive_data15 and collect_transmit_data15 methods15).
  protected spi_transfer15 trans_collected15;

  // Events15 needed to trigger covergroups15
  protected event cov_transaction15;

  event new_transfer_started15;
  event new_bit_started15;

  // Transfer15 collected15 covergroup
  covergroup cov_trans_cg15 @cov_transaction15;
    option.per_instance = 1;
    trans_mode15 : coverpoint csr_s15.mode_select15;
    trans_cpha15 : coverpoint csr_s15.tx_clk_phase15;
    trans_size15 : coverpoint csr_s15.transfer_data_size15 {
      bins sizes15[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes15 = default; }
    trans_txdata15 : coverpoint trans_collected15.transfer_data15 {
      option.auto_bin_max = 8; }
    trans_rxdata15 : coverpoint trans_collected15.receive_data15 {
      option.auto_bin_max = 8; }
    trans_modeXsize15 : cross trans_mode15, trans_size15;
  endgroup : cov_trans_cg15

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor15)
    `uvm_field_int(agent_id15, UVM_ALL_ON)
    `uvm_field_int(coverage_enable15, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg15 = new();
    cov_trans_cg15.set_inst_name("spi_cov_trans_cg15");
    item_collected_port15 = new("item_collected_port15", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if15)::get(this, "", "spi_if15", spi_if15))
   `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".spi_if15"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions15();
    join
  endtask : run_phase

  // collect_transactions15
  virtual protected task collect_transactions15();
    forever begin
      @(negedge spi_if15.sig_n_ss_in15);
      trans_collected15 = new();
      -> new_transfer_started15;
      if (m_parent != null)
        trans_collected15.agent15 = m_parent.get_name();
      collect_transfer15();
      if (coverage_enable15)
         -> cov_transaction15;
      item_collected_port15.write(trans_collected15);
    end
  endtask : collect_transactions15

  // collect_transfer15
  virtual protected task collect_transfer15();
    void'(this.begin_tr(trans_collected15));
    if (csr_s15.tx_clk_phase15 == 0) begin
      `uvm_info("SPI_MON15", $psprintf("tx_clk_phase15 is %d", csr_s15.tx_clk_phase15), UVM_HIGH)
      for (int i = 0; i < csr_s15.data_size15; i++) begin
        @(negedge spi_if15.sig_sclk_in15);
        -> new_bit_started15;
        if (csr_s15.mode_select15 == 1) begin     //DUT MASTER15 mode, OVC15 Slave15 mode
          trans_collected15.receive_data15[i] = spi_if15.sig_si15;
          `uvm_info("SPI_MON15", $psprintf("received15 data in mode_select15 1 is %h", trans_collected15.receive_data15), UVM_HIGH)
        end else begin
          trans_collected15.receive_data15[i] = spi_if15.sig_mi15;
          `uvm_info("SPI_MON15", $psprintf("received15 data in mode_select15 0 is %h", trans_collected15.receive_data15), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON15", $psprintf("tx_clk_phase15 is %d", csr_s15.tx_clk_phase15), UVM_HIGH)
      for (int i = 0; i < csr_s15.data_size15; i++) begin
        @(posedge spi_if15.sig_sclk_in15);
        -> new_bit_started15;
        if (csr_s15.mode_select15 == 1) begin     //DUT MASTER15 mode, OVC15 Slave15 mode
          trans_collected15.receive_data15[i] = spi_if15.sig_si15;
          `uvm_info("SPI_MON15", $psprintf("received15 data in mode_select15 1 is %h", trans_collected15.receive_data15), UVM_HIGH)
        end else begin
          trans_collected15.receive_data15[i] = spi_if15.sig_mi15;
          `uvm_info("SPI_MON15", $psprintf("received15 data in mode_select15 0 is %h", trans_collected15.receive_data15), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON15", $psprintf("Transfer15 collected15 :\n%s", trans_collected15.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected15);
  endtask : collect_transfer15

endclass : spi_monitor15

`endif // SPI_MONITOR_SV15


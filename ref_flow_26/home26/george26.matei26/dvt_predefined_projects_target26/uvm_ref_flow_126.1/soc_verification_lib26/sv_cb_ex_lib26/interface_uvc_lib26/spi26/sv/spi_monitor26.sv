/*-------------------------------------------------------------------------
File26 name   : spi_monitor26.sv
Title26       : SPI26 SystemVerilog26 UVM UVC26
Project26     : SystemVerilog26 UVM Cluster26 Level26 Verification26
Created26     :
Description26 : 
Notes26       :  
---------------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV26
`define SPI_MONITOR_SV26

class spi_monitor26 extends uvm_monitor;

  // This26 property is the virtual interfaced26 needed for this component to
  // view26 HDL signals26. 
  virtual interface spi_if26 spi_if26;

  spi_csr_s26 csr_s26;

  // Agent26 Id26
  protected int agent_id26;

  // The following26 bit is used to control26 whether26 coverage26 is
  // done both in the monitor26 class and the interface.
  bit coverage_enable26 = 1;

  uvm_analysis_port #(spi_transfer26) item_collected_port26;

  // The following26 property holds26 the transaction information currently
  // begin captured26 (by the collect_receive_data26 and collect_transmit_data26 methods26).
  protected spi_transfer26 trans_collected26;

  // Events26 needed to trigger covergroups26
  protected event cov_transaction26;

  event new_transfer_started26;
  event new_bit_started26;

  // Transfer26 collected26 covergroup
  covergroup cov_trans_cg26 @cov_transaction26;
    option.per_instance = 1;
    trans_mode26 : coverpoint csr_s26.mode_select26;
    trans_cpha26 : coverpoint csr_s26.tx_clk_phase26;
    trans_size26 : coverpoint csr_s26.transfer_data_size26 {
      bins sizes26[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes26 = default; }
    trans_txdata26 : coverpoint trans_collected26.transfer_data26 {
      option.auto_bin_max = 8; }
    trans_rxdata26 : coverpoint trans_collected26.receive_data26 {
      option.auto_bin_max = 8; }
    trans_modeXsize26 : cross trans_mode26, trans_size26;
  endgroup : cov_trans_cg26

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor26)
    `uvm_field_int(agent_id26, UVM_ALL_ON)
    `uvm_field_int(coverage_enable26, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg26 = new();
    cov_trans_cg26.set_inst_name("spi_cov_trans_cg26");
    item_collected_port26 = new("item_collected_port26", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if26)::get(this, "", "spi_if26", spi_if26))
   `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".spi_if26"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions26();
    join
  endtask : run_phase

  // collect_transactions26
  virtual protected task collect_transactions26();
    forever begin
      @(negedge spi_if26.sig_n_ss_in26);
      trans_collected26 = new();
      -> new_transfer_started26;
      if (m_parent != null)
        trans_collected26.agent26 = m_parent.get_name();
      collect_transfer26();
      if (coverage_enable26)
         -> cov_transaction26;
      item_collected_port26.write(trans_collected26);
    end
  endtask : collect_transactions26

  // collect_transfer26
  virtual protected task collect_transfer26();
    void'(this.begin_tr(trans_collected26));
    if (csr_s26.tx_clk_phase26 == 0) begin
      `uvm_info("SPI_MON26", $psprintf("tx_clk_phase26 is %d", csr_s26.tx_clk_phase26), UVM_HIGH)
      for (int i = 0; i < csr_s26.data_size26; i++) begin
        @(negedge spi_if26.sig_sclk_in26);
        -> new_bit_started26;
        if (csr_s26.mode_select26 == 1) begin     //DUT MASTER26 mode, OVC26 Slave26 mode
          trans_collected26.receive_data26[i] = spi_if26.sig_si26;
          `uvm_info("SPI_MON26", $psprintf("received26 data in mode_select26 1 is %h", trans_collected26.receive_data26), UVM_HIGH)
        end else begin
          trans_collected26.receive_data26[i] = spi_if26.sig_mi26;
          `uvm_info("SPI_MON26", $psprintf("received26 data in mode_select26 0 is %h", trans_collected26.receive_data26), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON26", $psprintf("tx_clk_phase26 is %d", csr_s26.tx_clk_phase26), UVM_HIGH)
      for (int i = 0; i < csr_s26.data_size26; i++) begin
        @(posedge spi_if26.sig_sclk_in26);
        -> new_bit_started26;
        if (csr_s26.mode_select26 == 1) begin     //DUT MASTER26 mode, OVC26 Slave26 mode
          trans_collected26.receive_data26[i] = spi_if26.sig_si26;
          `uvm_info("SPI_MON26", $psprintf("received26 data in mode_select26 1 is %h", trans_collected26.receive_data26), UVM_HIGH)
        end else begin
          trans_collected26.receive_data26[i] = spi_if26.sig_mi26;
          `uvm_info("SPI_MON26", $psprintf("received26 data in mode_select26 0 is %h", trans_collected26.receive_data26), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON26", $psprintf("Transfer26 collected26 :\n%s", trans_collected26.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected26);
  endtask : collect_transfer26

endclass : spi_monitor26

`endif // SPI_MONITOR_SV26


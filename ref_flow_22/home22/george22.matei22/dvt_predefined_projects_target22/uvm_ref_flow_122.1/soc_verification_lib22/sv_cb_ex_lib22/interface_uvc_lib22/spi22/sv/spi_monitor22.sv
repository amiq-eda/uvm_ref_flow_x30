/*-------------------------------------------------------------------------
File22 name   : spi_monitor22.sv
Title22       : SPI22 SystemVerilog22 UVM UVC22
Project22     : SystemVerilog22 UVM Cluster22 Level22 Verification22
Created22     :
Description22 : 
Notes22       :  
---------------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV22
`define SPI_MONITOR_SV22

class spi_monitor22 extends uvm_monitor;

  // This22 property is the virtual interfaced22 needed for this component to
  // view22 HDL signals22. 
  virtual interface spi_if22 spi_if22;

  spi_csr_s22 csr_s22;

  // Agent22 Id22
  protected int agent_id22;

  // The following22 bit is used to control22 whether22 coverage22 is
  // done both in the monitor22 class and the interface.
  bit coverage_enable22 = 1;

  uvm_analysis_port #(spi_transfer22) item_collected_port22;

  // The following22 property holds22 the transaction information currently
  // begin captured22 (by the collect_receive_data22 and collect_transmit_data22 methods22).
  protected spi_transfer22 trans_collected22;

  // Events22 needed to trigger covergroups22
  protected event cov_transaction22;

  event new_transfer_started22;
  event new_bit_started22;

  // Transfer22 collected22 covergroup
  covergroup cov_trans_cg22 @cov_transaction22;
    option.per_instance = 1;
    trans_mode22 : coverpoint csr_s22.mode_select22;
    trans_cpha22 : coverpoint csr_s22.tx_clk_phase22;
    trans_size22 : coverpoint csr_s22.transfer_data_size22 {
      bins sizes22[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes22 = default; }
    trans_txdata22 : coverpoint trans_collected22.transfer_data22 {
      option.auto_bin_max = 8; }
    trans_rxdata22 : coverpoint trans_collected22.receive_data22 {
      option.auto_bin_max = 8; }
    trans_modeXsize22 : cross trans_mode22, trans_size22;
  endgroup : cov_trans_cg22

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor22)
    `uvm_field_int(agent_id22, UVM_ALL_ON)
    `uvm_field_int(coverage_enable22, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg22 = new();
    cov_trans_cg22.set_inst_name("spi_cov_trans_cg22");
    item_collected_port22 = new("item_collected_port22", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if22)::get(this, "", "spi_if22", spi_if22))
   `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".spi_if22"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions22();
    join
  endtask : run_phase

  // collect_transactions22
  virtual protected task collect_transactions22();
    forever begin
      @(negedge spi_if22.sig_n_ss_in22);
      trans_collected22 = new();
      -> new_transfer_started22;
      if (m_parent != null)
        trans_collected22.agent22 = m_parent.get_name();
      collect_transfer22();
      if (coverage_enable22)
         -> cov_transaction22;
      item_collected_port22.write(trans_collected22);
    end
  endtask : collect_transactions22

  // collect_transfer22
  virtual protected task collect_transfer22();
    void'(this.begin_tr(trans_collected22));
    if (csr_s22.tx_clk_phase22 == 0) begin
      `uvm_info("SPI_MON22", $psprintf("tx_clk_phase22 is %d", csr_s22.tx_clk_phase22), UVM_HIGH)
      for (int i = 0; i < csr_s22.data_size22; i++) begin
        @(negedge spi_if22.sig_sclk_in22);
        -> new_bit_started22;
        if (csr_s22.mode_select22 == 1) begin     //DUT MASTER22 mode, OVC22 Slave22 mode
          trans_collected22.receive_data22[i] = spi_if22.sig_si22;
          `uvm_info("SPI_MON22", $psprintf("received22 data in mode_select22 1 is %h", trans_collected22.receive_data22), UVM_HIGH)
        end else begin
          trans_collected22.receive_data22[i] = spi_if22.sig_mi22;
          `uvm_info("SPI_MON22", $psprintf("received22 data in mode_select22 0 is %h", trans_collected22.receive_data22), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON22", $psprintf("tx_clk_phase22 is %d", csr_s22.tx_clk_phase22), UVM_HIGH)
      for (int i = 0; i < csr_s22.data_size22; i++) begin
        @(posedge spi_if22.sig_sclk_in22);
        -> new_bit_started22;
        if (csr_s22.mode_select22 == 1) begin     //DUT MASTER22 mode, OVC22 Slave22 mode
          trans_collected22.receive_data22[i] = spi_if22.sig_si22;
          `uvm_info("SPI_MON22", $psprintf("received22 data in mode_select22 1 is %h", trans_collected22.receive_data22), UVM_HIGH)
        end else begin
          trans_collected22.receive_data22[i] = spi_if22.sig_mi22;
          `uvm_info("SPI_MON22", $psprintf("received22 data in mode_select22 0 is %h", trans_collected22.receive_data22), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON22", $psprintf("Transfer22 collected22 :\n%s", trans_collected22.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected22);
  endtask : collect_transfer22

endclass : spi_monitor22

`endif // SPI_MONITOR_SV22


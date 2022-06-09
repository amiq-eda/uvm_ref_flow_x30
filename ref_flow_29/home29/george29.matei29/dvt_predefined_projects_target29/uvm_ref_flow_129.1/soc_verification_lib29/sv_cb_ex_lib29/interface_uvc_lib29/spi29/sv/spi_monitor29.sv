/*-------------------------------------------------------------------------
File29 name   : spi_monitor29.sv
Title29       : SPI29 SystemVerilog29 UVM UVC29
Project29     : SystemVerilog29 UVM Cluster29 Level29 Verification29
Created29     :
Description29 : 
Notes29       :  
---------------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV29
`define SPI_MONITOR_SV29

class spi_monitor29 extends uvm_monitor;

  // This29 property is the virtual interfaced29 needed for this component to
  // view29 HDL signals29. 
  virtual interface spi_if29 spi_if29;

  spi_csr_s29 csr_s29;

  // Agent29 Id29
  protected int agent_id29;

  // The following29 bit is used to control29 whether29 coverage29 is
  // done both in the monitor29 class and the interface.
  bit coverage_enable29 = 1;

  uvm_analysis_port #(spi_transfer29) item_collected_port29;

  // The following29 property holds29 the transaction information currently
  // begin captured29 (by the collect_receive_data29 and collect_transmit_data29 methods29).
  protected spi_transfer29 trans_collected29;

  // Events29 needed to trigger covergroups29
  protected event cov_transaction29;

  event new_transfer_started29;
  event new_bit_started29;

  // Transfer29 collected29 covergroup
  covergroup cov_trans_cg29 @cov_transaction29;
    option.per_instance = 1;
    trans_mode29 : coverpoint csr_s29.mode_select29;
    trans_cpha29 : coverpoint csr_s29.tx_clk_phase29;
    trans_size29 : coverpoint csr_s29.transfer_data_size29 {
      bins sizes29[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes29 = default; }
    trans_txdata29 : coverpoint trans_collected29.transfer_data29 {
      option.auto_bin_max = 8; }
    trans_rxdata29 : coverpoint trans_collected29.receive_data29 {
      option.auto_bin_max = 8; }
    trans_modeXsize29 : cross trans_mode29, trans_size29;
  endgroup : cov_trans_cg29

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor29)
    `uvm_field_int(agent_id29, UVM_ALL_ON)
    `uvm_field_int(coverage_enable29, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg29 = new();
    cov_trans_cg29.set_inst_name("spi_cov_trans_cg29");
    item_collected_port29 = new("item_collected_port29", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if29)::get(this, "", "spi_if29", spi_if29))
   `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".spi_if29"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions29();
    join
  endtask : run_phase

  // collect_transactions29
  virtual protected task collect_transactions29();
    forever begin
      @(negedge spi_if29.sig_n_ss_in29);
      trans_collected29 = new();
      -> new_transfer_started29;
      if (m_parent != null)
        trans_collected29.agent29 = m_parent.get_name();
      collect_transfer29();
      if (coverage_enable29)
         -> cov_transaction29;
      item_collected_port29.write(trans_collected29);
    end
  endtask : collect_transactions29

  // collect_transfer29
  virtual protected task collect_transfer29();
    void'(this.begin_tr(trans_collected29));
    if (csr_s29.tx_clk_phase29 == 0) begin
      `uvm_info("SPI_MON29", $psprintf("tx_clk_phase29 is %d", csr_s29.tx_clk_phase29), UVM_HIGH)
      for (int i = 0; i < csr_s29.data_size29; i++) begin
        @(negedge spi_if29.sig_sclk_in29);
        -> new_bit_started29;
        if (csr_s29.mode_select29 == 1) begin     //DUT MASTER29 mode, OVC29 Slave29 mode
          trans_collected29.receive_data29[i] = spi_if29.sig_si29;
          `uvm_info("SPI_MON29", $psprintf("received29 data in mode_select29 1 is %h", trans_collected29.receive_data29), UVM_HIGH)
        end else begin
          trans_collected29.receive_data29[i] = spi_if29.sig_mi29;
          `uvm_info("SPI_MON29", $psprintf("received29 data in mode_select29 0 is %h", trans_collected29.receive_data29), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON29", $psprintf("tx_clk_phase29 is %d", csr_s29.tx_clk_phase29), UVM_HIGH)
      for (int i = 0; i < csr_s29.data_size29; i++) begin
        @(posedge spi_if29.sig_sclk_in29);
        -> new_bit_started29;
        if (csr_s29.mode_select29 == 1) begin     //DUT MASTER29 mode, OVC29 Slave29 mode
          trans_collected29.receive_data29[i] = spi_if29.sig_si29;
          `uvm_info("SPI_MON29", $psprintf("received29 data in mode_select29 1 is %h", trans_collected29.receive_data29), UVM_HIGH)
        end else begin
          trans_collected29.receive_data29[i] = spi_if29.sig_mi29;
          `uvm_info("SPI_MON29", $psprintf("received29 data in mode_select29 0 is %h", trans_collected29.receive_data29), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON29", $psprintf("Transfer29 collected29 :\n%s", trans_collected29.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected29);
  endtask : collect_transfer29

endclass : spi_monitor29

`endif // SPI_MONITOR_SV29


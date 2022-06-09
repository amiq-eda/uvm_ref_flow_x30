/*-------------------------------------------------------------------------
File23 name   : spi_monitor23.sv
Title23       : SPI23 SystemVerilog23 UVM UVC23
Project23     : SystemVerilog23 UVM Cluster23 Level23 Verification23
Created23     :
Description23 : 
Notes23       :  
---------------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV23
`define SPI_MONITOR_SV23

class spi_monitor23 extends uvm_monitor;

  // This23 property is the virtual interfaced23 needed for this component to
  // view23 HDL signals23. 
  virtual interface spi_if23 spi_if23;

  spi_csr_s23 csr_s23;

  // Agent23 Id23
  protected int agent_id23;

  // The following23 bit is used to control23 whether23 coverage23 is
  // done both in the monitor23 class and the interface.
  bit coverage_enable23 = 1;

  uvm_analysis_port #(spi_transfer23) item_collected_port23;

  // The following23 property holds23 the transaction information currently
  // begin captured23 (by the collect_receive_data23 and collect_transmit_data23 methods23).
  protected spi_transfer23 trans_collected23;

  // Events23 needed to trigger covergroups23
  protected event cov_transaction23;

  event new_transfer_started23;
  event new_bit_started23;

  // Transfer23 collected23 covergroup
  covergroup cov_trans_cg23 @cov_transaction23;
    option.per_instance = 1;
    trans_mode23 : coverpoint csr_s23.mode_select23;
    trans_cpha23 : coverpoint csr_s23.tx_clk_phase23;
    trans_size23 : coverpoint csr_s23.transfer_data_size23 {
      bins sizes23[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes23 = default; }
    trans_txdata23 : coverpoint trans_collected23.transfer_data23 {
      option.auto_bin_max = 8; }
    trans_rxdata23 : coverpoint trans_collected23.receive_data23 {
      option.auto_bin_max = 8; }
    trans_modeXsize23 : cross trans_mode23, trans_size23;
  endgroup : cov_trans_cg23

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor23)
    `uvm_field_int(agent_id23, UVM_ALL_ON)
    `uvm_field_int(coverage_enable23, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg23 = new();
    cov_trans_cg23.set_inst_name("spi_cov_trans_cg23");
    item_collected_port23 = new("item_collected_port23", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if23)::get(this, "", "spi_if23", spi_if23))
   `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".spi_if23"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions23();
    join
  endtask : run_phase

  // collect_transactions23
  virtual protected task collect_transactions23();
    forever begin
      @(negedge spi_if23.sig_n_ss_in23);
      trans_collected23 = new();
      -> new_transfer_started23;
      if (m_parent != null)
        trans_collected23.agent23 = m_parent.get_name();
      collect_transfer23();
      if (coverage_enable23)
         -> cov_transaction23;
      item_collected_port23.write(trans_collected23);
    end
  endtask : collect_transactions23

  // collect_transfer23
  virtual protected task collect_transfer23();
    void'(this.begin_tr(trans_collected23));
    if (csr_s23.tx_clk_phase23 == 0) begin
      `uvm_info("SPI_MON23", $psprintf("tx_clk_phase23 is %d", csr_s23.tx_clk_phase23), UVM_HIGH)
      for (int i = 0; i < csr_s23.data_size23; i++) begin
        @(negedge spi_if23.sig_sclk_in23);
        -> new_bit_started23;
        if (csr_s23.mode_select23 == 1) begin     //DUT MASTER23 mode, OVC23 Slave23 mode
          trans_collected23.receive_data23[i] = spi_if23.sig_si23;
          `uvm_info("SPI_MON23", $psprintf("received23 data in mode_select23 1 is %h", trans_collected23.receive_data23), UVM_HIGH)
        end else begin
          trans_collected23.receive_data23[i] = spi_if23.sig_mi23;
          `uvm_info("SPI_MON23", $psprintf("received23 data in mode_select23 0 is %h", trans_collected23.receive_data23), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON23", $psprintf("tx_clk_phase23 is %d", csr_s23.tx_clk_phase23), UVM_HIGH)
      for (int i = 0; i < csr_s23.data_size23; i++) begin
        @(posedge spi_if23.sig_sclk_in23);
        -> new_bit_started23;
        if (csr_s23.mode_select23 == 1) begin     //DUT MASTER23 mode, OVC23 Slave23 mode
          trans_collected23.receive_data23[i] = spi_if23.sig_si23;
          `uvm_info("SPI_MON23", $psprintf("received23 data in mode_select23 1 is %h", trans_collected23.receive_data23), UVM_HIGH)
        end else begin
          trans_collected23.receive_data23[i] = spi_if23.sig_mi23;
          `uvm_info("SPI_MON23", $psprintf("received23 data in mode_select23 0 is %h", trans_collected23.receive_data23), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON23", $psprintf("Transfer23 collected23 :\n%s", trans_collected23.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected23);
  endtask : collect_transfer23

endclass : spi_monitor23

`endif // SPI_MONITOR_SV23


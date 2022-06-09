/*-------------------------------------------------------------------------
File2 name   : spi_monitor2.sv
Title2       : SPI2 SystemVerilog2 UVM UVC2
Project2     : SystemVerilog2 UVM Cluster2 Level2 Verification2
Created2     :
Description2 : 
Notes2       :  
---------------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV2
`define SPI_MONITOR_SV2

class spi_monitor2 extends uvm_monitor;

  // This2 property is the virtual interfaced2 needed for this component to
  // view2 HDL signals2. 
  virtual interface spi_if2 spi_if2;

  spi_csr_s2 csr_s2;

  // Agent2 Id2
  protected int agent_id2;

  // The following2 bit is used to control2 whether2 coverage2 is
  // done both in the monitor2 class and the interface.
  bit coverage_enable2 = 1;

  uvm_analysis_port #(spi_transfer2) item_collected_port2;

  // The following2 property holds2 the transaction information currently
  // begin captured2 (by the collect_receive_data2 and collect_transmit_data2 methods2).
  protected spi_transfer2 trans_collected2;

  // Events2 needed to trigger covergroups2
  protected event cov_transaction2;

  event new_transfer_started2;
  event new_bit_started2;

  // Transfer2 collected2 covergroup
  covergroup cov_trans_cg2 @cov_transaction2;
    option.per_instance = 1;
    trans_mode2 : coverpoint csr_s2.mode_select2;
    trans_cpha2 : coverpoint csr_s2.tx_clk_phase2;
    trans_size2 : coverpoint csr_s2.transfer_data_size2 {
      bins sizes2[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes2 = default; }
    trans_txdata2 : coverpoint trans_collected2.transfer_data2 {
      option.auto_bin_max = 8; }
    trans_rxdata2 : coverpoint trans_collected2.receive_data2 {
      option.auto_bin_max = 8; }
    trans_modeXsize2 : cross trans_mode2, trans_size2;
  endgroup : cov_trans_cg2

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor2)
    `uvm_field_int(agent_id2, UVM_ALL_ON)
    `uvm_field_int(coverage_enable2, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg2 = new();
    cov_trans_cg2.set_inst_name("spi_cov_trans_cg2");
    item_collected_port2 = new("item_collected_port2", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if2)::get(this, "", "spi_if2", spi_if2))
   `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".spi_if2"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions2();
    join
  endtask : run_phase

  // collect_transactions2
  virtual protected task collect_transactions2();
    forever begin
      @(negedge spi_if2.sig_n_ss_in2);
      trans_collected2 = new();
      -> new_transfer_started2;
      if (m_parent != null)
        trans_collected2.agent2 = m_parent.get_name();
      collect_transfer2();
      if (coverage_enable2)
         -> cov_transaction2;
      item_collected_port2.write(trans_collected2);
    end
  endtask : collect_transactions2

  // collect_transfer2
  virtual protected task collect_transfer2();
    void'(this.begin_tr(trans_collected2));
    if (csr_s2.tx_clk_phase2 == 0) begin
      `uvm_info("SPI_MON2", $psprintf("tx_clk_phase2 is %d", csr_s2.tx_clk_phase2), UVM_HIGH)
      for (int i = 0; i < csr_s2.data_size2; i++) begin
        @(negedge spi_if2.sig_sclk_in2);
        -> new_bit_started2;
        if (csr_s2.mode_select2 == 1) begin     //DUT MASTER2 mode, OVC2 Slave2 mode
          trans_collected2.receive_data2[i] = spi_if2.sig_si2;
          `uvm_info("SPI_MON2", $psprintf("received2 data in mode_select2 1 is %h", trans_collected2.receive_data2), UVM_HIGH)
        end else begin
          trans_collected2.receive_data2[i] = spi_if2.sig_mi2;
          `uvm_info("SPI_MON2", $psprintf("received2 data in mode_select2 0 is %h", trans_collected2.receive_data2), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON2", $psprintf("tx_clk_phase2 is %d", csr_s2.tx_clk_phase2), UVM_HIGH)
      for (int i = 0; i < csr_s2.data_size2; i++) begin
        @(posedge spi_if2.sig_sclk_in2);
        -> new_bit_started2;
        if (csr_s2.mode_select2 == 1) begin     //DUT MASTER2 mode, OVC2 Slave2 mode
          trans_collected2.receive_data2[i] = spi_if2.sig_si2;
          `uvm_info("SPI_MON2", $psprintf("received2 data in mode_select2 1 is %h", trans_collected2.receive_data2), UVM_HIGH)
        end else begin
          trans_collected2.receive_data2[i] = spi_if2.sig_mi2;
          `uvm_info("SPI_MON2", $psprintf("received2 data in mode_select2 0 is %h", trans_collected2.receive_data2), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON2", $psprintf("Transfer2 collected2 :\n%s", trans_collected2.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected2);
  endtask : collect_transfer2

endclass : spi_monitor2

`endif // SPI_MONITOR_SV2


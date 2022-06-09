/*-------------------------------------------------------------------------
File24 name   : spi_driver24.sv
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


`ifndef SPI_DRIVER_SV24
`define SPI_DRIVER_SV24

class spi_driver24 extends uvm_driver #(spi_transfer24);

  // The virtual interface used to drive24 and view24 HDL signals24.
  virtual spi_if24 spi_if24;

  spi_monitor24 monitor24;
  spi_csr_s24 csr_s24;

  // Agent24 Id24
  protected int agent_id24;

  // Provide24 implmentations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(spi_driver24)
    `uvm_field_int(agent_id24, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
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
      get_and_drive24();
      reset_signals24();
    join
  endtask : run_phase

  // get_and_drive24 
  virtual protected task get_and_drive24();
    uvm_sequence_item item;
    spi_transfer24 this_trans24;
    @(posedge spi_if24.sig_n_p_reset24);
    forever begin
      @(posedge spi_if24.sig_pclk24);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans24, req))
        `uvm_fatal("CASTFL24", "Failed24 to cast req to this_trans24 in get_and_drive24")
      drive_transfer24(this_trans24);
      seq_item_port.item_done();
    end
  endtask : get_and_drive24

  // reset_signals24
  virtual protected task reset_signals24();
      @(negedge spi_if24.sig_n_p_reset24);
      spi_if24.sig_slave_out_clk24  <= 'b0;
      spi_if24.sig_n_so_en24        <= 'b1;
      spi_if24.sig_so24             <= 'bz;
      spi_if24.sig_n_ss_en24        <= 'b1;
      spi_if24.sig_n_ss_out24       <= '1;
      spi_if24.sig_n_sclk_en24      <= 'b1;
      spi_if24.sig_sclk_out24       <= 'b0;
      spi_if24.sig_n_mo_en24        <= 'b1;
      spi_if24.sig_mo24             <= 'b0;
  endtask : reset_signals24

  // drive_transfer24
  virtual protected task drive_transfer24 (spi_transfer24 trans24);
    if (csr_s24.mode_select24 == 1) begin       //DUT MASTER24 mode, OVC24 SLAVE24 mode
      @monitor24.new_transfer_started24;
      for (int i = 0; i < csr_s24.data_size24; i++) begin
        @monitor24.new_bit_started24;
        spi_if24.sig_n_so_en24 <= 1'b0;
        spi_if24.sig_so24 <= trans24.transfer_data24[i];
      end
      spi_if24.sig_n_so_en24 <= 1'b1;
      `uvm_info("SPI_DRIVER24", $psprintf("Transfer24 sent24 :\n%s", trans24.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer24

endclass : spi_driver24

`endif // SPI_DRIVER_SV24


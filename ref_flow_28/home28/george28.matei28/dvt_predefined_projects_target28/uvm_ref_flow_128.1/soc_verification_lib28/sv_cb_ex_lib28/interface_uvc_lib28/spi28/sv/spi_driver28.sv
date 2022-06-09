/*-------------------------------------------------------------------------
File28 name   : spi_driver28.sv
Title28       : SPI28 SystemVerilog28 UVM UVC28
Project28     : SystemVerilog28 UVM Cluster28 Level28 Verification28
Created28     :
Description28 : 
Notes28       :  
---------------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV28
`define SPI_DRIVER_SV28

class spi_driver28 extends uvm_driver #(spi_transfer28);

  // The virtual interface used to drive28 and view28 HDL signals28.
  virtual spi_if28 spi_if28;

  spi_monitor28 monitor28;
  spi_csr_s28 csr_s28;

  // Agent28 Id28
  protected int agent_id28;

  // Provide28 implmentations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(spi_driver28)
    `uvm_field_int(agent_id28, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if28)::get(this, "", "spi_if28", spi_if28))
   `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".spi_if28"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive28();
      reset_signals28();
    join
  endtask : run_phase

  // get_and_drive28 
  virtual protected task get_and_drive28();
    uvm_sequence_item item;
    spi_transfer28 this_trans28;
    @(posedge spi_if28.sig_n_p_reset28);
    forever begin
      @(posedge spi_if28.sig_pclk28);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans28, req))
        `uvm_fatal("CASTFL28", "Failed28 to cast req to this_trans28 in get_and_drive28")
      drive_transfer28(this_trans28);
      seq_item_port.item_done();
    end
  endtask : get_and_drive28

  // reset_signals28
  virtual protected task reset_signals28();
      @(negedge spi_if28.sig_n_p_reset28);
      spi_if28.sig_slave_out_clk28  <= 'b0;
      spi_if28.sig_n_so_en28        <= 'b1;
      spi_if28.sig_so28             <= 'bz;
      spi_if28.sig_n_ss_en28        <= 'b1;
      spi_if28.sig_n_ss_out28       <= '1;
      spi_if28.sig_n_sclk_en28      <= 'b1;
      spi_if28.sig_sclk_out28       <= 'b0;
      spi_if28.sig_n_mo_en28        <= 'b1;
      spi_if28.sig_mo28             <= 'b0;
  endtask : reset_signals28

  // drive_transfer28
  virtual protected task drive_transfer28 (spi_transfer28 trans28);
    if (csr_s28.mode_select28 == 1) begin       //DUT MASTER28 mode, OVC28 SLAVE28 mode
      @monitor28.new_transfer_started28;
      for (int i = 0; i < csr_s28.data_size28; i++) begin
        @monitor28.new_bit_started28;
        spi_if28.sig_n_so_en28 <= 1'b0;
        spi_if28.sig_so28 <= trans28.transfer_data28[i];
      end
      spi_if28.sig_n_so_en28 <= 1'b1;
      `uvm_info("SPI_DRIVER28", $psprintf("Transfer28 sent28 :\n%s", trans28.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer28

endclass : spi_driver28

`endif // SPI_DRIVER_SV28


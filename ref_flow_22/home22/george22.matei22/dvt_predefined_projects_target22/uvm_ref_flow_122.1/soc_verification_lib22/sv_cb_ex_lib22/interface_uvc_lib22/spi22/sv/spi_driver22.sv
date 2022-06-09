/*-------------------------------------------------------------------------
File22 name   : spi_driver22.sv
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


`ifndef SPI_DRIVER_SV22
`define SPI_DRIVER_SV22

class spi_driver22 extends uvm_driver #(spi_transfer22);

  // The virtual interface used to drive22 and view22 HDL signals22.
  virtual spi_if22 spi_if22;

  spi_monitor22 monitor22;
  spi_csr_s22 csr_s22;

  // Agent22 Id22
  protected int agent_id22;

  // Provide22 implmentations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(spi_driver22)
    `uvm_field_int(agent_id22, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
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
      get_and_drive22();
      reset_signals22();
    join
  endtask : run_phase

  // get_and_drive22 
  virtual protected task get_and_drive22();
    uvm_sequence_item item;
    spi_transfer22 this_trans22;
    @(posedge spi_if22.sig_n_p_reset22);
    forever begin
      @(posedge spi_if22.sig_pclk22);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans22, req))
        `uvm_fatal("CASTFL22", "Failed22 to cast req to this_trans22 in get_and_drive22")
      drive_transfer22(this_trans22);
      seq_item_port.item_done();
    end
  endtask : get_and_drive22

  // reset_signals22
  virtual protected task reset_signals22();
      @(negedge spi_if22.sig_n_p_reset22);
      spi_if22.sig_slave_out_clk22  <= 'b0;
      spi_if22.sig_n_so_en22        <= 'b1;
      spi_if22.sig_so22             <= 'bz;
      spi_if22.sig_n_ss_en22        <= 'b1;
      spi_if22.sig_n_ss_out22       <= '1;
      spi_if22.sig_n_sclk_en22      <= 'b1;
      spi_if22.sig_sclk_out22       <= 'b0;
      spi_if22.sig_n_mo_en22        <= 'b1;
      spi_if22.sig_mo22             <= 'b0;
  endtask : reset_signals22

  // drive_transfer22
  virtual protected task drive_transfer22 (spi_transfer22 trans22);
    if (csr_s22.mode_select22 == 1) begin       //DUT MASTER22 mode, OVC22 SLAVE22 mode
      @monitor22.new_transfer_started22;
      for (int i = 0; i < csr_s22.data_size22; i++) begin
        @monitor22.new_bit_started22;
        spi_if22.sig_n_so_en22 <= 1'b0;
        spi_if22.sig_so22 <= trans22.transfer_data22[i];
      end
      spi_if22.sig_n_so_en22 <= 1'b1;
      `uvm_info("SPI_DRIVER22", $psprintf("Transfer22 sent22 :\n%s", trans22.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer22

endclass : spi_driver22

`endif // SPI_DRIVER_SV22


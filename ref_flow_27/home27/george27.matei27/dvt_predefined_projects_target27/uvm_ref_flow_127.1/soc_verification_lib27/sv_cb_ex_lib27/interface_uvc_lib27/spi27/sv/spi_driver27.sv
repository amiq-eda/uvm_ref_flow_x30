/*-------------------------------------------------------------------------
File27 name   : spi_driver27.sv
Title27       : SPI27 SystemVerilog27 UVM UVC27
Project27     : SystemVerilog27 UVM Cluster27 Level27 Verification27
Created27     :
Description27 : 
Notes27       :  
---------------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV27
`define SPI_DRIVER_SV27

class spi_driver27 extends uvm_driver #(spi_transfer27);

  // The virtual interface used to drive27 and view27 HDL signals27.
  virtual spi_if27 spi_if27;

  spi_monitor27 monitor27;
  spi_csr_s27 csr_s27;

  // Agent27 Id27
  protected int agent_id27;

  // Provide27 implmentations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(spi_driver27)
    `uvm_field_int(agent_id27, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if27)::get(this, "", "spi_if27", spi_if27))
   `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".spi_if27"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive27();
      reset_signals27();
    join
  endtask : run_phase

  // get_and_drive27 
  virtual protected task get_and_drive27();
    uvm_sequence_item item;
    spi_transfer27 this_trans27;
    @(posedge spi_if27.sig_n_p_reset27);
    forever begin
      @(posedge spi_if27.sig_pclk27);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans27, req))
        `uvm_fatal("CASTFL27", "Failed27 to cast req to this_trans27 in get_and_drive27")
      drive_transfer27(this_trans27);
      seq_item_port.item_done();
    end
  endtask : get_and_drive27

  // reset_signals27
  virtual protected task reset_signals27();
      @(negedge spi_if27.sig_n_p_reset27);
      spi_if27.sig_slave_out_clk27  <= 'b0;
      spi_if27.sig_n_so_en27        <= 'b1;
      spi_if27.sig_so27             <= 'bz;
      spi_if27.sig_n_ss_en27        <= 'b1;
      spi_if27.sig_n_ss_out27       <= '1;
      spi_if27.sig_n_sclk_en27      <= 'b1;
      spi_if27.sig_sclk_out27       <= 'b0;
      spi_if27.sig_n_mo_en27        <= 'b1;
      spi_if27.sig_mo27             <= 'b0;
  endtask : reset_signals27

  // drive_transfer27
  virtual protected task drive_transfer27 (spi_transfer27 trans27);
    if (csr_s27.mode_select27 == 1) begin       //DUT MASTER27 mode, OVC27 SLAVE27 mode
      @monitor27.new_transfer_started27;
      for (int i = 0; i < csr_s27.data_size27; i++) begin
        @monitor27.new_bit_started27;
        spi_if27.sig_n_so_en27 <= 1'b0;
        spi_if27.sig_so27 <= trans27.transfer_data27[i];
      end
      spi_if27.sig_n_so_en27 <= 1'b1;
      `uvm_info("SPI_DRIVER27", $psprintf("Transfer27 sent27 :\n%s", trans27.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer27

endclass : spi_driver27

`endif // SPI_DRIVER_SV27


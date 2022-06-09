/*-------------------------------------------------------------------------
File23 name   : spi_driver23.sv
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


`ifndef SPI_DRIVER_SV23
`define SPI_DRIVER_SV23

class spi_driver23 extends uvm_driver #(spi_transfer23);

  // The virtual interface used to drive23 and view23 HDL signals23.
  virtual spi_if23 spi_if23;

  spi_monitor23 monitor23;
  spi_csr_s23 csr_s23;

  // Agent23 Id23
  protected int agent_id23;

  // Provide23 implmentations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(spi_driver23)
    `uvm_field_int(agent_id23, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
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
      get_and_drive23();
      reset_signals23();
    join
  endtask : run_phase

  // get_and_drive23 
  virtual protected task get_and_drive23();
    uvm_sequence_item item;
    spi_transfer23 this_trans23;
    @(posedge spi_if23.sig_n_p_reset23);
    forever begin
      @(posedge spi_if23.sig_pclk23);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans23, req))
        `uvm_fatal("CASTFL23", "Failed23 to cast req to this_trans23 in get_and_drive23")
      drive_transfer23(this_trans23);
      seq_item_port.item_done();
    end
  endtask : get_and_drive23

  // reset_signals23
  virtual protected task reset_signals23();
      @(negedge spi_if23.sig_n_p_reset23);
      spi_if23.sig_slave_out_clk23  <= 'b0;
      spi_if23.sig_n_so_en23        <= 'b1;
      spi_if23.sig_so23             <= 'bz;
      spi_if23.sig_n_ss_en23        <= 'b1;
      spi_if23.sig_n_ss_out23       <= '1;
      spi_if23.sig_n_sclk_en23      <= 'b1;
      spi_if23.sig_sclk_out23       <= 'b0;
      spi_if23.sig_n_mo_en23        <= 'b1;
      spi_if23.sig_mo23             <= 'b0;
  endtask : reset_signals23

  // drive_transfer23
  virtual protected task drive_transfer23 (spi_transfer23 trans23);
    if (csr_s23.mode_select23 == 1) begin       //DUT MASTER23 mode, OVC23 SLAVE23 mode
      @monitor23.new_transfer_started23;
      for (int i = 0; i < csr_s23.data_size23; i++) begin
        @monitor23.new_bit_started23;
        spi_if23.sig_n_so_en23 <= 1'b0;
        spi_if23.sig_so23 <= trans23.transfer_data23[i];
      end
      spi_if23.sig_n_so_en23 <= 1'b1;
      `uvm_info("SPI_DRIVER23", $psprintf("Transfer23 sent23 :\n%s", trans23.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer23

endclass : spi_driver23

`endif // SPI_DRIVER_SV23


/*-------------------------------------------------------------------------
File30 name   : spi_driver30.sv
Title30       : SPI30 SystemVerilog30 UVM UVC30
Project30     : SystemVerilog30 UVM Cluster30 Level30 Verification30
Created30     :
Description30 : 
Notes30       :  
---------------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV30
`define SPI_DRIVER_SV30

class spi_driver30 extends uvm_driver #(spi_transfer30);

  // The virtual interface used to drive30 and view30 HDL signals30.
  virtual spi_if30 spi_if30;

  spi_monitor30 monitor30;
  spi_csr_s30 csr_s30;

  // Agent30 Id30
  protected int agent_id30;

  // Provide30 implmentations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(spi_driver30)
    `uvm_field_int(agent_id30, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if30)::get(this, "", "spi_if30", spi_if30))
   `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".spi_if30"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive30();
      reset_signals30();
    join
  endtask : run_phase

  // get_and_drive30 
  virtual protected task get_and_drive30();
    uvm_sequence_item item;
    spi_transfer30 this_trans30;
    @(posedge spi_if30.sig_n_p_reset30);
    forever begin
      @(posedge spi_if30.sig_pclk30);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans30, req))
        `uvm_fatal("CASTFL30", "Failed30 to cast req to this_trans30 in get_and_drive30")
      drive_transfer30(this_trans30);
      seq_item_port.item_done();
    end
  endtask : get_and_drive30

  // reset_signals30
  virtual protected task reset_signals30();
      @(negedge spi_if30.sig_n_p_reset30);
      spi_if30.sig_slave_out_clk30  <= 'b0;
      spi_if30.sig_n_so_en30        <= 'b1;
      spi_if30.sig_so30             <= 'bz;
      spi_if30.sig_n_ss_en30        <= 'b1;
      spi_if30.sig_n_ss_out30       <= '1;
      spi_if30.sig_n_sclk_en30      <= 'b1;
      spi_if30.sig_sclk_out30       <= 'b0;
      spi_if30.sig_n_mo_en30        <= 'b1;
      spi_if30.sig_mo30             <= 'b0;
  endtask : reset_signals30

  // drive_transfer30
  virtual protected task drive_transfer30 (spi_transfer30 trans30);
    if (csr_s30.mode_select30 == 1) begin       //DUT MASTER30 mode, OVC30 SLAVE30 mode
      @monitor30.new_transfer_started30;
      for (int i = 0; i < csr_s30.data_size30; i++) begin
        @monitor30.new_bit_started30;
        spi_if30.sig_n_so_en30 <= 1'b0;
        spi_if30.sig_so30 <= trans30.transfer_data30[i];
      end
      spi_if30.sig_n_so_en30 <= 1'b1;
      `uvm_info("SPI_DRIVER30", $psprintf("Transfer30 sent30 :\n%s", trans30.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer30

endclass : spi_driver30

`endif // SPI_DRIVER_SV30


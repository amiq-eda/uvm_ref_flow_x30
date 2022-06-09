/*-------------------------------------------------------------------------
File15 name   : spi_driver15.sv
Title15       : SPI15 SystemVerilog15 UVM UVC15
Project15     : SystemVerilog15 UVM Cluster15 Level15 Verification15
Created15     :
Description15 : 
Notes15       :  
---------------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV15
`define SPI_DRIVER_SV15

class spi_driver15 extends uvm_driver #(spi_transfer15);

  // The virtual interface used to drive15 and view15 HDL signals15.
  virtual spi_if15 spi_if15;

  spi_monitor15 monitor15;
  spi_csr_s15 csr_s15;

  // Agent15 Id15
  protected int agent_id15;

  // Provide15 implmentations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(spi_driver15)
    `uvm_field_int(agent_id15, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if15)::get(this, "", "spi_if15", spi_if15))
   `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".spi_if15"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive15();
      reset_signals15();
    join
  endtask : run_phase

  // get_and_drive15 
  virtual protected task get_and_drive15();
    uvm_sequence_item item;
    spi_transfer15 this_trans15;
    @(posedge spi_if15.sig_n_p_reset15);
    forever begin
      @(posedge spi_if15.sig_pclk15);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans15, req))
        `uvm_fatal("CASTFL15", "Failed15 to cast req to this_trans15 in get_and_drive15")
      drive_transfer15(this_trans15);
      seq_item_port.item_done();
    end
  endtask : get_and_drive15

  // reset_signals15
  virtual protected task reset_signals15();
      @(negedge spi_if15.sig_n_p_reset15);
      spi_if15.sig_slave_out_clk15  <= 'b0;
      spi_if15.sig_n_so_en15        <= 'b1;
      spi_if15.sig_so15             <= 'bz;
      spi_if15.sig_n_ss_en15        <= 'b1;
      spi_if15.sig_n_ss_out15       <= '1;
      spi_if15.sig_n_sclk_en15      <= 'b1;
      spi_if15.sig_sclk_out15       <= 'b0;
      spi_if15.sig_n_mo_en15        <= 'b1;
      spi_if15.sig_mo15             <= 'b0;
  endtask : reset_signals15

  // drive_transfer15
  virtual protected task drive_transfer15 (spi_transfer15 trans15);
    if (csr_s15.mode_select15 == 1) begin       //DUT MASTER15 mode, OVC15 SLAVE15 mode
      @monitor15.new_transfer_started15;
      for (int i = 0; i < csr_s15.data_size15; i++) begin
        @monitor15.new_bit_started15;
        spi_if15.sig_n_so_en15 <= 1'b0;
        spi_if15.sig_so15 <= trans15.transfer_data15[i];
      end
      spi_if15.sig_n_so_en15 <= 1'b1;
      `uvm_info("SPI_DRIVER15", $psprintf("Transfer15 sent15 :\n%s", trans15.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer15

endclass : spi_driver15

`endif // SPI_DRIVER_SV15


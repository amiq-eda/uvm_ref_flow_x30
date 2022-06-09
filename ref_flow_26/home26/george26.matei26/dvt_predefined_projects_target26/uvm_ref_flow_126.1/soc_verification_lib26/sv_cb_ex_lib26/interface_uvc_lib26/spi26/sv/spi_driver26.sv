/*-------------------------------------------------------------------------
File26 name   : spi_driver26.sv
Title26       : SPI26 SystemVerilog26 UVM UVC26
Project26     : SystemVerilog26 UVM Cluster26 Level26 Verification26
Created26     :
Description26 : 
Notes26       :  
---------------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV26
`define SPI_DRIVER_SV26

class spi_driver26 extends uvm_driver #(spi_transfer26);

  // The virtual interface used to drive26 and view26 HDL signals26.
  virtual spi_if26 spi_if26;

  spi_monitor26 monitor26;
  spi_csr_s26 csr_s26;

  // Agent26 Id26
  protected int agent_id26;

  // Provide26 implmentations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(spi_driver26)
    `uvm_field_int(agent_id26, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if26)::get(this, "", "spi_if26", spi_if26))
   `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".spi_if26"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive26();
      reset_signals26();
    join
  endtask : run_phase

  // get_and_drive26 
  virtual protected task get_and_drive26();
    uvm_sequence_item item;
    spi_transfer26 this_trans26;
    @(posedge spi_if26.sig_n_p_reset26);
    forever begin
      @(posedge spi_if26.sig_pclk26);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans26, req))
        `uvm_fatal("CASTFL26", "Failed26 to cast req to this_trans26 in get_and_drive26")
      drive_transfer26(this_trans26);
      seq_item_port.item_done();
    end
  endtask : get_and_drive26

  // reset_signals26
  virtual protected task reset_signals26();
      @(negedge spi_if26.sig_n_p_reset26);
      spi_if26.sig_slave_out_clk26  <= 'b0;
      spi_if26.sig_n_so_en26        <= 'b1;
      spi_if26.sig_so26             <= 'bz;
      spi_if26.sig_n_ss_en26        <= 'b1;
      spi_if26.sig_n_ss_out26       <= '1;
      spi_if26.sig_n_sclk_en26      <= 'b1;
      spi_if26.sig_sclk_out26       <= 'b0;
      spi_if26.sig_n_mo_en26        <= 'b1;
      spi_if26.sig_mo26             <= 'b0;
  endtask : reset_signals26

  // drive_transfer26
  virtual protected task drive_transfer26 (spi_transfer26 trans26);
    if (csr_s26.mode_select26 == 1) begin       //DUT MASTER26 mode, OVC26 SLAVE26 mode
      @monitor26.new_transfer_started26;
      for (int i = 0; i < csr_s26.data_size26; i++) begin
        @monitor26.new_bit_started26;
        spi_if26.sig_n_so_en26 <= 1'b0;
        spi_if26.sig_so26 <= trans26.transfer_data26[i];
      end
      spi_if26.sig_n_so_en26 <= 1'b1;
      `uvm_info("SPI_DRIVER26", $psprintf("Transfer26 sent26 :\n%s", trans26.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer26

endclass : spi_driver26

`endif // SPI_DRIVER_SV26


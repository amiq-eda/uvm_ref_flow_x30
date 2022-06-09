/*-------------------------------------------------------------------------
File5 name   : spi_driver5.sv
Title5       : SPI5 SystemVerilog5 UVM UVC5
Project5     : SystemVerilog5 UVM Cluster5 Level5 Verification5
Created5     :
Description5 : 
Notes5       :  
---------------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV5
`define SPI_DRIVER_SV5

class spi_driver5 extends uvm_driver #(spi_transfer5);

  // The virtual interface used to drive5 and view5 HDL signals5.
  virtual spi_if5 spi_if5;

  spi_monitor5 monitor5;
  spi_csr_s5 csr_s5;

  // Agent5 Id5
  protected int agent_id5;

  // Provide5 implmentations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(spi_driver5)
    `uvm_field_int(agent_id5, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if5)::get(this, "", "spi_if5", spi_if5))
   `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".spi_if5"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive5();
      reset_signals5();
    join
  endtask : run_phase

  // get_and_drive5 
  virtual protected task get_and_drive5();
    uvm_sequence_item item;
    spi_transfer5 this_trans5;
    @(posedge spi_if5.sig_n_p_reset5);
    forever begin
      @(posedge spi_if5.sig_pclk5);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans5, req))
        `uvm_fatal("CASTFL5", "Failed5 to cast req to this_trans5 in get_and_drive5")
      drive_transfer5(this_trans5);
      seq_item_port.item_done();
    end
  endtask : get_and_drive5

  // reset_signals5
  virtual protected task reset_signals5();
      @(negedge spi_if5.sig_n_p_reset5);
      spi_if5.sig_slave_out_clk5  <= 'b0;
      spi_if5.sig_n_so_en5        <= 'b1;
      spi_if5.sig_so5             <= 'bz;
      spi_if5.sig_n_ss_en5        <= 'b1;
      spi_if5.sig_n_ss_out5       <= '1;
      spi_if5.sig_n_sclk_en5      <= 'b1;
      spi_if5.sig_sclk_out5       <= 'b0;
      spi_if5.sig_n_mo_en5        <= 'b1;
      spi_if5.sig_mo5             <= 'b0;
  endtask : reset_signals5

  // drive_transfer5
  virtual protected task drive_transfer5 (spi_transfer5 trans5);
    if (csr_s5.mode_select5 == 1) begin       //DUT MASTER5 mode, OVC5 SLAVE5 mode
      @monitor5.new_transfer_started5;
      for (int i = 0; i < csr_s5.data_size5; i++) begin
        @monitor5.new_bit_started5;
        spi_if5.sig_n_so_en5 <= 1'b0;
        spi_if5.sig_so5 <= trans5.transfer_data5[i];
      end
      spi_if5.sig_n_so_en5 <= 1'b1;
      `uvm_info("SPI_DRIVER5", $psprintf("Transfer5 sent5 :\n%s", trans5.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer5

endclass : spi_driver5

`endif // SPI_DRIVER_SV5


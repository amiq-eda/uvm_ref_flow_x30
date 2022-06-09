/*-------------------------------------------------------------------------
File17 name   : spi_driver17.sv
Title17       : SPI17 SystemVerilog17 UVM UVC17
Project17     : SystemVerilog17 UVM Cluster17 Level17 Verification17
Created17     :
Description17 : 
Notes17       :  
---------------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV17
`define SPI_DRIVER_SV17

class spi_driver17 extends uvm_driver #(spi_transfer17);

  // The virtual interface used to drive17 and view17 HDL signals17.
  virtual spi_if17 spi_if17;

  spi_monitor17 monitor17;
  spi_csr_s17 csr_s17;

  // Agent17 Id17
  protected int agent_id17;

  // Provide17 implmentations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(spi_driver17)
    `uvm_field_int(agent_id17, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if17)::get(this, "", "spi_if17", spi_if17))
   `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".spi_if17"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive17();
      reset_signals17();
    join
  endtask : run_phase

  // get_and_drive17 
  virtual protected task get_and_drive17();
    uvm_sequence_item item;
    spi_transfer17 this_trans17;
    @(posedge spi_if17.sig_n_p_reset17);
    forever begin
      @(posedge spi_if17.sig_pclk17);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans17, req))
        `uvm_fatal("CASTFL17", "Failed17 to cast req to this_trans17 in get_and_drive17")
      drive_transfer17(this_trans17);
      seq_item_port.item_done();
    end
  endtask : get_and_drive17

  // reset_signals17
  virtual protected task reset_signals17();
      @(negedge spi_if17.sig_n_p_reset17);
      spi_if17.sig_slave_out_clk17  <= 'b0;
      spi_if17.sig_n_so_en17        <= 'b1;
      spi_if17.sig_so17             <= 'bz;
      spi_if17.sig_n_ss_en17        <= 'b1;
      spi_if17.sig_n_ss_out17       <= '1;
      spi_if17.sig_n_sclk_en17      <= 'b1;
      spi_if17.sig_sclk_out17       <= 'b0;
      spi_if17.sig_n_mo_en17        <= 'b1;
      spi_if17.sig_mo17             <= 'b0;
  endtask : reset_signals17

  // drive_transfer17
  virtual protected task drive_transfer17 (spi_transfer17 trans17);
    if (csr_s17.mode_select17 == 1) begin       //DUT MASTER17 mode, OVC17 SLAVE17 mode
      @monitor17.new_transfer_started17;
      for (int i = 0; i < csr_s17.data_size17; i++) begin
        @monitor17.new_bit_started17;
        spi_if17.sig_n_so_en17 <= 1'b0;
        spi_if17.sig_so17 <= trans17.transfer_data17[i];
      end
      spi_if17.sig_n_so_en17 <= 1'b1;
      `uvm_info("SPI_DRIVER17", $psprintf("Transfer17 sent17 :\n%s", trans17.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer17

endclass : spi_driver17

`endif // SPI_DRIVER_SV17


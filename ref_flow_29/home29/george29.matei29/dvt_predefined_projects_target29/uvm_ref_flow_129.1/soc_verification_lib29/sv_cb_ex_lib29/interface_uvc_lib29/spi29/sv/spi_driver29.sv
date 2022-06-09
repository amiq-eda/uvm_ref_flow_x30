/*-------------------------------------------------------------------------
File29 name   : spi_driver29.sv
Title29       : SPI29 SystemVerilog29 UVM UVC29
Project29     : SystemVerilog29 UVM Cluster29 Level29 Verification29
Created29     :
Description29 : 
Notes29       :  
---------------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV29
`define SPI_DRIVER_SV29

class spi_driver29 extends uvm_driver #(spi_transfer29);

  // The virtual interface used to drive29 and view29 HDL signals29.
  virtual spi_if29 spi_if29;

  spi_monitor29 monitor29;
  spi_csr_s29 csr_s29;

  // Agent29 Id29
  protected int agent_id29;

  // Provide29 implmentations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(spi_driver29)
    `uvm_field_int(agent_id29, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if29)::get(this, "", "spi_if29", spi_if29))
   `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".spi_if29"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive29();
      reset_signals29();
    join
  endtask : run_phase

  // get_and_drive29 
  virtual protected task get_and_drive29();
    uvm_sequence_item item;
    spi_transfer29 this_trans29;
    @(posedge spi_if29.sig_n_p_reset29);
    forever begin
      @(posedge spi_if29.sig_pclk29);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans29, req))
        `uvm_fatal("CASTFL29", "Failed29 to cast req to this_trans29 in get_and_drive29")
      drive_transfer29(this_trans29);
      seq_item_port.item_done();
    end
  endtask : get_and_drive29

  // reset_signals29
  virtual protected task reset_signals29();
      @(negedge spi_if29.sig_n_p_reset29);
      spi_if29.sig_slave_out_clk29  <= 'b0;
      spi_if29.sig_n_so_en29        <= 'b1;
      spi_if29.sig_so29             <= 'bz;
      spi_if29.sig_n_ss_en29        <= 'b1;
      spi_if29.sig_n_ss_out29       <= '1;
      spi_if29.sig_n_sclk_en29      <= 'b1;
      spi_if29.sig_sclk_out29       <= 'b0;
      spi_if29.sig_n_mo_en29        <= 'b1;
      spi_if29.sig_mo29             <= 'b0;
  endtask : reset_signals29

  // drive_transfer29
  virtual protected task drive_transfer29 (spi_transfer29 trans29);
    if (csr_s29.mode_select29 == 1) begin       //DUT MASTER29 mode, OVC29 SLAVE29 mode
      @monitor29.new_transfer_started29;
      for (int i = 0; i < csr_s29.data_size29; i++) begin
        @monitor29.new_bit_started29;
        spi_if29.sig_n_so_en29 <= 1'b0;
        spi_if29.sig_so29 <= trans29.transfer_data29[i];
      end
      spi_if29.sig_n_so_en29 <= 1'b1;
      `uvm_info("SPI_DRIVER29", $psprintf("Transfer29 sent29 :\n%s", trans29.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer29

endclass : spi_driver29

`endif // SPI_DRIVER_SV29


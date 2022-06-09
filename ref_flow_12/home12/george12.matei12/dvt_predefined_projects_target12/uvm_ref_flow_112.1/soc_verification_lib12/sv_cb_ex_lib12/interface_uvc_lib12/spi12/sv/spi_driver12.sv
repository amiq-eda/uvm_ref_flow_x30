/*-------------------------------------------------------------------------
File12 name   : spi_driver12.sv
Title12       : SPI12 SystemVerilog12 UVM UVC12
Project12     : SystemVerilog12 UVM Cluster12 Level12 Verification12
Created12     :
Description12 : 
Notes12       :  
---------------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV12
`define SPI_DRIVER_SV12

class spi_driver12 extends uvm_driver #(spi_transfer12);

  // The virtual interface used to drive12 and view12 HDL signals12.
  virtual spi_if12 spi_if12;

  spi_monitor12 monitor12;
  spi_csr_s12 csr_s12;

  // Agent12 Id12
  protected int agent_id12;

  // Provide12 implmentations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(spi_driver12)
    `uvm_field_int(agent_id12, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if12)::get(this, "", "spi_if12", spi_if12))
   `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".spi_if12"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive12();
      reset_signals12();
    join
  endtask : run_phase

  // get_and_drive12 
  virtual protected task get_and_drive12();
    uvm_sequence_item item;
    spi_transfer12 this_trans12;
    @(posedge spi_if12.sig_n_p_reset12);
    forever begin
      @(posedge spi_if12.sig_pclk12);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans12, req))
        `uvm_fatal("CASTFL12", "Failed12 to cast req to this_trans12 in get_and_drive12")
      drive_transfer12(this_trans12);
      seq_item_port.item_done();
    end
  endtask : get_and_drive12

  // reset_signals12
  virtual protected task reset_signals12();
      @(negedge spi_if12.sig_n_p_reset12);
      spi_if12.sig_slave_out_clk12  <= 'b0;
      spi_if12.sig_n_so_en12        <= 'b1;
      spi_if12.sig_so12             <= 'bz;
      spi_if12.sig_n_ss_en12        <= 'b1;
      spi_if12.sig_n_ss_out12       <= '1;
      spi_if12.sig_n_sclk_en12      <= 'b1;
      spi_if12.sig_sclk_out12       <= 'b0;
      spi_if12.sig_n_mo_en12        <= 'b1;
      spi_if12.sig_mo12             <= 'b0;
  endtask : reset_signals12

  // drive_transfer12
  virtual protected task drive_transfer12 (spi_transfer12 trans12);
    if (csr_s12.mode_select12 == 1) begin       //DUT MASTER12 mode, OVC12 SLAVE12 mode
      @monitor12.new_transfer_started12;
      for (int i = 0; i < csr_s12.data_size12; i++) begin
        @monitor12.new_bit_started12;
        spi_if12.sig_n_so_en12 <= 1'b0;
        spi_if12.sig_so12 <= trans12.transfer_data12[i];
      end
      spi_if12.sig_n_so_en12 <= 1'b1;
      `uvm_info("SPI_DRIVER12", $psprintf("Transfer12 sent12 :\n%s", trans12.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer12

endclass : spi_driver12

`endif // SPI_DRIVER_SV12


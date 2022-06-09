/*-------------------------------------------------------------------------
File6 name   : spi_driver6.sv
Title6       : SPI6 SystemVerilog6 UVM UVC6
Project6     : SystemVerilog6 UVM Cluster6 Level6 Verification6
Created6     :
Description6 : 
Notes6       :  
---------------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV6
`define SPI_DRIVER_SV6

class spi_driver6 extends uvm_driver #(spi_transfer6);

  // The virtual interface used to drive6 and view6 HDL signals6.
  virtual spi_if6 spi_if6;

  spi_monitor6 monitor6;
  spi_csr_s6 csr_s6;

  // Agent6 Id6
  protected int agent_id6;

  // Provide6 implmentations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(spi_driver6)
    `uvm_field_int(agent_id6, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if6)::get(this, "", "spi_if6", spi_if6))
   `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".spi_if6"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive6();
      reset_signals6();
    join
  endtask : run_phase

  // get_and_drive6 
  virtual protected task get_and_drive6();
    uvm_sequence_item item;
    spi_transfer6 this_trans6;
    @(posedge spi_if6.sig_n_p_reset6);
    forever begin
      @(posedge spi_if6.sig_pclk6);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans6, req))
        `uvm_fatal("CASTFL6", "Failed6 to cast req to this_trans6 in get_and_drive6")
      drive_transfer6(this_trans6);
      seq_item_port.item_done();
    end
  endtask : get_and_drive6

  // reset_signals6
  virtual protected task reset_signals6();
      @(negedge spi_if6.sig_n_p_reset6);
      spi_if6.sig_slave_out_clk6  <= 'b0;
      spi_if6.sig_n_so_en6        <= 'b1;
      spi_if6.sig_so6             <= 'bz;
      spi_if6.sig_n_ss_en6        <= 'b1;
      spi_if6.sig_n_ss_out6       <= '1;
      spi_if6.sig_n_sclk_en6      <= 'b1;
      spi_if6.sig_sclk_out6       <= 'b0;
      spi_if6.sig_n_mo_en6        <= 'b1;
      spi_if6.sig_mo6             <= 'b0;
  endtask : reset_signals6

  // drive_transfer6
  virtual protected task drive_transfer6 (spi_transfer6 trans6);
    if (csr_s6.mode_select6 == 1) begin       //DUT MASTER6 mode, OVC6 SLAVE6 mode
      @monitor6.new_transfer_started6;
      for (int i = 0; i < csr_s6.data_size6; i++) begin
        @monitor6.new_bit_started6;
        spi_if6.sig_n_so_en6 <= 1'b0;
        spi_if6.sig_so6 <= trans6.transfer_data6[i];
      end
      spi_if6.sig_n_so_en6 <= 1'b1;
      `uvm_info("SPI_DRIVER6", $psprintf("Transfer6 sent6 :\n%s", trans6.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer6

endclass : spi_driver6

`endif // SPI_DRIVER_SV6


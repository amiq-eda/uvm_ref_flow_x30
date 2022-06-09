/*-------------------------------------------------------------------------
File18 name   : spi_driver18.sv
Title18       : SPI18 SystemVerilog18 UVM UVC18
Project18     : SystemVerilog18 UVM Cluster18 Level18 Verification18
Created18     :
Description18 : 
Notes18       :  
---------------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV18
`define SPI_DRIVER_SV18

class spi_driver18 extends uvm_driver #(spi_transfer18);

  // The virtual interface used to drive18 and view18 HDL signals18.
  virtual spi_if18 spi_if18;

  spi_monitor18 monitor18;
  spi_csr_s18 csr_s18;

  // Agent18 Id18
  protected int agent_id18;

  // Provide18 implmentations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(spi_driver18)
    `uvm_field_int(agent_id18, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if18)::get(this, "", "spi_if18", spi_if18))
   `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".spi_if18"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive18();
      reset_signals18();
    join
  endtask : run_phase

  // get_and_drive18 
  virtual protected task get_and_drive18();
    uvm_sequence_item item;
    spi_transfer18 this_trans18;
    @(posedge spi_if18.sig_n_p_reset18);
    forever begin
      @(posedge spi_if18.sig_pclk18);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans18, req))
        `uvm_fatal("CASTFL18", "Failed18 to cast req to this_trans18 in get_and_drive18")
      drive_transfer18(this_trans18);
      seq_item_port.item_done();
    end
  endtask : get_and_drive18

  // reset_signals18
  virtual protected task reset_signals18();
      @(negedge spi_if18.sig_n_p_reset18);
      spi_if18.sig_slave_out_clk18  <= 'b0;
      spi_if18.sig_n_so_en18        <= 'b1;
      spi_if18.sig_so18             <= 'bz;
      spi_if18.sig_n_ss_en18        <= 'b1;
      spi_if18.sig_n_ss_out18       <= '1;
      spi_if18.sig_n_sclk_en18      <= 'b1;
      spi_if18.sig_sclk_out18       <= 'b0;
      spi_if18.sig_n_mo_en18        <= 'b1;
      spi_if18.sig_mo18             <= 'b0;
  endtask : reset_signals18

  // drive_transfer18
  virtual protected task drive_transfer18 (spi_transfer18 trans18);
    if (csr_s18.mode_select18 == 1) begin       //DUT MASTER18 mode, OVC18 SLAVE18 mode
      @monitor18.new_transfer_started18;
      for (int i = 0; i < csr_s18.data_size18; i++) begin
        @monitor18.new_bit_started18;
        spi_if18.sig_n_so_en18 <= 1'b0;
        spi_if18.sig_so18 <= trans18.transfer_data18[i];
      end
      spi_if18.sig_n_so_en18 <= 1'b1;
      `uvm_info("SPI_DRIVER18", $psprintf("Transfer18 sent18 :\n%s", trans18.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer18

endclass : spi_driver18

`endif // SPI_DRIVER_SV18


/*-------------------------------------------------------------------------
File1 name   : spi_driver1.sv
Title1       : SPI1 SystemVerilog1 UVM UVC1
Project1     : SystemVerilog1 UVM Cluster1 Level1 Verification1
Created1     :
Description1 : 
Notes1       :  
---------------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV1
`define SPI_DRIVER_SV1

class spi_driver1 extends uvm_driver #(spi_transfer1);

  // The virtual interface used to drive1 and view1 HDL signals1.
  virtual spi_if1 spi_if1;

  spi_monitor1 monitor1;
  spi_csr_s1 csr_s1;

  // Agent1 Id1
  protected int agent_id1;

  // Provide1 implmentations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(spi_driver1)
    `uvm_field_int(agent_id1, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if1)::get(this, "", "spi_if1", spi_if1))
   `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".spi_if1"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive1();
      reset_signals1();
    join
  endtask : run_phase

  // get_and_drive1 
  virtual protected task get_and_drive1();
    uvm_sequence_item item;
    spi_transfer1 this_trans1;
    @(posedge spi_if1.sig_n_p_reset1);
    forever begin
      @(posedge spi_if1.sig_pclk1);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans1, req))
        `uvm_fatal("CASTFL1", "Failed1 to cast req to this_trans1 in get_and_drive1")
      drive_transfer1(this_trans1);
      seq_item_port.item_done();
    end
  endtask : get_and_drive1

  // reset_signals1
  virtual protected task reset_signals1();
      @(negedge spi_if1.sig_n_p_reset1);
      spi_if1.sig_slave_out_clk1  <= 'b0;
      spi_if1.sig_n_so_en1        <= 'b1;
      spi_if1.sig_so1             <= 'bz;
      spi_if1.sig_n_ss_en1        <= 'b1;
      spi_if1.sig_n_ss_out1       <= '1;
      spi_if1.sig_n_sclk_en1      <= 'b1;
      spi_if1.sig_sclk_out1       <= 'b0;
      spi_if1.sig_n_mo_en1        <= 'b1;
      spi_if1.sig_mo1             <= 'b0;
  endtask : reset_signals1

  // drive_transfer1
  virtual protected task drive_transfer1 (spi_transfer1 trans1);
    if (csr_s1.mode_select1 == 1) begin       //DUT MASTER1 mode, OVC1 SLAVE1 mode
      @monitor1.new_transfer_started1;
      for (int i = 0; i < csr_s1.data_size1; i++) begin
        @monitor1.new_bit_started1;
        spi_if1.sig_n_so_en1 <= 1'b0;
        spi_if1.sig_so1 <= trans1.transfer_data1[i];
      end
      spi_if1.sig_n_so_en1 <= 1'b1;
      `uvm_info("SPI_DRIVER1", $psprintf("Transfer1 sent1 :\n%s", trans1.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer1

endclass : spi_driver1

`endif // SPI_DRIVER_SV1


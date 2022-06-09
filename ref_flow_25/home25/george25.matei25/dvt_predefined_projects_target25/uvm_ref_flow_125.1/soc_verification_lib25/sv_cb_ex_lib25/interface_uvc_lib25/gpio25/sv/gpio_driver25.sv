/*-------------------------------------------------------------------------
File25 name   : gpio_driver25.sv
Title25       : GPIO25 SystemVerilog25 UVM OVC25
Project25     : SystemVerilog25 UVM Cluster25 Level25 Verification25
Created25     :
Description25 : 
Notes25       :  
---------------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV25
`define GPIO_DRIVER_SV25

class gpio_driver25 extends uvm_driver #(gpio_transfer25);

  // The virtual interface used to drive25 and view25 HDL signals25.
  virtual gpio_if25 gpio_if25;

  // Provide25 implmentations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils(gpio_driver25)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if25)::get(this, "", "gpio_if25", gpio_if25))
   `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".gpio_if25"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive25();
      reset_signals25();
    join
  endtask : run_phase

  // get_and_drive25 
  virtual protected task get_and_drive25();
    uvm_sequence_item item;
    gpio_transfer25 this_trans25;
    @(posedge gpio_if25.n_p_reset25);
    forever begin
      @(posedge gpio_if25.pclk25);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans25, req))
        `uvm_fatal("CASTFL25", "Failed25 to cast req to this_trans25 in get_and_drive25")
      drive_transfer25(this_trans25);
      seq_item_port.item_done();
    end
  endtask : get_and_drive25

  // reset_signals25
  virtual protected task reset_signals25();
      @(negedge gpio_if25.n_p_reset25);
      gpio_if25.gpio_pin_in25  <= 'b0;
  endtask : reset_signals25

  // drive_transfer25
  virtual protected task drive_transfer25 (gpio_transfer25 trans25);
    if (trans25.transmit_delay25 > 0) begin
      repeat(trans25.transmit_delay25) @(posedge gpio_if25.pclk25);
    end
    drive_data25(trans25);
  endtask : drive_transfer25

  virtual protected task drive_data25 (gpio_transfer25 trans25);
    @gpio_if25.pclk25;
    for (int i = 0; i < `GPIO_DATA_WIDTH25; i++) begin
      if (gpio_if25.n_gpio_pin_oe25[i] == 0) begin
        trans25.transfer_data25[i] = gpio_if25.gpio_pin_out25[i];
        gpio_if25.gpio_pin_in25[i] = gpio_if25.gpio_pin_out25[i];
      end else
        gpio_if25.gpio_pin_in25[i] = trans25.transfer_data25[i];
    end
    `uvm_info("GPIO_DRIVER25", $psprintf("GPIO25 Transfer25:\n%s", trans25.sprint()), UVM_MEDIUM)
  endtask : drive_data25

endclass : gpio_driver25

`endif // GPIO_DRIVER_SV25


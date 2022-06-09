/*-------------------------------------------------------------------------
File24 name   : gpio_driver24.sv
Title24       : GPIO24 SystemVerilog24 UVM OVC24
Project24     : SystemVerilog24 UVM Cluster24 Level24 Verification24
Created24     :
Description24 : 
Notes24       :  
---------------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV24
`define GPIO_DRIVER_SV24

class gpio_driver24 extends uvm_driver #(gpio_transfer24);

  // The virtual interface used to drive24 and view24 HDL signals24.
  virtual gpio_if24 gpio_if24;

  // Provide24 implmentations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils(gpio_driver24)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if24)::get(this, "", "gpio_if24", gpio_if24))
   `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".gpio_if24"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive24();
      reset_signals24();
    join
  endtask : run_phase

  // get_and_drive24 
  virtual protected task get_and_drive24();
    uvm_sequence_item item;
    gpio_transfer24 this_trans24;
    @(posedge gpio_if24.n_p_reset24);
    forever begin
      @(posedge gpio_if24.pclk24);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans24, req))
        `uvm_fatal("CASTFL24", "Failed24 to cast req to this_trans24 in get_and_drive24")
      drive_transfer24(this_trans24);
      seq_item_port.item_done();
    end
  endtask : get_and_drive24

  // reset_signals24
  virtual protected task reset_signals24();
      @(negedge gpio_if24.n_p_reset24);
      gpio_if24.gpio_pin_in24  <= 'b0;
  endtask : reset_signals24

  // drive_transfer24
  virtual protected task drive_transfer24 (gpio_transfer24 trans24);
    if (trans24.transmit_delay24 > 0) begin
      repeat(trans24.transmit_delay24) @(posedge gpio_if24.pclk24);
    end
    drive_data24(trans24);
  endtask : drive_transfer24

  virtual protected task drive_data24 (gpio_transfer24 trans24);
    @gpio_if24.pclk24;
    for (int i = 0; i < `GPIO_DATA_WIDTH24; i++) begin
      if (gpio_if24.n_gpio_pin_oe24[i] == 0) begin
        trans24.transfer_data24[i] = gpio_if24.gpio_pin_out24[i];
        gpio_if24.gpio_pin_in24[i] = gpio_if24.gpio_pin_out24[i];
      end else
        gpio_if24.gpio_pin_in24[i] = trans24.transfer_data24[i];
    end
    `uvm_info("GPIO_DRIVER24", $psprintf("GPIO24 Transfer24:\n%s", trans24.sprint()), UVM_MEDIUM)
  endtask : drive_data24

endclass : gpio_driver24

`endif // GPIO_DRIVER_SV24


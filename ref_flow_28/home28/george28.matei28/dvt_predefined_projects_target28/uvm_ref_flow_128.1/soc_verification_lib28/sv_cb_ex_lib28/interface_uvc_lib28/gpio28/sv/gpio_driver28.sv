/*-------------------------------------------------------------------------
File28 name   : gpio_driver28.sv
Title28       : GPIO28 SystemVerilog28 UVM OVC28
Project28     : SystemVerilog28 UVM Cluster28 Level28 Verification28
Created28     :
Description28 : 
Notes28       :  
---------------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV28
`define GPIO_DRIVER_SV28

class gpio_driver28 extends uvm_driver #(gpio_transfer28);

  // The virtual interface used to drive28 and view28 HDL signals28.
  virtual gpio_if28 gpio_if28;

  // Provide28 implmentations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils(gpio_driver28)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if28)::get(this, "", "gpio_if28", gpio_if28))
   `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".gpio_if28"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive28();
      reset_signals28();
    join
  endtask : run_phase

  // get_and_drive28 
  virtual protected task get_and_drive28();
    uvm_sequence_item item;
    gpio_transfer28 this_trans28;
    @(posedge gpio_if28.n_p_reset28);
    forever begin
      @(posedge gpio_if28.pclk28);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans28, req))
        `uvm_fatal("CASTFL28", "Failed28 to cast req to this_trans28 in get_and_drive28")
      drive_transfer28(this_trans28);
      seq_item_port.item_done();
    end
  endtask : get_and_drive28

  // reset_signals28
  virtual protected task reset_signals28();
      @(negedge gpio_if28.n_p_reset28);
      gpio_if28.gpio_pin_in28  <= 'b0;
  endtask : reset_signals28

  // drive_transfer28
  virtual protected task drive_transfer28 (gpio_transfer28 trans28);
    if (trans28.transmit_delay28 > 0) begin
      repeat(trans28.transmit_delay28) @(posedge gpio_if28.pclk28);
    end
    drive_data28(trans28);
  endtask : drive_transfer28

  virtual protected task drive_data28 (gpio_transfer28 trans28);
    @gpio_if28.pclk28;
    for (int i = 0; i < `GPIO_DATA_WIDTH28; i++) begin
      if (gpio_if28.n_gpio_pin_oe28[i] == 0) begin
        trans28.transfer_data28[i] = gpio_if28.gpio_pin_out28[i];
        gpio_if28.gpio_pin_in28[i] = gpio_if28.gpio_pin_out28[i];
      end else
        gpio_if28.gpio_pin_in28[i] = trans28.transfer_data28[i];
    end
    `uvm_info("GPIO_DRIVER28", $psprintf("GPIO28 Transfer28:\n%s", trans28.sprint()), UVM_MEDIUM)
  endtask : drive_data28

endclass : gpio_driver28

`endif // GPIO_DRIVER_SV28


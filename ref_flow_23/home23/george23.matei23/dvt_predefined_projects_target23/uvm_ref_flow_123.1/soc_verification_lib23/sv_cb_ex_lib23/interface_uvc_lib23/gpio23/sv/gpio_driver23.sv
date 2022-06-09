/*-------------------------------------------------------------------------
File23 name   : gpio_driver23.sv
Title23       : GPIO23 SystemVerilog23 UVM OVC23
Project23     : SystemVerilog23 UVM Cluster23 Level23 Verification23
Created23     :
Description23 : 
Notes23       :  
---------------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV23
`define GPIO_DRIVER_SV23

class gpio_driver23 extends uvm_driver #(gpio_transfer23);

  // The virtual interface used to drive23 and view23 HDL signals23.
  virtual gpio_if23 gpio_if23;

  // Provide23 implmentations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils(gpio_driver23)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if23)::get(this, "", "gpio_if23", gpio_if23))
   `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".gpio_if23"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive23();
      reset_signals23();
    join
  endtask : run_phase

  // get_and_drive23 
  virtual protected task get_and_drive23();
    uvm_sequence_item item;
    gpio_transfer23 this_trans23;
    @(posedge gpio_if23.n_p_reset23);
    forever begin
      @(posedge gpio_if23.pclk23);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans23, req))
        `uvm_fatal("CASTFL23", "Failed23 to cast req to this_trans23 in get_and_drive23")
      drive_transfer23(this_trans23);
      seq_item_port.item_done();
    end
  endtask : get_and_drive23

  // reset_signals23
  virtual protected task reset_signals23();
      @(negedge gpio_if23.n_p_reset23);
      gpio_if23.gpio_pin_in23  <= 'b0;
  endtask : reset_signals23

  // drive_transfer23
  virtual protected task drive_transfer23 (gpio_transfer23 trans23);
    if (trans23.transmit_delay23 > 0) begin
      repeat(trans23.transmit_delay23) @(posedge gpio_if23.pclk23);
    end
    drive_data23(trans23);
  endtask : drive_transfer23

  virtual protected task drive_data23 (gpio_transfer23 trans23);
    @gpio_if23.pclk23;
    for (int i = 0; i < `GPIO_DATA_WIDTH23; i++) begin
      if (gpio_if23.n_gpio_pin_oe23[i] == 0) begin
        trans23.transfer_data23[i] = gpio_if23.gpio_pin_out23[i];
        gpio_if23.gpio_pin_in23[i] = gpio_if23.gpio_pin_out23[i];
      end else
        gpio_if23.gpio_pin_in23[i] = trans23.transfer_data23[i];
    end
    `uvm_info("GPIO_DRIVER23", $psprintf("GPIO23 Transfer23:\n%s", trans23.sprint()), UVM_MEDIUM)
  endtask : drive_data23

endclass : gpio_driver23

`endif // GPIO_DRIVER_SV23


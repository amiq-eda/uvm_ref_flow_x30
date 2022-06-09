/*-------------------------------------------------------------------------
File11 name   : gpio_driver11.sv
Title11       : GPIO11 SystemVerilog11 UVM OVC11
Project11     : SystemVerilog11 UVM Cluster11 Level11 Verification11
Created11     :
Description11 : 
Notes11       :  
---------------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV11
`define GPIO_DRIVER_SV11

class gpio_driver11 extends uvm_driver #(gpio_transfer11);

  // The virtual interface used to drive11 and view11 HDL signals11.
  virtual gpio_if11 gpio_if11;

  // Provide11 implmentations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils(gpio_driver11)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if11)::get(this, "", "gpio_if11", gpio_if11))
   `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".gpio_if11"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive11();
      reset_signals11();
    join
  endtask : run_phase

  // get_and_drive11 
  virtual protected task get_and_drive11();
    uvm_sequence_item item;
    gpio_transfer11 this_trans11;
    @(posedge gpio_if11.n_p_reset11);
    forever begin
      @(posedge gpio_if11.pclk11);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans11, req))
        `uvm_fatal("CASTFL11", "Failed11 to cast req to this_trans11 in get_and_drive11")
      drive_transfer11(this_trans11);
      seq_item_port.item_done();
    end
  endtask : get_and_drive11

  // reset_signals11
  virtual protected task reset_signals11();
      @(negedge gpio_if11.n_p_reset11);
      gpio_if11.gpio_pin_in11  <= 'b0;
  endtask : reset_signals11

  // drive_transfer11
  virtual protected task drive_transfer11 (gpio_transfer11 trans11);
    if (trans11.transmit_delay11 > 0) begin
      repeat(trans11.transmit_delay11) @(posedge gpio_if11.pclk11);
    end
    drive_data11(trans11);
  endtask : drive_transfer11

  virtual protected task drive_data11 (gpio_transfer11 trans11);
    @gpio_if11.pclk11;
    for (int i = 0; i < `GPIO_DATA_WIDTH11; i++) begin
      if (gpio_if11.n_gpio_pin_oe11[i] == 0) begin
        trans11.transfer_data11[i] = gpio_if11.gpio_pin_out11[i];
        gpio_if11.gpio_pin_in11[i] = gpio_if11.gpio_pin_out11[i];
      end else
        gpio_if11.gpio_pin_in11[i] = trans11.transfer_data11[i];
    end
    `uvm_info("GPIO_DRIVER11", $psprintf("GPIO11 Transfer11:\n%s", trans11.sprint()), UVM_MEDIUM)
  endtask : drive_data11

endclass : gpio_driver11

`endif // GPIO_DRIVER_SV11


/*-------------------------------------------------------------------------
File4 name   : gpio_driver4.sv
Title4       : GPIO4 SystemVerilog4 UVM OVC4
Project4     : SystemVerilog4 UVM Cluster4 Level4 Verification4
Created4     :
Description4 : 
Notes4       :  
---------------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV4
`define GPIO_DRIVER_SV4

class gpio_driver4 extends uvm_driver #(gpio_transfer4);

  // The virtual interface used to drive4 and view4 HDL signals4.
  virtual gpio_if4 gpio_if4;

  // Provide4 implmentations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils(gpio_driver4)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if4)::get(this, "", "gpio_if4", gpio_if4))
   `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".gpio_if4"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive4();
      reset_signals4();
    join
  endtask : run_phase

  // get_and_drive4 
  virtual protected task get_and_drive4();
    uvm_sequence_item item;
    gpio_transfer4 this_trans4;
    @(posedge gpio_if4.n_p_reset4);
    forever begin
      @(posedge gpio_if4.pclk4);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans4, req))
        `uvm_fatal("CASTFL4", "Failed4 to cast req to this_trans4 in get_and_drive4")
      drive_transfer4(this_trans4);
      seq_item_port.item_done();
    end
  endtask : get_and_drive4

  // reset_signals4
  virtual protected task reset_signals4();
      @(negedge gpio_if4.n_p_reset4);
      gpio_if4.gpio_pin_in4  <= 'b0;
  endtask : reset_signals4

  // drive_transfer4
  virtual protected task drive_transfer4 (gpio_transfer4 trans4);
    if (trans4.transmit_delay4 > 0) begin
      repeat(trans4.transmit_delay4) @(posedge gpio_if4.pclk4);
    end
    drive_data4(trans4);
  endtask : drive_transfer4

  virtual protected task drive_data4 (gpio_transfer4 trans4);
    @gpio_if4.pclk4;
    for (int i = 0; i < `GPIO_DATA_WIDTH4; i++) begin
      if (gpio_if4.n_gpio_pin_oe4[i] == 0) begin
        trans4.transfer_data4[i] = gpio_if4.gpio_pin_out4[i];
        gpio_if4.gpio_pin_in4[i] = gpio_if4.gpio_pin_out4[i];
      end else
        gpio_if4.gpio_pin_in4[i] = trans4.transfer_data4[i];
    end
    `uvm_info("GPIO_DRIVER4", $psprintf("GPIO4 Transfer4:\n%s", trans4.sprint()), UVM_MEDIUM)
  endtask : drive_data4

endclass : gpio_driver4

`endif // GPIO_DRIVER_SV4


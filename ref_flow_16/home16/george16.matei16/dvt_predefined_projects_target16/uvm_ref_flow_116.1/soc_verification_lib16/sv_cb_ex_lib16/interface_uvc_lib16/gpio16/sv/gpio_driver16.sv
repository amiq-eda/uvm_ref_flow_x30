/*-------------------------------------------------------------------------
File16 name   : gpio_driver16.sv
Title16       : GPIO16 SystemVerilog16 UVM OVC16
Project16     : SystemVerilog16 UVM Cluster16 Level16 Verification16
Created16     :
Description16 : 
Notes16       :  
---------------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV16
`define GPIO_DRIVER_SV16

class gpio_driver16 extends uvm_driver #(gpio_transfer16);

  // The virtual interface used to drive16 and view16 HDL signals16.
  virtual gpio_if16 gpio_if16;

  // Provide16 implmentations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils(gpio_driver16)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if16)::get(this, "", "gpio_if16", gpio_if16))
   `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".gpio_if16"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive16();
      reset_signals16();
    join
  endtask : run_phase

  // get_and_drive16 
  virtual protected task get_and_drive16();
    uvm_sequence_item item;
    gpio_transfer16 this_trans16;
    @(posedge gpio_if16.n_p_reset16);
    forever begin
      @(posedge gpio_if16.pclk16);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans16, req))
        `uvm_fatal("CASTFL16", "Failed16 to cast req to this_trans16 in get_and_drive16")
      drive_transfer16(this_trans16);
      seq_item_port.item_done();
    end
  endtask : get_and_drive16

  // reset_signals16
  virtual protected task reset_signals16();
      @(negedge gpio_if16.n_p_reset16);
      gpio_if16.gpio_pin_in16  <= 'b0;
  endtask : reset_signals16

  // drive_transfer16
  virtual protected task drive_transfer16 (gpio_transfer16 trans16);
    if (trans16.transmit_delay16 > 0) begin
      repeat(trans16.transmit_delay16) @(posedge gpio_if16.pclk16);
    end
    drive_data16(trans16);
  endtask : drive_transfer16

  virtual protected task drive_data16 (gpio_transfer16 trans16);
    @gpio_if16.pclk16;
    for (int i = 0; i < `GPIO_DATA_WIDTH16; i++) begin
      if (gpio_if16.n_gpio_pin_oe16[i] == 0) begin
        trans16.transfer_data16[i] = gpio_if16.gpio_pin_out16[i];
        gpio_if16.gpio_pin_in16[i] = gpio_if16.gpio_pin_out16[i];
      end else
        gpio_if16.gpio_pin_in16[i] = trans16.transfer_data16[i];
    end
    `uvm_info("GPIO_DRIVER16", $psprintf("GPIO16 Transfer16:\n%s", trans16.sprint()), UVM_MEDIUM)
  endtask : drive_data16

endclass : gpio_driver16

`endif // GPIO_DRIVER_SV16


/*-------------------------------------------------------------------------
File29 name   : gpio_driver29.sv
Title29       : GPIO29 SystemVerilog29 UVM OVC29
Project29     : SystemVerilog29 UVM Cluster29 Level29 Verification29
Created29     :
Description29 : 
Notes29       :  
---------------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV29
`define GPIO_DRIVER_SV29

class gpio_driver29 extends uvm_driver #(gpio_transfer29);

  // The virtual interface used to drive29 and view29 HDL signals29.
  virtual gpio_if29 gpio_if29;

  // Provide29 implmentations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils(gpio_driver29)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if29)::get(this, "", "gpio_if29", gpio_if29))
   `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".gpio_if29"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive29();
      reset_signals29();
    join
  endtask : run_phase

  // get_and_drive29 
  virtual protected task get_and_drive29();
    uvm_sequence_item item;
    gpio_transfer29 this_trans29;
    @(posedge gpio_if29.n_p_reset29);
    forever begin
      @(posedge gpio_if29.pclk29);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans29, req))
        `uvm_fatal("CASTFL29", "Failed29 to cast req to this_trans29 in get_and_drive29")
      drive_transfer29(this_trans29);
      seq_item_port.item_done();
    end
  endtask : get_and_drive29

  // reset_signals29
  virtual protected task reset_signals29();
      @(negedge gpio_if29.n_p_reset29);
      gpio_if29.gpio_pin_in29  <= 'b0;
  endtask : reset_signals29

  // drive_transfer29
  virtual protected task drive_transfer29 (gpio_transfer29 trans29);
    if (trans29.transmit_delay29 > 0) begin
      repeat(trans29.transmit_delay29) @(posedge gpio_if29.pclk29);
    end
    drive_data29(trans29);
  endtask : drive_transfer29

  virtual protected task drive_data29 (gpio_transfer29 trans29);
    @gpio_if29.pclk29;
    for (int i = 0; i < `GPIO_DATA_WIDTH29; i++) begin
      if (gpio_if29.n_gpio_pin_oe29[i] == 0) begin
        trans29.transfer_data29[i] = gpio_if29.gpio_pin_out29[i];
        gpio_if29.gpio_pin_in29[i] = gpio_if29.gpio_pin_out29[i];
      end else
        gpio_if29.gpio_pin_in29[i] = trans29.transfer_data29[i];
    end
    `uvm_info("GPIO_DRIVER29", $psprintf("GPIO29 Transfer29:\n%s", trans29.sprint()), UVM_MEDIUM)
  endtask : drive_data29

endclass : gpio_driver29

`endif // GPIO_DRIVER_SV29


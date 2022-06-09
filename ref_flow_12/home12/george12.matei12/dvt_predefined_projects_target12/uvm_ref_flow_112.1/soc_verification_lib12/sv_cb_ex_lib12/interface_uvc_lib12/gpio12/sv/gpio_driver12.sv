/*-------------------------------------------------------------------------
File12 name   : gpio_driver12.sv
Title12       : GPIO12 SystemVerilog12 UVM OVC12
Project12     : SystemVerilog12 UVM Cluster12 Level12 Verification12
Created12     :
Description12 : 
Notes12       :  
---------------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV12
`define GPIO_DRIVER_SV12

class gpio_driver12 extends uvm_driver #(gpio_transfer12);

  // The virtual interface used to drive12 and view12 HDL signals12.
  virtual gpio_if12 gpio_if12;

  // Provide12 implmentations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils(gpio_driver12)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if12)::get(this, "", "gpio_if12", gpio_if12))
   `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".gpio_if12"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive12();
      reset_signals12();
    join
  endtask : run_phase

  // get_and_drive12 
  virtual protected task get_and_drive12();
    uvm_sequence_item item;
    gpio_transfer12 this_trans12;
    @(posedge gpio_if12.n_p_reset12);
    forever begin
      @(posedge gpio_if12.pclk12);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans12, req))
        `uvm_fatal("CASTFL12", "Failed12 to cast req to this_trans12 in get_and_drive12")
      drive_transfer12(this_trans12);
      seq_item_port.item_done();
    end
  endtask : get_and_drive12

  // reset_signals12
  virtual protected task reset_signals12();
      @(negedge gpio_if12.n_p_reset12);
      gpio_if12.gpio_pin_in12  <= 'b0;
  endtask : reset_signals12

  // drive_transfer12
  virtual protected task drive_transfer12 (gpio_transfer12 trans12);
    if (trans12.transmit_delay12 > 0) begin
      repeat(trans12.transmit_delay12) @(posedge gpio_if12.pclk12);
    end
    drive_data12(trans12);
  endtask : drive_transfer12

  virtual protected task drive_data12 (gpio_transfer12 trans12);
    @gpio_if12.pclk12;
    for (int i = 0; i < `GPIO_DATA_WIDTH12; i++) begin
      if (gpio_if12.n_gpio_pin_oe12[i] == 0) begin
        trans12.transfer_data12[i] = gpio_if12.gpio_pin_out12[i];
        gpio_if12.gpio_pin_in12[i] = gpio_if12.gpio_pin_out12[i];
      end else
        gpio_if12.gpio_pin_in12[i] = trans12.transfer_data12[i];
    end
    `uvm_info("GPIO_DRIVER12", $psprintf("GPIO12 Transfer12:\n%s", trans12.sprint()), UVM_MEDIUM)
  endtask : drive_data12

endclass : gpio_driver12

`endif // GPIO_DRIVER_SV12


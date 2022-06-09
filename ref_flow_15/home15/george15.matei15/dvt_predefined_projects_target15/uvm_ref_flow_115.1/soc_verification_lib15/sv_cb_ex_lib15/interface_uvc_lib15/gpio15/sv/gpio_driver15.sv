/*-------------------------------------------------------------------------
File15 name   : gpio_driver15.sv
Title15       : GPIO15 SystemVerilog15 UVM OVC15
Project15     : SystemVerilog15 UVM Cluster15 Level15 Verification15
Created15     :
Description15 : 
Notes15       :  
---------------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV15
`define GPIO_DRIVER_SV15

class gpio_driver15 extends uvm_driver #(gpio_transfer15);

  // The virtual interface used to drive15 and view15 HDL signals15.
  virtual gpio_if15 gpio_if15;

  // Provide15 implmentations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils(gpio_driver15)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if15)::get(this, "", "gpio_if15", gpio_if15))
   `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".gpio_if15"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive15();
      reset_signals15();
    join
  endtask : run_phase

  // get_and_drive15 
  virtual protected task get_and_drive15();
    uvm_sequence_item item;
    gpio_transfer15 this_trans15;
    @(posedge gpio_if15.n_p_reset15);
    forever begin
      @(posedge gpio_if15.pclk15);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans15, req))
        `uvm_fatal("CASTFL15", "Failed15 to cast req to this_trans15 in get_and_drive15")
      drive_transfer15(this_trans15);
      seq_item_port.item_done();
    end
  endtask : get_and_drive15

  // reset_signals15
  virtual protected task reset_signals15();
      @(negedge gpio_if15.n_p_reset15);
      gpio_if15.gpio_pin_in15  <= 'b0;
  endtask : reset_signals15

  // drive_transfer15
  virtual protected task drive_transfer15 (gpio_transfer15 trans15);
    if (trans15.transmit_delay15 > 0) begin
      repeat(trans15.transmit_delay15) @(posedge gpio_if15.pclk15);
    end
    drive_data15(trans15);
  endtask : drive_transfer15

  virtual protected task drive_data15 (gpio_transfer15 trans15);
    @gpio_if15.pclk15;
    for (int i = 0; i < `GPIO_DATA_WIDTH15; i++) begin
      if (gpio_if15.n_gpio_pin_oe15[i] == 0) begin
        trans15.transfer_data15[i] = gpio_if15.gpio_pin_out15[i];
        gpio_if15.gpio_pin_in15[i] = gpio_if15.gpio_pin_out15[i];
      end else
        gpio_if15.gpio_pin_in15[i] = trans15.transfer_data15[i];
    end
    `uvm_info("GPIO_DRIVER15", $psprintf("GPIO15 Transfer15:\n%s", trans15.sprint()), UVM_MEDIUM)
  endtask : drive_data15

endclass : gpio_driver15

`endif // GPIO_DRIVER_SV15


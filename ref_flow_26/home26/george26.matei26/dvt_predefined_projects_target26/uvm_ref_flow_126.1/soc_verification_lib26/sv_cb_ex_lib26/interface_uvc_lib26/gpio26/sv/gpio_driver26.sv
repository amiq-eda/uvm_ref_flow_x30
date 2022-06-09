/*-------------------------------------------------------------------------
File26 name   : gpio_driver26.sv
Title26       : GPIO26 SystemVerilog26 UVM OVC26
Project26     : SystemVerilog26 UVM Cluster26 Level26 Verification26
Created26     :
Description26 : 
Notes26       :  
---------------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV26
`define GPIO_DRIVER_SV26

class gpio_driver26 extends uvm_driver #(gpio_transfer26);

  // The virtual interface used to drive26 and view26 HDL signals26.
  virtual gpio_if26 gpio_if26;

  // Provide26 implmentations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils(gpio_driver26)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if26)::get(this, "", "gpio_if26", gpio_if26))
   `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".gpio_if26"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive26();
      reset_signals26();
    join
  endtask : run_phase

  // get_and_drive26 
  virtual protected task get_and_drive26();
    uvm_sequence_item item;
    gpio_transfer26 this_trans26;
    @(posedge gpio_if26.n_p_reset26);
    forever begin
      @(posedge gpio_if26.pclk26);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans26, req))
        `uvm_fatal("CASTFL26", "Failed26 to cast req to this_trans26 in get_and_drive26")
      drive_transfer26(this_trans26);
      seq_item_port.item_done();
    end
  endtask : get_and_drive26

  // reset_signals26
  virtual protected task reset_signals26();
      @(negedge gpio_if26.n_p_reset26);
      gpio_if26.gpio_pin_in26  <= 'b0;
  endtask : reset_signals26

  // drive_transfer26
  virtual protected task drive_transfer26 (gpio_transfer26 trans26);
    if (trans26.transmit_delay26 > 0) begin
      repeat(trans26.transmit_delay26) @(posedge gpio_if26.pclk26);
    end
    drive_data26(trans26);
  endtask : drive_transfer26

  virtual protected task drive_data26 (gpio_transfer26 trans26);
    @gpio_if26.pclk26;
    for (int i = 0; i < `GPIO_DATA_WIDTH26; i++) begin
      if (gpio_if26.n_gpio_pin_oe26[i] == 0) begin
        trans26.transfer_data26[i] = gpio_if26.gpio_pin_out26[i];
        gpio_if26.gpio_pin_in26[i] = gpio_if26.gpio_pin_out26[i];
      end else
        gpio_if26.gpio_pin_in26[i] = trans26.transfer_data26[i];
    end
    `uvm_info("GPIO_DRIVER26", $psprintf("GPIO26 Transfer26:\n%s", trans26.sprint()), UVM_MEDIUM)
  endtask : drive_data26

endclass : gpio_driver26

`endif // GPIO_DRIVER_SV26


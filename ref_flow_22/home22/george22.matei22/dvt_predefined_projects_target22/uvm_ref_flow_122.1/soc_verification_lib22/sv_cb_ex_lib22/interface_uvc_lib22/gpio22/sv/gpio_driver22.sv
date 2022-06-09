/*-------------------------------------------------------------------------
File22 name   : gpio_driver22.sv
Title22       : GPIO22 SystemVerilog22 UVM OVC22
Project22     : SystemVerilog22 UVM Cluster22 Level22 Verification22
Created22     :
Description22 : 
Notes22       :  
---------------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV22
`define GPIO_DRIVER_SV22

class gpio_driver22 extends uvm_driver #(gpio_transfer22);

  // The virtual interface used to drive22 and view22 HDL signals22.
  virtual gpio_if22 gpio_if22;

  // Provide22 implmentations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils(gpio_driver22)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if22)::get(this, "", "gpio_if22", gpio_if22))
   `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".gpio_if22"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive22();
      reset_signals22();
    join
  endtask : run_phase

  // get_and_drive22 
  virtual protected task get_and_drive22();
    uvm_sequence_item item;
    gpio_transfer22 this_trans22;
    @(posedge gpio_if22.n_p_reset22);
    forever begin
      @(posedge gpio_if22.pclk22);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans22, req))
        `uvm_fatal("CASTFL22", "Failed22 to cast req to this_trans22 in get_and_drive22")
      drive_transfer22(this_trans22);
      seq_item_port.item_done();
    end
  endtask : get_and_drive22

  // reset_signals22
  virtual protected task reset_signals22();
      @(negedge gpio_if22.n_p_reset22);
      gpio_if22.gpio_pin_in22  <= 'b0;
  endtask : reset_signals22

  // drive_transfer22
  virtual protected task drive_transfer22 (gpio_transfer22 trans22);
    if (trans22.transmit_delay22 > 0) begin
      repeat(trans22.transmit_delay22) @(posedge gpio_if22.pclk22);
    end
    drive_data22(trans22);
  endtask : drive_transfer22

  virtual protected task drive_data22 (gpio_transfer22 trans22);
    @gpio_if22.pclk22;
    for (int i = 0; i < `GPIO_DATA_WIDTH22; i++) begin
      if (gpio_if22.n_gpio_pin_oe22[i] == 0) begin
        trans22.transfer_data22[i] = gpio_if22.gpio_pin_out22[i];
        gpio_if22.gpio_pin_in22[i] = gpio_if22.gpio_pin_out22[i];
      end else
        gpio_if22.gpio_pin_in22[i] = trans22.transfer_data22[i];
    end
    `uvm_info("GPIO_DRIVER22", $psprintf("GPIO22 Transfer22:\n%s", trans22.sprint()), UVM_MEDIUM)
  endtask : drive_data22

endclass : gpio_driver22

`endif // GPIO_DRIVER_SV22


/*-------------------------------------------------------------------------
File17 name   : gpio_driver17.sv
Title17       : GPIO17 SystemVerilog17 UVM OVC17
Project17     : SystemVerilog17 UVM Cluster17 Level17 Verification17
Created17     :
Description17 : 
Notes17       :  
---------------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV17
`define GPIO_DRIVER_SV17

class gpio_driver17 extends uvm_driver #(gpio_transfer17);

  // The virtual interface used to drive17 and view17 HDL signals17.
  virtual gpio_if17 gpio_if17;

  // Provide17 implmentations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils(gpio_driver17)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if17)::get(this, "", "gpio_if17", gpio_if17))
   `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".gpio_if17"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive17();
      reset_signals17();
    join
  endtask : run_phase

  // get_and_drive17 
  virtual protected task get_and_drive17();
    uvm_sequence_item item;
    gpio_transfer17 this_trans17;
    @(posedge gpio_if17.n_p_reset17);
    forever begin
      @(posedge gpio_if17.pclk17);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans17, req))
        `uvm_fatal("CASTFL17", "Failed17 to cast req to this_trans17 in get_and_drive17")
      drive_transfer17(this_trans17);
      seq_item_port.item_done();
    end
  endtask : get_and_drive17

  // reset_signals17
  virtual protected task reset_signals17();
      @(negedge gpio_if17.n_p_reset17);
      gpio_if17.gpio_pin_in17  <= 'b0;
  endtask : reset_signals17

  // drive_transfer17
  virtual protected task drive_transfer17 (gpio_transfer17 trans17);
    if (trans17.transmit_delay17 > 0) begin
      repeat(trans17.transmit_delay17) @(posedge gpio_if17.pclk17);
    end
    drive_data17(trans17);
  endtask : drive_transfer17

  virtual protected task drive_data17 (gpio_transfer17 trans17);
    @gpio_if17.pclk17;
    for (int i = 0; i < `GPIO_DATA_WIDTH17; i++) begin
      if (gpio_if17.n_gpio_pin_oe17[i] == 0) begin
        trans17.transfer_data17[i] = gpio_if17.gpio_pin_out17[i];
        gpio_if17.gpio_pin_in17[i] = gpio_if17.gpio_pin_out17[i];
      end else
        gpio_if17.gpio_pin_in17[i] = trans17.transfer_data17[i];
    end
    `uvm_info("GPIO_DRIVER17", $psprintf("GPIO17 Transfer17:\n%s", trans17.sprint()), UVM_MEDIUM)
  endtask : drive_data17

endclass : gpio_driver17

`endif // GPIO_DRIVER_SV17


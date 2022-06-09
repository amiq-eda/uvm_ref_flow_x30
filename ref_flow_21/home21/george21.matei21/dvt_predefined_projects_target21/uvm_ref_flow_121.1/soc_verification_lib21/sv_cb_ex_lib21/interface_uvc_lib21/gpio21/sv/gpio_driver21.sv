/*-------------------------------------------------------------------------
File21 name   : gpio_driver21.sv
Title21       : GPIO21 SystemVerilog21 UVM OVC21
Project21     : SystemVerilog21 UVM Cluster21 Level21 Verification21
Created21     :
Description21 : 
Notes21       :  
---------------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV21
`define GPIO_DRIVER_SV21

class gpio_driver21 extends uvm_driver #(gpio_transfer21);

  // The virtual interface used to drive21 and view21 HDL signals21.
  virtual gpio_if21 gpio_if21;

  // Provide21 implmentations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils(gpio_driver21)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if21)::get(this, "", "gpio_if21", gpio_if21))
   `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".gpio_if21"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive21();
      reset_signals21();
    join
  endtask : run_phase

  // get_and_drive21 
  virtual protected task get_and_drive21();
    uvm_sequence_item item;
    gpio_transfer21 this_trans21;
    @(posedge gpio_if21.n_p_reset21);
    forever begin
      @(posedge gpio_if21.pclk21);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans21, req))
        `uvm_fatal("CASTFL21", "Failed21 to cast req to this_trans21 in get_and_drive21")
      drive_transfer21(this_trans21);
      seq_item_port.item_done();
    end
  endtask : get_and_drive21

  // reset_signals21
  virtual protected task reset_signals21();
      @(negedge gpio_if21.n_p_reset21);
      gpio_if21.gpio_pin_in21  <= 'b0;
  endtask : reset_signals21

  // drive_transfer21
  virtual protected task drive_transfer21 (gpio_transfer21 trans21);
    if (trans21.transmit_delay21 > 0) begin
      repeat(trans21.transmit_delay21) @(posedge gpio_if21.pclk21);
    end
    drive_data21(trans21);
  endtask : drive_transfer21

  virtual protected task drive_data21 (gpio_transfer21 trans21);
    @gpio_if21.pclk21;
    for (int i = 0; i < `GPIO_DATA_WIDTH21; i++) begin
      if (gpio_if21.n_gpio_pin_oe21[i] == 0) begin
        trans21.transfer_data21[i] = gpio_if21.gpio_pin_out21[i];
        gpio_if21.gpio_pin_in21[i] = gpio_if21.gpio_pin_out21[i];
      end else
        gpio_if21.gpio_pin_in21[i] = trans21.transfer_data21[i];
    end
    `uvm_info("GPIO_DRIVER21", $psprintf("GPIO21 Transfer21:\n%s", trans21.sprint()), UVM_MEDIUM)
  endtask : drive_data21

endclass : gpio_driver21

`endif // GPIO_DRIVER_SV21


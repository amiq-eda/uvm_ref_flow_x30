/*-------------------------------------------------------------------------
File1 name   : gpio_driver1.sv
Title1       : GPIO1 SystemVerilog1 UVM OVC1
Project1     : SystemVerilog1 UVM Cluster1 Level1 Verification1
Created1     :
Description1 : 
Notes1       :  
---------------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV1
`define GPIO_DRIVER_SV1

class gpio_driver1 extends uvm_driver #(gpio_transfer1);

  // The virtual interface used to drive1 and view1 HDL signals1.
  virtual gpio_if1 gpio_if1;

  // Provide1 implmentations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils(gpio_driver1)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if1)::get(this, "", "gpio_if1", gpio_if1))
   `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".gpio_if1"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive1();
      reset_signals1();
    join
  endtask : run_phase

  // get_and_drive1 
  virtual protected task get_and_drive1();
    uvm_sequence_item item;
    gpio_transfer1 this_trans1;
    @(posedge gpio_if1.n_p_reset1);
    forever begin
      @(posedge gpio_if1.pclk1);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans1, req))
        `uvm_fatal("CASTFL1", "Failed1 to cast req to this_trans1 in get_and_drive1")
      drive_transfer1(this_trans1);
      seq_item_port.item_done();
    end
  endtask : get_and_drive1

  // reset_signals1
  virtual protected task reset_signals1();
      @(negedge gpio_if1.n_p_reset1);
      gpio_if1.gpio_pin_in1  <= 'b0;
  endtask : reset_signals1

  // drive_transfer1
  virtual protected task drive_transfer1 (gpio_transfer1 trans1);
    if (trans1.transmit_delay1 > 0) begin
      repeat(trans1.transmit_delay1) @(posedge gpio_if1.pclk1);
    end
    drive_data1(trans1);
  endtask : drive_transfer1

  virtual protected task drive_data1 (gpio_transfer1 trans1);
    @gpio_if1.pclk1;
    for (int i = 0; i < `GPIO_DATA_WIDTH1; i++) begin
      if (gpio_if1.n_gpio_pin_oe1[i] == 0) begin
        trans1.transfer_data1[i] = gpio_if1.gpio_pin_out1[i];
        gpio_if1.gpio_pin_in1[i] = gpio_if1.gpio_pin_out1[i];
      end else
        gpio_if1.gpio_pin_in1[i] = trans1.transfer_data1[i];
    end
    `uvm_info("GPIO_DRIVER1", $psprintf("GPIO1 Transfer1:\n%s", trans1.sprint()), UVM_MEDIUM)
  endtask : drive_data1

endclass : gpio_driver1

`endif // GPIO_DRIVER_SV1


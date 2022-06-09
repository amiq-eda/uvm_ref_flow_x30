/*-------------------------------------------------------------------------
File28 name   : uart_tx_monitor28.sv
Title28       : TX28 monitor28 file for uart28 uvc28
Project28     :
Created28     :
Description28 : Describes28 UART28 TX28 Monitor28
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV28
`define UART_TX_MONITOR_SV28

class uart_tx_monitor28 extends uart_monitor28;
 
  `uvm_component_utils_begin(uart_tx_monitor28)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg28;
    FRAME_DATA28: coverpoint cur_frame28.payload28 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger28 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB28: coverpoint msb_lsb_data28 { 
        bins zero = {0};
        bins one = {1};
        bins two28 = {2};
        bins three28 = {3};
      }
  endgroup

  covergroup tx_protocol_cg28;
    PARITY_ERROR_GEN28: coverpoint cur_frame28.error_bits28[1] {
        bins normal28 = { 0 };
        bins parity_error28 = { 1 };
      }
    FRAME_BREAK28: coverpoint cur_frame28.error_bits28[2] {
        bins normal28 = { 0 };
        bins frame_break28 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg28 = new();
    tx_traffic_cg28.set_inst_name ("tx_traffic_cg28");
    tx_protocol_cg28 = new();
    tx_protocol_cg28.set_inst_name ("tx_protocol_cg28");
  endfunction: new

  // Additional28 class methods28
  extern virtual task start_synchronizer28(ref bit serial_d128, ref bit serial_b28);
  extern virtual function void perform_coverage28();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor28

task uart_tx_monitor28::start_synchronizer28(ref bit serial_d128, ref bit serial_b28);
  super.start_synchronizer28(serial_d128, serial_b28);
  forever begin
    @(posedge vif28.clock28);
    if (!vif28.reset) begin
      serial_d128 = 1;
      serial_b28 = 1;
    end else begin
      serial_d128 = serial_b28;
      serial_b28 = vif28.txd28;
    end
  end
endtask : start_synchronizer28

function void uart_tx_monitor28::perform_coverage28();
  super.perform_coverage28();
  tx_traffic_cg28.sample();
  tx_protocol_cg28.sample();
endfunction : perform_coverage28

function void uart_tx_monitor28::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART28 Frames28 Collected28:%0d", num_frames28), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV28

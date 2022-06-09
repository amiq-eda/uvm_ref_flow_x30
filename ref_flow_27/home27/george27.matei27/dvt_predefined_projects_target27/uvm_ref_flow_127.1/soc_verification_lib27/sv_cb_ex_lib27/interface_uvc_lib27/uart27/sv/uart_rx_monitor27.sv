/*-------------------------------------------------------------------------
File27 name   : uart_rx_monitor27.sv
Title27       : monitor27 file for uart27 uvc27
Project27     :
Created27     :
Description27 : descirbes27 UART27 Monitor27
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef UART_RX_MONITOR_SV27
`define UART_RX_MONITOR_SV27

class uart_rx_monitor27 extends uart_monitor27;

  `uvm_component_utils_begin(uart_rx_monitor27)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup rx_traffic_cg27;
    FRAME_DATA27: coverpoint cur_frame27.payload27 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger27 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB27: coverpoint msb_lsb_data27 { 
        bins zero = {0};
        bins one = {1};
        bins two27 = {2};
        bins three27 = {3};
      }
  endgroup

  covergroup rx_protocol_cg27;
    PARITY_ERROR_GEN27: coverpoint cur_frame27.error_bits27[1] {
        bins normal27 = { 0 };
        bins parity_error27 = { 1 };
      }
    FRAME_BREAK27: coverpoint cur_frame27.error_bits27[2] {
        bins normal27 = { 0 };
        bins frame_break27 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rx_traffic_cg27 = new();
    rx_traffic_cg27.set_inst_name ("rx_traffic_cg27");
    rx_protocol_cg27 = new();    
    rx_protocol_cg27.set_inst_name ("rx_protocol_cg27");
  endfunction: new

  // Additional27 class methods27
  extern virtual function void perform_coverage27();
  extern virtual task start_synchronizer27(ref bit serial_d127, ref bit serial_b27);
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_rx_monitor27

task uart_rx_monitor27::start_synchronizer27(ref bit serial_d127, ref bit serial_b27);
  super.start_synchronizer27(serial_d127, serial_b27);
  forever begin
    @(posedge vif27.clock27);
    if (!vif27.reset) begin
      serial_d127 = 1;
      serial_b27 = 1;
    end else begin
      serial_d127 = serial_b27;
      serial_b27 = vif27.rxd27;
    end
  end
endtask : start_synchronizer27

function void uart_rx_monitor27::perform_coverage27();
  super.perform_coverage27();
  rx_traffic_cg27.sample();
  rx_protocol_cg27.sample();
endfunction : perform_coverage27

function void uart_rx_monitor27::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART27 Frames27 Collected27:%0d", num_frames27), UVM_LOW)
endfunction : report_phase


`endif  // UART_RX_MONITOR_SV27

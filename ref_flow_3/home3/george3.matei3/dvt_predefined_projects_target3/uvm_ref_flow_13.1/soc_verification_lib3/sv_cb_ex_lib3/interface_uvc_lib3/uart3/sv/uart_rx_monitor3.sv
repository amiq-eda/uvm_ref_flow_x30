/*-------------------------------------------------------------------------
File3 name   : uart_rx_monitor3.sv
Title3       : monitor3 file for uart3 uvc3
Project3     :
Created3     :
Description3 : descirbes3 UART3 Monitor3
Notes3       :  
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef UART_RX_MONITOR_SV3
`define UART_RX_MONITOR_SV3

class uart_rx_monitor3 extends uart_monitor3;

  `uvm_component_utils_begin(uart_rx_monitor3)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup rx_traffic_cg3;
    FRAME_DATA3: coverpoint cur_frame3.payload3 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger3 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB3: coverpoint msb_lsb_data3 { 
        bins zero = {0};
        bins one = {1};
        bins two3 = {2};
        bins three3 = {3};
      }
  endgroup

  covergroup rx_protocol_cg3;
    PARITY_ERROR_GEN3: coverpoint cur_frame3.error_bits3[1] {
        bins normal3 = { 0 };
        bins parity_error3 = { 1 };
      }
    FRAME_BREAK3: coverpoint cur_frame3.error_bits3[2] {
        bins normal3 = { 0 };
        bins frame_break3 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rx_traffic_cg3 = new();
    rx_traffic_cg3.set_inst_name ("rx_traffic_cg3");
    rx_protocol_cg3 = new();    
    rx_protocol_cg3.set_inst_name ("rx_protocol_cg3");
  endfunction: new

  // Additional3 class methods3
  extern virtual function void perform_coverage3();
  extern virtual task start_synchronizer3(ref bit serial_d13, ref bit serial_b3);
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_rx_monitor3

task uart_rx_monitor3::start_synchronizer3(ref bit serial_d13, ref bit serial_b3);
  super.start_synchronizer3(serial_d13, serial_b3);
  forever begin
    @(posedge vif3.clock3);
    if (!vif3.reset) begin
      serial_d13 = 1;
      serial_b3 = 1;
    end else begin
      serial_d13 = serial_b3;
      serial_b3 = vif3.rxd3;
    end
  end
endtask : start_synchronizer3

function void uart_rx_monitor3::perform_coverage3();
  super.perform_coverage3();
  rx_traffic_cg3.sample();
  rx_protocol_cg3.sample();
endfunction : perform_coverage3

function void uart_rx_monitor3::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART3 Frames3 Collected3:%0d", num_frames3), UVM_LOW)
endfunction : report_phase


`endif  // UART_RX_MONITOR_SV3

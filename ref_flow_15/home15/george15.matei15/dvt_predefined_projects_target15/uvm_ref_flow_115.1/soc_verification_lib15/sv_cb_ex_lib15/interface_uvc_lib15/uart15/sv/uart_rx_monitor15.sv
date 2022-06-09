/*-------------------------------------------------------------------------
File15 name   : uart_rx_monitor15.sv
Title15       : monitor15 file for uart15 uvc15
Project15     :
Created15     :
Description15 : descirbes15 UART15 Monitor15
Notes15       :  
----------------------------------------------------------------------*/
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


`ifndef UART_RX_MONITOR_SV15
`define UART_RX_MONITOR_SV15

class uart_rx_monitor15 extends uart_monitor15;

  `uvm_component_utils_begin(uart_rx_monitor15)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup rx_traffic_cg15;
    FRAME_DATA15: coverpoint cur_frame15.payload15 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger15 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB15: coverpoint msb_lsb_data15 { 
        bins zero = {0};
        bins one = {1};
        bins two15 = {2};
        bins three15 = {3};
      }
  endgroup

  covergroup rx_protocol_cg15;
    PARITY_ERROR_GEN15: coverpoint cur_frame15.error_bits15[1] {
        bins normal15 = { 0 };
        bins parity_error15 = { 1 };
      }
    FRAME_BREAK15: coverpoint cur_frame15.error_bits15[2] {
        bins normal15 = { 0 };
        bins frame_break15 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rx_traffic_cg15 = new();
    rx_traffic_cg15.set_inst_name ("rx_traffic_cg15");
    rx_protocol_cg15 = new();    
    rx_protocol_cg15.set_inst_name ("rx_protocol_cg15");
  endfunction: new

  // Additional15 class methods15
  extern virtual function void perform_coverage15();
  extern virtual task start_synchronizer15(ref bit serial_d115, ref bit serial_b15);
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_rx_monitor15

task uart_rx_monitor15::start_synchronizer15(ref bit serial_d115, ref bit serial_b15);
  super.start_synchronizer15(serial_d115, serial_b15);
  forever begin
    @(posedge vif15.clock15);
    if (!vif15.reset) begin
      serial_d115 = 1;
      serial_b15 = 1;
    end else begin
      serial_d115 = serial_b15;
      serial_b15 = vif15.rxd15;
    end
  end
endtask : start_synchronizer15

function void uart_rx_monitor15::perform_coverage15();
  super.perform_coverage15();
  rx_traffic_cg15.sample();
  rx_protocol_cg15.sample();
endfunction : perform_coverage15

function void uart_rx_monitor15::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART15 Frames15 Collected15:%0d", num_frames15), UVM_LOW)
endfunction : report_phase


`endif  // UART_RX_MONITOR_SV15

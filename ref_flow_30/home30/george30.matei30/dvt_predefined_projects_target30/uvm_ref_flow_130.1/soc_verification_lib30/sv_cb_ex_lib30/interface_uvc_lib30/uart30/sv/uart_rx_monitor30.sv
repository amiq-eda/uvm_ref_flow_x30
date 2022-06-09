/*-------------------------------------------------------------------------
File30 name   : uart_rx_monitor30.sv
Title30       : monitor30 file for uart30 uvc30
Project30     :
Created30     :
Description30 : descirbes30 UART30 Monitor30
Notes30       :  
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef UART_RX_MONITOR_SV30
`define UART_RX_MONITOR_SV30

class uart_rx_monitor30 extends uart_monitor30;

  `uvm_component_utils_begin(uart_rx_monitor30)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup rx_traffic_cg30;
    FRAME_DATA30: coverpoint cur_frame30.payload30 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger30 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB30: coverpoint msb_lsb_data30 { 
        bins zero = {0};
        bins one = {1};
        bins two30 = {2};
        bins three30 = {3};
      }
  endgroup

  covergroup rx_protocol_cg30;
    PARITY_ERROR_GEN30: coverpoint cur_frame30.error_bits30[1] {
        bins normal30 = { 0 };
        bins parity_error30 = { 1 };
      }
    FRAME_BREAK30: coverpoint cur_frame30.error_bits30[2] {
        bins normal30 = { 0 };
        bins frame_break30 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rx_traffic_cg30 = new();
    rx_traffic_cg30.set_inst_name ("rx_traffic_cg30");
    rx_protocol_cg30 = new();    
    rx_protocol_cg30.set_inst_name ("rx_protocol_cg30");
  endfunction: new

  // Additional30 class methods30
  extern virtual function void perform_coverage30();
  extern virtual task start_synchronizer30(ref bit serial_d130, ref bit serial_b30);
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_rx_monitor30

task uart_rx_monitor30::start_synchronizer30(ref bit serial_d130, ref bit serial_b30);
  super.start_synchronizer30(serial_d130, serial_b30);
  forever begin
    @(posedge vif30.clock30);
    if (!vif30.reset) begin
      serial_d130 = 1;
      serial_b30 = 1;
    end else begin
      serial_d130 = serial_b30;
      serial_b30 = vif30.rxd30;
    end
  end
endtask : start_synchronizer30

function void uart_rx_monitor30::perform_coverage30();
  super.perform_coverage30();
  rx_traffic_cg30.sample();
  rx_protocol_cg30.sample();
endfunction : perform_coverage30

function void uart_rx_monitor30::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART30 Frames30 Collected30:%0d", num_frames30), UVM_LOW)
endfunction : report_phase


`endif  // UART_RX_MONITOR_SV30

/*-------------------------------------------------------------------------
File17 name   : uart_rx_monitor17.sv
Title17       : monitor17 file for uart17 uvc17
Project17     :
Created17     :
Description17 : descirbes17 UART17 Monitor17
Notes17       :  
----------------------------------------------------------------------*/
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


`ifndef UART_RX_MONITOR_SV17
`define UART_RX_MONITOR_SV17

class uart_rx_monitor17 extends uart_monitor17;

  `uvm_component_utils_begin(uart_rx_monitor17)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup rx_traffic_cg17;
    FRAME_DATA17: coverpoint cur_frame17.payload17 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger17 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB17: coverpoint msb_lsb_data17 { 
        bins zero = {0};
        bins one = {1};
        bins two17 = {2};
        bins three17 = {3};
      }
  endgroup

  covergroup rx_protocol_cg17;
    PARITY_ERROR_GEN17: coverpoint cur_frame17.error_bits17[1] {
        bins normal17 = { 0 };
        bins parity_error17 = { 1 };
      }
    FRAME_BREAK17: coverpoint cur_frame17.error_bits17[2] {
        bins normal17 = { 0 };
        bins frame_break17 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rx_traffic_cg17 = new();
    rx_traffic_cg17.set_inst_name ("rx_traffic_cg17");
    rx_protocol_cg17 = new();    
    rx_protocol_cg17.set_inst_name ("rx_protocol_cg17");
  endfunction: new

  // Additional17 class methods17
  extern virtual function void perform_coverage17();
  extern virtual task start_synchronizer17(ref bit serial_d117, ref bit serial_b17);
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_rx_monitor17

task uart_rx_monitor17::start_synchronizer17(ref bit serial_d117, ref bit serial_b17);
  super.start_synchronizer17(serial_d117, serial_b17);
  forever begin
    @(posedge vif17.clock17);
    if (!vif17.reset) begin
      serial_d117 = 1;
      serial_b17 = 1;
    end else begin
      serial_d117 = serial_b17;
      serial_b17 = vif17.rxd17;
    end
  end
endtask : start_synchronizer17

function void uart_rx_monitor17::perform_coverage17();
  super.perform_coverage17();
  rx_traffic_cg17.sample();
  rx_protocol_cg17.sample();
endfunction : perform_coverage17

function void uart_rx_monitor17::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART17 Frames17 Collected17:%0d", num_frames17), UVM_LOW)
endfunction : report_phase


`endif  // UART_RX_MONITOR_SV17

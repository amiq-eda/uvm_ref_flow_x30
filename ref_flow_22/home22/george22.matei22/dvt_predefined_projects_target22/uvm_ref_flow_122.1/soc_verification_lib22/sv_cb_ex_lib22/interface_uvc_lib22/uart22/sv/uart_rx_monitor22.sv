/*-------------------------------------------------------------------------
File22 name   : uart_rx_monitor22.sv
Title22       : monitor22 file for uart22 uvc22
Project22     :
Created22     :
Description22 : descirbes22 UART22 Monitor22
Notes22       :  
----------------------------------------------------------------------*/
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


`ifndef UART_RX_MONITOR_SV22
`define UART_RX_MONITOR_SV22

class uart_rx_monitor22 extends uart_monitor22;

  `uvm_component_utils_begin(uart_rx_monitor22)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup rx_traffic_cg22;
    FRAME_DATA22: coverpoint cur_frame22.payload22 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger22 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB22: coverpoint msb_lsb_data22 { 
        bins zero = {0};
        bins one = {1};
        bins two22 = {2};
        bins three22 = {3};
      }
  endgroup

  covergroup rx_protocol_cg22;
    PARITY_ERROR_GEN22: coverpoint cur_frame22.error_bits22[1] {
        bins normal22 = { 0 };
        bins parity_error22 = { 1 };
      }
    FRAME_BREAK22: coverpoint cur_frame22.error_bits22[2] {
        bins normal22 = { 0 };
        bins frame_break22 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rx_traffic_cg22 = new();
    rx_traffic_cg22.set_inst_name ("rx_traffic_cg22");
    rx_protocol_cg22 = new();    
    rx_protocol_cg22.set_inst_name ("rx_protocol_cg22");
  endfunction: new

  // Additional22 class methods22
  extern virtual function void perform_coverage22();
  extern virtual task start_synchronizer22(ref bit serial_d122, ref bit serial_b22);
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_rx_monitor22

task uart_rx_monitor22::start_synchronizer22(ref bit serial_d122, ref bit serial_b22);
  super.start_synchronizer22(serial_d122, serial_b22);
  forever begin
    @(posedge vif22.clock22);
    if (!vif22.reset) begin
      serial_d122 = 1;
      serial_b22 = 1;
    end else begin
      serial_d122 = serial_b22;
      serial_b22 = vif22.rxd22;
    end
  end
endtask : start_synchronizer22

function void uart_rx_monitor22::perform_coverage22();
  super.perform_coverage22();
  rx_traffic_cg22.sample();
  rx_protocol_cg22.sample();
endfunction : perform_coverage22

function void uart_rx_monitor22::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART22 Frames22 Collected22:%0d", num_frames22), UVM_LOW)
endfunction : report_phase


`endif  // UART_RX_MONITOR_SV22

/*-------------------------------------------------------------------------
File8 name   : uart_tx_monitor8.sv
Title8       : TX8 monitor8 file for uart8 uvc8
Project8     :
Created8     :
Description8 : Describes8 UART8 TX8 Monitor8
Notes8       :  
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV8
`define UART_TX_MONITOR_SV8

class uart_tx_monitor8 extends uart_monitor8;
 
  `uvm_component_utils_begin(uart_tx_monitor8)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg8;
    FRAME_DATA8: coverpoint cur_frame8.payload8 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger8 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB8: coverpoint msb_lsb_data8 { 
        bins zero = {0};
        bins one = {1};
        bins two8 = {2};
        bins three8 = {3};
      }
  endgroup

  covergroup tx_protocol_cg8;
    PARITY_ERROR_GEN8: coverpoint cur_frame8.error_bits8[1] {
        bins normal8 = { 0 };
        bins parity_error8 = { 1 };
      }
    FRAME_BREAK8: coverpoint cur_frame8.error_bits8[2] {
        bins normal8 = { 0 };
        bins frame_break8 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg8 = new();
    tx_traffic_cg8.set_inst_name ("tx_traffic_cg8");
    tx_protocol_cg8 = new();
    tx_protocol_cg8.set_inst_name ("tx_protocol_cg8");
  endfunction: new

  // Additional8 class methods8
  extern virtual task start_synchronizer8(ref bit serial_d18, ref bit serial_b8);
  extern virtual function void perform_coverage8();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor8

task uart_tx_monitor8::start_synchronizer8(ref bit serial_d18, ref bit serial_b8);
  super.start_synchronizer8(serial_d18, serial_b8);
  forever begin
    @(posedge vif8.clock8);
    if (!vif8.reset) begin
      serial_d18 = 1;
      serial_b8 = 1;
    end else begin
      serial_d18 = serial_b8;
      serial_b8 = vif8.txd8;
    end
  end
endtask : start_synchronizer8

function void uart_tx_monitor8::perform_coverage8();
  super.perform_coverage8();
  tx_traffic_cg8.sample();
  tx_protocol_cg8.sample();
endfunction : perform_coverage8

function void uart_tx_monitor8::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART8 Frames8 Collected8:%0d", num_frames8), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV8

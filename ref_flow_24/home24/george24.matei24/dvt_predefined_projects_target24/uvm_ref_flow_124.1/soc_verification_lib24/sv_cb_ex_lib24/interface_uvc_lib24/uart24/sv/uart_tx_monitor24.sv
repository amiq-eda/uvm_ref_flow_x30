/*-------------------------------------------------------------------------
File24 name   : uart_tx_monitor24.sv
Title24       : TX24 monitor24 file for uart24 uvc24
Project24     :
Created24     :
Description24 : Describes24 UART24 TX24 Monitor24
Notes24       :  
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV24
`define UART_TX_MONITOR_SV24

class uart_tx_monitor24 extends uart_monitor24;
 
  `uvm_component_utils_begin(uart_tx_monitor24)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg24;
    FRAME_DATA24: coverpoint cur_frame24.payload24 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger24 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB24: coverpoint msb_lsb_data24 { 
        bins zero = {0};
        bins one = {1};
        bins two24 = {2};
        bins three24 = {3};
      }
  endgroup

  covergroup tx_protocol_cg24;
    PARITY_ERROR_GEN24: coverpoint cur_frame24.error_bits24[1] {
        bins normal24 = { 0 };
        bins parity_error24 = { 1 };
      }
    FRAME_BREAK24: coverpoint cur_frame24.error_bits24[2] {
        bins normal24 = { 0 };
        bins frame_break24 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg24 = new();
    tx_traffic_cg24.set_inst_name ("tx_traffic_cg24");
    tx_protocol_cg24 = new();
    tx_protocol_cg24.set_inst_name ("tx_protocol_cg24");
  endfunction: new

  // Additional24 class methods24
  extern virtual task start_synchronizer24(ref bit serial_d124, ref bit serial_b24);
  extern virtual function void perform_coverage24();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor24

task uart_tx_monitor24::start_synchronizer24(ref bit serial_d124, ref bit serial_b24);
  super.start_synchronizer24(serial_d124, serial_b24);
  forever begin
    @(posedge vif24.clock24);
    if (!vif24.reset) begin
      serial_d124 = 1;
      serial_b24 = 1;
    end else begin
      serial_d124 = serial_b24;
      serial_b24 = vif24.txd24;
    end
  end
endtask : start_synchronizer24

function void uart_tx_monitor24::perform_coverage24();
  super.perform_coverage24();
  tx_traffic_cg24.sample();
  tx_protocol_cg24.sample();
endfunction : perform_coverage24

function void uart_tx_monitor24::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART24 Frames24 Collected24:%0d", num_frames24), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV24

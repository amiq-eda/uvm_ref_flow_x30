/*-------------------------------------------------------------------------
File7 name   : uart_tx_monitor7.sv
Title7       : TX7 monitor7 file for uart7 uvc7
Project7     :
Created7     :
Description7 : Describes7 UART7 TX7 Monitor7
Notes7       :  
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV7
`define UART_TX_MONITOR_SV7

class uart_tx_monitor7 extends uart_monitor7;
 
  `uvm_component_utils_begin(uart_tx_monitor7)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg7;
    FRAME_DATA7: coverpoint cur_frame7.payload7 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger7 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB7: coverpoint msb_lsb_data7 { 
        bins zero = {0};
        bins one = {1};
        bins two7 = {2};
        bins three7 = {3};
      }
  endgroup

  covergroup tx_protocol_cg7;
    PARITY_ERROR_GEN7: coverpoint cur_frame7.error_bits7[1] {
        bins normal7 = { 0 };
        bins parity_error7 = { 1 };
      }
    FRAME_BREAK7: coverpoint cur_frame7.error_bits7[2] {
        bins normal7 = { 0 };
        bins frame_break7 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg7 = new();
    tx_traffic_cg7.set_inst_name ("tx_traffic_cg7");
    tx_protocol_cg7 = new();
    tx_protocol_cg7.set_inst_name ("tx_protocol_cg7");
  endfunction: new

  // Additional7 class methods7
  extern virtual task start_synchronizer7(ref bit serial_d17, ref bit serial_b7);
  extern virtual function void perform_coverage7();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor7

task uart_tx_monitor7::start_synchronizer7(ref bit serial_d17, ref bit serial_b7);
  super.start_synchronizer7(serial_d17, serial_b7);
  forever begin
    @(posedge vif7.clock7);
    if (!vif7.reset) begin
      serial_d17 = 1;
      serial_b7 = 1;
    end else begin
      serial_d17 = serial_b7;
      serial_b7 = vif7.txd7;
    end
  end
endtask : start_synchronizer7

function void uart_tx_monitor7::perform_coverage7();
  super.perform_coverage7();
  tx_traffic_cg7.sample();
  tx_protocol_cg7.sample();
endfunction : perform_coverage7

function void uart_tx_monitor7::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART7 Frames7 Collected7:%0d", num_frames7), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV7

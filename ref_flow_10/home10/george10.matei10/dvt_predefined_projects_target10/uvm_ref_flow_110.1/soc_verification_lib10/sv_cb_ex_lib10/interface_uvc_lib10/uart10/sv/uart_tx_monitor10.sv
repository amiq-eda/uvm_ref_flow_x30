/*-------------------------------------------------------------------------
File10 name   : uart_tx_monitor10.sv
Title10       : TX10 monitor10 file for uart10 uvc10
Project10     :
Created10     :
Description10 : Describes10 UART10 TX10 Monitor10
Notes10       :  
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV10
`define UART_TX_MONITOR_SV10

class uart_tx_monitor10 extends uart_monitor10;
 
  `uvm_component_utils_begin(uart_tx_monitor10)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg10;
    FRAME_DATA10: coverpoint cur_frame10.payload10 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger10 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB10: coverpoint msb_lsb_data10 { 
        bins zero = {0};
        bins one = {1};
        bins two10 = {2};
        bins three10 = {3};
      }
  endgroup

  covergroup tx_protocol_cg10;
    PARITY_ERROR_GEN10: coverpoint cur_frame10.error_bits10[1] {
        bins normal10 = { 0 };
        bins parity_error10 = { 1 };
      }
    FRAME_BREAK10: coverpoint cur_frame10.error_bits10[2] {
        bins normal10 = { 0 };
        bins frame_break10 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg10 = new();
    tx_traffic_cg10.set_inst_name ("tx_traffic_cg10");
    tx_protocol_cg10 = new();
    tx_protocol_cg10.set_inst_name ("tx_protocol_cg10");
  endfunction: new

  // Additional10 class methods10
  extern virtual task start_synchronizer10(ref bit serial_d110, ref bit serial_b10);
  extern virtual function void perform_coverage10();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor10

task uart_tx_monitor10::start_synchronizer10(ref bit serial_d110, ref bit serial_b10);
  super.start_synchronizer10(serial_d110, serial_b10);
  forever begin
    @(posedge vif10.clock10);
    if (!vif10.reset) begin
      serial_d110 = 1;
      serial_b10 = 1;
    end else begin
      serial_d110 = serial_b10;
      serial_b10 = vif10.txd10;
    end
  end
endtask : start_synchronizer10

function void uart_tx_monitor10::perform_coverage10();
  super.perform_coverage10();
  tx_traffic_cg10.sample();
  tx_protocol_cg10.sample();
endfunction : perform_coverage10

function void uart_tx_monitor10::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART10 Frames10 Collected10:%0d", num_frames10), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV10

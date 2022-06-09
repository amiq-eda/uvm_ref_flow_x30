/*-------------------------------------------------------------------------
File11 name   : uart_tx_monitor11.sv
Title11       : TX11 monitor11 file for uart11 uvc11
Project11     :
Created11     :
Description11 : Describes11 UART11 TX11 Monitor11
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV11
`define UART_TX_MONITOR_SV11

class uart_tx_monitor11 extends uart_monitor11;
 
  `uvm_component_utils_begin(uart_tx_monitor11)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg11;
    FRAME_DATA11: coverpoint cur_frame11.payload11 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger11 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB11: coverpoint msb_lsb_data11 { 
        bins zero = {0};
        bins one = {1};
        bins two11 = {2};
        bins three11 = {3};
      }
  endgroup

  covergroup tx_protocol_cg11;
    PARITY_ERROR_GEN11: coverpoint cur_frame11.error_bits11[1] {
        bins normal11 = { 0 };
        bins parity_error11 = { 1 };
      }
    FRAME_BREAK11: coverpoint cur_frame11.error_bits11[2] {
        bins normal11 = { 0 };
        bins frame_break11 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg11 = new();
    tx_traffic_cg11.set_inst_name ("tx_traffic_cg11");
    tx_protocol_cg11 = new();
    tx_protocol_cg11.set_inst_name ("tx_protocol_cg11");
  endfunction: new

  // Additional11 class methods11
  extern virtual task start_synchronizer11(ref bit serial_d111, ref bit serial_b11);
  extern virtual function void perform_coverage11();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor11

task uart_tx_monitor11::start_synchronizer11(ref bit serial_d111, ref bit serial_b11);
  super.start_synchronizer11(serial_d111, serial_b11);
  forever begin
    @(posedge vif11.clock11);
    if (!vif11.reset) begin
      serial_d111 = 1;
      serial_b11 = 1;
    end else begin
      serial_d111 = serial_b11;
      serial_b11 = vif11.txd11;
    end
  end
endtask : start_synchronizer11

function void uart_tx_monitor11::perform_coverage11();
  super.perform_coverage11();
  tx_traffic_cg11.sample();
  tx_protocol_cg11.sample();
endfunction : perform_coverage11

function void uart_tx_monitor11::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART11 Frames11 Collected11:%0d", num_frames11), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV11

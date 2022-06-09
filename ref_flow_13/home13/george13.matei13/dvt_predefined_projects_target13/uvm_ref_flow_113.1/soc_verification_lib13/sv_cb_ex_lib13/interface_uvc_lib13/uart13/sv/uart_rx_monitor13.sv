/*-------------------------------------------------------------------------
File13 name   : uart_rx_monitor13.sv
Title13       : monitor13 file for uart13 uvc13
Project13     :
Created13     :
Description13 : descirbes13 UART13 Monitor13
Notes13       :  
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef UART_RX_MONITOR_SV13
`define UART_RX_MONITOR_SV13

class uart_rx_monitor13 extends uart_monitor13;

  `uvm_component_utils_begin(uart_rx_monitor13)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup rx_traffic_cg13;
    FRAME_DATA13: coverpoint cur_frame13.payload13 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger13 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB13: coverpoint msb_lsb_data13 { 
        bins zero = {0};
        bins one = {1};
        bins two13 = {2};
        bins three13 = {3};
      }
  endgroup

  covergroup rx_protocol_cg13;
    PARITY_ERROR_GEN13: coverpoint cur_frame13.error_bits13[1] {
        bins normal13 = { 0 };
        bins parity_error13 = { 1 };
      }
    FRAME_BREAK13: coverpoint cur_frame13.error_bits13[2] {
        bins normal13 = { 0 };
        bins frame_break13 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rx_traffic_cg13 = new();
    rx_traffic_cg13.set_inst_name ("rx_traffic_cg13");
    rx_protocol_cg13 = new();    
    rx_protocol_cg13.set_inst_name ("rx_protocol_cg13");
  endfunction: new

  // Additional13 class methods13
  extern virtual function void perform_coverage13();
  extern virtual task start_synchronizer13(ref bit serial_d113, ref bit serial_b13);
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_rx_monitor13

task uart_rx_monitor13::start_synchronizer13(ref bit serial_d113, ref bit serial_b13);
  super.start_synchronizer13(serial_d113, serial_b13);
  forever begin
    @(posedge vif13.clock13);
    if (!vif13.reset) begin
      serial_d113 = 1;
      serial_b13 = 1;
    end else begin
      serial_d113 = serial_b13;
      serial_b13 = vif13.rxd13;
    end
  end
endtask : start_synchronizer13

function void uart_rx_monitor13::perform_coverage13();
  super.perform_coverage13();
  rx_traffic_cg13.sample();
  rx_protocol_cg13.sample();
endfunction : perform_coverage13

function void uart_rx_monitor13::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART13 Frames13 Collected13:%0d", num_frames13), UVM_LOW)
endfunction : report_phase


`endif  // UART_RX_MONITOR_SV13

/*-------------------------------------------------------------------------
File12 name   : uart_rx_monitor12.sv
Title12       : monitor12 file for uart12 uvc12
Project12     :
Created12     :
Description12 : descirbes12 UART12 Monitor12
Notes12       :  
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef UART_RX_MONITOR_SV12
`define UART_RX_MONITOR_SV12

class uart_rx_monitor12 extends uart_monitor12;

  `uvm_component_utils_begin(uart_rx_monitor12)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup rx_traffic_cg12;
    FRAME_DATA12: coverpoint cur_frame12.payload12 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger12 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB12: coverpoint msb_lsb_data12 { 
        bins zero = {0};
        bins one = {1};
        bins two12 = {2};
        bins three12 = {3};
      }
  endgroup

  covergroup rx_protocol_cg12;
    PARITY_ERROR_GEN12: coverpoint cur_frame12.error_bits12[1] {
        bins normal12 = { 0 };
        bins parity_error12 = { 1 };
      }
    FRAME_BREAK12: coverpoint cur_frame12.error_bits12[2] {
        bins normal12 = { 0 };
        bins frame_break12 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rx_traffic_cg12 = new();
    rx_traffic_cg12.set_inst_name ("rx_traffic_cg12");
    rx_protocol_cg12 = new();    
    rx_protocol_cg12.set_inst_name ("rx_protocol_cg12");
  endfunction: new

  // Additional12 class methods12
  extern virtual function void perform_coverage12();
  extern virtual task start_synchronizer12(ref bit serial_d112, ref bit serial_b12);
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_rx_monitor12

task uart_rx_monitor12::start_synchronizer12(ref bit serial_d112, ref bit serial_b12);
  super.start_synchronizer12(serial_d112, serial_b12);
  forever begin
    @(posedge vif12.clock12);
    if (!vif12.reset) begin
      serial_d112 = 1;
      serial_b12 = 1;
    end else begin
      serial_d112 = serial_b12;
      serial_b12 = vif12.rxd12;
    end
  end
endtask : start_synchronizer12

function void uart_rx_monitor12::perform_coverage12();
  super.perform_coverage12();
  rx_traffic_cg12.sample();
  rx_protocol_cg12.sample();
endfunction : perform_coverage12

function void uart_rx_monitor12::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART12 Frames12 Collected12:%0d", num_frames12), UVM_LOW)
endfunction : report_phase


`endif  // UART_RX_MONITOR_SV12

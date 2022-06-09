/*-------------------------------------------------------------------------
File6 name   : uart_rx_monitor6.sv
Title6       : monitor6 file for uart6 uvc6
Project6     :
Created6     :
Description6 : descirbes6 UART6 Monitor6
Notes6       :  
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef UART_RX_MONITOR_SV6
`define UART_RX_MONITOR_SV6

class uart_rx_monitor6 extends uart_monitor6;

  `uvm_component_utils_begin(uart_rx_monitor6)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup rx_traffic_cg6;
    FRAME_DATA6: coverpoint cur_frame6.payload6 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger6 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB6: coverpoint msb_lsb_data6 { 
        bins zero = {0};
        bins one = {1};
        bins two6 = {2};
        bins three6 = {3};
      }
  endgroup

  covergroup rx_protocol_cg6;
    PARITY_ERROR_GEN6: coverpoint cur_frame6.error_bits6[1] {
        bins normal6 = { 0 };
        bins parity_error6 = { 1 };
      }
    FRAME_BREAK6: coverpoint cur_frame6.error_bits6[2] {
        bins normal6 = { 0 };
        bins frame_break6 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rx_traffic_cg6 = new();
    rx_traffic_cg6.set_inst_name ("rx_traffic_cg6");
    rx_protocol_cg6 = new();    
    rx_protocol_cg6.set_inst_name ("rx_protocol_cg6");
  endfunction: new

  // Additional6 class methods6
  extern virtual function void perform_coverage6();
  extern virtual task start_synchronizer6(ref bit serial_d16, ref bit serial_b6);
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_rx_monitor6

task uart_rx_monitor6::start_synchronizer6(ref bit serial_d16, ref bit serial_b6);
  super.start_synchronizer6(serial_d16, serial_b6);
  forever begin
    @(posedge vif6.clock6);
    if (!vif6.reset) begin
      serial_d16 = 1;
      serial_b6 = 1;
    end else begin
      serial_d16 = serial_b6;
      serial_b6 = vif6.rxd6;
    end
  end
endtask : start_synchronizer6

function void uart_rx_monitor6::perform_coverage6();
  super.perform_coverage6();
  rx_traffic_cg6.sample();
  rx_protocol_cg6.sample();
endfunction : perform_coverage6

function void uart_rx_monitor6::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART6 Frames6 Collected6:%0d", num_frames6), UVM_LOW)
endfunction : report_phase


`endif  // UART_RX_MONITOR_SV6

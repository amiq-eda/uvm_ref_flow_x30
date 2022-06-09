/*-------------------------------------------------------------------------
File2 name   : uart_rx_monitor2.sv
Title2       : monitor2 file for uart2 uvc2
Project2     :
Created2     :
Description2 : descirbes2 UART2 Monitor2
Notes2       :  
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef UART_RX_MONITOR_SV2
`define UART_RX_MONITOR_SV2

class uart_rx_monitor2 extends uart_monitor2;

  `uvm_component_utils_begin(uart_rx_monitor2)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup rx_traffic_cg2;
    FRAME_DATA2: coverpoint cur_frame2.payload2 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger2 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB2: coverpoint msb_lsb_data2 { 
        bins zero = {0};
        bins one = {1};
        bins two2 = {2};
        bins three2 = {3};
      }
  endgroup

  covergroup rx_protocol_cg2;
    PARITY_ERROR_GEN2: coverpoint cur_frame2.error_bits2[1] {
        bins normal2 = { 0 };
        bins parity_error2 = { 1 };
      }
    FRAME_BREAK2: coverpoint cur_frame2.error_bits2[2] {
        bins normal2 = { 0 };
        bins frame_break2 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rx_traffic_cg2 = new();
    rx_traffic_cg2.set_inst_name ("rx_traffic_cg2");
    rx_protocol_cg2 = new();    
    rx_protocol_cg2.set_inst_name ("rx_protocol_cg2");
  endfunction: new

  // Additional2 class methods2
  extern virtual function void perform_coverage2();
  extern virtual task start_synchronizer2(ref bit serial_d12, ref bit serial_b2);
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_rx_monitor2

task uart_rx_monitor2::start_synchronizer2(ref bit serial_d12, ref bit serial_b2);
  super.start_synchronizer2(serial_d12, serial_b2);
  forever begin
    @(posedge vif2.clock2);
    if (!vif2.reset) begin
      serial_d12 = 1;
      serial_b2 = 1;
    end else begin
      serial_d12 = serial_b2;
      serial_b2 = vif2.rxd2;
    end
  end
endtask : start_synchronizer2

function void uart_rx_monitor2::perform_coverage2();
  super.perform_coverage2();
  rx_traffic_cg2.sample();
  rx_protocol_cg2.sample();
endfunction : perform_coverage2

function void uart_rx_monitor2::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART2 Frames2 Collected2:%0d", num_frames2), UVM_LOW)
endfunction : report_phase


`endif  // UART_RX_MONITOR_SV2

/*-------------------------------------------------------------------------
File1 name   : uart_tx_monitor1.sv
Title1       : TX1 monitor1 file for uart1 uvc1
Project1     :
Created1     :
Description1 : Describes1 UART1 TX1 Monitor1
Notes1       :  
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV1
`define UART_TX_MONITOR_SV1

class uart_tx_monitor1 extends uart_monitor1;
 
  `uvm_component_utils_begin(uart_tx_monitor1)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg1;
    FRAME_DATA1: coverpoint cur_frame1.payload1 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger1 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB1: coverpoint msb_lsb_data1 { 
        bins zero = {0};
        bins one = {1};
        bins two1 = {2};
        bins three1 = {3};
      }
  endgroup

  covergroup tx_protocol_cg1;
    PARITY_ERROR_GEN1: coverpoint cur_frame1.error_bits1[1] {
        bins normal1 = { 0 };
        bins parity_error1 = { 1 };
      }
    FRAME_BREAK1: coverpoint cur_frame1.error_bits1[2] {
        bins normal1 = { 0 };
        bins frame_break1 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg1 = new();
    tx_traffic_cg1.set_inst_name ("tx_traffic_cg1");
    tx_protocol_cg1 = new();
    tx_protocol_cg1.set_inst_name ("tx_protocol_cg1");
  endfunction: new

  // Additional1 class methods1
  extern virtual task start_synchronizer1(ref bit serial_d11, ref bit serial_b1);
  extern virtual function void perform_coverage1();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor1

task uart_tx_monitor1::start_synchronizer1(ref bit serial_d11, ref bit serial_b1);
  super.start_synchronizer1(serial_d11, serial_b1);
  forever begin
    @(posedge vif1.clock1);
    if (!vif1.reset) begin
      serial_d11 = 1;
      serial_b1 = 1;
    end else begin
      serial_d11 = serial_b1;
      serial_b1 = vif1.txd1;
    end
  end
endtask : start_synchronizer1

function void uart_tx_monitor1::perform_coverage1();
  super.perform_coverage1();
  tx_traffic_cg1.sample();
  tx_protocol_cg1.sample();
endfunction : perform_coverage1

function void uart_tx_monitor1::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART1 Frames1 Collected1:%0d", num_frames1), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV1

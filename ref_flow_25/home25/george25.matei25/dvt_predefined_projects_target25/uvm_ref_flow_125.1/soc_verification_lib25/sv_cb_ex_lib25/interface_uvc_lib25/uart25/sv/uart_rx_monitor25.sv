/*-------------------------------------------------------------------------
File25 name   : uart_rx_monitor25.sv
Title25       : monitor25 file for uart25 uvc25
Project25     :
Created25     :
Description25 : descirbes25 UART25 Monitor25
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef UART_RX_MONITOR_SV25
`define UART_RX_MONITOR_SV25

class uart_rx_monitor25 extends uart_monitor25;

  `uvm_component_utils_begin(uart_rx_monitor25)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup rx_traffic_cg25;
    FRAME_DATA25: coverpoint cur_frame25.payload25 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger25 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB25: coverpoint msb_lsb_data25 { 
        bins zero = {0};
        bins one = {1};
        bins two25 = {2};
        bins three25 = {3};
      }
  endgroup

  covergroup rx_protocol_cg25;
    PARITY_ERROR_GEN25: coverpoint cur_frame25.error_bits25[1] {
        bins normal25 = { 0 };
        bins parity_error25 = { 1 };
      }
    FRAME_BREAK25: coverpoint cur_frame25.error_bits25[2] {
        bins normal25 = { 0 };
        bins frame_break25 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rx_traffic_cg25 = new();
    rx_traffic_cg25.set_inst_name ("rx_traffic_cg25");
    rx_protocol_cg25 = new();    
    rx_protocol_cg25.set_inst_name ("rx_protocol_cg25");
  endfunction: new

  // Additional25 class methods25
  extern virtual function void perform_coverage25();
  extern virtual task start_synchronizer25(ref bit serial_d125, ref bit serial_b25);
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_rx_monitor25

task uart_rx_monitor25::start_synchronizer25(ref bit serial_d125, ref bit serial_b25);
  super.start_synchronizer25(serial_d125, serial_b25);
  forever begin
    @(posedge vif25.clock25);
    if (!vif25.reset) begin
      serial_d125 = 1;
      serial_b25 = 1;
    end else begin
      serial_d125 = serial_b25;
      serial_b25 = vif25.rxd25;
    end
  end
endtask : start_synchronizer25

function void uart_rx_monitor25::perform_coverage25();
  super.perform_coverage25();
  rx_traffic_cg25.sample();
  rx_protocol_cg25.sample();
endfunction : perform_coverage25

function void uart_rx_monitor25::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART25 Frames25 Collected25:%0d", num_frames25), UVM_LOW)
endfunction : report_phase


`endif  // UART_RX_MONITOR_SV25

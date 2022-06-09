/*-------------------------------------------------------------------------
File16 name   : uart_tx_monitor16.sv
Title16       : TX16 monitor16 file for uart16 uvc16
Project16     :
Created16     :
Description16 : Describes16 UART16 TX16 Monitor16
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV16
`define UART_TX_MONITOR_SV16

class uart_tx_monitor16 extends uart_monitor16;
 
  `uvm_component_utils_begin(uart_tx_monitor16)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg16;
    FRAME_DATA16: coverpoint cur_frame16.payload16 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger16 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB16: coverpoint msb_lsb_data16 { 
        bins zero = {0};
        bins one = {1};
        bins two16 = {2};
        bins three16 = {3};
      }
  endgroup

  covergroup tx_protocol_cg16;
    PARITY_ERROR_GEN16: coverpoint cur_frame16.error_bits16[1] {
        bins normal16 = { 0 };
        bins parity_error16 = { 1 };
      }
    FRAME_BREAK16: coverpoint cur_frame16.error_bits16[2] {
        bins normal16 = { 0 };
        bins frame_break16 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg16 = new();
    tx_traffic_cg16.set_inst_name ("tx_traffic_cg16");
    tx_protocol_cg16 = new();
    tx_protocol_cg16.set_inst_name ("tx_protocol_cg16");
  endfunction: new

  // Additional16 class methods16
  extern virtual task start_synchronizer16(ref bit serial_d116, ref bit serial_b16);
  extern virtual function void perform_coverage16();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor16

task uart_tx_monitor16::start_synchronizer16(ref bit serial_d116, ref bit serial_b16);
  super.start_synchronizer16(serial_d116, serial_b16);
  forever begin
    @(posedge vif16.clock16);
    if (!vif16.reset) begin
      serial_d116 = 1;
      serial_b16 = 1;
    end else begin
      serial_d116 = serial_b16;
      serial_b16 = vif16.txd16;
    end
  end
endtask : start_synchronizer16

function void uart_tx_monitor16::perform_coverage16();
  super.perform_coverage16();
  tx_traffic_cg16.sample();
  tx_protocol_cg16.sample();
endfunction : perform_coverage16

function void uart_tx_monitor16::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART16 Frames16 Collected16:%0d", num_frames16), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV16

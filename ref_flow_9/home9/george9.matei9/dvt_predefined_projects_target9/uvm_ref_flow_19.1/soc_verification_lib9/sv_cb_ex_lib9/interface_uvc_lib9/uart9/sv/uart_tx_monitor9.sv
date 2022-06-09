/*-------------------------------------------------------------------------
File9 name   : uart_tx_monitor9.sv
Title9       : TX9 monitor9 file for uart9 uvc9
Project9     :
Created9     :
Description9 : Describes9 UART9 TX9 Monitor9
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV9
`define UART_TX_MONITOR_SV9

class uart_tx_monitor9 extends uart_monitor9;
 
  `uvm_component_utils_begin(uart_tx_monitor9)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg9;
    FRAME_DATA9: coverpoint cur_frame9.payload9 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger9 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB9: coverpoint msb_lsb_data9 { 
        bins zero = {0};
        bins one = {1};
        bins two9 = {2};
        bins three9 = {3};
      }
  endgroup

  covergroup tx_protocol_cg9;
    PARITY_ERROR_GEN9: coverpoint cur_frame9.error_bits9[1] {
        bins normal9 = { 0 };
        bins parity_error9 = { 1 };
      }
    FRAME_BREAK9: coverpoint cur_frame9.error_bits9[2] {
        bins normal9 = { 0 };
        bins frame_break9 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg9 = new();
    tx_traffic_cg9.set_inst_name ("tx_traffic_cg9");
    tx_protocol_cg9 = new();
    tx_protocol_cg9.set_inst_name ("tx_protocol_cg9");
  endfunction: new

  // Additional9 class methods9
  extern virtual task start_synchronizer9(ref bit serial_d19, ref bit serial_b9);
  extern virtual function void perform_coverage9();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor9

task uart_tx_monitor9::start_synchronizer9(ref bit serial_d19, ref bit serial_b9);
  super.start_synchronizer9(serial_d19, serial_b9);
  forever begin
    @(posedge vif9.clock9);
    if (!vif9.reset) begin
      serial_d19 = 1;
      serial_b9 = 1;
    end else begin
      serial_d19 = serial_b9;
      serial_b9 = vif9.txd9;
    end
  end
endtask : start_synchronizer9

function void uart_tx_monitor9::perform_coverage9();
  super.perform_coverage9();
  tx_traffic_cg9.sample();
  tx_protocol_cg9.sample();
endfunction : perform_coverage9

function void uart_tx_monitor9::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART9 Frames9 Collected9:%0d", num_frames9), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV9

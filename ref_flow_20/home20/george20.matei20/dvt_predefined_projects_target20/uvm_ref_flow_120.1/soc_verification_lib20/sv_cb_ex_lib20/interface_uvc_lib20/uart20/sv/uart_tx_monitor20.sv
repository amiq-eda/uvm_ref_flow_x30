/*-------------------------------------------------------------------------
File20 name   : uart_tx_monitor20.sv
Title20       : TX20 monitor20 file for uart20 uvc20
Project20     :
Created20     :
Description20 : Describes20 UART20 TX20 Monitor20
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV20
`define UART_TX_MONITOR_SV20

class uart_tx_monitor20 extends uart_monitor20;
 
  `uvm_component_utils_begin(uart_tx_monitor20)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg20;
    FRAME_DATA20: coverpoint cur_frame20.payload20 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger20 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB20: coverpoint msb_lsb_data20 { 
        bins zero = {0};
        bins one = {1};
        bins two20 = {2};
        bins three20 = {3};
      }
  endgroup

  covergroup tx_protocol_cg20;
    PARITY_ERROR_GEN20: coverpoint cur_frame20.error_bits20[1] {
        bins normal20 = { 0 };
        bins parity_error20 = { 1 };
      }
    FRAME_BREAK20: coverpoint cur_frame20.error_bits20[2] {
        bins normal20 = { 0 };
        bins frame_break20 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg20 = new();
    tx_traffic_cg20.set_inst_name ("tx_traffic_cg20");
    tx_protocol_cg20 = new();
    tx_protocol_cg20.set_inst_name ("tx_protocol_cg20");
  endfunction: new

  // Additional20 class methods20
  extern virtual task start_synchronizer20(ref bit serial_d120, ref bit serial_b20);
  extern virtual function void perform_coverage20();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor20

task uart_tx_monitor20::start_synchronizer20(ref bit serial_d120, ref bit serial_b20);
  super.start_synchronizer20(serial_d120, serial_b20);
  forever begin
    @(posedge vif20.clock20);
    if (!vif20.reset) begin
      serial_d120 = 1;
      serial_b20 = 1;
    end else begin
      serial_d120 = serial_b20;
      serial_b20 = vif20.txd20;
    end
  end
endtask : start_synchronizer20

function void uart_tx_monitor20::perform_coverage20();
  super.perform_coverage20();
  tx_traffic_cg20.sample();
  tx_protocol_cg20.sample();
endfunction : perform_coverage20

function void uart_tx_monitor20::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART20 Frames20 Collected20:%0d", num_frames20), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV20

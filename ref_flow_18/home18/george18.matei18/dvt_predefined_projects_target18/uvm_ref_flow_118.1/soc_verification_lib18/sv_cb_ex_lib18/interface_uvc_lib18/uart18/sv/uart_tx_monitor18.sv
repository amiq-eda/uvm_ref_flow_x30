/*-------------------------------------------------------------------------
File18 name   : uart_tx_monitor18.sv
Title18       : TX18 monitor18 file for uart18 uvc18
Project18     :
Created18     :
Description18 : Describes18 UART18 TX18 Monitor18
Notes18       :  
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV18
`define UART_TX_MONITOR_SV18

class uart_tx_monitor18 extends uart_monitor18;
 
  `uvm_component_utils_begin(uart_tx_monitor18)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg18;
    FRAME_DATA18: coverpoint cur_frame18.payload18 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger18 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB18: coverpoint msb_lsb_data18 { 
        bins zero = {0};
        bins one = {1};
        bins two18 = {2};
        bins three18 = {3};
      }
  endgroup

  covergroup tx_protocol_cg18;
    PARITY_ERROR_GEN18: coverpoint cur_frame18.error_bits18[1] {
        bins normal18 = { 0 };
        bins parity_error18 = { 1 };
      }
    FRAME_BREAK18: coverpoint cur_frame18.error_bits18[2] {
        bins normal18 = { 0 };
        bins frame_break18 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg18 = new();
    tx_traffic_cg18.set_inst_name ("tx_traffic_cg18");
    tx_protocol_cg18 = new();
    tx_protocol_cg18.set_inst_name ("tx_protocol_cg18");
  endfunction: new

  // Additional18 class methods18
  extern virtual task start_synchronizer18(ref bit serial_d118, ref bit serial_b18);
  extern virtual function void perform_coverage18();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor18

task uart_tx_monitor18::start_synchronizer18(ref bit serial_d118, ref bit serial_b18);
  super.start_synchronizer18(serial_d118, serial_b18);
  forever begin
    @(posedge vif18.clock18);
    if (!vif18.reset) begin
      serial_d118 = 1;
      serial_b18 = 1;
    end else begin
      serial_d118 = serial_b18;
      serial_b18 = vif18.txd18;
    end
  end
endtask : start_synchronizer18

function void uart_tx_monitor18::perform_coverage18();
  super.perform_coverage18();
  tx_traffic_cg18.sample();
  tx_protocol_cg18.sample();
endfunction : perform_coverage18

function void uart_tx_monitor18::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART18 Frames18 Collected18:%0d", num_frames18), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV18

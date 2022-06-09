/*-------------------------------------------------------------------------
File29 name   : uart_tx_monitor29.sv
Title29       : TX29 monitor29 file for uart29 uvc29
Project29     :
Created29     :
Description29 : Describes29 UART29 TX29 Monitor29
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV29
`define UART_TX_MONITOR_SV29

class uart_tx_monitor29 extends uart_monitor29;
 
  `uvm_component_utils_begin(uart_tx_monitor29)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg29;
    FRAME_DATA29: coverpoint cur_frame29.payload29 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger29 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB29: coverpoint msb_lsb_data29 { 
        bins zero = {0};
        bins one = {1};
        bins two29 = {2};
        bins three29 = {3};
      }
  endgroup

  covergroup tx_protocol_cg29;
    PARITY_ERROR_GEN29: coverpoint cur_frame29.error_bits29[1] {
        bins normal29 = { 0 };
        bins parity_error29 = { 1 };
      }
    FRAME_BREAK29: coverpoint cur_frame29.error_bits29[2] {
        bins normal29 = { 0 };
        bins frame_break29 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg29 = new();
    tx_traffic_cg29.set_inst_name ("tx_traffic_cg29");
    tx_protocol_cg29 = new();
    tx_protocol_cg29.set_inst_name ("tx_protocol_cg29");
  endfunction: new

  // Additional29 class methods29
  extern virtual task start_synchronizer29(ref bit serial_d129, ref bit serial_b29);
  extern virtual function void perform_coverage29();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor29

task uart_tx_monitor29::start_synchronizer29(ref bit serial_d129, ref bit serial_b29);
  super.start_synchronizer29(serial_d129, serial_b29);
  forever begin
    @(posedge vif29.clock29);
    if (!vif29.reset) begin
      serial_d129 = 1;
      serial_b29 = 1;
    end else begin
      serial_d129 = serial_b29;
      serial_b29 = vif29.txd29;
    end
  end
endtask : start_synchronizer29

function void uart_tx_monitor29::perform_coverage29();
  super.perform_coverage29();
  tx_traffic_cg29.sample();
  tx_protocol_cg29.sample();
endfunction : perform_coverage29

function void uart_tx_monitor29::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART29 Frames29 Collected29:%0d", num_frames29), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV29

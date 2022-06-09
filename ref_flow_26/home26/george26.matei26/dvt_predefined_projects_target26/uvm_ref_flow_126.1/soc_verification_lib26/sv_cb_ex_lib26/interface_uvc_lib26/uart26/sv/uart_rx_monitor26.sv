/*-------------------------------------------------------------------------
File26 name   : uart_rx_monitor26.sv
Title26       : monitor26 file for uart26 uvc26
Project26     :
Created26     :
Description26 : descirbes26 UART26 Monitor26
Notes26       :  
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef UART_RX_MONITOR_SV26
`define UART_RX_MONITOR_SV26

class uart_rx_monitor26 extends uart_monitor26;

  `uvm_component_utils_begin(uart_rx_monitor26)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup rx_traffic_cg26;
    FRAME_DATA26: coverpoint cur_frame26.payload26 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger26 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB26: coverpoint msb_lsb_data26 { 
        bins zero = {0};
        bins one = {1};
        bins two26 = {2};
        bins three26 = {3};
      }
  endgroup

  covergroup rx_protocol_cg26;
    PARITY_ERROR_GEN26: coverpoint cur_frame26.error_bits26[1] {
        bins normal26 = { 0 };
        bins parity_error26 = { 1 };
      }
    FRAME_BREAK26: coverpoint cur_frame26.error_bits26[2] {
        bins normal26 = { 0 };
        bins frame_break26 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rx_traffic_cg26 = new();
    rx_traffic_cg26.set_inst_name ("rx_traffic_cg26");
    rx_protocol_cg26 = new();    
    rx_protocol_cg26.set_inst_name ("rx_protocol_cg26");
  endfunction: new

  // Additional26 class methods26
  extern virtual function void perform_coverage26();
  extern virtual task start_synchronizer26(ref bit serial_d126, ref bit serial_b26);
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_rx_monitor26

task uart_rx_monitor26::start_synchronizer26(ref bit serial_d126, ref bit serial_b26);
  super.start_synchronizer26(serial_d126, serial_b26);
  forever begin
    @(posedge vif26.clock26);
    if (!vif26.reset) begin
      serial_d126 = 1;
      serial_b26 = 1;
    end else begin
      serial_d126 = serial_b26;
      serial_b26 = vif26.rxd26;
    end
  end
endtask : start_synchronizer26

function void uart_rx_monitor26::perform_coverage26();
  super.perform_coverage26();
  rx_traffic_cg26.sample();
  rx_protocol_cg26.sample();
endfunction : perform_coverage26

function void uart_rx_monitor26::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART26 Frames26 Collected26:%0d", num_frames26), UVM_LOW)
endfunction : report_phase


`endif  // UART_RX_MONITOR_SV26

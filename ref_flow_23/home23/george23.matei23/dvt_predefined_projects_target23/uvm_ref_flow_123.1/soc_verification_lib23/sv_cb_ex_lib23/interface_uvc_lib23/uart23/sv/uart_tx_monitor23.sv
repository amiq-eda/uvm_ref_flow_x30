/*-------------------------------------------------------------------------
File23 name   : uart_tx_monitor23.sv
Title23       : TX23 monitor23 file for uart23 uvc23
Project23     :
Created23     :
Description23 : Describes23 UART23 TX23 Monitor23
Notes23       :  
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV23
`define UART_TX_MONITOR_SV23

class uart_tx_monitor23 extends uart_monitor23;
 
  `uvm_component_utils_begin(uart_tx_monitor23)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg23;
    FRAME_DATA23: coverpoint cur_frame23.payload23 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger23 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB23: coverpoint msb_lsb_data23 { 
        bins zero = {0};
        bins one = {1};
        bins two23 = {2};
        bins three23 = {3};
      }
  endgroup

  covergroup tx_protocol_cg23;
    PARITY_ERROR_GEN23: coverpoint cur_frame23.error_bits23[1] {
        bins normal23 = { 0 };
        bins parity_error23 = { 1 };
      }
    FRAME_BREAK23: coverpoint cur_frame23.error_bits23[2] {
        bins normal23 = { 0 };
        bins frame_break23 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg23 = new();
    tx_traffic_cg23.set_inst_name ("tx_traffic_cg23");
    tx_protocol_cg23 = new();
    tx_protocol_cg23.set_inst_name ("tx_protocol_cg23");
  endfunction: new

  // Additional23 class methods23
  extern virtual task start_synchronizer23(ref bit serial_d123, ref bit serial_b23);
  extern virtual function void perform_coverage23();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor23

task uart_tx_monitor23::start_synchronizer23(ref bit serial_d123, ref bit serial_b23);
  super.start_synchronizer23(serial_d123, serial_b23);
  forever begin
    @(posedge vif23.clock23);
    if (!vif23.reset) begin
      serial_d123 = 1;
      serial_b23 = 1;
    end else begin
      serial_d123 = serial_b23;
      serial_b23 = vif23.txd23;
    end
  end
endtask : start_synchronizer23

function void uart_tx_monitor23::perform_coverage23();
  super.perform_coverage23();
  tx_traffic_cg23.sample();
  tx_protocol_cg23.sample();
endfunction : perform_coverage23

function void uart_tx_monitor23::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART23 Frames23 Collected23:%0d", num_frames23), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV23

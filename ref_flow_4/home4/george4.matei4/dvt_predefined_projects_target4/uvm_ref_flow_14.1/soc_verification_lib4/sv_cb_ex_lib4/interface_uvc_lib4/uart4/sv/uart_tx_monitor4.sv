/*-------------------------------------------------------------------------
File4 name   : uart_tx_monitor4.sv
Title4       : TX4 monitor4 file for uart4 uvc4
Project4     :
Created4     :
Description4 : Describes4 UART4 TX4 Monitor4
Notes4       :  
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV4
`define UART_TX_MONITOR_SV4

class uart_tx_monitor4 extends uart_monitor4;
 
  `uvm_component_utils_begin(uart_tx_monitor4)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg4;
    FRAME_DATA4: coverpoint cur_frame4.payload4 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger4 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB4: coverpoint msb_lsb_data4 { 
        bins zero = {0};
        bins one = {1};
        bins two4 = {2};
        bins three4 = {3};
      }
  endgroup

  covergroup tx_protocol_cg4;
    PARITY_ERROR_GEN4: coverpoint cur_frame4.error_bits4[1] {
        bins normal4 = { 0 };
        bins parity_error4 = { 1 };
      }
    FRAME_BREAK4: coverpoint cur_frame4.error_bits4[2] {
        bins normal4 = { 0 };
        bins frame_break4 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg4 = new();
    tx_traffic_cg4.set_inst_name ("tx_traffic_cg4");
    tx_protocol_cg4 = new();
    tx_protocol_cg4.set_inst_name ("tx_protocol_cg4");
  endfunction: new

  // Additional4 class methods4
  extern virtual task start_synchronizer4(ref bit serial_d14, ref bit serial_b4);
  extern virtual function void perform_coverage4();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor4

task uart_tx_monitor4::start_synchronizer4(ref bit serial_d14, ref bit serial_b4);
  super.start_synchronizer4(serial_d14, serial_b4);
  forever begin
    @(posedge vif4.clock4);
    if (!vif4.reset) begin
      serial_d14 = 1;
      serial_b4 = 1;
    end else begin
      serial_d14 = serial_b4;
      serial_b4 = vif4.txd4;
    end
  end
endtask : start_synchronizer4

function void uart_tx_monitor4::perform_coverage4();
  super.perform_coverage4();
  tx_traffic_cg4.sample();
  tx_protocol_cg4.sample();
endfunction : perform_coverage4

function void uart_tx_monitor4::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART4 Frames4 Collected4:%0d", num_frames4), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV4

/*-------------------------------------------------------------------------
File19 name   : uart_tx_monitor19.sv
Title19       : TX19 monitor19 file for uart19 uvc19
Project19     :
Created19     :
Description19 : Describes19 UART19 TX19 Monitor19
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV19
`define UART_TX_MONITOR_SV19

class uart_tx_monitor19 extends uart_monitor19;
 
  `uvm_component_utils_begin(uart_tx_monitor19)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg19;
    FRAME_DATA19: coverpoint cur_frame19.payload19 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger19 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB19: coverpoint msb_lsb_data19 { 
        bins zero = {0};
        bins one = {1};
        bins two19 = {2};
        bins three19 = {3};
      }
  endgroup

  covergroup tx_protocol_cg19;
    PARITY_ERROR_GEN19: coverpoint cur_frame19.error_bits19[1] {
        bins normal19 = { 0 };
        bins parity_error19 = { 1 };
      }
    FRAME_BREAK19: coverpoint cur_frame19.error_bits19[2] {
        bins normal19 = { 0 };
        bins frame_break19 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg19 = new();
    tx_traffic_cg19.set_inst_name ("tx_traffic_cg19");
    tx_protocol_cg19 = new();
    tx_protocol_cg19.set_inst_name ("tx_protocol_cg19");
  endfunction: new

  // Additional19 class methods19
  extern virtual task start_synchronizer19(ref bit serial_d119, ref bit serial_b19);
  extern virtual function void perform_coverage19();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor19

task uart_tx_monitor19::start_synchronizer19(ref bit serial_d119, ref bit serial_b19);
  super.start_synchronizer19(serial_d119, serial_b19);
  forever begin
    @(posedge vif19.clock19);
    if (!vif19.reset) begin
      serial_d119 = 1;
      serial_b19 = 1;
    end else begin
      serial_d119 = serial_b19;
      serial_b19 = vif19.txd19;
    end
  end
endtask : start_synchronizer19

function void uart_tx_monitor19::perform_coverage19();
  super.perform_coverage19();
  tx_traffic_cg19.sample();
  tx_protocol_cg19.sample();
endfunction : perform_coverage19

function void uart_tx_monitor19::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART19 Frames19 Collected19:%0d", num_frames19), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV19

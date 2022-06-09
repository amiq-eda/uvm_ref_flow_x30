/*-------------------------------------------------------------------------
File5 name   : uart_tx_monitor5.sv
Title5       : TX5 monitor5 file for uart5 uvc5
Project5     :
Created5     :
Description5 : Describes5 UART5 TX5 Monitor5
Notes5       :  
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV5
`define UART_TX_MONITOR_SV5

class uart_tx_monitor5 extends uart_monitor5;
 
  `uvm_component_utils_begin(uart_tx_monitor5)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg5;
    FRAME_DATA5: coverpoint cur_frame5.payload5 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger5 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB5: coverpoint msb_lsb_data5 { 
        bins zero = {0};
        bins one = {1};
        bins two5 = {2};
        bins three5 = {3};
      }
  endgroup

  covergroup tx_protocol_cg5;
    PARITY_ERROR_GEN5: coverpoint cur_frame5.error_bits5[1] {
        bins normal5 = { 0 };
        bins parity_error5 = { 1 };
      }
    FRAME_BREAK5: coverpoint cur_frame5.error_bits5[2] {
        bins normal5 = { 0 };
        bins frame_break5 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg5 = new();
    tx_traffic_cg5.set_inst_name ("tx_traffic_cg5");
    tx_protocol_cg5 = new();
    tx_protocol_cg5.set_inst_name ("tx_protocol_cg5");
  endfunction: new

  // Additional5 class methods5
  extern virtual task start_synchronizer5(ref bit serial_d15, ref bit serial_b5);
  extern virtual function void perform_coverage5();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor5

task uart_tx_monitor5::start_synchronizer5(ref bit serial_d15, ref bit serial_b5);
  super.start_synchronizer5(serial_d15, serial_b5);
  forever begin
    @(posedge vif5.clock5);
    if (!vif5.reset) begin
      serial_d15 = 1;
      serial_b5 = 1;
    end else begin
      serial_d15 = serial_b5;
      serial_b5 = vif5.txd5;
    end
  end
endtask : start_synchronizer5

function void uart_tx_monitor5::perform_coverage5();
  super.perform_coverage5();
  tx_traffic_cg5.sample();
  tx_protocol_cg5.sample();
endfunction : perform_coverage5

function void uart_tx_monitor5::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART5 Frames5 Collected5:%0d", num_frames5), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV5

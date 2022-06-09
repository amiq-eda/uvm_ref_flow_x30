/*-------------------------------------------------------------------------
File14 name   : uart_tx_monitor14.sv
Title14       : TX14 monitor14 file for uart14 uvc14
Project14     :
Created14     :
Description14 : Describes14 UART14 TX14 Monitor14
Notes14       :  
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV14
`define UART_TX_MONITOR_SV14

class uart_tx_monitor14 extends uart_monitor14;
 
  `uvm_component_utils_begin(uart_tx_monitor14)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg14;
    FRAME_DATA14: coverpoint cur_frame14.payload14 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger14 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB14: coverpoint msb_lsb_data14 { 
        bins zero = {0};
        bins one = {1};
        bins two14 = {2};
        bins three14 = {3};
      }
  endgroup

  covergroup tx_protocol_cg14;
    PARITY_ERROR_GEN14: coverpoint cur_frame14.error_bits14[1] {
        bins normal14 = { 0 };
        bins parity_error14 = { 1 };
      }
    FRAME_BREAK14: coverpoint cur_frame14.error_bits14[2] {
        bins normal14 = { 0 };
        bins frame_break14 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg14 = new();
    tx_traffic_cg14.set_inst_name ("tx_traffic_cg14");
    tx_protocol_cg14 = new();
    tx_protocol_cg14.set_inst_name ("tx_protocol_cg14");
  endfunction: new

  // Additional14 class methods14
  extern virtual task start_synchronizer14(ref bit serial_d114, ref bit serial_b14);
  extern virtual function void perform_coverage14();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor14

task uart_tx_monitor14::start_synchronizer14(ref bit serial_d114, ref bit serial_b14);
  super.start_synchronizer14(serial_d114, serial_b14);
  forever begin
    @(posedge vif14.clock14);
    if (!vif14.reset) begin
      serial_d114 = 1;
      serial_b14 = 1;
    end else begin
      serial_d114 = serial_b14;
      serial_b14 = vif14.txd14;
    end
  end
endtask : start_synchronizer14

function void uart_tx_monitor14::perform_coverage14();
  super.perform_coverage14();
  tx_traffic_cg14.sample();
  tx_protocol_cg14.sample();
endfunction : perform_coverage14

function void uart_tx_monitor14::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART14 Frames14 Collected14:%0d", num_frames14), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV14

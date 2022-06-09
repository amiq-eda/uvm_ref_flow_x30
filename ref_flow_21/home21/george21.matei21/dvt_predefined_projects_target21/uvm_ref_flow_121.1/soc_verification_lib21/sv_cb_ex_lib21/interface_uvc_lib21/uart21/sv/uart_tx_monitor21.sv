/*-------------------------------------------------------------------------
File21 name   : uart_tx_monitor21.sv
Title21       : TX21 monitor21 file for uart21 uvc21
Project21     :
Created21     :
Description21 : Describes21 UART21 TX21 Monitor21
Notes21       :  
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef UART_TX_MONITOR_SV21
`define UART_TX_MONITOR_SV21

class uart_tx_monitor21 extends uart_monitor21;
 
  `uvm_component_utils_begin(uart_tx_monitor21)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  covergroup tx_traffic_cg21;
    FRAME_DATA21: coverpoint cur_frame21.payload21 { 
        bins zero = {0};
        bins smaller = {[1:127]};
        bins larger21 = {[128:254]};
        bins max = {255};
      }
    FRAME_MSB_LSB21: coverpoint msb_lsb_data21 { 
        bins zero = {0};
        bins one = {1};
        bins two21 = {2};
        bins three21 = {3};
      }
  endgroup

  covergroup tx_protocol_cg21;
    PARITY_ERROR_GEN21: coverpoint cur_frame21.error_bits21[1] {
        bins normal21 = { 0 };
        bins parity_error21 = { 1 };
      }
    FRAME_BREAK21: coverpoint cur_frame21.error_bits21[2] {
        bins normal21 = { 0 };
        bins frame_break21 = { 1 };
      }
  endgroup

  function new (string name, uvm_component parent);
    super.new(name, parent);
    tx_traffic_cg21 = new();
    tx_traffic_cg21.set_inst_name ("tx_traffic_cg21");
    tx_protocol_cg21 = new();
    tx_protocol_cg21.set_inst_name ("tx_protocol_cg21");
  endfunction: new

  // Additional21 class methods21
  extern virtual task start_synchronizer21(ref bit serial_d121, ref bit serial_b21);
  extern virtual function void perform_coverage21();
  extern virtual function void report_phase(uvm_phase phase);

endclass: uart_tx_monitor21

task uart_tx_monitor21::start_synchronizer21(ref bit serial_d121, ref bit serial_b21);
  super.start_synchronizer21(serial_d121, serial_b21);
  forever begin
    @(posedge vif21.clock21);
    if (!vif21.reset) begin
      serial_d121 = 1;
      serial_b21 = 1;
    end else begin
      serial_d121 = serial_b21;
      serial_b21 = vif21.txd21;
    end
  end
endtask : start_synchronizer21

function void uart_tx_monitor21::perform_coverage21();
  super.perform_coverage21();
  tx_traffic_cg21.sample();
  tx_protocol_cg21.sample();
endfunction : perform_coverage21

function void uart_tx_monitor21::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("UART21 Frames21 Collected21:%0d", num_frames21), UVM_LOW)
endfunction : report_phase

`endif // UART_TX_MONITOR_SV21

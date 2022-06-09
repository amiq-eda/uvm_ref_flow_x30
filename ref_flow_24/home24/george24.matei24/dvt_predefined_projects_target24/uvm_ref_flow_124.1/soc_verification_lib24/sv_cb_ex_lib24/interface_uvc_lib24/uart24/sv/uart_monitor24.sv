/*-------------------------------------------------------------------------
File24 name   : uart_monitor24.sv
Title24       : monitor24 file for uart24 uvc24
Project24     :
Created24     :
Description24 : Descirbes24 UART24 Monitor24. Rx24/Tx24 monitors24 should be derived24 form24
            : this uart_monitor24 base class
Notes24       :  
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH24
`define UART_MONITOR_SVH24

virtual class uart_monitor24 extends uvm_monitor;
   uvm_analysis_port #(uart_frame24) frame_collected_port24;

  // virtual interface 
  virtual interface uart_if24 vif24;

  // Handle24 to  a cfg class
  uart_config24 cfg; 

  int num_frames24;
  bit sample_clk24;
  bit baud_clk24;
  bit [15:0] ua_brgr24;
  bit [7:0] ua_bdiv24;
  int num_of_bits_rcvd24;
  int transmit_delay24;
  bit sop_detected24;
  bit tmp_bit024;
  bit serial_d124;
  bit serial_bit24;
  bit serial_b24;
  bit [1:0]  msb_lsb_data24;

  bit checks_enable24 = 1;   // enable protocol24 checking
  bit coverage_enable24 = 1; // control24 coverage24 in the monitor24
  uart_frame24 cur_frame24;

  `uvm_field_utils_begin(uart_monitor24)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable24, UVM_DEFAULT)
      `uvm_field_int(coverage_enable24, UVM_DEFAULT)
      `uvm_field_object(cur_frame24, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg24;
    NUM_STOP_BITS24 : coverpoint cfg.nbstop24 {
      bins ONE24 = {0};
      bins TWO24 = {1};
    }
    DATA_LENGTH24 : coverpoint cfg.char_length24 {
      bins EIGHT24 = {0,1};
      bins SEVEN24 = {2};
      bins SIX24 = {3};
    }
    PARITY_MODE24 : coverpoint cfg.parity_mode24 {
      bins EVEN24  = {0};
      bins ODD24   = {1};
      bins SPACE24 = {2};
      bins MARK24  = {3};
    }
    PARITY_ERROR24: coverpoint cur_frame24.error_bits24[1]
      {
        bins good24 = { 0 };
        bins bad24 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE24: cross DATA_LENGTH24, PARITY_MODE24;
    PARITY_ERROR_x_PARITY_MODE24: cross PARITY_ERROR24, PARITY_MODE24;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg24 = new();
    uart_trans_frame_cg24.set_inst_name ("uart_trans_frame_cg24");
    frame_collected_port24 = new("frame_collected_port24", this);
  endfunction: new

  // Additional24 class methods24;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate24(ref bit [15:0] ua_brgr24, ref bit sample_clk24, ref bit sop_detected24);
  extern virtual task start_synchronizer24(ref bit serial_d124, ref bit serial_b24);
  extern virtual protected function void perform_coverage24();
  extern virtual task collect_frame24();
  extern virtual task wait_for_sop24(ref bit sop_detected24);
  extern virtual task sample_and_store24();
endclass: uart_monitor24

// UVM build_phase
function void uart_monitor24::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config24)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG24", "uart_config24 not set for this somponent24")
endfunction : build_phase

function void uart_monitor24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if24)::get(this, "","vif24",vif24))
      `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".vif24"})
endfunction : connect_phase

task uart_monitor24::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start24 Running24", UVM_LOW)
  @(negedge vif24.reset); 
  wait (vif24.reset);
  `uvm_info(get_type_name(), "Detected24 Reset24 Done24", UVM_LOW)
  num_frames24 = 0;
  cur_frame24 = uart_frame24::type_id::create("cur_frame24", this);

  fork
    gen_sample_rate24(ua_brgr24, sample_clk24, sop_detected24);
    start_synchronizer24(serial_d124, serial_b24);
    sample_and_store24();
  join
endtask : run_phase

task uart_monitor24::gen_sample_rate24(ref bit [15:0] ua_brgr24, ref bit sample_clk24, ref bit sop_detected24);
    forever begin
      @(posedge vif24.clock24);
      if ((!vif24.reset) || (sop_detected24)) begin
        `uvm_info(get_type_name(), "sample_clk24- resetting24 ua_brgr24", UVM_HIGH)
        ua_brgr24 = 0;
        sample_clk24 = 0;
        sop_detected24 = 0;
      end else begin
        if ( ua_brgr24 == ({cfg.baud_rate_div24, cfg.baud_rate_gen24})) begin
          ua_brgr24 = 0;
          sample_clk24 = 1;
        end else begin
          sample_clk24 = 0;
          ua_brgr24++;
        end
      end
    end
endtask

task uart_monitor24::start_synchronizer24(ref bit serial_d124, ref bit serial_b24);
endtask

task uart_monitor24::sample_and_store24();
  forever begin
    wait_for_sop24(sop_detected24);
    collect_frame24();
  end
endtask : sample_and_store24

task uart_monitor24::wait_for_sop24(ref bit sop_detected24);
    transmit_delay24 = 0;
    sop_detected24 = 0;
    while (!sop_detected24) begin
      `uvm_info(get_type_name(), "trying24 to detect24 SOP24", UVM_MEDIUM)
      while (!(serial_d124 == 1 && serial_b24 == 0)) begin
        @(negedge vif24.clock24);
        transmit_delay24++;
      end
      if (serial_b24 != 0)
        `uvm_info(get_type_name(), "Encountered24 a glitch24 in serial24 during SOP24, shall24 continue", UVM_LOW)
      else
      begin
        sop_detected24 = 1;
        `uvm_info(get_type_name(), "SOP24 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop24
  

task uart_monitor24::collect_frame24();
  bit [7:0] payload_byte24;
  cur_frame24 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting24 a frame24: %0d", num_frames24+1), UVM_HIGH)
   // Begin24 Transaction24 Recording24
  void'(this.begin_tr(cur_frame24, "UART24 Monitor24", , get_full_name()));
  cur_frame24.transmit_delay24 = transmit_delay24;
  cur_frame24.start_bit24 = 1'b0;
  cur_frame24.parity_type24 = GOOD_PARITY24;
  num_of_bits_rcvd24 = 0;

    while (num_of_bits_rcvd24 < (1 + cfg.char_len_val24 + cfg.parity_en24 + cfg.nbstop24))
    begin
      @(posedge vif24.clock24);
      #1;
      if (sample_clk24) begin
        num_of_bits_rcvd24++;
        if ((num_of_bits_rcvd24 > 0) && (num_of_bits_rcvd24 <= cfg.char_len_val24)) begin // sending24 "data bits" 
          cur_frame24.payload24[num_of_bits_rcvd24-1] = serial_b24;
          payload_byte24 = cur_frame24.payload24[num_of_bits_rcvd24-1];
          `uvm_info(get_type_name(), $psprintf("Received24 a Frame24 data bit:'b%0b", payload_byte24), UVM_HIGH)
        end
        msb_lsb_data24[0] =  cur_frame24.payload24[0] ;
        msb_lsb_data24[1] =  cur_frame24.payload24[cfg.char_len_val24-1] ;
        if ((num_of_bits_rcvd24 == (1 + cfg.char_len_val24)) && (cfg.parity_en24)) begin // sending24 "parity24 bit" if parity24 is enabled
          cur_frame24.parity24 = serial_b24;
          `uvm_info(get_type_name(), $psprintf("Received24 Parity24 bit:'b%0b", cur_frame24.parity24), UVM_HIGH)
          if (serial_b24 == cur_frame24.calc_parity24(cfg.char_len_val24, cfg.parity_mode24))
            `uvm_info(get_type_name(), "Received24 Parity24 is same as calculated24 Parity24", UVM_MEDIUM)
          else if (checks_enable24)
            `uvm_error(get_type_name(), "####### FAIL24 :Received24 Parity24 doesn't match the calculated24 Parity24  ")
        end
        if (num_of_bits_rcvd24 == (1 + cfg.char_len_val24 + cfg.parity_en24)) begin // sending24 "stop/error bits"
          for (int i = 0; i < cfg.nbstop24; i++) begin
            wait (sample_clk24);
            cur_frame24.stop_bits24[i] = serial_b24;
            `uvm_info(get_type_name(), $psprintf("Received24 a Stop bit: 'b%0b", cur_frame24.stop_bits24[i]), UVM_HIGH)
            num_of_bits_rcvd24++;
            wait (!sample_clk24);
          end
        end
        wait (!sample_clk24);
      end
    end
 num_frames24++; 
 `uvm_info(get_type_name(), $psprintf("Collected24 the following24 Frame24 No:%0d\n%s", num_frames24, cur_frame24.sprint()), UVM_MEDIUM)

  if(coverage_enable24) perform_coverage24();
  frame_collected_port24.write(cur_frame24);
  this.end_tr(cur_frame24);
endtask : collect_frame24

function void uart_monitor24::perform_coverage24();
  uart_trans_frame_cg24.sample();
endfunction : perform_coverage24

`endif

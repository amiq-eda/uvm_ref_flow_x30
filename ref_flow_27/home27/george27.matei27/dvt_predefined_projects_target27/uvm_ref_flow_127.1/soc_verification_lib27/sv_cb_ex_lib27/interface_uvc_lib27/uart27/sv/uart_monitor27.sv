/*-------------------------------------------------------------------------
File27 name   : uart_monitor27.sv
Title27       : monitor27 file for uart27 uvc27
Project27     :
Created27     :
Description27 : Descirbes27 UART27 Monitor27. Rx27/Tx27 monitors27 should be derived27 form27
            : this uart_monitor27 base class
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH27
`define UART_MONITOR_SVH27

virtual class uart_monitor27 extends uvm_monitor;
   uvm_analysis_port #(uart_frame27) frame_collected_port27;

  // virtual interface 
  virtual interface uart_if27 vif27;

  // Handle27 to  a cfg class
  uart_config27 cfg; 

  int num_frames27;
  bit sample_clk27;
  bit baud_clk27;
  bit [15:0] ua_brgr27;
  bit [7:0] ua_bdiv27;
  int num_of_bits_rcvd27;
  int transmit_delay27;
  bit sop_detected27;
  bit tmp_bit027;
  bit serial_d127;
  bit serial_bit27;
  bit serial_b27;
  bit [1:0]  msb_lsb_data27;

  bit checks_enable27 = 1;   // enable protocol27 checking
  bit coverage_enable27 = 1; // control27 coverage27 in the monitor27
  uart_frame27 cur_frame27;

  `uvm_field_utils_begin(uart_monitor27)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable27, UVM_DEFAULT)
      `uvm_field_int(coverage_enable27, UVM_DEFAULT)
      `uvm_field_object(cur_frame27, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg27;
    NUM_STOP_BITS27 : coverpoint cfg.nbstop27 {
      bins ONE27 = {0};
      bins TWO27 = {1};
    }
    DATA_LENGTH27 : coverpoint cfg.char_length27 {
      bins EIGHT27 = {0,1};
      bins SEVEN27 = {2};
      bins SIX27 = {3};
    }
    PARITY_MODE27 : coverpoint cfg.parity_mode27 {
      bins EVEN27  = {0};
      bins ODD27   = {1};
      bins SPACE27 = {2};
      bins MARK27  = {3};
    }
    PARITY_ERROR27: coverpoint cur_frame27.error_bits27[1]
      {
        bins good27 = { 0 };
        bins bad27 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE27: cross DATA_LENGTH27, PARITY_MODE27;
    PARITY_ERROR_x_PARITY_MODE27: cross PARITY_ERROR27, PARITY_MODE27;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg27 = new();
    uart_trans_frame_cg27.set_inst_name ("uart_trans_frame_cg27");
    frame_collected_port27 = new("frame_collected_port27", this);
  endfunction: new

  // Additional27 class methods27;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate27(ref bit [15:0] ua_brgr27, ref bit sample_clk27, ref bit sop_detected27);
  extern virtual task start_synchronizer27(ref bit serial_d127, ref bit serial_b27);
  extern virtual protected function void perform_coverage27();
  extern virtual task collect_frame27();
  extern virtual task wait_for_sop27(ref bit sop_detected27);
  extern virtual task sample_and_store27();
endclass: uart_monitor27

// UVM build_phase
function void uart_monitor27::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config27)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG27", "uart_config27 not set for this somponent27")
endfunction : build_phase

function void uart_monitor27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if27)::get(this, "","vif27",vif27))
      `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".vif27"})
endfunction : connect_phase

task uart_monitor27::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start27 Running27", UVM_LOW)
  @(negedge vif27.reset); 
  wait (vif27.reset);
  `uvm_info(get_type_name(), "Detected27 Reset27 Done27", UVM_LOW)
  num_frames27 = 0;
  cur_frame27 = uart_frame27::type_id::create("cur_frame27", this);

  fork
    gen_sample_rate27(ua_brgr27, sample_clk27, sop_detected27);
    start_synchronizer27(serial_d127, serial_b27);
    sample_and_store27();
  join
endtask : run_phase

task uart_monitor27::gen_sample_rate27(ref bit [15:0] ua_brgr27, ref bit sample_clk27, ref bit sop_detected27);
    forever begin
      @(posedge vif27.clock27);
      if ((!vif27.reset) || (sop_detected27)) begin
        `uvm_info(get_type_name(), "sample_clk27- resetting27 ua_brgr27", UVM_HIGH)
        ua_brgr27 = 0;
        sample_clk27 = 0;
        sop_detected27 = 0;
      end else begin
        if ( ua_brgr27 == ({cfg.baud_rate_div27, cfg.baud_rate_gen27})) begin
          ua_brgr27 = 0;
          sample_clk27 = 1;
        end else begin
          sample_clk27 = 0;
          ua_brgr27++;
        end
      end
    end
endtask

task uart_monitor27::start_synchronizer27(ref bit serial_d127, ref bit serial_b27);
endtask

task uart_monitor27::sample_and_store27();
  forever begin
    wait_for_sop27(sop_detected27);
    collect_frame27();
  end
endtask : sample_and_store27

task uart_monitor27::wait_for_sop27(ref bit sop_detected27);
    transmit_delay27 = 0;
    sop_detected27 = 0;
    while (!sop_detected27) begin
      `uvm_info(get_type_name(), "trying27 to detect27 SOP27", UVM_MEDIUM)
      while (!(serial_d127 == 1 && serial_b27 == 0)) begin
        @(negedge vif27.clock27);
        transmit_delay27++;
      end
      if (serial_b27 != 0)
        `uvm_info(get_type_name(), "Encountered27 a glitch27 in serial27 during SOP27, shall27 continue", UVM_LOW)
      else
      begin
        sop_detected27 = 1;
        `uvm_info(get_type_name(), "SOP27 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop27
  

task uart_monitor27::collect_frame27();
  bit [7:0] payload_byte27;
  cur_frame27 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting27 a frame27: %0d", num_frames27+1), UVM_HIGH)
   // Begin27 Transaction27 Recording27
  void'(this.begin_tr(cur_frame27, "UART27 Monitor27", , get_full_name()));
  cur_frame27.transmit_delay27 = transmit_delay27;
  cur_frame27.start_bit27 = 1'b0;
  cur_frame27.parity_type27 = GOOD_PARITY27;
  num_of_bits_rcvd27 = 0;

    while (num_of_bits_rcvd27 < (1 + cfg.char_len_val27 + cfg.parity_en27 + cfg.nbstop27))
    begin
      @(posedge vif27.clock27);
      #1;
      if (sample_clk27) begin
        num_of_bits_rcvd27++;
        if ((num_of_bits_rcvd27 > 0) && (num_of_bits_rcvd27 <= cfg.char_len_val27)) begin // sending27 "data bits" 
          cur_frame27.payload27[num_of_bits_rcvd27-1] = serial_b27;
          payload_byte27 = cur_frame27.payload27[num_of_bits_rcvd27-1];
          `uvm_info(get_type_name(), $psprintf("Received27 a Frame27 data bit:'b%0b", payload_byte27), UVM_HIGH)
        end
        msb_lsb_data27[0] =  cur_frame27.payload27[0] ;
        msb_lsb_data27[1] =  cur_frame27.payload27[cfg.char_len_val27-1] ;
        if ((num_of_bits_rcvd27 == (1 + cfg.char_len_val27)) && (cfg.parity_en27)) begin // sending27 "parity27 bit" if parity27 is enabled
          cur_frame27.parity27 = serial_b27;
          `uvm_info(get_type_name(), $psprintf("Received27 Parity27 bit:'b%0b", cur_frame27.parity27), UVM_HIGH)
          if (serial_b27 == cur_frame27.calc_parity27(cfg.char_len_val27, cfg.parity_mode27))
            `uvm_info(get_type_name(), "Received27 Parity27 is same as calculated27 Parity27", UVM_MEDIUM)
          else if (checks_enable27)
            `uvm_error(get_type_name(), "####### FAIL27 :Received27 Parity27 doesn't match the calculated27 Parity27  ")
        end
        if (num_of_bits_rcvd27 == (1 + cfg.char_len_val27 + cfg.parity_en27)) begin // sending27 "stop/error bits"
          for (int i = 0; i < cfg.nbstop27; i++) begin
            wait (sample_clk27);
            cur_frame27.stop_bits27[i] = serial_b27;
            `uvm_info(get_type_name(), $psprintf("Received27 a Stop bit: 'b%0b", cur_frame27.stop_bits27[i]), UVM_HIGH)
            num_of_bits_rcvd27++;
            wait (!sample_clk27);
          end
        end
        wait (!sample_clk27);
      end
    end
 num_frames27++; 
 `uvm_info(get_type_name(), $psprintf("Collected27 the following27 Frame27 No:%0d\n%s", num_frames27, cur_frame27.sprint()), UVM_MEDIUM)

  if(coverage_enable27) perform_coverage27();
  frame_collected_port27.write(cur_frame27);
  this.end_tr(cur_frame27);
endtask : collect_frame27

function void uart_monitor27::perform_coverage27();
  uart_trans_frame_cg27.sample();
endfunction : perform_coverage27

`endif

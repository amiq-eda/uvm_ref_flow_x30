/*-------------------------------------------------------------------------
File8 name   : uart_monitor8.sv
Title8       : monitor8 file for uart8 uvc8
Project8     :
Created8     :
Description8 : Descirbes8 UART8 Monitor8. Rx8/Tx8 monitors8 should be derived8 form8
            : this uart_monitor8 base class
Notes8       :  
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH8
`define UART_MONITOR_SVH8

virtual class uart_monitor8 extends uvm_monitor;
   uvm_analysis_port #(uart_frame8) frame_collected_port8;

  // virtual interface 
  virtual interface uart_if8 vif8;

  // Handle8 to  a cfg class
  uart_config8 cfg; 

  int num_frames8;
  bit sample_clk8;
  bit baud_clk8;
  bit [15:0] ua_brgr8;
  bit [7:0] ua_bdiv8;
  int num_of_bits_rcvd8;
  int transmit_delay8;
  bit sop_detected8;
  bit tmp_bit08;
  bit serial_d18;
  bit serial_bit8;
  bit serial_b8;
  bit [1:0]  msb_lsb_data8;

  bit checks_enable8 = 1;   // enable protocol8 checking
  bit coverage_enable8 = 1; // control8 coverage8 in the monitor8
  uart_frame8 cur_frame8;

  `uvm_field_utils_begin(uart_monitor8)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable8, UVM_DEFAULT)
      `uvm_field_int(coverage_enable8, UVM_DEFAULT)
      `uvm_field_object(cur_frame8, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg8;
    NUM_STOP_BITS8 : coverpoint cfg.nbstop8 {
      bins ONE8 = {0};
      bins TWO8 = {1};
    }
    DATA_LENGTH8 : coverpoint cfg.char_length8 {
      bins EIGHT8 = {0,1};
      bins SEVEN8 = {2};
      bins SIX8 = {3};
    }
    PARITY_MODE8 : coverpoint cfg.parity_mode8 {
      bins EVEN8  = {0};
      bins ODD8   = {1};
      bins SPACE8 = {2};
      bins MARK8  = {3};
    }
    PARITY_ERROR8: coverpoint cur_frame8.error_bits8[1]
      {
        bins good8 = { 0 };
        bins bad8 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE8: cross DATA_LENGTH8, PARITY_MODE8;
    PARITY_ERROR_x_PARITY_MODE8: cross PARITY_ERROR8, PARITY_MODE8;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg8 = new();
    uart_trans_frame_cg8.set_inst_name ("uart_trans_frame_cg8");
    frame_collected_port8 = new("frame_collected_port8", this);
  endfunction: new

  // Additional8 class methods8;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate8(ref bit [15:0] ua_brgr8, ref bit sample_clk8, ref bit sop_detected8);
  extern virtual task start_synchronizer8(ref bit serial_d18, ref bit serial_b8);
  extern virtual protected function void perform_coverage8();
  extern virtual task collect_frame8();
  extern virtual task wait_for_sop8(ref bit sop_detected8);
  extern virtual task sample_and_store8();
endclass: uart_monitor8

// UVM build_phase
function void uart_monitor8::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config8)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG8", "uart_config8 not set for this somponent8")
endfunction : build_phase

function void uart_monitor8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if8)::get(this, "","vif8",vif8))
      `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".vif8"})
endfunction : connect_phase

task uart_monitor8::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start8 Running8", UVM_LOW)
  @(negedge vif8.reset); 
  wait (vif8.reset);
  `uvm_info(get_type_name(), "Detected8 Reset8 Done8", UVM_LOW)
  num_frames8 = 0;
  cur_frame8 = uart_frame8::type_id::create("cur_frame8", this);

  fork
    gen_sample_rate8(ua_brgr8, sample_clk8, sop_detected8);
    start_synchronizer8(serial_d18, serial_b8);
    sample_and_store8();
  join
endtask : run_phase

task uart_monitor8::gen_sample_rate8(ref bit [15:0] ua_brgr8, ref bit sample_clk8, ref bit sop_detected8);
    forever begin
      @(posedge vif8.clock8);
      if ((!vif8.reset) || (sop_detected8)) begin
        `uvm_info(get_type_name(), "sample_clk8- resetting8 ua_brgr8", UVM_HIGH)
        ua_brgr8 = 0;
        sample_clk8 = 0;
        sop_detected8 = 0;
      end else begin
        if ( ua_brgr8 == ({cfg.baud_rate_div8, cfg.baud_rate_gen8})) begin
          ua_brgr8 = 0;
          sample_clk8 = 1;
        end else begin
          sample_clk8 = 0;
          ua_brgr8++;
        end
      end
    end
endtask

task uart_monitor8::start_synchronizer8(ref bit serial_d18, ref bit serial_b8);
endtask

task uart_monitor8::sample_and_store8();
  forever begin
    wait_for_sop8(sop_detected8);
    collect_frame8();
  end
endtask : sample_and_store8

task uart_monitor8::wait_for_sop8(ref bit sop_detected8);
    transmit_delay8 = 0;
    sop_detected8 = 0;
    while (!sop_detected8) begin
      `uvm_info(get_type_name(), "trying8 to detect8 SOP8", UVM_MEDIUM)
      while (!(serial_d18 == 1 && serial_b8 == 0)) begin
        @(negedge vif8.clock8);
        transmit_delay8++;
      end
      if (serial_b8 != 0)
        `uvm_info(get_type_name(), "Encountered8 a glitch8 in serial8 during SOP8, shall8 continue", UVM_LOW)
      else
      begin
        sop_detected8 = 1;
        `uvm_info(get_type_name(), "SOP8 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop8
  

task uart_monitor8::collect_frame8();
  bit [7:0] payload_byte8;
  cur_frame8 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting8 a frame8: %0d", num_frames8+1), UVM_HIGH)
   // Begin8 Transaction8 Recording8
  void'(this.begin_tr(cur_frame8, "UART8 Monitor8", , get_full_name()));
  cur_frame8.transmit_delay8 = transmit_delay8;
  cur_frame8.start_bit8 = 1'b0;
  cur_frame8.parity_type8 = GOOD_PARITY8;
  num_of_bits_rcvd8 = 0;

    while (num_of_bits_rcvd8 < (1 + cfg.char_len_val8 + cfg.parity_en8 + cfg.nbstop8))
    begin
      @(posedge vif8.clock8);
      #1;
      if (sample_clk8) begin
        num_of_bits_rcvd8++;
        if ((num_of_bits_rcvd8 > 0) && (num_of_bits_rcvd8 <= cfg.char_len_val8)) begin // sending8 "data bits" 
          cur_frame8.payload8[num_of_bits_rcvd8-1] = serial_b8;
          payload_byte8 = cur_frame8.payload8[num_of_bits_rcvd8-1];
          `uvm_info(get_type_name(), $psprintf("Received8 a Frame8 data bit:'b%0b", payload_byte8), UVM_HIGH)
        end
        msb_lsb_data8[0] =  cur_frame8.payload8[0] ;
        msb_lsb_data8[1] =  cur_frame8.payload8[cfg.char_len_val8-1] ;
        if ((num_of_bits_rcvd8 == (1 + cfg.char_len_val8)) && (cfg.parity_en8)) begin // sending8 "parity8 bit" if parity8 is enabled
          cur_frame8.parity8 = serial_b8;
          `uvm_info(get_type_name(), $psprintf("Received8 Parity8 bit:'b%0b", cur_frame8.parity8), UVM_HIGH)
          if (serial_b8 == cur_frame8.calc_parity8(cfg.char_len_val8, cfg.parity_mode8))
            `uvm_info(get_type_name(), "Received8 Parity8 is same as calculated8 Parity8", UVM_MEDIUM)
          else if (checks_enable8)
            `uvm_error(get_type_name(), "####### FAIL8 :Received8 Parity8 doesn't match the calculated8 Parity8  ")
        end
        if (num_of_bits_rcvd8 == (1 + cfg.char_len_val8 + cfg.parity_en8)) begin // sending8 "stop/error bits"
          for (int i = 0; i < cfg.nbstop8; i++) begin
            wait (sample_clk8);
            cur_frame8.stop_bits8[i] = serial_b8;
            `uvm_info(get_type_name(), $psprintf("Received8 a Stop bit: 'b%0b", cur_frame8.stop_bits8[i]), UVM_HIGH)
            num_of_bits_rcvd8++;
            wait (!sample_clk8);
          end
        end
        wait (!sample_clk8);
      end
    end
 num_frames8++; 
 `uvm_info(get_type_name(), $psprintf("Collected8 the following8 Frame8 No:%0d\n%s", num_frames8, cur_frame8.sprint()), UVM_MEDIUM)

  if(coverage_enable8) perform_coverage8();
  frame_collected_port8.write(cur_frame8);
  this.end_tr(cur_frame8);
endtask : collect_frame8

function void uart_monitor8::perform_coverage8();
  uart_trans_frame_cg8.sample();
endfunction : perform_coverage8

`endif

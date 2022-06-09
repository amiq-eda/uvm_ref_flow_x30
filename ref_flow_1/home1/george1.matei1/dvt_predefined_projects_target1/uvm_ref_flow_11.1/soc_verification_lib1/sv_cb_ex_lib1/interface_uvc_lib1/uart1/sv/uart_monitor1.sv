/*-------------------------------------------------------------------------
File1 name   : uart_monitor1.sv
Title1       : monitor1 file for uart1 uvc1
Project1     :
Created1     :
Description1 : Descirbes1 UART1 Monitor1. Rx1/Tx1 monitors1 should be derived1 form1
            : this uart_monitor1 base class
Notes1       :  
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH1
`define UART_MONITOR_SVH1

virtual class uart_monitor1 extends uvm_monitor;
   uvm_analysis_port #(uart_frame1) frame_collected_port1;

  // virtual interface 
  virtual interface uart_if1 vif1;

  // Handle1 to  a cfg class
  uart_config1 cfg; 

  int num_frames1;
  bit sample_clk1;
  bit baud_clk1;
  bit [15:0] ua_brgr1;
  bit [7:0] ua_bdiv1;
  int num_of_bits_rcvd1;
  int transmit_delay1;
  bit sop_detected1;
  bit tmp_bit01;
  bit serial_d11;
  bit serial_bit1;
  bit serial_b1;
  bit [1:0]  msb_lsb_data1;

  bit checks_enable1 = 1;   // enable protocol1 checking
  bit coverage_enable1 = 1; // control1 coverage1 in the monitor1
  uart_frame1 cur_frame1;

  `uvm_field_utils_begin(uart_monitor1)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable1, UVM_DEFAULT)
      `uvm_field_int(coverage_enable1, UVM_DEFAULT)
      `uvm_field_object(cur_frame1, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg1;
    NUM_STOP_BITS1 : coverpoint cfg.nbstop1 {
      bins ONE1 = {0};
      bins TWO1 = {1};
    }
    DATA_LENGTH1 : coverpoint cfg.char_length1 {
      bins EIGHT1 = {0,1};
      bins SEVEN1 = {2};
      bins SIX1 = {3};
    }
    PARITY_MODE1 : coverpoint cfg.parity_mode1 {
      bins EVEN1  = {0};
      bins ODD1   = {1};
      bins SPACE1 = {2};
      bins MARK1  = {3};
    }
    PARITY_ERROR1: coverpoint cur_frame1.error_bits1[1]
      {
        bins good1 = { 0 };
        bins bad1 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE1: cross DATA_LENGTH1, PARITY_MODE1;
    PARITY_ERROR_x_PARITY_MODE1: cross PARITY_ERROR1, PARITY_MODE1;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg1 = new();
    uart_trans_frame_cg1.set_inst_name ("uart_trans_frame_cg1");
    frame_collected_port1 = new("frame_collected_port1", this);
  endfunction: new

  // Additional1 class methods1;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate1(ref bit [15:0] ua_brgr1, ref bit sample_clk1, ref bit sop_detected1);
  extern virtual task start_synchronizer1(ref bit serial_d11, ref bit serial_b1);
  extern virtual protected function void perform_coverage1();
  extern virtual task collect_frame1();
  extern virtual task wait_for_sop1(ref bit sop_detected1);
  extern virtual task sample_and_store1();
endclass: uart_monitor1

// UVM build_phase
function void uart_monitor1::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config1)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG1", "uart_config1 not set for this somponent1")
endfunction : build_phase

function void uart_monitor1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if1)::get(this, "","vif1",vif1))
      `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".vif1"})
endfunction : connect_phase

task uart_monitor1::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start1 Running1", UVM_LOW)
  @(negedge vif1.reset); 
  wait (vif1.reset);
  `uvm_info(get_type_name(), "Detected1 Reset1 Done1", UVM_LOW)
  num_frames1 = 0;
  cur_frame1 = uart_frame1::type_id::create("cur_frame1", this);

  fork
    gen_sample_rate1(ua_brgr1, sample_clk1, sop_detected1);
    start_synchronizer1(serial_d11, serial_b1);
    sample_and_store1();
  join
endtask : run_phase

task uart_monitor1::gen_sample_rate1(ref bit [15:0] ua_brgr1, ref bit sample_clk1, ref bit sop_detected1);
    forever begin
      @(posedge vif1.clock1);
      if ((!vif1.reset) || (sop_detected1)) begin
        `uvm_info(get_type_name(), "sample_clk1- resetting1 ua_brgr1", UVM_HIGH)
        ua_brgr1 = 0;
        sample_clk1 = 0;
        sop_detected1 = 0;
      end else begin
        if ( ua_brgr1 == ({cfg.baud_rate_div1, cfg.baud_rate_gen1})) begin
          ua_brgr1 = 0;
          sample_clk1 = 1;
        end else begin
          sample_clk1 = 0;
          ua_brgr1++;
        end
      end
    end
endtask

task uart_monitor1::start_synchronizer1(ref bit serial_d11, ref bit serial_b1);
endtask

task uart_monitor1::sample_and_store1();
  forever begin
    wait_for_sop1(sop_detected1);
    collect_frame1();
  end
endtask : sample_and_store1

task uart_monitor1::wait_for_sop1(ref bit sop_detected1);
    transmit_delay1 = 0;
    sop_detected1 = 0;
    while (!sop_detected1) begin
      `uvm_info(get_type_name(), "trying1 to detect1 SOP1", UVM_MEDIUM)
      while (!(serial_d11 == 1 && serial_b1 == 0)) begin
        @(negedge vif1.clock1);
        transmit_delay1++;
      end
      if (serial_b1 != 0)
        `uvm_info(get_type_name(), "Encountered1 a glitch1 in serial1 during SOP1, shall1 continue", UVM_LOW)
      else
      begin
        sop_detected1 = 1;
        `uvm_info(get_type_name(), "SOP1 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop1
  

task uart_monitor1::collect_frame1();
  bit [7:0] payload_byte1;
  cur_frame1 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting1 a frame1: %0d", num_frames1+1), UVM_HIGH)
   // Begin1 Transaction1 Recording1
  void'(this.begin_tr(cur_frame1, "UART1 Monitor1", , get_full_name()));
  cur_frame1.transmit_delay1 = transmit_delay1;
  cur_frame1.start_bit1 = 1'b0;
  cur_frame1.parity_type1 = GOOD_PARITY1;
  num_of_bits_rcvd1 = 0;

    while (num_of_bits_rcvd1 < (1 + cfg.char_len_val1 + cfg.parity_en1 + cfg.nbstop1))
    begin
      @(posedge vif1.clock1);
      #1;
      if (sample_clk1) begin
        num_of_bits_rcvd1++;
        if ((num_of_bits_rcvd1 > 0) && (num_of_bits_rcvd1 <= cfg.char_len_val1)) begin // sending1 "data bits" 
          cur_frame1.payload1[num_of_bits_rcvd1-1] = serial_b1;
          payload_byte1 = cur_frame1.payload1[num_of_bits_rcvd1-1];
          `uvm_info(get_type_name(), $psprintf("Received1 a Frame1 data bit:'b%0b", payload_byte1), UVM_HIGH)
        end
        msb_lsb_data1[0] =  cur_frame1.payload1[0] ;
        msb_lsb_data1[1] =  cur_frame1.payload1[cfg.char_len_val1-1] ;
        if ((num_of_bits_rcvd1 == (1 + cfg.char_len_val1)) && (cfg.parity_en1)) begin // sending1 "parity1 bit" if parity1 is enabled
          cur_frame1.parity1 = serial_b1;
          `uvm_info(get_type_name(), $psprintf("Received1 Parity1 bit:'b%0b", cur_frame1.parity1), UVM_HIGH)
          if (serial_b1 == cur_frame1.calc_parity1(cfg.char_len_val1, cfg.parity_mode1))
            `uvm_info(get_type_name(), "Received1 Parity1 is same as calculated1 Parity1", UVM_MEDIUM)
          else if (checks_enable1)
            `uvm_error(get_type_name(), "####### FAIL1 :Received1 Parity1 doesn't match the calculated1 Parity1  ")
        end
        if (num_of_bits_rcvd1 == (1 + cfg.char_len_val1 + cfg.parity_en1)) begin // sending1 "stop/error bits"
          for (int i = 0; i < cfg.nbstop1; i++) begin
            wait (sample_clk1);
            cur_frame1.stop_bits1[i] = serial_b1;
            `uvm_info(get_type_name(), $psprintf("Received1 a Stop bit: 'b%0b", cur_frame1.stop_bits1[i]), UVM_HIGH)
            num_of_bits_rcvd1++;
            wait (!sample_clk1);
          end
        end
        wait (!sample_clk1);
      end
    end
 num_frames1++; 
 `uvm_info(get_type_name(), $psprintf("Collected1 the following1 Frame1 No:%0d\n%s", num_frames1, cur_frame1.sprint()), UVM_MEDIUM)

  if(coverage_enable1) perform_coverage1();
  frame_collected_port1.write(cur_frame1);
  this.end_tr(cur_frame1);
endtask : collect_frame1

function void uart_monitor1::perform_coverage1();
  uart_trans_frame_cg1.sample();
endfunction : perform_coverage1

`endif

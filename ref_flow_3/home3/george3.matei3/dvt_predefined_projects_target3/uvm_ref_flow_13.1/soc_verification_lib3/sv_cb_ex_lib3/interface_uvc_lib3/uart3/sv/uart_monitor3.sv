/*-------------------------------------------------------------------------
File3 name   : uart_monitor3.sv
Title3       : monitor3 file for uart3 uvc3
Project3     :
Created3     :
Description3 : Descirbes3 UART3 Monitor3. Rx3/Tx3 monitors3 should be derived3 form3
            : this uart_monitor3 base class
Notes3       :  
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH3
`define UART_MONITOR_SVH3

virtual class uart_monitor3 extends uvm_monitor;
   uvm_analysis_port #(uart_frame3) frame_collected_port3;

  // virtual interface 
  virtual interface uart_if3 vif3;

  // Handle3 to  a cfg class
  uart_config3 cfg; 

  int num_frames3;
  bit sample_clk3;
  bit baud_clk3;
  bit [15:0] ua_brgr3;
  bit [7:0] ua_bdiv3;
  int num_of_bits_rcvd3;
  int transmit_delay3;
  bit sop_detected3;
  bit tmp_bit03;
  bit serial_d13;
  bit serial_bit3;
  bit serial_b3;
  bit [1:0]  msb_lsb_data3;

  bit checks_enable3 = 1;   // enable protocol3 checking
  bit coverage_enable3 = 1; // control3 coverage3 in the monitor3
  uart_frame3 cur_frame3;

  `uvm_field_utils_begin(uart_monitor3)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable3, UVM_DEFAULT)
      `uvm_field_int(coverage_enable3, UVM_DEFAULT)
      `uvm_field_object(cur_frame3, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg3;
    NUM_STOP_BITS3 : coverpoint cfg.nbstop3 {
      bins ONE3 = {0};
      bins TWO3 = {1};
    }
    DATA_LENGTH3 : coverpoint cfg.char_length3 {
      bins EIGHT3 = {0,1};
      bins SEVEN3 = {2};
      bins SIX3 = {3};
    }
    PARITY_MODE3 : coverpoint cfg.parity_mode3 {
      bins EVEN3  = {0};
      bins ODD3   = {1};
      bins SPACE3 = {2};
      bins MARK3  = {3};
    }
    PARITY_ERROR3: coverpoint cur_frame3.error_bits3[1]
      {
        bins good3 = { 0 };
        bins bad3 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE3: cross DATA_LENGTH3, PARITY_MODE3;
    PARITY_ERROR_x_PARITY_MODE3: cross PARITY_ERROR3, PARITY_MODE3;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg3 = new();
    uart_trans_frame_cg3.set_inst_name ("uart_trans_frame_cg3");
    frame_collected_port3 = new("frame_collected_port3", this);
  endfunction: new

  // Additional3 class methods3;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate3(ref bit [15:0] ua_brgr3, ref bit sample_clk3, ref bit sop_detected3);
  extern virtual task start_synchronizer3(ref bit serial_d13, ref bit serial_b3);
  extern virtual protected function void perform_coverage3();
  extern virtual task collect_frame3();
  extern virtual task wait_for_sop3(ref bit sop_detected3);
  extern virtual task sample_and_store3();
endclass: uart_monitor3

// UVM build_phase
function void uart_monitor3::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config3)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG3", "uart_config3 not set for this somponent3")
endfunction : build_phase

function void uart_monitor3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if3)::get(this, "","vif3",vif3))
      `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".vif3"})
endfunction : connect_phase

task uart_monitor3::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start3 Running3", UVM_LOW)
  @(negedge vif3.reset); 
  wait (vif3.reset);
  `uvm_info(get_type_name(), "Detected3 Reset3 Done3", UVM_LOW)
  num_frames3 = 0;
  cur_frame3 = uart_frame3::type_id::create("cur_frame3", this);

  fork
    gen_sample_rate3(ua_brgr3, sample_clk3, sop_detected3);
    start_synchronizer3(serial_d13, serial_b3);
    sample_and_store3();
  join
endtask : run_phase

task uart_monitor3::gen_sample_rate3(ref bit [15:0] ua_brgr3, ref bit sample_clk3, ref bit sop_detected3);
    forever begin
      @(posedge vif3.clock3);
      if ((!vif3.reset) || (sop_detected3)) begin
        `uvm_info(get_type_name(), "sample_clk3- resetting3 ua_brgr3", UVM_HIGH)
        ua_brgr3 = 0;
        sample_clk3 = 0;
        sop_detected3 = 0;
      end else begin
        if ( ua_brgr3 == ({cfg.baud_rate_div3, cfg.baud_rate_gen3})) begin
          ua_brgr3 = 0;
          sample_clk3 = 1;
        end else begin
          sample_clk3 = 0;
          ua_brgr3++;
        end
      end
    end
endtask

task uart_monitor3::start_synchronizer3(ref bit serial_d13, ref bit serial_b3);
endtask

task uart_monitor3::sample_and_store3();
  forever begin
    wait_for_sop3(sop_detected3);
    collect_frame3();
  end
endtask : sample_and_store3

task uart_monitor3::wait_for_sop3(ref bit sop_detected3);
    transmit_delay3 = 0;
    sop_detected3 = 0;
    while (!sop_detected3) begin
      `uvm_info(get_type_name(), "trying3 to detect3 SOP3", UVM_MEDIUM)
      while (!(serial_d13 == 1 && serial_b3 == 0)) begin
        @(negedge vif3.clock3);
        transmit_delay3++;
      end
      if (serial_b3 != 0)
        `uvm_info(get_type_name(), "Encountered3 a glitch3 in serial3 during SOP3, shall3 continue", UVM_LOW)
      else
      begin
        sop_detected3 = 1;
        `uvm_info(get_type_name(), "SOP3 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop3
  

task uart_monitor3::collect_frame3();
  bit [7:0] payload_byte3;
  cur_frame3 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting3 a frame3: %0d", num_frames3+1), UVM_HIGH)
   // Begin3 Transaction3 Recording3
  void'(this.begin_tr(cur_frame3, "UART3 Monitor3", , get_full_name()));
  cur_frame3.transmit_delay3 = transmit_delay3;
  cur_frame3.start_bit3 = 1'b0;
  cur_frame3.parity_type3 = GOOD_PARITY3;
  num_of_bits_rcvd3 = 0;

    while (num_of_bits_rcvd3 < (1 + cfg.char_len_val3 + cfg.parity_en3 + cfg.nbstop3))
    begin
      @(posedge vif3.clock3);
      #1;
      if (sample_clk3) begin
        num_of_bits_rcvd3++;
        if ((num_of_bits_rcvd3 > 0) && (num_of_bits_rcvd3 <= cfg.char_len_val3)) begin // sending3 "data bits" 
          cur_frame3.payload3[num_of_bits_rcvd3-1] = serial_b3;
          payload_byte3 = cur_frame3.payload3[num_of_bits_rcvd3-1];
          `uvm_info(get_type_name(), $psprintf("Received3 a Frame3 data bit:'b%0b", payload_byte3), UVM_HIGH)
        end
        msb_lsb_data3[0] =  cur_frame3.payload3[0] ;
        msb_lsb_data3[1] =  cur_frame3.payload3[cfg.char_len_val3-1] ;
        if ((num_of_bits_rcvd3 == (1 + cfg.char_len_val3)) && (cfg.parity_en3)) begin // sending3 "parity3 bit" if parity3 is enabled
          cur_frame3.parity3 = serial_b3;
          `uvm_info(get_type_name(), $psprintf("Received3 Parity3 bit:'b%0b", cur_frame3.parity3), UVM_HIGH)
          if (serial_b3 == cur_frame3.calc_parity3(cfg.char_len_val3, cfg.parity_mode3))
            `uvm_info(get_type_name(), "Received3 Parity3 is same as calculated3 Parity3", UVM_MEDIUM)
          else if (checks_enable3)
            `uvm_error(get_type_name(), "####### FAIL3 :Received3 Parity3 doesn't match the calculated3 Parity3  ")
        end
        if (num_of_bits_rcvd3 == (1 + cfg.char_len_val3 + cfg.parity_en3)) begin // sending3 "stop/error bits"
          for (int i = 0; i < cfg.nbstop3; i++) begin
            wait (sample_clk3);
            cur_frame3.stop_bits3[i] = serial_b3;
            `uvm_info(get_type_name(), $psprintf("Received3 a Stop bit: 'b%0b", cur_frame3.stop_bits3[i]), UVM_HIGH)
            num_of_bits_rcvd3++;
            wait (!sample_clk3);
          end
        end
        wait (!sample_clk3);
      end
    end
 num_frames3++; 
 `uvm_info(get_type_name(), $psprintf("Collected3 the following3 Frame3 No:%0d\n%s", num_frames3, cur_frame3.sprint()), UVM_MEDIUM)

  if(coverage_enable3) perform_coverage3();
  frame_collected_port3.write(cur_frame3);
  this.end_tr(cur_frame3);
endtask : collect_frame3

function void uart_monitor3::perform_coverage3();
  uart_trans_frame_cg3.sample();
endfunction : perform_coverage3

`endif

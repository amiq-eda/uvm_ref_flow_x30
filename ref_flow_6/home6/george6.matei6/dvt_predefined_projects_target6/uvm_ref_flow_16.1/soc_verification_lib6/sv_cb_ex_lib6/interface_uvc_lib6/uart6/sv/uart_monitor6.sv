/*-------------------------------------------------------------------------
File6 name   : uart_monitor6.sv
Title6       : monitor6 file for uart6 uvc6
Project6     :
Created6     :
Description6 : Descirbes6 UART6 Monitor6. Rx6/Tx6 monitors6 should be derived6 form6
            : this uart_monitor6 base class
Notes6       :  
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH6
`define UART_MONITOR_SVH6

virtual class uart_monitor6 extends uvm_monitor;
   uvm_analysis_port #(uart_frame6) frame_collected_port6;

  // virtual interface 
  virtual interface uart_if6 vif6;

  // Handle6 to  a cfg class
  uart_config6 cfg; 

  int num_frames6;
  bit sample_clk6;
  bit baud_clk6;
  bit [15:0] ua_brgr6;
  bit [7:0] ua_bdiv6;
  int num_of_bits_rcvd6;
  int transmit_delay6;
  bit sop_detected6;
  bit tmp_bit06;
  bit serial_d16;
  bit serial_bit6;
  bit serial_b6;
  bit [1:0]  msb_lsb_data6;

  bit checks_enable6 = 1;   // enable protocol6 checking
  bit coverage_enable6 = 1; // control6 coverage6 in the monitor6
  uart_frame6 cur_frame6;

  `uvm_field_utils_begin(uart_monitor6)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable6, UVM_DEFAULT)
      `uvm_field_int(coverage_enable6, UVM_DEFAULT)
      `uvm_field_object(cur_frame6, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg6;
    NUM_STOP_BITS6 : coverpoint cfg.nbstop6 {
      bins ONE6 = {0};
      bins TWO6 = {1};
    }
    DATA_LENGTH6 : coverpoint cfg.char_length6 {
      bins EIGHT6 = {0,1};
      bins SEVEN6 = {2};
      bins SIX6 = {3};
    }
    PARITY_MODE6 : coverpoint cfg.parity_mode6 {
      bins EVEN6  = {0};
      bins ODD6   = {1};
      bins SPACE6 = {2};
      bins MARK6  = {3};
    }
    PARITY_ERROR6: coverpoint cur_frame6.error_bits6[1]
      {
        bins good6 = { 0 };
        bins bad6 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE6: cross DATA_LENGTH6, PARITY_MODE6;
    PARITY_ERROR_x_PARITY_MODE6: cross PARITY_ERROR6, PARITY_MODE6;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg6 = new();
    uart_trans_frame_cg6.set_inst_name ("uart_trans_frame_cg6");
    frame_collected_port6 = new("frame_collected_port6", this);
  endfunction: new

  // Additional6 class methods6;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate6(ref bit [15:0] ua_brgr6, ref bit sample_clk6, ref bit sop_detected6);
  extern virtual task start_synchronizer6(ref bit serial_d16, ref bit serial_b6);
  extern virtual protected function void perform_coverage6();
  extern virtual task collect_frame6();
  extern virtual task wait_for_sop6(ref bit sop_detected6);
  extern virtual task sample_and_store6();
endclass: uart_monitor6

// UVM build_phase
function void uart_monitor6::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config6)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG6", "uart_config6 not set for this somponent6")
endfunction : build_phase

function void uart_monitor6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if6)::get(this, "","vif6",vif6))
      `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".vif6"})
endfunction : connect_phase

task uart_monitor6::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start6 Running6", UVM_LOW)
  @(negedge vif6.reset); 
  wait (vif6.reset);
  `uvm_info(get_type_name(), "Detected6 Reset6 Done6", UVM_LOW)
  num_frames6 = 0;
  cur_frame6 = uart_frame6::type_id::create("cur_frame6", this);

  fork
    gen_sample_rate6(ua_brgr6, sample_clk6, sop_detected6);
    start_synchronizer6(serial_d16, serial_b6);
    sample_and_store6();
  join
endtask : run_phase

task uart_monitor6::gen_sample_rate6(ref bit [15:0] ua_brgr6, ref bit sample_clk6, ref bit sop_detected6);
    forever begin
      @(posedge vif6.clock6);
      if ((!vif6.reset) || (sop_detected6)) begin
        `uvm_info(get_type_name(), "sample_clk6- resetting6 ua_brgr6", UVM_HIGH)
        ua_brgr6 = 0;
        sample_clk6 = 0;
        sop_detected6 = 0;
      end else begin
        if ( ua_brgr6 == ({cfg.baud_rate_div6, cfg.baud_rate_gen6})) begin
          ua_brgr6 = 0;
          sample_clk6 = 1;
        end else begin
          sample_clk6 = 0;
          ua_brgr6++;
        end
      end
    end
endtask

task uart_monitor6::start_synchronizer6(ref bit serial_d16, ref bit serial_b6);
endtask

task uart_monitor6::sample_and_store6();
  forever begin
    wait_for_sop6(sop_detected6);
    collect_frame6();
  end
endtask : sample_and_store6

task uart_monitor6::wait_for_sop6(ref bit sop_detected6);
    transmit_delay6 = 0;
    sop_detected6 = 0;
    while (!sop_detected6) begin
      `uvm_info(get_type_name(), "trying6 to detect6 SOP6", UVM_MEDIUM)
      while (!(serial_d16 == 1 && serial_b6 == 0)) begin
        @(negedge vif6.clock6);
        transmit_delay6++;
      end
      if (serial_b6 != 0)
        `uvm_info(get_type_name(), "Encountered6 a glitch6 in serial6 during SOP6, shall6 continue", UVM_LOW)
      else
      begin
        sop_detected6 = 1;
        `uvm_info(get_type_name(), "SOP6 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop6
  

task uart_monitor6::collect_frame6();
  bit [7:0] payload_byte6;
  cur_frame6 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting6 a frame6: %0d", num_frames6+1), UVM_HIGH)
   // Begin6 Transaction6 Recording6
  void'(this.begin_tr(cur_frame6, "UART6 Monitor6", , get_full_name()));
  cur_frame6.transmit_delay6 = transmit_delay6;
  cur_frame6.start_bit6 = 1'b0;
  cur_frame6.parity_type6 = GOOD_PARITY6;
  num_of_bits_rcvd6 = 0;

    while (num_of_bits_rcvd6 < (1 + cfg.char_len_val6 + cfg.parity_en6 + cfg.nbstop6))
    begin
      @(posedge vif6.clock6);
      #1;
      if (sample_clk6) begin
        num_of_bits_rcvd6++;
        if ((num_of_bits_rcvd6 > 0) && (num_of_bits_rcvd6 <= cfg.char_len_val6)) begin // sending6 "data bits" 
          cur_frame6.payload6[num_of_bits_rcvd6-1] = serial_b6;
          payload_byte6 = cur_frame6.payload6[num_of_bits_rcvd6-1];
          `uvm_info(get_type_name(), $psprintf("Received6 a Frame6 data bit:'b%0b", payload_byte6), UVM_HIGH)
        end
        msb_lsb_data6[0] =  cur_frame6.payload6[0] ;
        msb_lsb_data6[1] =  cur_frame6.payload6[cfg.char_len_val6-1] ;
        if ((num_of_bits_rcvd6 == (1 + cfg.char_len_val6)) && (cfg.parity_en6)) begin // sending6 "parity6 bit" if parity6 is enabled
          cur_frame6.parity6 = serial_b6;
          `uvm_info(get_type_name(), $psprintf("Received6 Parity6 bit:'b%0b", cur_frame6.parity6), UVM_HIGH)
          if (serial_b6 == cur_frame6.calc_parity6(cfg.char_len_val6, cfg.parity_mode6))
            `uvm_info(get_type_name(), "Received6 Parity6 is same as calculated6 Parity6", UVM_MEDIUM)
          else if (checks_enable6)
            `uvm_error(get_type_name(), "####### FAIL6 :Received6 Parity6 doesn't match the calculated6 Parity6  ")
        end
        if (num_of_bits_rcvd6 == (1 + cfg.char_len_val6 + cfg.parity_en6)) begin // sending6 "stop/error bits"
          for (int i = 0; i < cfg.nbstop6; i++) begin
            wait (sample_clk6);
            cur_frame6.stop_bits6[i] = serial_b6;
            `uvm_info(get_type_name(), $psprintf("Received6 a Stop bit: 'b%0b", cur_frame6.stop_bits6[i]), UVM_HIGH)
            num_of_bits_rcvd6++;
            wait (!sample_clk6);
          end
        end
        wait (!sample_clk6);
      end
    end
 num_frames6++; 
 `uvm_info(get_type_name(), $psprintf("Collected6 the following6 Frame6 No:%0d\n%s", num_frames6, cur_frame6.sprint()), UVM_MEDIUM)

  if(coverage_enable6) perform_coverage6();
  frame_collected_port6.write(cur_frame6);
  this.end_tr(cur_frame6);
endtask : collect_frame6

function void uart_monitor6::perform_coverage6();
  uart_trans_frame_cg6.sample();
endfunction : perform_coverage6

`endif

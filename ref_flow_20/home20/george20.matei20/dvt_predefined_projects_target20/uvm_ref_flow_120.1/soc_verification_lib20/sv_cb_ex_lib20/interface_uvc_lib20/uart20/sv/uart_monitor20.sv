/*-------------------------------------------------------------------------
File20 name   : uart_monitor20.sv
Title20       : monitor20 file for uart20 uvc20
Project20     :
Created20     :
Description20 : Descirbes20 UART20 Monitor20. Rx20/Tx20 monitors20 should be derived20 form20
            : this uart_monitor20 base class
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH20
`define UART_MONITOR_SVH20

virtual class uart_monitor20 extends uvm_monitor;
   uvm_analysis_port #(uart_frame20) frame_collected_port20;

  // virtual interface 
  virtual interface uart_if20 vif20;

  // Handle20 to  a cfg class
  uart_config20 cfg; 

  int num_frames20;
  bit sample_clk20;
  bit baud_clk20;
  bit [15:0] ua_brgr20;
  bit [7:0] ua_bdiv20;
  int num_of_bits_rcvd20;
  int transmit_delay20;
  bit sop_detected20;
  bit tmp_bit020;
  bit serial_d120;
  bit serial_bit20;
  bit serial_b20;
  bit [1:0]  msb_lsb_data20;

  bit checks_enable20 = 1;   // enable protocol20 checking
  bit coverage_enable20 = 1; // control20 coverage20 in the monitor20
  uart_frame20 cur_frame20;

  `uvm_field_utils_begin(uart_monitor20)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable20, UVM_DEFAULT)
      `uvm_field_int(coverage_enable20, UVM_DEFAULT)
      `uvm_field_object(cur_frame20, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg20;
    NUM_STOP_BITS20 : coverpoint cfg.nbstop20 {
      bins ONE20 = {0};
      bins TWO20 = {1};
    }
    DATA_LENGTH20 : coverpoint cfg.char_length20 {
      bins EIGHT20 = {0,1};
      bins SEVEN20 = {2};
      bins SIX20 = {3};
    }
    PARITY_MODE20 : coverpoint cfg.parity_mode20 {
      bins EVEN20  = {0};
      bins ODD20   = {1};
      bins SPACE20 = {2};
      bins MARK20  = {3};
    }
    PARITY_ERROR20: coverpoint cur_frame20.error_bits20[1]
      {
        bins good20 = { 0 };
        bins bad20 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE20: cross DATA_LENGTH20, PARITY_MODE20;
    PARITY_ERROR_x_PARITY_MODE20: cross PARITY_ERROR20, PARITY_MODE20;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg20 = new();
    uart_trans_frame_cg20.set_inst_name ("uart_trans_frame_cg20");
    frame_collected_port20 = new("frame_collected_port20", this);
  endfunction: new

  // Additional20 class methods20;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate20(ref bit [15:0] ua_brgr20, ref bit sample_clk20, ref bit sop_detected20);
  extern virtual task start_synchronizer20(ref bit serial_d120, ref bit serial_b20);
  extern virtual protected function void perform_coverage20();
  extern virtual task collect_frame20();
  extern virtual task wait_for_sop20(ref bit sop_detected20);
  extern virtual task sample_and_store20();
endclass: uart_monitor20

// UVM build_phase
function void uart_monitor20::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config20)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG20", "uart_config20 not set for this somponent20")
endfunction : build_phase

function void uart_monitor20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if20)::get(this, "","vif20",vif20))
      `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
endfunction : connect_phase

task uart_monitor20::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start20 Running20", UVM_LOW)
  @(negedge vif20.reset); 
  wait (vif20.reset);
  `uvm_info(get_type_name(), "Detected20 Reset20 Done20", UVM_LOW)
  num_frames20 = 0;
  cur_frame20 = uart_frame20::type_id::create("cur_frame20", this);

  fork
    gen_sample_rate20(ua_brgr20, sample_clk20, sop_detected20);
    start_synchronizer20(serial_d120, serial_b20);
    sample_and_store20();
  join
endtask : run_phase

task uart_monitor20::gen_sample_rate20(ref bit [15:0] ua_brgr20, ref bit sample_clk20, ref bit sop_detected20);
    forever begin
      @(posedge vif20.clock20);
      if ((!vif20.reset) || (sop_detected20)) begin
        `uvm_info(get_type_name(), "sample_clk20- resetting20 ua_brgr20", UVM_HIGH)
        ua_brgr20 = 0;
        sample_clk20 = 0;
        sop_detected20 = 0;
      end else begin
        if ( ua_brgr20 == ({cfg.baud_rate_div20, cfg.baud_rate_gen20})) begin
          ua_brgr20 = 0;
          sample_clk20 = 1;
        end else begin
          sample_clk20 = 0;
          ua_brgr20++;
        end
      end
    end
endtask

task uart_monitor20::start_synchronizer20(ref bit serial_d120, ref bit serial_b20);
endtask

task uart_monitor20::sample_and_store20();
  forever begin
    wait_for_sop20(sop_detected20);
    collect_frame20();
  end
endtask : sample_and_store20

task uart_monitor20::wait_for_sop20(ref bit sop_detected20);
    transmit_delay20 = 0;
    sop_detected20 = 0;
    while (!sop_detected20) begin
      `uvm_info(get_type_name(), "trying20 to detect20 SOP20", UVM_MEDIUM)
      while (!(serial_d120 == 1 && serial_b20 == 0)) begin
        @(negedge vif20.clock20);
        transmit_delay20++;
      end
      if (serial_b20 != 0)
        `uvm_info(get_type_name(), "Encountered20 a glitch20 in serial20 during SOP20, shall20 continue", UVM_LOW)
      else
      begin
        sop_detected20 = 1;
        `uvm_info(get_type_name(), "SOP20 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop20
  

task uart_monitor20::collect_frame20();
  bit [7:0] payload_byte20;
  cur_frame20 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting20 a frame20: %0d", num_frames20+1), UVM_HIGH)
   // Begin20 Transaction20 Recording20
  void'(this.begin_tr(cur_frame20, "UART20 Monitor20", , get_full_name()));
  cur_frame20.transmit_delay20 = transmit_delay20;
  cur_frame20.start_bit20 = 1'b0;
  cur_frame20.parity_type20 = GOOD_PARITY20;
  num_of_bits_rcvd20 = 0;

    while (num_of_bits_rcvd20 < (1 + cfg.char_len_val20 + cfg.parity_en20 + cfg.nbstop20))
    begin
      @(posedge vif20.clock20);
      #1;
      if (sample_clk20) begin
        num_of_bits_rcvd20++;
        if ((num_of_bits_rcvd20 > 0) && (num_of_bits_rcvd20 <= cfg.char_len_val20)) begin // sending20 "data bits" 
          cur_frame20.payload20[num_of_bits_rcvd20-1] = serial_b20;
          payload_byte20 = cur_frame20.payload20[num_of_bits_rcvd20-1];
          `uvm_info(get_type_name(), $psprintf("Received20 a Frame20 data bit:'b%0b", payload_byte20), UVM_HIGH)
        end
        msb_lsb_data20[0] =  cur_frame20.payload20[0] ;
        msb_lsb_data20[1] =  cur_frame20.payload20[cfg.char_len_val20-1] ;
        if ((num_of_bits_rcvd20 == (1 + cfg.char_len_val20)) && (cfg.parity_en20)) begin // sending20 "parity20 bit" if parity20 is enabled
          cur_frame20.parity20 = serial_b20;
          `uvm_info(get_type_name(), $psprintf("Received20 Parity20 bit:'b%0b", cur_frame20.parity20), UVM_HIGH)
          if (serial_b20 == cur_frame20.calc_parity20(cfg.char_len_val20, cfg.parity_mode20))
            `uvm_info(get_type_name(), "Received20 Parity20 is same as calculated20 Parity20", UVM_MEDIUM)
          else if (checks_enable20)
            `uvm_error(get_type_name(), "####### FAIL20 :Received20 Parity20 doesn't match the calculated20 Parity20  ")
        end
        if (num_of_bits_rcvd20 == (1 + cfg.char_len_val20 + cfg.parity_en20)) begin // sending20 "stop/error bits"
          for (int i = 0; i < cfg.nbstop20; i++) begin
            wait (sample_clk20);
            cur_frame20.stop_bits20[i] = serial_b20;
            `uvm_info(get_type_name(), $psprintf("Received20 a Stop bit: 'b%0b", cur_frame20.stop_bits20[i]), UVM_HIGH)
            num_of_bits_rcvd20++;
            wait (!sample_clk20);
          end
        end
        wait (!sample_clk20);
      end
    end
 num_frames20++; 
 `uvm_info(get_type_name(), $psprintf("Collected20 the following20 Frame20 No:%0d\n%s", num_frames20, cur_frame20.sprint()), UVM_MEDIUM)

  if(coverage_enable20) perform_coverage20();
  frame_collected_port20.write(cur_frame20);
  this.end_tr(cur_frame20);
endtask : collect_frame20

function void uart_monitor20::perform_coverage20();
  uart_trans_frame_cg20.sample();
endfunction : perform_coverage20

`endif

/*-------------------------------------------------------------------------
File7 name   : uart_monitor7.sv
Title7       : monitor7 file for uart7 uvc7
Project7     :
Created7     :
Description7 : Descirbes7 UART7 Monitor7. Rx7/Tx7 monitors7 should be derived7 form7
            : this uart_monitor7 base class
Notes7       :  
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH7
`define UART_MONITOR_SVH7

virtual class uart_monitor7 extends uvm_monitor;
   uvm_analysis_port #(uart_frame7) frame_collected_port7;

  // virtual interface 
  virtual interface uart_if7 vif7;

  // Handle7 to  a cfg class
  uart_config7 cfg; 

  int num_frames7;
  bit sample_clk7;
  bit baud_clk7;
  bit [15:0] ua_brgr7;
  bit [7:0] ua_bdiv7;
  int num_of_bits_rcvd7;
  int transmit_delay7;
  bit sop_detected7;
  bit tmp_bit07;
  bit serial_d17;
  bit serial_bit7;
  bit serial_b7;
  bit [1:0]  msb_lsb_data7;

  bit checks_enable7 = 1;   // enable protocol7 checking
  bit coverage_enable7 = 1; // control7 coverage7 in the monitor7
  uart_frame7 cur_frame7;

  `uvm_field_utils_begin(uart_monitor7)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable7, UVM_DEFAULT)
      `uvm_field_int(coverage_enable7, UVM_DEFAULT)
      `uvm_field_object(cur_frame7, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg7;
    NUM_STOP_BITS7 : coverpoint cfg.nbstop7 {
      bins ONE7 = {0};
      bins TWO7 = {1};
    }
    DATA_LENGTH7 : coverpoint cfg.char_length7 {
      bins EIGHT7 = {0,1};
      bins SEVEN7 = {2};
      bins SIX7 = {3};
    }
    PARITY_MODE7 : coverpoint cfg.parity_mode7 {
      bins EVEN7  = {0};
      bins ODD7   = {1};
      bins SPACE7 = {2};
      bins MARK7  = {3};
    }
    PARITY_ERROR7: coverpoint cur_frame7.error_bits7[1]
      {
        bins good7 = { 0 };
        bins bad7 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE7: cross DATA_LENGTH7, PARITY_MODE7;
    PARITY_ERROR_x_PARITY_MODE7: cross PARITY_ERROR7, PARITY_MODE7;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg7 = new();
    uart_trans_frame_cg7.set_inst_name ("uart_trans_frame_cg7");
    frame_collected_port7 = new("frame_collected_port7", this);
  endfunction: new

  // Additional7 class methods7;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate7(ref bit [15:0] ua_brgr7, ref bit sample_clk7, ref bit sop_detected7);
  extern virtual task start_synchronizer7(ref bit serial_d17, ref bit serial_b7);
  extern virtual protected function void perform_coverage7();
  extern virtual task collect_frame7();
  extern virtual task wait_for_sop7(ref bit sop_detected7);
  extern virtual task sample_and_store7();
endclass: uart_monitor7

// UVM build_phase
function void uart_monitor7::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config7)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG7", "uart_config7 not set for this somponent7")
endfunction : build_phase

function void uart_monitor7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if7)::get(this, "","vif7",vif7))
      `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".vif7"})
endfunction : connect_phase

task uart_monitor7::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start7 Running7", UVM_LOW)
  @(negedge vif7.reset); 
  wait (vif7.reset);
  `uvm_info(get_type_name(), "Detected7 Reset7 Done7", UVM_LOW)
  num_frames7 = 0;
  cur_frame7 = uart_frame7::type_id::create("cur_frame7", this);

  fork
    gen_sample_rate7(ua_brgr7, sample_clk7, sop_detected7);
    start_synchronizer7(serial_d17, serial_b7);
    sample_and_store7();
  join
endtask : run_phase

task uart_monitor7::gen_sample_rate7(ref bit [15:0] ua_brgr7, ref bit sample_clk7, ref bit sop_detected7);
    forever begin
      @(posedge vif7.clock7);
      if ((!vif7.reset) || (sop_detected7)) begin
        `uvm_info(get_type_name(), "sample_clk7- resetting7 ua_brgr7", UVM_HIGH)
        ua_brgr7 = 0;
        sample_clk7 = 0;
        sop_detected7 = 0;
      end else begin
        if ( ua_brgr7 == ({cfg.baud_rate_div7, cfg.baud_rate_gen7})) begin
          ua_brgr7 = 0;
          sample_clk7 = 1;
        end else begin
          sample_clk7 = 0;
          ua_brgr7++;
        end
      end
    end
endtask

task uart_monitor7::start_synchronizer7(ref bit serial_d17, ref bit serial_b7);
endtask

task uart_monitor7::sample_and_store7();
  forever begin
    wait_for_sop7(sop_detected7);
    collect_frame7();
  end
endtask : sample_and_store7

task uart_monitor7::wait_for_sop7(ref bit sop_detected7);
    transmit_delay7 = 0;
    sop_detected7 = 0;
    while (!sop_detected7) begin
      `uvm_info(get_type_name(), "trying7 to detect7 SOP7", UVM_MEDIUM)
      while (!(serial_d17 == 1 && serial_b7 == 0)) begin
        @(negedge vif7.clock7);
        transmit_delay7++;
      end
      if (serial_b7 != 0)
        `uvm_info(get_type_name(), "Encountered7 a glitch7 in serial7 during SOP7, shall7 continue", UVM_LOW)
      else
      begin
        sop_detected7 = 1;
        `uvm_info(get_type_name(), "SOP7 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop7
  

task uart_monitor7::collect_frame7();
  bit [7:0] payload_byte7;
  cur_frame7 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting7 a frame7: %0d", num_frames7+1), UVM_HIGH)
   // Begin7 Transaction7 Recording7
  void'(this.begin_tr(cur_frame7, "UART7 Monitor7", , get_full_name()));
  cur_frame7.transmit_delay7 = transmit_delay7;
  cur_frame7.start_bit7 = 1'b0;
  cur_frame7.parity_type7 = GOOD_PARITY7;
  num_of_bits_rcvd7 = 0;

    while (num_of_bits_rcvd7 < (1 + cfg.char_len_val7 + cfg.parity_en7 + cfg.nbstop7))
    begin
      @(posedge vif7.clock7);
      #1;
      if (sample_clk7) begin
        num_of_bits_rcvd7++;
        if ((num_of_bits_rcvd7 > 0) && (num_of_bits_rcvd7 <= cfg.char_len_val7)) begin // sending7 "data bits" 
          cur_frame7.payload7[num_of_bits_rcvd7-1] = serial_b7;
          payload_byte7 = cur_frame7.payload7[num_of_bits_rcvd7-1];
          `uvm_info(get_type_name(), $psprintf("Received7 a Frame7 data bit:'b%0b", payload_byte7), UVM_HIGH)
        end
        msb_lsb_data7[0] =  cur_frame7.payload7[0] ;
        msb_lsb_data7[1] =  cur_frame7.payload7[cfg.char_len_val7-1] ;
        if ((num_of_bits_rcvd7 == (1 + cfg.char_len_val7)) && (cfg.parity_en7)) begin // sending7 "parity7 bit" if parity7 is enabled
          cur_frame7.parity7 = serial_b7;
          `uvm_info(get_type_name(), $psprintf("Received7 Parity7 bit:'b%0b", cur_frame7.parity7), UVM_HIGH)
          if (serial_b7 == cur_frame7.calc_parity7(cfg.char_len_val7, cfg.parity_mode7))
            `uvm_info(get_type_name(), "Received7 Parity7 is same as calculated7 Parity7", UVM_MEDIUM)
          else if (checks_enable7)
            `uvm_error(get_type_name(), "####### FAIL7 :Received7 Parity7 doesn't match the calculated7 Parity7  ")
        end
        if (num_of_bits_rcvd7 == (1 + cfg.char_len_val7 + cfg.parity_en7)) begin // sending7 "stop/error bits"
          for (int i = 0; i < cfg.nbstop7; i++) begin
            wait (sample_clk7);
            cur_frame7.stop_bits7[i] = serial_b7;
            `uvm_info(get_type_name(), $psprintf("Received7 a Stop bit: 'b%0b", cur_frame7.stop_bits7[i]), UVM_HIGH)
            num_of_bits_rcvd7++;
            wait (!sample_clk7);
          end
        end
        wait (!sample_clk7);
      end
    end
 num_frames7++; 
 `uvm_info(get_type_name(), $psprintf("Collected7 the following7 Frame7 No:%0d\n%s", num_frames7, cur_frame7.sprint()), UVM_MEDIUM)

  if(coverage_enable7) perform_coverage7();
  frame_collected_port7.write(cur_frame7);
  this.end_tr(cur_frame7);
endtask : collect_frame7

function void uart_monitor7::perform_coverage7();
  uart_trans_frame_cg7.sample();
endfunction : perform_coverage7

`endif

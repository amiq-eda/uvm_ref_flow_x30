/*-------------------------------------------------------------------------
File15 name   : uart_monitor15.sv
Title15       : monitor15 file for uart15 uvc15
Project15     :
Created15     :
Description15 : Descirbes15 UART15 Monitor15. Rx15/Tx15 monitors15 should be derived15 form15
            : this uart_monitor15 base class
Notes15       :  
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH15
`define UART_MONITOR_SVH15

virtual class uart_monitor15 extends uvm_monitor;
   uvm_analysis_port #(uart_frame15) frame_collected_port15;

  // virtual interface 
  virtual interface uart_if15 vif15;

  // Handle15 to  a cfg class
  uart_config15 cfg; 

  int num_frames15;
  bit sample_clk15;
  bit baud_clk15;
  bit [15:0] ua_brgr15;
  bit [7:0] ua_bdiv15;
  int num_of_bits_rcvd15;
  int transmit_delay15;
  bit sop_detected15;
  bit tmp_bit015;
  bit serial_d115;
  bit serial_bit15;
  bit serial_b15;
  bit [1:0]  msb_lsb_data15;

  bit checks_enable15 = 1;   // enable protocol15 checking
  bit coverage_enable15 = 1; // control15 coverage15 in the monitor15
  uart_frame15 cur_frame15;

  `uvm_field_utils_begin(uart_monitor15)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable15, UVM_DEFAULT)
      `uvm_field_int(coverage_enable15, UVM_DEFAULT)
      `uvm_field_object(cur_frame15, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg15;
    NUM_STOP_BITS15 : coverpoint cfg.nbstop15 {
      bins ONE15 = {0};
      bins TWO15 = {1};
    }
    DATA_LENGTH15 : coverpoint cfg.char_length15 {
      bins EIGHT15 = {0,1};
      bins SEVEN15 = {2};
      bins SIX15 = {3};
    }
    PARITY_MODE15 : coverpoint cfg.parity_mode15 {
      bins EVEN15  = {0};
      bins ODD15   = {1};
      bins SPACE15 = {2};
      bins MARK15  = {3};
    }
    PARITY_ERROR15: coverpoint cur_frame15.error_bits15[1]
      {
        bins good15 = { 0 };
        bins bad15 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE15: cross DATA_LENGTH15, PARITY_MODE15;
    PARITY_ERROR_x_PARITY_MODE15: cross PARITY_ERROR15, PARITY_MODE15;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg15 = new();
    uart_trans_frame_cg15.set_inst_name ("uart_trans_frame_cg15");
    frame_collected_port15 = new("frame_collected_port15", this);
  endfunction: new

  // Additional15 class methods15;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate15(ref bit [15:0] ua_brgr15, ref bit sample_clk15, ref bit sop_detected15);
  extern virtual task start_synchronizer15(ref bit serial_d115, ref bit serial_b15);
  extern virtual protected function void perform_coverage15();
  extern virtual task collect_frame15();
  extern virtual task wait_for_sop15(ref bit sop_detected15);
  extern virtual task sample_and_store15();
endclass: uart_monitor15

// UVM build_phase
function void uart_monitor15::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config15)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG15", "uart_config15 not set for this somponent15")
endfunction : build_phase

function void uart_monitor15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if15)::get(this, "","vif15",vif15))
      `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".vif15"})
endfunction : connect_phase

task uart_monitor15::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start15 Running15", UVM_LOW)
  @(negedge vif15.reset); 
  wait (vif15.reset);
  `uvm_info(get_type_name(), "Detected15 Reset15 Done15", UVM_LOW)
  num_frames15 = 0;
  cur_frame15 = uart_frame15::type_id::create("cur_frame15", this);

  fork
    gen_sample_rate15(ua_brgr15, sample_clk15, sop_detected15);
    start_synchronizer15(serial_d115, serial_b15);
    sample_and_store15();
  join
endtask : run_phase

task uart_monitor15::gen_sample_rate15(ref bit [15:0] ua_brgr15, ref bit sample_clk15, ref bit sop_detected15);
    forever begin
      @(posedge vif15.clock15);
      if ((!vif15.reset) || (sop_detected15)) begin
        `uvm_info(get_type_name(), "sample_clk15- resetting15 ua_brgr15", UVM_HIGH)
        ua_brgr15 = 0;
        sample_clk15 = 0;
        sop_detected15 = 0;
      end else begin
        if ( ua_brgr15 == ({cfg.baud_rate_div15, cfg.baud_rate_gen15})) begin
          ua_brgr15 = 0;
          sample_clk15 = 1;
        end else begin
          sample_clk15 = 0;
          ua_brgr15++;
        end
      end
    end
endtask

task uart_monitor15::start_synchronizer15(ref bit serial_d115, ref bit serial_b15);
endtask

task uart_monitor15::sample_and_store15();
  forever begin
    wait_for_sop15(sop_detected15);
    collect_frame15();
  end
endtask : sample_and_store15

task uart_monitor15::wait_for_sop15(ref bit sop_detected15);
    transmit_delay15 = 0;
    sop_detected15 = 0;
    while (!sop_detected15) begin
      `uvm_info(get_type_name(), "trying15 to detect15 SOP15", UVM_MEDIUM)
      while (!(serial_d115 == 1 && serial_b15 == 0)) begin
        @(negedge vif15.clock15);
        transmit_delay15++;
      end
      if (serial_b15 != 0)
        `uvm_info(get_type_name(), "Encountered15 a glitch15 in serial15 during SOP15, shall15 continue", UVM_LOW)
      else
      begin
        sop_detected15 = 1;
        `uvm_info(get_type_name(), "SOP15 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop15
  

task uart_monitor15::collect_frame15();
  bit [7:0] payload_byte15;
  cur_frame15 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting15 a frame15: %0d", num_frames15+1), UVM_HIGH)
   // Begin15 Transaction15 Recording15
  void'(this.begin_tr(cur_frame15, "UART15 Monitor15", , get_full_name()));
  cur_frame15.transmit_delay15 = transmit_delay15;
  cur_frame15.start_bit15 = 1'b0;
  cur_frame15.parity_type15 = GOOD_PARITY15;
  num_of_bits_rcvd15 = 0;

    while (num_of_bits_rcvd15 < (1 + cfg.char_len_val15 + cfg.parity_en15 + cfg.nbstop15))
    begin
      @(posedge vif15.clock15);
      #1;
      if (sample_clk15) begin
        num_of_bits_rcvd15++;
        if ((num_of_bits_rcvd15 > 0) && (num_of_bits_rcvd15 <= cfg.char_len_val15)) begin // sending15 "data bits" 
          cur_frame15.payload15[num_of_bits_rcvd15-1] = serial_b15;
          payload_byte15 = cur_frame15.payload15[num_of_bits_rcvd15-1];
          `uvm_info(get_type_name(), $psprintf("Received15 a Frame15 data bit:'b%0b", payload_byte15), UVM_HIGH)
        end
        msb_lsb_data15[0] =  cur_frame15.payload15[0] ;
        msb_lsb_data15[1] =  cur_frame15.payload15[cfg.char_len_val15-1] ;
        if ((num_of_bits_rcvd15 == (1 + cfg.char_len_val15)) && (cfg.parity_en15)) begin // sending15 "parity15 bit" if parity15 is enabled
          cur_frame15.parity15 = serial_b15;
          `uvm_info(get_type_name(), $psprintf("Received15 Parity15 bit:'b%0b", cur_frame15.parity15), UVM_HIGH)
          if (serial_b15 == cur_frame15.calc_parity15(cfg.char_len_val15, cfg.parity_mode15))
            `uvm_info(get_type_name(), "Received15 Parity15 is same as calculated15 Parity15", UVM_MEDIUM)
          else if (checks_enable15)
            `uvm_error(get_type_name(), "####### FAIL15 :Received15 Parity15 doesn't match the calculated15 Parity15  ")
        end
        if (num_of_bits_rcvd15 == (1 + cfg.char_len_val15 + cfg.parity_en15)) begin // sending15 "stop/error bits"
          for (int i = 0; i < cfg.nbstop15; i++) begin
            wait (sample_clk15);
            cur_frame15.stop_bits15[i] = serial_b15;
            `uvm_info(get_type_name(), $psprintf("Received15 a Stop bit: 'b%0b", cur_frame15.stop_bits15[i]), UVM_HIGH)
            num_of_bits_rcvd15++;
            wait (!sample_clk15);
          end
        end
        wait (!sample_clk15);
      end
    end
 num_frames15++; 
 `uvm_info(get_type_name(), $psprintf("Collected15 the following15 Frame15 No:%0d\n%s", num_frames15, cur_frame15.sprint()), UVM_MEDIUM)

  if(coverage_enable15) perform_coverage15();
  frame_collected_port15.write(cur_frame15);
  this.end_tr(cur_frame15);
endtask : collect_frame15

function void uart_monitor15::perform_coverage15();
  uart_trans_frame_cg15.sample();
endfunction : perform_coverage15

`endif

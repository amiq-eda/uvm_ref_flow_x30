/*-------------------------------------------------------------------------
File9 name   : uart_monitor9.sv
Title9       : monitor9 file for uart9 uvc9
Project9     :
Created9     :
Description9 : Descirbes9 UART9 Monitor9. Rx9/Tx9 monitors9 should be derived9 form9
            : this uart_monitor9 base class
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH9
`define UART_MONITOR_SVH9

virtual class uart_monitor9 extends uvm_monitor;
   uvm_analysis_port #(uart_frame9) frame_collected_port9;

  // virtual interface 
  virtual interface uart_if9 vif9;

  // Handle9 to  a cfg class
  uart_config9 cfg; 

  int num_frames9;
  bit sample_clk9;
  bit baud_clk9;
  bit [15:0] ua_brgr9;
  bit [7:0] ua_bdiv9;
  int num_of_bits_rcvd9;
  int transmit_delay9;
  bit sop_detected9;
  bit tmp_bit09;
  bit serial_d19;
  bit serial_bit9;
  bit serial_b9;
  bit [1:0]  msb_lsb_data9;

  bit checks_enable9 = 1;   // enable protocol9 checking
  bit coverage_enable9 = 1; // control9 coverage9 in the monitor9
  uart_frame9 cur_frame9;

  `uvm_field_utils_begin(uart_monitor9)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable9, UVM_DEFAULT)
      `uvm_field_int(coverage_enable9, UVM_DEFAULT)
      `uvm_field_object(cur_frame9, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg9;
    NUM_STOP_BITS9 : coverpoint cfg.nbstop9 {
      bins ONE9 = {0};
      bins TWO9 = {1};
    }
    DATA_LENGTH9 : coverpoint cfg.char_length9 {
      bins EIGHT9 = {0,1};
      bins SEVEN9 = {2};
      bins SIX9 = {3};
    }
    PARITY_MODE9 : coverpoint cfg.parity_mode9 {
      bins EVEN9  = {0};
      bins ODD9   = {1};
      bins SPACE9 = {2};
      bins MARK9  = {3};
    }
    PARITY_ERROR9: coverpoint cur_frame9.error_bits9[1]
      {
        bins good9 = { 0 };
        bins bad9 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE9: cross DATA_LENGTH9, PARITY_MODE9;
    PARITY_ERROR_x_PARITY_MODE9: cross PARITY_ERROR9, PARITY_MODE9;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg9 = new();
    uart_trans_frame_cg9.set_inst_name ("uart_trans_frame_cg9");
    frame_collected_port9 = new("frame_collected_port9", this);
  endfunction: new

  // Additional9 class methods9;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate9(ref bit [15:0] ua_brgr9, ref bit sample_clk9, ref bit sop_detected9);
  extern virtual task start_synchronizer9(ref bit serial_d19, ref bit serial_b9);
  extern virtual protected function void perform_coverage9();
  extern virtual task collect_frame9();
  extern virtual task wait_for_sop9(ref bit sop_detected9);
  extern virtual task sample_and_store9();
endclass: uart_monitor9

// UVM build_phase
function void uart_monitor9::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config9)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG9", "uart_config9 not set for this somponent9")
endfunction : build_phase

function void uart_monitor9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if9)::get(this, "","vif9",vif9))
      `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
endfunction : connect_phase

task uart_monitor9::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start9 Running9", UVM_LOW)
  @(negedge vif9.reset); 
  wait (vif9.reset);
  `uvm_info(get_type_name(), "Detected9 Reset9 Done9", UVM_LOW)
  num_frames9 = 0;
  cur_frame9 = uart_frame9::type_id::create("cur_frame9", this);

  fork
    gen_sample_rate9(ua_brgr9, sample_clk9, sop_detected9);
    start_synchronizer9(serial_d19, serial_b9);
    sample_and_store9();
  join
endtask : run_phase

task uart_monitor9::gen_sample_rate9(ref bit [15:0] ua_brgr9, ref bit sample_clk9, ref bit sop_detected9);
    forever begin
      @(posedge vif9.clock9);
      if ((!vif9.reset) || (sop_detected9)) begin
        `uvm_info(get_type_name(), "sample_clk9- resetting9 ua_brgr9", UVM_HIGH)
        ua_brgr9 = 0;
        sample_clk9 = 0;
        sop_detected9 = 0;
      end else begin
        if ( ua_brgr9 == ({cfg.baud_rate_div9, cfg.baud_rate_gen9})) begin
          ua_brgr9 = 0;
          sample_clk9 = 1;
        end else begin
          sample_clk9 = 0;
          ua_brgr9++;
        end
      end
    end
endtask

task uart_monitor9::start_synchronizer9(ref bit serial_d19, ref bit serial_b9);
endtask

task uart_monitor9::sample_and_store9();
  forever begin
    wait_for_sop9(sop_detected9);
    collect_frame9();
  end
endtask : sample_and_store9

task uart_monitor9::wait_for_sop9(ref bit sop_detected9);
    transmit_delay9 = 0;
    sop_detected9 = 0;
    while (!sop_detected9) begin
      `uvm_info(get_type_name(), "trying9 to detect9 SOP9", UVM_MEDIUM)
      while (!(serial_d19 == 1 && serial_b9 == 0)) begin
        @(negedge vif9.clock9);
        transmit_delay9++;
      end
      if (serial_b9 != 0)
        `uvm_info(get_type_name(), "Encountered9 a glitch9 in serial9 during SOP9, shall9 continue", UVM_LOW)
      else
      begin
        sop_detected9 = 1;
        `uvm_info(get_type_name(), "SOP9 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop9
  

task uart_monitor9::collect_frame9();
  bit [7:0] payload_byte9;
  cur_frame9 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting9 a frame9: %0d", num_frames9+1), UVM_HIGH)
   // Begin9 Transaction9 Recording9
  void'(this.begin_tr(cur_frame9, "UART9 Monitor9", , get_full_name()));
  cur_frame9.transmit_delay9 = transmit_delay9;
  cur_frame9.start_bit9 = 1'b0;
  cur_frame9.parity_type9 = GOOD_PARITY9;
  num_of_bits_rcvd9 = 0;

    while (num_of_bits_rcvd9 < (1 + cfg.char_len_val9 + cfg.parity_en9 + cfg.nbstop9))
    begin
      @(posedge vif9.clock9);
      #1;
      if (sample_clk9) begin
        num_of_bits_rcvd9++;
        if ((num_of_bits_rcvd9 > 0) && (num_of_bits_rcvd9 <= cfg.char_len_val9)) begin // sending9 "data bits" 
          cur_frame9.payload9[num_of_bits_rcvd9-1] = serial_b9;
          payload_byte9 = cur_frame9.payload9[num_of_bits_rcvd9-1];
          `uvm_info(get_type_name(), $psprintf("Received9 a Frame9 data bit:'b%0b", payload_byte9), UVM_HIGH)
        end
        msb_lsb_data9[0] =  cur_frame9.payload9[0] ;
        msb_lsb_data9[1] =  cur_frame9.payload9[cfg.char_len_val9-1] ;
        if ((num_of_bits_rcvd9 == (1 + cfg.char_len_val9)) && (cfg.parity_en9)) begin // sending9 "parity9 bit" if parity9 is enabled
          cur_frame9.parity9 = serial_b9;
          `uvm_info(get_type_name(), $psprintf("Received9 Parity9 bit:'b%0b", cur_frame9.parity9), UVM_HIGH)
          if (serial_b9 == cur_frame9.calc_parity9(cfg.char_len_val9, cfg.parity_mode9))
            `uvm_info(get_type_name(), "Received9 Parity9 is same as calculated9 Parity9", UVM_MEDIUM)
          else if (checks_enable9)
            `uvm_error(get_type_name(), "####### FAIL9 :Received9 Parity9 doesn't match the calculated9 Parity9  ")
        end
        if (num_of_bits_rcvd9 == (1 + cfg.char_len_val9 + cfg.parity_en9)) begin // sending9 "stop/error bits"
          for (int i = 0; i < cfg.nbstop9; i++) begin
            wait (sample_clk9);
            cur_frame9.stop_bits9[i] = serial_b9;
            `uvm_info(get_type_name(), $psprintf("Received9 a Stop bit: 'b%0b", cur_frame9.stop_bits9[i]), UVM_HIGH)
            num_of_bits_rcvd9++;
            wait (!sample_clk9);
          end
        end
        wait (!sample_clk9);
      end
    end
 num_frames9++; 
 `uvm_info(get_type_name(), $psprintf("Collected9 the following9 Frame9 No:%0d\n%s", num_frames9, cur_frame9.sprint()), UVM_MEDIUM)

  if(coverage_enable9) perform_coverage9();
  frame_collected_port9.write(cur_frame9);
  this.end_tr(cur_frame9);
endtask : collect_frame9

function void uart_monitor9::perform_coverage9();
  uart_trans_frame_cg9.sample();
endfunction : perform_coverage9

`endif

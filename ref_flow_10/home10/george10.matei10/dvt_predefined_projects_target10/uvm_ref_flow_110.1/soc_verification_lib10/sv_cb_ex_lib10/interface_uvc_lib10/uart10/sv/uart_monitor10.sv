/*-------------------------------------------------------------------------
File10 name   : uart_monitor10.sv
Title10       : monitor10 file for uart10 uvc10
Project10     :
Created10     :
Description10 : Descirbes10 UART10 Monitor10. Rx10/Tx10 monitors10 should be derived10 form10
            : this uart_monitor10 base class
Notes10       :  
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH10
`define UART_MONITOR_SVH10

virtual class uart_monitor10 extends uvm_monitor;
   uvm_analysis_port #(uart_frame10) frame_collected_port10;

  // virtual interface 
  virtual interface uart_if10 vif10;

  // Handle10 to  a cfg class
  uart_config10 cfg; 

  int num_frames10;
  bit sample_clk10;
  bit baud_clk10;
  bit [15:0] ua_brgr10;
  bit [7:0] ua_bdiv10;
  int num_of_bits_rcvd10;
  int transmit_delay10;
  bit sop_detected10;
  bit tmp_bit010;
  bit serial_d110;
  bit serial_bit10;
  bit serial_b10;
  bit [1:0]  msb_lsb_data10;

  bit checks_enable10 = 1;   // enable protocol10 checking
  bit coverage_enable10 = 1; // control10 coverage10 in the monitor10
  uart_frame10 cur_frame10;

  `uvm_field_utils_begin(uart_monitor10)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable10, UVM_DEFAULT)
      `uvm_field_int(coverage_enable10, UVM_DEFAULT)
      `uvm_field_object(cur_frame10, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg10;
    NUM_STOP_BITS10 : coverpoint cfg.nbstop10 {
      bins ONE10 = {0};
      bins TWO10 = {1};
    }
    DATA_LENGTH10 : coverpoint cfg.char_length10 {
      bins EIGHT10 = {0,1};
      bins SEVEN10 = {2};
      bins SIX10 = {3};
    }
    PARITY_MODE10 : coverpoint cfg.parity_mode10 {
      bins EVEN10  = {0};
      bins ODD10   = {1};
      bins SPACE10 = {2};
      bins MARK10  = {3};
    }
    PARITY_ERROR10: coverpoint cur_frame10.error_bits10[1]
      {
        bins good10 = { 0 };
        bins bad10 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE10: cross DATA_LENGTH10, PARITY_MODE10;
    PARITY_ERROR_x_PARITY_MODE10: cross PARITY_ERROR10, PARITY_MODE10;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg10 = new();
    uart_trans_frame_cg10.set_inst_name ("uart_trans_frame_cg10");
    frame_collected_port10 = new("frame_collected_port10", this);
  endfunction: new

  // Additional10 class methods10;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate10(ref bit [15:0] ua_brgr10, ref bit sample_clk10, ref bit sop_detected10);
  extern virtual task start_synchronizer10(ref bit serial_d110, ref bit serial_b10);
  extern virtual protected function void perform_coverage10();
  extern virtual task collect_frame10();
  extern virtual task wait_for_sop10(ref bit sop_detected10);
  extern virtual task sample_and_store10();
endclass: uart_monitor10

// UVM build_phase
function void uart_monitor10::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config10)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG10", "uart_config10 not set for this somponent10")
endfunction : build_phase

function void uart_monitor10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if10)::get(this, "","vif10",vif10))
      `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".vif10"})
endfunction : connect_phase

task uart_monitor10::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start10 Running10", UVM_LOW)
  @(negedge vif10.reset); 
  wait (vif10.reset);
  `uvm_info(get_type_name(), "Detected10 Reset10 Done10", UVM_LOW)
  num_frames10 = 0;
  cur_frame10 = uart_frame10::type_id::create("cur_frame10", this);

  fork
    gen_sample_rate10(ua_brgr10, sample_clk10, sop_detected10);
    start_synchronizer10(serial_d110, serial_b10);
    sample_and_store10();
  join
endtask : run_phase

task uart_monitor10::gen_sample_rate10(ref bit [15:0] ua_brgr10, ref bit sample_clk10, ref bit sop_detected10);
    forever begin
      @(posedge vif10.clock10);
      if ((!vif10.reset) || (sop_detected10)) begin
        `uvm_info(get_type_name(), "sample_clk10- resetting10 ua_brgr10", UVM_HIGH)
        ua_brgr10 = 0;
        sample_clk10 = 0;
        sop_detected10 = 0;
      end else begin
        if ( ua_brgr10 == ({cfg.baud_rate_div10, cfg.baud_rate_gen10})) begin
          ua_brgr10 = 0;
          sample_clk10 = 1;
        end else begin
          sample_clk10 = 0;
          ua_brgr10++;
        end
      end
    end
endtask

task uart_monitor10::start_synchronizer10(ref bit serial_d110, ref bit serial_b10);
endtask

task uart_monitor10::sample_and_store10();
  forever begin
    wait_for_sop10(sop_detected10);
    collect_frame10();
  end
endtask : sample_and_store10

task uart_monitor10::wait_for_sop10(ref bit sop_detected10);
    transmit_delay10 = 0;
    sop_detected10 = 0;
    while (!sop_detected10) begin
      `uvm_info(get_type_name(), "trying10 to detect10 SOP10", UVM_MEDIUM)
      while (!(serial_d110 == 1 && serial_b10 == 0)) begin
        @(negedge vif10.clock10);
        transmit_delay10++;
      end
      if (serial_b10 != 0)
        `uvm_info(get_type_name(), "Encountered10 a glitch10 in serial10 during SOP10, shall10 continue", UVM_LOW)
      else
      begin
        sop_detected10 = 1;
        `uvm_info(get_type_name(), "SOP10 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop10
  

task uart_monitor10::collect_frame10();
  bit [7:0] payload_byte10;
  cur_frame10 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting10 a frame10: %0d", num_frames10+1), UVM_HIGH)
   // Begin10 Transaction10 Recording10
  void'(this.begin_tr(cur_frame10, "UART10 Monitor10", , get_full_name()));
  cur_frame10.transmit_delay10 = transmit_delay10;
  cur_frame10.start_bit10 = 1'b0;
  cur_frame10.parity_type10 = GOOD_PARITY10;
  num_of_bits_rcvd10 = 0;

    while (num_of_bits_rcvd10 < (1 + cfg.char_len_val10 + cfg.parity_en10 + cfg.nbstop10))
    begin
      @(posedge vif10.clock10);
      #1;
      if (sample_clk10) begin
        num_of_bits_rcvd10++;
        if ((num_of_bits_rcvd10 > 0) && (num_of_bits_rcvd10 <= cfg.char_len_val10)) begin // sending10 "data bits" 
          cur_frame10.payload10[num_of_bits_rcvd10-1] = serial_b10;
          payload_byte10 = cur_frame10.payload10[num_of_bits_rcvd10-1];
          `uvm_info(get_type_name(), $psprintf("Received10 a Frame10 data bit:'b%0b", payload_byte10), UVM_HIGH)
        end
        msb_lsb_data10[0] =  cur_frame10.payload10[0] ;
        msb_lsb_data10[1] =  cur_frame10.payload10[cfg.char_len_val10-1] ;
        if ((num_of_bits_rcvd10 == (1 + cfg.char_len_val10)) && (cfg.parity_en10)) begin // sending10 "parity10 bit" if parity10 is enabled
          cur_frame10.parity10 = serial_b10;
          `uvm_info(get_type_name(), $psprintf("Received10 Parity10 bit:'b%0b", cur_frame10.parity10), UVM_HIGH)
          if (serial_b10 == cur_frame10.calc_parity10(cfg.char_len_val10, cfg.parity_mode10))
            `uvm_info(get_type_name(), "Received10 Parity10 is same as calculated10 Parity10", UVM_MEDIUM)
          else if (checks_enable10)
            `uvm_error(get_type_name(), "####### FAIL10 :Received10 Parity10 doesn't match the calculated10 Parity10  ")
        end
        if (num_of_bits_rcvd10 == (1 + cfg.char_len_val10 + cfg.parity_en10)) begin // sending10 "stop/error bits"
          for (int i = 0; i < cfg.nbstop10; i++) begin
            wait (sample_clk10);
            cur_frame10.stop_bits10[i] = serial_b10;
            `uvm_info(get_type_name(), $psprintf("Received10 a Stop bit: 'b%0b", cur_frame10.stop_bits10[i]), UVM_HIGH)
            num_of_bits_rcvd10++;
            wait (!sample_clk10);
          end
        end
        wait (!sample_clk10);
      end
    end
 num_frames10++; 
 `uvm_info(get_type_name(), $psprintf("Collected10 the following10 Frame10 No:%0d\n%s", num_frames10, cur_frame10.sprint()), UVM_MEDIUM)

  if(coverage_enable10) perform_coverage10();
  frame_collected_port10.write(cur_frame10);
  this.end_tr(cur_frame10);
endtask : collect_frame10

function void uart_monitor10::perform_coverage10();
  uart_trans_frame_cg10.sample();
endfunction : perform_coverage10

`endif

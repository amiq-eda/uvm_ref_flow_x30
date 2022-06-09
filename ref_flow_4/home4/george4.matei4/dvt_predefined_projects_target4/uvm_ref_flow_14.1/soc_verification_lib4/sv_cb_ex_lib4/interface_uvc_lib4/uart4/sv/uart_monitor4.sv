/*-------------------------------------------------------------------------
File4 name   : uart_monitor4.sv
Title4       : monitor4 file for uart4 uvc4
Project4     :
Created4     :
Description4 : Descirbes4 UART4 Monitor4. Rx4/Tx4 monitors4 should be derived4 form4
            : this uart_monitor4 base class
Notes4       :  
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH4
`define UART_MONITOR_SVH4

virtual class uart_monitor4 extends uvm_monitor;
   uvm_analysis_port #(uart_frame4) frame_collected_port4;

  // virtual interface 
  virtual interface uart_if4 vif4;

  // Handle4 to  a cfg class
  uart_config4 cfg; 

  int num_frames4;
  bit sample_clk4;
  bit baud_clk4;
  bit [15:0] ua_brgr4;
  bit [7:0] ua_bdiv4;
  int num_of_bits_rcvd4;
  int transmit_delay4;
  bit sop_detected4;
  bit tmp_bit04;
  bit serial_d14;
  bit serial_bit4;
  bit serial_b4;
  bit [1:0]  msb_lsb_data4;

  bit checks_enable4 = 1;   // enable protocol4 checking
  bit coverage_enable4 = 1; // control4 coverage4 in the monitor4
  uart_frame4 cur_frame4;

  `uvm_field_utils_begin(uart_monitor4)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable4, UVM_DEFAULT)
      `uvm_field_int(coverage_enable4, UVM_DEFAULT)
      `uvm_field_object(cur_frame4, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg4;
    NUM_STOP_BITS4 : coverpoint cfg.nbstop4 {
      bins ONE4 = {0};
      bins TWO4 = {1};
    }
    DATA_LENGTH4 : coverpoint cfg.char_length4 {
      bins EIGHT4 = {0,1};
      bins SEVEN4 = {2};
      bins SIX4 = {3};
    }
    PARITY_MODE4 : coverpoint cfg.parity_mode4 {
      bins EVEN4  = {0};
      bins ODD4   = {1};
      bins SPACE4 = {2};
      bins MARK4  = {3};
    }
    PARITY_ERROR4: coverpoint cur_frame4.error_bits4[1]
      {
        bins good4 = { 0 };
        bins bad4 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE4: cross DATA_LENGTH4, PARITY_MODE4;
    PARITY_ERROR_x_PARITY_MODE4: cross PARITY_ERROR4, PARITY_MODE4;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg4 = new();
    uart_trans_frame_cg4.set_inst_name ("uart_trans_frame_cg4");
    frame_collected_port4 = new("frame_collected_port4", this);
  endfunction: new

  // Additional4 class methods4;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate4(ref bit [15:0] ua_brgr4, ref bit sample_clk4, ref bit sop_detected4);
  extern virtual task start_synchronizer4(ref bit serial_d14, ref bit serial_b4);
  extern virtual protected function void perform_coverage4();
  extern virtual task collect_frame4();
  extern virtual task wait_for_sop4(ref bit sop_detected4);
  extern virtual task sample_and_store4();
endclass: uart_monitor4

// UVM build_phase
function void uart_monitor4::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config4)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG4", "uart_config4 not set for this somponent4")
endfunction : build_phase

function void uart_monitor4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if4)::get(this, "","vif4",vif4))
      `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".vif4"})
endfunction : connect_phase

task uart_monitor4::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start4 Running4", UVM_LOW)
  @(negedge vif4.reset); 
  wait (vif4.reset);
  `uvm_info(get_type_name(), "Detected4 Reset4 Done4", UVM_LOW)
  num_frames4 = 0;
  cur_frame4 = uart_frame4::type_id::create("cur_frame4", this);

  fork
    gen_sample_rate4(ua_brgr4, sample_clk4, sop_detected4);
    start_synchronizer4(serial_d14, serial_b4);
    sample_and_store4();
  join
endtask : run_phase

task uart_monitor4::gen_sample_rate4(ref bit [15:0] ua_brgr4, ref bit sample_clk4, ref bit sop_detected4);
    forever begin
      @(posedge vif4.clock4);
      if ((!vif4.reset) || (sop_detected4)) begin
        `uvm_info(get_type_name(), "sample_clk4- resetting4 ua_brgr4", UVM_HIGH)
        ua_brgr4 = 0;
        sample_clk4 = 0;
        sop_detected4 = 0;
      end else begin
        if ( ua_brgr4 == ({cfg.baud_rate_div4, cfg.baud_rate_gen4})) begin
          ua_brgr4 = 0;
          sample_clk4 = 1;
        end else begin
          sample_clk4 = 0;
          ua_brgr4++;
        end
      end
    end
endtask

task uart_monitor4::start_synchronizer4(ref bit serial_d14, ref bit serial_b4);
endtask

task uart_monitor4::sample_and_store4();
  forever begin
    wait_for_sop4(sop_detected4);
    collect_frame4();
  end
endtask : sample_and_store4

task uart_monitor4::wait_for_sop4(ref bit sop_detected4);
    transmit_delay4 = 0;
    sop_detected4 = 0;
    while (!sop_detected4) begin
      `uvm_info(get_type_name(), "trying4 to detect4 SOP4", UVM_MEDIUM)
      while (!(serial_d14 == 1 && serial_b4 == 0)) begin
        @(negedge vif4.clock4);
        transmit_delay4++;
      end
      if (serial_b4 != 0)
        `uvm_info(get_type_name(), "Encountered4 a glitch4 in serial4 during SOP4, shall4 continue", UVM_LOW)
      else
      begin
        sop_detected4 = 1;
        `uvm_info(get_type_name(), "SOP4 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop4
  

task uart_monitor4::collect_frame4();
  bit [7:0] payload_byte4;
  cur_frame4 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting4 a frame4: %0d", num_frames4+1), UVM_HIGH)
   // Begin4 Transaction4 Recording4
  void'(this.begin_tr(cur_frame4, "UART4 Monitor4", , get_full_name()));
  cur_frame4.transmit_delay4 = transmit_delay4;
  cur_frame4.start_bit4 = 1'b0;
  cur_frame4.parity_type4 = GOOD_PARITY4;
  num_of_bits_rcvd4 = 0;

    while (num_of_bits_rcvd4 < (1 + cfg.char_len_val4 + cfg.parity_en4 + cfg.nbstop4))
    begin
      @(posedge vif4.clock4);
      #1;
      if (sample_clk4) begin
        num_of_bits_rcvd4++;
        if ((num_of_bits_rcvd4 > 0) && (num_of_bits_rcvd4 <= cfg.char_len_val4)) begin // sending4 "data bits" 
          cur_frame4.payload4[num_of_bits_rcvd4-1] = serial_b4;
          payload_byte4 = cur_frame4.payload4[num_of_bits_rcvd4-1];
          `uvm_info(get_type_name(), $psprintf("Received4 a Frame4 data bit:'b%0b", payload_byte4), UVM_HIGH)
        end
        msb_lsb_data4[0] =  cur_frame4.payload4[0] ;
        msb_lsb_data4[1] =  cur_frame4.payload4[cfg.char_len_val4-1] ;
        if ((num_of_bits_rcvd4 == (1 + cfg.char_len_val4)) && (cfg.parity_en4)) begin // sending4 "parity4 bit" if parity4 is enabled
          cur_frame4.parity4 = serial_b4;
          `uvm_info(get_type_name(), $psprintf("Received4 Parity4 bit:'b%0b", cur_frame4.parity4), UVM_HIGH)
          if (serial_b4 == cur_frame4.calc_parity4(cfg.char_len_val4, cfg.parity_mode4))
            `uvm_info(get_type_name(), "Received4 Parity4 is same as calculated4 Parity4", UVM_MEDIUM)
          else if (checks_enable4)
            `uvm_error(get_type_name(), "####### FAIL4 :Received4 Parity4 doesn't match the calculated4 Parity4  ")
        end
        if (num_of_bits_rcvd4 == (1 + cfg.char_len_val4 + cfg.parity_en4)) begin // sending4 "stop/error bits"
          for (int i = 0; i < cfg.nbstop4; i++) begin
            wait (sample_clk4);
            cur_frame4.stop_bits4[i] = serial_b4;
            `uvm_info(get_type_name(), $psprintf("Received4 a Stop bit: 'b%0b", cur_frame4.stop_bits4[i]), UVM_HIGH)
            num_of_bits_rcvd4++;
            wait (!sample_clk4);
          end
        end
        wait (!sample_clk4);
      end
    end
 num_frames4++; 
 `uvm_info(get_type_name(), $psprintf("Collected4 the following4 Frame4 No:%0d\n%s", num_frames4, cur_frame4.sprint()), UVM_MEDIUM)

  if(coverage_enable4) perform_coverage4();
  frame_collected_port4.write(cur_frame4);
  this.end_tr(cur_frame4);
endtask : collect_frame4

function void uart_monitor4::perform_coverage4();
  uart_trans_frame_cg4.sample();
endfunction : perform_coverage4

`endif

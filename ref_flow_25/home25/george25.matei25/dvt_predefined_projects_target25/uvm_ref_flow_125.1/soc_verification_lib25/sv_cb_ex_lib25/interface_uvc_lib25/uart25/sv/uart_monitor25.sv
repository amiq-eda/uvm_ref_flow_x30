/*-------------------------------------------------------------------------
File25 name   : uart_monitor25.sv
Title25       : monitor25 file for uart25 uvc25
Project25     :
Created25     :
Description25 : Descirbes25 UART25 Monitor25. Rx25/Tx25 monitors25 should be derived25 form25
            : this uart_monitor25 base class
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH25
`define UART_MONITOR_SVH25

virtual class uart_monitor25 extends uvm_monitor;
   uvm_analysis_port #(uart_frame25) frame_collected_port25;

  // virtual interface 
  virtual interface uart_if25 vif25;

  // Handle25 to  a cfg class
  uart_config25 cfg; 

  int num_frames25;
  bit sample_clk25;
  bit baud_clk25;
  bit [15:0] ua_brgr25;
  bit [7:0] ua_bdiv25;
  int num_of_bits_rcvd25;
  int transmit_delay25;
  bit sop_detected25;
  bit tmp_bit025;
  bit serial_d125;
  bit serial_bit25;
  bit serial_b25;
  bit [1:0]  msb_lsb_data25;

  bit checks_enable25 = 1;   // enable protocol25 checking
  bit coverage_enable25 = 1; // control25 coverage25 in the monitor25
  uart_frame25 cur_frame25;

  `uvm_field_utils_begin(uart_monitor25)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable25, UVM_DEFAULT)
      `uvm_field_int(coverage_enable25, UVM_DEFAULT)
      `uvm_field_object(cur_frame25, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg25;
    NUM_STOP_BITS25 : coverpoint cfg.nbstop25 {
      bins ONE25 = {0};
      bins TWO25 = {1};
    }
    DATA_LENGTH25 : coverpoint cfg.char_length25 {
      bins EIGHT25 = {0,1};
      bins SEVEN25 = {2};
      bins SIX25 = {3};
    }
    PARITY_MODE25 : coverpoint cfg.parity_mode25 {
      bins EVEN25  = {0};
      bins ODD25   = {1};
      bins SPACE25 = {2};
      bins MARK25  = {3};
    }
    PARITY_ERROR25: coverpoint cur_frame25.error_bits25[1]
      {
        bins good25 = { 0 };
        bins bad25 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE25: cross DATA_LENGTH25, PARITY_MODE25;
    PARITY_ERROR_x_PARITY_MODE25: cross PARITY_ERROR25, PARITY_MODE25;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg25 = new();
    uart_trans_frame_cg25.set_inst_name ("uart_trans_frame_cg25");
    frame_collected_port25 = new("frame_collected_port25", this);
  endfunction: new

  // Additional25 class methods25;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate25(ref bit [15:0] ua_brgr25, ref bit sample_clk25, ref bit sop_detected25);
  extern virtual task start_synchronizer25(ref bit serial_d125, ref bit serial_b25);
  extern virtual protected function void perform_coverage25();
  extern virtual task collect_frame25();
  extern virtual task wait_for_sop25(ref bit sop_detected25);
  extern virtual task sample_and_store25();
endclass: uart_monitor25

// UVM build_phase
function void uart_monitor25::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config25)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG25", "uart_config25 not set for this somponent25")
endfunction : build_phase

function void uart_monitor25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if25)::get(this, "","vif25",vif25))
      `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
endfunction : connect_phase

task uart_monitor25::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start25 Running25", UVM_LOW)
  @(negedge vif25.reset); 
  wait (vif25.reset);
  `uvm_info(get_type_name(), "Detected25 Reset25 Done25", UVM_LOW)
  num_frames25 = 0;
  cur_frame25 = uart_frame25::type_id::create("cur_frame25", this);

  fork
    gen_sample_rate25(ua_brgr25, sample_clk25, sop_detected25);
    start_synchronizer25(serial_d125, serial_b25);
    sample_and_store25();
  join
endtask : run_phase

task uart_monitor25::gen_sample_rate25(ref bit [15:0] ua_brgr25, ref bit sample_clk25, ref bit sop_detected25);
    forever begin
      @(posedge vif25.clock25);
      if ((!vif25.reset) || (sop_detected25)) begin
        `uvm_info(get_type_name(), "sample_clk25- resetting25 ua_brgr25", UVM_HIGH)
        ua_brgr25 = 0;
        sample_clk25 = 0;
        sop_detected25 = 0;
      end else begin
        if ( ua_brgr25 == ({cfg.baud_rate_div25, cfg.baud_rate_gen25})) begin
          ua_brgr25 = 0;
          sample_clk25 = 1;
        end else begin
          sample_clk25 = 0;
          ua_brgr25++;
        end
      end
    end
endtask

task uart_monitor25::start_synchronizer25(ref bit serial_d125, ref bit serial_b25);
endtask

task uart_monitor25::sample_and_store25();
  forever begin
    wait_for_sop25(sop_detected25);
    collect_frame25();
  end
endtask : sample_and_store25

task uart_monitor25::wait_for_sop25(ref bit sop_detected25);
    transmit_delay25 = 0;
    sop_detected25 = 0;
    while (!sop_detected25) begin
      `uvm_info(get_type_name(), "trying25 to detect25 SOP25", UVM_MEDIUM)
      while (!(serial_d125 == 1 && serial_b25 == 0)) begin
        @(negedge vif25.clock25);
        transmit_delay25++;
      end
      if (serial_b25 != 0)
        `uvm_info(get_type_name(), "Encountered25 a glitch25 in serial25 during SOP25, shall25 continue", UVM_LOW)
      else
      begin
        sop_detected25 = 1;
        `uvm_info(get_type_name(), "SOP25 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop25
  

task uart_monitor25::collect_frame25();
  bit [7:0] payload_byte25;
  cur_frame25 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting25 a frame25: %0d", num_frames25+1), UVM_HIGH)
   // Begin25 Transaction25 Recording25
  void'(this.begin_tr(cur_frame25, "UART25 Monitor25", , get_full_name()));
  cur_frame25.transmit_delay25 = transmit_delay25;
  cur_frame25.start_bit25 = 1'b0;
  cur_frame25.parity_type25 = GOOD_PARITY25;
  num_of_bits_rcvd25 = 0;

    while (num_of_bits_rcvd25 < (1 + cfg.char_len_val25 + cfg.parity_en25 + cfg.nbstop25))
    begin
      @(posedge vif25.clock25);
      #1;
      if (sample_clk25) begin
        num_of_bits_rcvd25++;
        if ((num_of_bits_rcvd25 > 0) && (num_of_bits_rcvd25 <= cfg.char_len_val25)) begin // sending25 "data bits" 
          cur_frame25.payload25[num_of_bits_rcvd25-1] = serial_b25;
          payload_byte25 = cur_frame25.payload25[num_of_bits_rcvd25-1];
          `uvm_info(get_type_name(), $psprintf("Received25 a Frame25 data bit:'b%0b", payload_byte25), UVM_HIGH)
        end
        msb_lsb_data25[0] =  cur_frame25.payload25[0] ;
        msb_lsb_data25[1] =  cur_frame25.payload25[cfg.char_len_val25-1] ;
        if ((num_of_bits_rcvd25 == (1 + cfg.char_len_val25)) && (cfg.parity_en25)) begin // sending25 "parity25 bit" if parity25 is enabled
          cur_frame25.parity25 = serial_b25;
          `uvm_info(get_type_name(), $psprintf("Received25 Parity25 bit:'b%0b", cur_frame25.parity25), UVM_HIGH)
          if (serial_b25 == cur_frame25.calc_parity25(cfg.char_len_val25, cfg.parity_mode25))
            `uvm_info(get_type_name(), "Received25 Parity25 is same as calculated25 Parity25", UVM_MEDIUM)
          else if (checks_enable25)
            `uvm_error(get_type_name(), "####### FAIL25 :Received25 Parity25 doesn't match the calculated25 Parity25  ")
        end
        if (num_of_bits_rcvd25 == (1 + cfg.char_len_val25 + cfg.parity_en25)) begin // sending25 "stop/error bits"
          for (int i = 0; i < cfg.nbstop25; i++) begin
            wait (sample_clk25);
            cur_frame25.stop_bits25[i] = serial_b25;
            `uvm_info(get_type_name(), $psprintf("Received25 a Stop bit: 'b%0b", cur_frame25.stop_bits25[i]), UVM_HIGH)
            num_of_bits_rcvd25++;
            wait (!sample_clk25);
          end
        end
        wait (!sample_clk25);
      end
    end
 num_frames25++; 
 `uvm_info(get_type_name(), $psprintf("Collected25 the following25 Frame25 No:%0d\n%s", num_frames25, cur_frame25.sprint()), UVM_MEDIUM)

  if(coverage_enable25) perform_coverage25();
  frame_collected_port25.write(cur_frame25);
  this.end_tr(cur_frame25);
endtask : collect_frame25

function void uart_monitor25::perform_coverage25();
  uart_trans_frame_cg25.sample();
endfunction : perform_coverage25

`endif

/*-------------------------------------------------------------------------
File14 name   : uart_monitor14.sv
Title14       : monitor14 file for uart14 uvc14
Project14     :
Created14     :
Description14 : Descirbes14 UART14 Monitor14. Rx14/Tx14 monitors14 should be derived14 form14
            : this uart_monitor14 base class
Notes14       :  
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH14
`define UART_MONITOR_SVH14

virtual class uart_monitor14 extends uvm_monitor;
   uvm_analysis_port #(uart_frame14) frame_collected_port14;

  // virtual interface 
  virtual interface uart_if14 vif14;

  // Handle14 to  a cfg class
  uart_config14 cfg; 

  int num_frames14;
  bit sample_clk14;
  bit baud_clk14;
  bit [15:0] ua_brgr14;
  bit [7:0] ua_bdiv14;
  int num_of_bits_rcvd14;
  int transmit_delay14;
  bit sop_detected14;
  bit tmp_bit014;
  bit serial_d114;
  bit serial_bit14;
  bit serial_b14;
  bit [1:0]  msb_lsb_data14;

  bit checks_enable14 = 1;   // enable protocol14 checking
  bit coverage_enable14 = 1; // control14 coverage14 in the monitor14
  uart_frame14 cur_frame14;

  `uvm_field_utils_begin(uart_monitor14)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable14, UVM_DEFAULT)
      `uvm_field_int(coverage_enable14, UVM_DEFAULT)
      `uvm_field_object(cur_frame14, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg14;
    NUM_STOP_BITS14 : coverpoint cfg.nbstop14 {
      bins ONE14 = {0};
      bins TWO14 = {1};
    }
    DATA_LENGTH14 : coverpoint cfg.char_length14 {
      bins EIGHT14 = {0,1};
      bins SEVEN14 = {2};
      bins SIX14 = {3};
    }
    PARITY_MODE14 : coverpoint cfg.parity_mode14 {
      bins EVEN14  = {0};
      bins ODD14   = {1};
      bins SPACE14 = {2};
      bins MARK14  = {3};
    }
    PARITY_ERROR14: coverpoint cur_frame14.error_bits14[1]
      {
        bins good14 = { 0 };
        bins bad14 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE14: cross DATA_LENGTH14, PARITY_MODE14;
    PARITY_ERROR_x_PARITY_MODE14: cross PARITY_ERROR14, PARITY_MODE14;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg14 = new();
    uart_trans_frame_cg14.set_inst_name ("uart_trans_frame_cg14");
    frame_collected_port14 = new("frame_collected_port14", this);
  endfunction: new

  // Additional14 class methods14;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate14(ref bit [15:0] ua_brgr14, ref bit sample_clk14, ref bit sop_detected14);
  extern virtual task start_synchronizer14(ref bit serial_d114, ref bit serial_b14);
  extern virtual protected function void perform_coverage14();
  extern virtual task collect_frame14();
  extern virtual task wait_for_sop14(ref bit sop_detected14);
  extern virtual task sample_and_store14();
endclass: uart_monitor14

// UVM build_phase
function void uart_monitor14::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config14)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG14", "uart_config14 not set for this somponent14")
endfunction : build_phase

function void uart_monitor14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if14)::get(this, "","vif14",vif14))
      `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
endfunction : connect_phase

task uart_monitor14::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start14 Running14", UVM_LOW)
  @(negedge vif14.reset); 
  wait (vif14.reset);
  `uvm_info(get_type_name(), "Detected14 Reset14 Done14", UVM_LOW)
  num_frames14 = 0;
  cur_frame14 = uart_frame14::type_id::create("cur_frame14", this);

  fork
    gen_sample_rate14(ua_brgr14, sample_clk14, sop_detected14);
    start_synchronizer14(serial_d114, serial_b14);
    sample_and_store14();
  join
endtask : run_phase

task uart_monitor14::gen_sample_rate14(ref bit [15:0] ua_brgr14, ref bit sample_clk14, ref bit sop_detected14);
    forever begin
      @(posedge vif14.clock14);
      if ((!vif14.reset) || (sop_detected14)) begin
        `uvm_info(get_type_name(), "sample_clk14- resetting14 ua_brgr14", UVM_HIGH)
        ua_brgr14 = 0;
        sample_clk14 = 0;
        sop_detected14 = 0;
      end else begin
        if ( ua_brgr14 == ({cfg.baud_rate_div14, cfg.baud_rate_gen14})) begin
          ua_brgr14 = 0;
          sample_clk14 = 1;
        end else begin
          sample_clk14 = 0;
          ua_brgr14++;
        end
      end
    end
endtask

task uart_monitor14::start_synchronizer14(ref bit serial_d114, ref bit serial_b14);
endtask

task uart_monitor14::sample_and_store14();
  forever begin
    wait_for_sop14(sop_detected14);
    collect_frame14();
  end
endtask : sample_and_store14

task uart_monitor14::wait_for_sop14(ref bit sop_detected14);
    transmit_delay14 = 0;
    sop_detected14 = 0;
    while (!sop_detected14) begin
      `uvm_info(get_type_name(), "trying14 to detect14 SOP14", UVM_MEDIUM)
      while (!(serial_d114 == 1 && serial_b14 == 0)) begin
        @(negedge vif14.clock14);
        transmit_delay14++;
      end
      if (serial_b14 != 0)
        `uvm_info(get_type_name(), "Encountered14 a glitch14 in serial14 during SOP14, shall14 continue", UVM_LOW)
      else
      begin
        sop_detected14 = 1;
        `uvm_info(get_type_name(), "SOP14 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop14
  

task uart_monitor14::collect_frame14();
  bit [7:0] payload_byte14;
  cur_frame14 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting14 a frame14: %0d", num_frames14+1), UVM_HIGH)
   // Begin14 Transaction14 Recording14
  void'(this.begin_tr(cur_frame14, "UART14 Monitor14", , get_full_name()));
  cur_frame14.transmit_delay14 = transmit_delay14;
  cur_frame14.start_bit14 = 1'b0;
  cur_frame14.parity_type14 = GOOD_PARITY14;
  num_of_bits_rcvd14 = 0;

    while (num_of_bits_rcvd14 < (1 + cfg.char_len_val14 + cfg.parity_en14 + cfg.nbstop14))
    begin
      @(posedge vif14.clock14);
      #1;
      if (sample_clk14) begin
        num_of_bits_rcvd14++;
        if ((num_of_bits_rcvd14 > 0) && (num_of_bits_rcvd14 <= cfg.char_len_val14)) begin // sending14 "data bits" 
          cur_frame14.payload14[num_of_bits_rcvd14-1] = serial_b14;
          payload_byte14 = cur_frame14.payload14[num_of_bits_rcvd14-1];
          `uvm_info(get_type_name(), $psprintf("Received14 a Frame14 data bit:'b%0b", payload_byte14), UVM_HIGH)
        end
        msb_lsb_data14[0] =  cur_frame14.payload14[0] ;
        msb_lsb_data14[1] =  cur_frame14.payload14[cfg.char_len_val14-1] ;
        if ((num_of_bits_rcvd14 == (1 + cfg.char_len_val14)) && (cfg.parity_en14)) begin // sending14 "parity14 bit" if parity14 is enabled
          cur_frame14.parity14 = serial_b14;
          `uvm_info(get_type_name(), $psprintf("Received14 Parity14 bit:'b%0b", cur_frame14.parity14), UVM_HIGH)
          if (serial_b14 == cur_frame14.calc_parity14(cfg.char_len_val14, cfg.parity_mode14))
            `uvm_info(get_type_name(), "Received14 Parity14 is same as calculated14 Parity14", UVM_MEDIUM)
          else if (checks_enable14)
            `uvm_error(get_type_name(), "####### FAIL14 :Received14 Parity14 doesn't match the calculated14 Parity14  ")
        end
        if (num_of_bits_rcvd14 == (1 + cfg.char_len_val14 + cfg.parity_en14)) begin // sending14 "stop/error bits"
          for (int i = 0; i < cfg.nbstop14; i++) begin
            wait (sample_clk14);
            cur_frame14.stop_bits14[i] = serial_b14;
            `uvm_info(get_type_name(), $psprintf("Received14 a Stop bit: 'b%0b", cur_frame14.stop_bits14[i]), UVM_HIGH)
            num_of_bits_rcvd14++;
            wait (!sample_clk14);
          end
        end
        wait (!sample_clk14);
      end
    end
 num_frames14++; 
 `uvm_info(get_type_name(), $psprintf("Collected14 the following14 Frame14 No:%0d\n%s", num_frames14, cur_frame14.sprint()), UVM_MEDIUM)

  if(coverage_enable14) perform_coverage14();
  frame_collected_port14.write(cur_frame14);
  this.end_tr(cur_frame14);
endtask : collect_frame14

function void uart_monitor14::perform_coverage14();
  uart_trans_frame_cg14.sample();
endfunction : perform_coverage14

`endif

/*-------------------------------------------------------------------------
File28 name   : uart_monitor28.sv
Title28       : monitor28 file for uart28 uvc28
Project28     :
Created28     :
Description28 : Descirbes28 UART28 Monitor28. Rx28/Tx28 monitors28 should be derived28 form28
            : this uart_monitor28 base class
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH28
`define UART_MONITOR_SVH28

virtual class uart_monitor28 extends uvm_monitor;
   uvm_analysis_port #(uart_frame28) frame_collected_port28;

  // virtual interface 
  virtual interface uart_if28 vif28;

  // Handle28 to  a cfg class
  uart_config28 cfg; 

  int num_frames28;
  bit sample_clk28;
  bit baud_clk28;
  bit [15:0] ua_brgr28;
  bit [7:0] ua_bdiv28;
  int num_of_bits_rcvd28;
  int transmit_delay28;
  bit sop_detected28;
  bit tmp_bit028;
  bit serial_d128;
  bit serial_bit28;
  bit serial_b28;
  bit [1:0]  msb_lsb_data28;

  bit checks_enable28 = 1;   // enable protocol28 checking
  bit coverage_enable28 = 1; // control28 coverage28 in the monitor28
  uart_frame28 cur_frame28;

  `uvm_field_utils_begin(uart_monitor28)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable28, UVM_DEFAULT)
      `uvm_field_int(coverage_enable28, UVM_DEFAULT)
      `uvm_field_object(cur_frame28, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg28;
    NUM_STOP_BITS28 : coverpoint cfg.nbstop28 {
      bins ONE28 = {0};
      bins TWO28 = {1};
    }
    DATA_LENGTH28 : coverpoint cfg.char_length28 {
      bins EIGHT28 = {0,1};
      bins SEVEN28 = {2};
      bins SIX28 = {3};
    }
    PARITY_MODE28 : coverpoint cfg.parity_mode28 {
      bins EVEN28  = {0};
      bins ODD28   = {1};
      bins SPACE28 = {2};
      bins MARK28  = {3};
    }
    PARITY_ERROR28: coverpoint cur_frame28.error_bits28[1]
      {
        bins good28 = { 0 };
        bins bad28 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE28: cross DATA_LENGTH28, PARITY_MODE28;
    PARITY_ERROR_x_PARITY_MODE28: cross PARITY_ERROR28, PARITY_MODE28;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg28 = new();
    uart_trans_frame_cg28.set_inst_name ("uart_trans_frame_cg28");
    frame_collected_port28 = new("frame_collected_port28", this);
  endfunction: new

  // Additional28 class methods28;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate28(ref bit [15:0] ua_brgr28, ref bit sample_clk28, ref bit sop_detected28);
  extern virtual task start_synchronizer28(ref bit serial_d128, ref bit serial_b28);
  extern virtual protected function void perform_coverage28();
  extern virtual task collect_frame28();
  extern virtual task wait_for_sop28(ref bit sop_detected28);
  extern virtual task sample_and_store28();
endclass: uart_monitor28

// UVM build_phase
function void uart_monitor28::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config28)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG28", "uart_config28 not set for this somponent28")
endfunction : build_phase

function void uart_monitor28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if28)::get(this, "","vif28",vif28))
      `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".vif28"})
endfunction : connect_phase

task uart_monitor28::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start28 Running28", UVM_LOW)
  @(negedge vif28.reset); 
  wait (vif28.reset);
  `uvm_info(get_type_name(), "Detected28 Reset28 Done28", UVM_LOW)
  num_frames28 = 0;
  cur_frame28 = uart_frame28::type_id::create("cur_frame28", this);

  fork
    gen_sample_rate28(ua_brgr28, sample_clk28, sop_detected28);
    start_synchronizer28(serial_d128, serial_b28);
    sample_and_store28();
  join
endtask : run_phase

task uart_monitor28::gen_sample_rate28(ref bit [15:0] ua_brgr28, ref bit sample_clk28, ref bit sop_detected28);
    forever begin
      @(posedge vif28.clock28);
      if ((!vif28.reset) || (sop_detected28)) begin
        `uvm_info(get_type_name(), "sample_clk28- resetting28 ua_brgr28", UVM_HIGH)
        ua_brgr28 = 0;
        sample_clk28 = 0;
        sop_detected28 = 0;
      end else begin
        if ( ua_brgr28 == ({cfg.baud_rate_div28, cfg.baud_rate_gen28})) begin
          ua_brgr28 = 0;
          sample_clk28 = 1;
        end else begin
          sample_clk28 = 0;
          ua_brgr28++;
        end
      end
    end
endtask

task uart_monitor28::start_synchronizer28(ref bit serial_d128, ref bit serial_b28);
endtask

task uart_monitor28::sample_and_store28();
  forever begin
    wait_for_sop28(sop_detected28);
    collect_frame28();
  end
endtask : sample_and_store28

task uart_monitor28::wait_for_sop28(ref bit sop_detected28);
    transmit_delay28 = 0;
    sop_detected28 = 0;
    while (!sop_detected28) begin
      `uvm_info(get_type_name(), "trying28 to detect28 SOP28", UVM_MEDIUM)
      while (!(serial_d128 == 1 && serial_b28 == 0)) begin
        @(negedge vif28.clock28);
        transmit_delay28++;
      end
      if (serial_b28 != 0)
        `uvm_info(get_type_name(), "Encountered28 a glitch28 in serial28 during SOP28, shall28 continue", UVM_LOW)
      else
      begin
        sop_detected28 = 1;
        `uvm_info(get_type_name(), "SOP28 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop28
  

task uart_monitor28::collect_frame28();
  bit [7:0] payload_byte28;
  cur_frame28 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting28 a frame28: %0d", num_frames28+1), UVM_HIGH)
   // Begin28 Transaction28 Recording28
  void'(this.begin_tr(cur_frame28, "UART28 Monitor28", , get_full_name()));
  cur_frame28.transmit_delay28 = transmit_delay28;
  cur_frame28.start_bit28 = 1'b0;
  cur_frame28.parity_type28 = GOOD_PARITY28;
  num_of_bits_rcvd28 = 0;

    while (num_of_bits_rcvd28 < (1 + cfg.char_len_val28 + cfg.parity_en28 + cfg.nbstop28))
    begin
      @(posedge vif28.clock28);
      #1;
      if (sample_clk28) begin
        num_of_bits_rcvd28++;
        if ((num_of_bits_rcvd28 > 0) && (num_of_bits_rcvd28 <= cfg.char_len_val28)) begin // sending28 "data bits" 
          cur_frame28.payload28[num_of_bits_rcvd28-1] = serial_b28;
          payload_byte28 = cur_frame28.payload28[num_of_bits_rcvd28-1];
          `uvm_info(get_type_name(), $psprintf("Received28 a Frame28 data bit:'b%0b", payload_byte28), UVM_HIGH)
        end
        msb_lsb_data28[0] =  cur_frame28.payload28[0] ;
        msb_lsb_data28[1] =  cur_frame28.payload28[cfg.char_len_val28-1] ;
        if ((num_of_bits_rcvd28 == (1 + cfg.char_len_val28)) && (cfg.parity_en28)) begin // sending28 "parity28 bit" if parity28 is enabled
          cur_frame28.parity28 = serial_b28;
          `uvm_info(get_type_name(), $psprintf("Received28 Parity28 bit:'b%0b", cur_frame28.parity28), UVM_HIGH)
          if (serial_b28 == cur_frame28.calc_parity28(cfg.char_len_val28, cfg.parity_mode28))
            `uvm_info(get_type_name(), "Received28 Parity28 is same as calculated28 Parity28", UVM_MEDIUM)
          else if (checks_enable28)
            `uvm_error(get_type_name(), "####### FAIL28 :Received28 Parity28 doesn't match the calculated28 Parity28  ")
        end
        if (num_of_bits_rcvd28 == (1 + cfg.char_len_val28 + cfg.parity_en28)) begin // sending28 "stop/error bits"
          for (int i = 0; i < cfg.nbstop28; i++) begin
            wait (sample_clk28);
            cur_frame28.stop_bits28[i] = serial_b28;
            `uvm_info(get_type_name(), $psprintf("Received28 a Stop bit: 'b%0b", cur_frame28.stop_bits28[i]), UVM_HIGH)
            num_of_bits_rcvd28++;
            wait (!sample_clk28);
          end
        end
        wait (!sample_clk28);
      end
    end
 num_frames28++; 
 `uvm_info(get_type_name(), $psprintf("Collected28 the following28 Frame28 No:%0d\n%s", num_frames28, cur_frame28.sprint()), UVM_MEDIUM)

  if(coverage_enable28) perform_coverage28();
  frame_collected_port28.write(cur_frame28);
  this.end_tr(cur_frame28);
endtask : collect_frame28

function void uart_monitor28::perform_coverage28();
  uart_trans_frame_cg28.sample();
endfunction : perform_coverage28

`endif

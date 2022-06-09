/*-------------------------------------------------------------------------
File22 name   : uart_monitor22.sv
Title22       : monitor22 file for uart22 uvc22
Project22     :
Created22     :
Description22 : Descirbes22 UART22 Monitor22. Rx22/Tx22 monitors22 should be derived22 form22
            : this uart_monitor22 base class
Notes22       :  
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH22
`define UART_MONITOR_SVH22

virtual class uart_monitor22 extends uvm_monitor;
   uvm_analysis_port #(uart_frame22) frame_collected_port22;

  // virtual interface 
  virtual interface uart_if22 vif22;

  // Handle22 to  a cfg class
  uart_config22 cfg; 

  int num_frames22;
  bit sample_clk22;
  bit baud_clk22;
  bit [15:0] ua_brgr22;
  bit [7:0] ua_bdiv22;
  int num_of_bits_rcvd22;
  int transmit_delay22;
  bit sop_detected22;
  bit tmp_bit022;
  bit serial_d122;
  bit serial_bit22;
  bit serial_b22;
  bit [1:0]  msb_lsb_data22;

  bit checks_enable22 = 1;   // enable protocol22 checking
  bit coverage_enable22 = 1; // control22 coverage22 in the monitor22
  uart_frame22 cur_frame22;

  `uvm_field_utils_begin(uart_monitor22)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable22, UVM_DEFAULT)
      `uvm_field_int(coverage_enable22, UVM_DEFAULT)
      `uvm_field_object(cur_frame22, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg22;
    NUM_STOP_BITS22 : coverpoint cfg.nbstop22 {
      bins ONE22 = {0};
      bins TWO22 = {1};
    }
    DATA_LENGTH22 : coverpoint cfg.char_length22 {
      bins EIGHT22 = {0,1};
      bins SEVEN22 = {2};
      bins SIX22 = {3};
    }
    PARITY_MODE22 : coverpoint cfg.parity_mode22 {
      bins EVEN22  = {0};
      bins ODD22   = {1};
      bins SPACE22 = {2};
      bins MARK22  = {3};
    }
    PARITY_ERROR22: coverpoint cur_frame22.error_bits22[1]
      {
        bins good22 = { 0 };
        bins bad22 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE22: cross DATA_LENGTH22, PARITY_MODE22;
    PARITY_ERROR_x_PARITY_MODE22: cross PARITY_ERROR22, PARITY_MODE22;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg22 = new();
    uart_trans_frame_cg22.set_inst_name ("uart_trans_frame_cg22");
    frame_collected_port22 = new("frame_collected_port22", this);
  endfunction: new

  // Additional22 class methods22;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate22(ref bit [15:0] ua_brgr22, ref bit sample_clk22, ref bit sop_detected22);
  extern virtual task start_synchronizer22(ref bit serial_d122, ref bit serial_b22);
  extern virtual protected function void perform_coverage22();
  extern virtual task collect_frame22();
  extern virtual task wait_for_sop22(ref bit sop_detected22);
  extern virtual task sample_and_store22();
endclass: uart_monitor22

// UVM build_phase
function void uart_monitor22::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config22)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG22", "uart_config22 not set for this somponent22")
endfunction : build_phase

function void uart_monitor22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if22)::get(this, "","vif22",vif22))
      `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".vif22"})
endfunction : connect_phase

task uart_monitor22::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start22 Running22", UVM_LOW)
  @(negedge vif22.reset); 
  wait (vif22.reset);
  `uvm_info(get_type_name(), "Detected22 Reset22 Done22", UVM_LOW)
  num_frames22 = 0;
  cur_frame22 = uart_frame22::type_id::create("cur_frame22", this);

  fork
    gen_sample_rate22(ua_brgr22, sample_clk22, sop_detected22);
    start_synchronizer22(serial_d122, serial_b22);
    sample_and_store22();
  join
endtask : run_phase

task uart_monitor22::gen_sample_rate22(ref bit [15:0] ua_brgr22, ref bit sample_clk22, ref bit sop_detected22);
    forever begin
      @(posedge vif22.clock22);
      if ((!vif22.reset) || (sop_detected22)) begin
        `uvm_info(get_type_name(), "sample_clk22- resetting22 ua_brgr22", UVM_HIGH)
        ua_brgr22 = 0;
        sample_clk22 = 0;
        sop_detected22 = 0;
      end else begin
        if ( ua_brgr22 == ({cfg.baud_rate_div22, cfg.baud_rate_gen22})) begin
          ua_brgr22 = 0;
          sample_clk22 = 1;
        end else begin
          sample_clk22 = 0;
          ua_brgr22++;
        end
      end
    end
endtask

task uart_monitor22::start_synchronizer22(ref bit serial_d122, ref bit serial_b22);
endtask

task uart_monitor22::sample_and_store22();
  forever begin
    wait_for_sop22(sop_detected22);
    collect_frame22();
  end
endtask : sample_and_store22

task uart_monitor22::wait_for_sop22(ref bit sop_detected22);
    transmit_delay22 = 0;
    sop_detected22 = 0;
    while (!sop_detected22) begin
      `uvm_info(get_type_name(), "trying22 to detect22 SOP22", UVM_MEDIUM)
      while (!(serial_d122 == 1 && serial_b22 == 0)) begin
        @(negedge vif22.clock22);
        transmit_delay22++;
      end
      if (serial_b22 != 0)
        `uvm_info(get_type_name(), "Encountered22 a glitch22 in serial22 during SOP22, shall22 continue", UVM_LOW)
      else
      begin
        sop_detected22 = 1;
        `uvm_info(get_type_name(), "SOP22 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop22
  

task uart_monitor22::collect_frame22();
  bit [7:0] payload_byte22;
  cur_frame22 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting22 a frame22: %0d", num_frames22+1), UVM_HIGH)
   // Begin22 Transaction22 Recording22
  void'(this.begin_tr(cur_frame22, "UART22 Monitor22", , get_full_name()));
  cur_frame22.transmit_delay22 = transmit_delay22;
  cur_frame22.start_bit22 = 1'b0;
  cur_frame22.parity_type22 = GOOD_PARITY22;
  num_of_bits_rcvd22 = 0;

    while (num_of_bits_rcvd22 < (1 + cfg.char_len_val22 + cfg.parity_en22 + cfg.nbstop22))
    begin
      @(posedge vif22.clock22);
      #1;
      if (sample_clk22) begin
        num_of_bits_rcvd22++;
        if ((num_of_bits_rcvd22 > 0) && (num_of_bits_rcvd22 <= cfg.char_len_val22)) begin // sending22 "data bits" 
          cur_frame22.payload22[num_of_bits_rcvd22-1] = serial_b22;
          payload_byte22 = cur_frame22.payload22[num_of_bits_rcvd22-1];
          `uvm_info(get_type_name(), $psprintf("Received22 a Frame22 data bit:'b%0b", payload_byte22), UVM_HIGH)
        end
        msb_lsb_data22[0] =  cur_frame22.payload22[0] ;
        msb_lsb_data22[1] =  cur_frame22.payload22[cfg.char_len_val22-1] ;
        if ((num_of_bits_rcvd22 == (1 + cfg.char_len_val22)) && (cfg.parity_en22)) begin // sending22 "parity22 bit" if parity22 is enabled
          cur_frame22.parity22 = serial_b22;
          `uvm_info(get_type_name(), $psprintf("Received22 Parity22 bit:'b%0b", cur_frame22.parity22), UVM_HIGH)
          if (serial_b22 == cur_frame22.calc_parity22(cfg.char_len_val22, cfg.parity_mode22))
            `uvm_info(get_type_name(), "Received22 Parity22 is same as calculated22 Parity22", UVM_MEDIUM)
          else if (checks_enable22)
            `uvm_error(get_type_name(), "####### FAIL22 :Received22 Parity22 doesn't match the calculated22 Parity22  ")
        end
        if (num_of_bits_rcvd22 == (1 + cfg.char_len_val22 + cfg.parity_en22)) begin // sending22 "stop/error bits"
          for (int i = 0; i < cfg.nbstop22; i++) begin
            wait (sample_clk22);
            cur_frame22.stop_bits22[i] = serial_b22;
            `uvm_info(get_type_name(), $psprintf("Received22 a Stop bit: 'b%0b", cur_frame22.stop_bits22[i]), UVM_HIGH)
            num_of_bits_rcvd22++;
            wait (!sample_clk22);
          end
        end
        wait (!sample_clk22);
      end
    end
 num_frames22++; 
 `uvm_info(get_type_name(), $psprintf("Collected22 the following22 Frame22 No:%0d\n%s", num_frames22, cur_frame22.sprint()), UVM_MEDIUM)

  if(coverage_enable22) perform_coverage22();
  frame_collected_port22.write(cur_frame22);
  this.end_tr(cur_frame22);
endtask : collect_frame22

function void uart_monitor22::perform_coverage22();
  uart_trans_frame_cg22.sample();
endfunction : perform_coverage22

`endif

/*-------------------------------------------------------------------------
File26 name   : uart_monitor26.sv
Title26       : monitor26 file for uart26 uvc26
Project26     :
Created26     :
Description26 : Descirbes26 UART26 Monitor26. Rx26/Tx26 monitors26 should be derived26 form26
            : this uart_monitor26 base class
Notes26       :  
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH26
`define UART_MONITOR_SVH26

virtual class uart_monitor26 extends uvm_monitor;
   uvm_analysis_port #(uart_frame26) frame_collected_port26;

  // virtual interface 
  virtual interface uart_if26 vif26;

  // Handle26 to  a cfg class
  uart_config26 cfg; 

  int num_frames26;
  bit sample_clk26;
  bit baud_clk26;
  bit [15:0] ua_brgr26;
  bit [7:0] ua_bdiv26;
  int num_of_bits_rcvd26;
  int transmit_delay26;
  bit sop_detected26;
  bit tmp_bit026;
  bit serial_d126;
  bit serial_bit26;
  bit serial_b26;
  bit [1:0]  msb_lsb_data26;

  bit checks_enable26 = 1;   // enable protocol26 checking
  bit coverage_enable26 = 1; // control26 coverage26 in the monitor26
  uart_frame26 cur_frame26;

  `uvm_field_utils_begin(uart_monitor26)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable26, UVM_DEFAULT)
      `uvm_field_int(coverage_enable26, UVM_DEFAULT)
      `uvm_field_object(cur_frame26, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg26;
    NUM_STOP_BITS26 : coverpoint cfg.nbstop26 {
      bins ONE26 = {0};
      bins TWO26 = {1};
    }
    DATA_LENGTH26 : coverpoint cfg.char_length26 {
      bins EIGHT26 = {0,1};
      bins SEVEN26 = {2};
      bins SIX26 = {3};
    }
    PARITY_MODE26 : coverpoint cfg.parity_mode26 {
      bins EVEN26  = {0};
      bins ODD26   = {1};
      bins SPACE26 = {2};
      bins MARK26  = {3};
    }
    PARITY_ERROR26: coverpoint cur_frame26.error_bits26[1]
      {
        bins good26 = { 0 };
        bins bad26 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE26: cross DATA_LENGTH26, PARITY_MODE26;
    PARITY_ERROR_x_PARITY_MODE26: cross PARITY_ERROR26, PARITY_MODE26;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg26 = new();
    uart_trans_frame_cg26.set_inst_name ("uart_trans_frame_cg26");
    frame_collected_port26 = new("frame_collected_port26", this);
  endfunction: new

  // Additional26 class methods26;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate26(ref bit [15:0] ua_brgr26, ref bit sample_clk26, ref bit sop_detected26);
  extern virtual task start_synchronizer26(ref bit serial_d126, ref bit serial_b26);
  extern virtual protected function void perform_coverage26();
  extern virtual task collect_frame26();
  extern virtual task wait_for_sop26(ref bit sop_detected26);
  extern virtual task sample_and_store26();
endclass: uart_monitor26

// UVM build_phase
function void uart_monitor26::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config26)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG26", "uart_config26 not set for this somponent26")
endfunction : build_phase

function void uart_monitor26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if26)::get(this, "","vif26",vif26))
      `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
endfunction : connect_phase

task uart_monitor26::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start26 Running26", UVM_LOW)
  @(negedge vif26.reset); 
  wait (vif26.reset);
  `uvm_info(get_type_name(), "Detected26 Reset26 Done26", UVM_LOW)
  num_frames26 = 0;
  cur_frame26 = uart_frame26::type_id::create("cur_frame26", this);

  fork
    gen_sample_rate26(ua_brgr26, sample_clk26, sop_detected26);
    start_synchronizer26(serial_d126, serial_b26);
    sample_and_store26();
  join
endtask : run_phase

task uart_monitor26::gen_sample_rate26(ref bit [15:0] ua_brgr26, ref bit sample_clk26, ref bit sop_detected26);
    forever begin
      @(posedge vif26.clock26);
      if ((!vif26.reset) || (sop_detected26)) begin
        `uvm_info(get_type_name(), "sample_clk26- resetting26 ua_brgr26", UVM_HIGH)
        ua_brgr26 = 0;
        sample_clk26 = 0;
        sop_detected26 = 0;
      end else begin
        if ( ua_brgr26 == ({cfg.baud_rate_div26, cfg.baud_rate_gen26})) begin
          ua_brgr26 = 0;
          sample_clk26 = 1;
        end else begin
          sample_clk26 = 0;
          ua_brgr26++;
        end
      end
    end
endtask

task uart_monitor26::start_synchronizer26(ref bit serial_d126, ref bit serial_b26);
endtask

task uart_monitor26::sample_and_store26();
  forever begin
    wait_for_sop26(sop_detected26);
    collect_frame26();
  end
endtask : sample_and_store26

task uart_monitor26::wait_for_sop26(ref bit sop_detected26);
    transmit_delay26 = 0;
    sop_detected26 = 0;
    while (!sop_detected26) begin
      `uvm_info(get_type_name(), "trying26 to detect26 SOP26", UVM_MEDIUM)
      while (!(serial_d126 == 1 && serial_b26 == 0)) begin
        @(negedge vif26.clock26);
        transmit_delay26++;
      end
      if (serial_b26 != 0)
        `uvm_info(get_type_name(), "Encountered26 a glitch26 in serial26 during SOP26, shall26 continue", UVM_LOW)
      else
      begin
        sop_detected26 = 1;
        `uvm_info(get_type_name(), "SOP26 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop26
  

task uart_monitor26::collect_frame26();
  bit [7:0] payload_byte26;
  cur_frame26 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting26 a frame26: %0d", num_frames26+1), UVM_HIGH)
   // Begin26 Transaction26 Recording26
  void'(this.begin_tr(cur_frame26, "UART26 Monitor26", , get_full_name()));
  cur_frame26.transmit_delay26 = transmit_delay26;
  cur_frame26.start_bit26 = 1'b0;
  cur_frame26.parity_type26 = GOOD_PARITY26;
  num_of_bits_rcvd26 = 0;

    while (num_of_bits_rcvd26 < (1 + cfg.char_len_val26 + cfg.parity_en26 + cfg.nbstop26))
    begin
      @(posedge vif26.clock26);
      #1;
      if (sample_clk26) begin
        num_of_bits_rcvd26++;
        if ((num_of_bits_rcvd26 > 0) && (num_of_bits_rcvd26 <= cfg.char_len_val26)) begin // sending26 "data bits" 
          cur_frame26.payload26[num_of_bits_rcvd26-1] = serial_b26;
          payload_byte26 = cur_frame26.payload26[num_of_bits_rcvd26-1];
          `uvm_info(get_type_name(), $psprintf("Received26 a Frame26 data bit:'b%0b", payload_byte26), UVM_HIGH)
        end
        msb_lsb_data26[0] =  cur_frame26.payload26[0] ;
        msb_lsb_data26[1] =  cur_frame26.payload26[cfg.char_len_val26-1] ;
        if ((num_of_bits_rcvd26 == (1 + cfg.char_len_val26)) && (cfg.parity_en26)) begin // sending26 "parity26 bit" if parity26 is enabled
          cur_frame26.parity26 = serial_b26;
          `uvm_info(get_type_name(), $psprintf("Received26 Parity26 bit:'b%0b", cur_frame26.parity26), UVM_HIGH)
          if (serial_b26 == cur_frame26.calc_parity26(cfg.char_len_val26, cfg.parity_mode26))
            `uvm_info(get_type_name(), "Received26 Parity26 is same as calculated26 Parity26", UVM_MEDIUM)
          else if (checks_enable26)
            `uvm_error(get_type_name(), "####### FAIL26 :Received26 Parity26 doesn't match the calculated26 Parity26  ")
        end
        if (num_of_bits_rcvd26 == (1 + cfg.char_len_val26 + cfg.parity_en26)) begin // sending26 "stop/error bits"
          for (int i = 0; i < cfg.nbstop26; i++) begin
            wait (sample_clk26);
            cur_frame26.stop_bits26[i] = serial_b26;
            `uvm_info(get_type_name(), $psprintf("Received26 a Stop bit: 'b%0b", cur_frame26.stop_bits26[i]), UVM_HIGH)
            num_of_bits_rcvd26++;
            wait (!sample_clk26);
          end
        end
        wait (!sample_clk26);
      end
    end
 num_frames26++; 
 `uvm_info(get_type_name(), $psprintf("Collected26 the following26 Frame26 No:%0d\n%s", num_frames26, cur_frame26.sprint()), UVM_MEDIUM)

  if(coverage_enable26) perform_coverage26();
  frame_collected_port26.write(cur_frame26);
  this.end_tr(cur_frame26);
endtask : collect_frame26

function void uart_monitor26::perform_coverage26();
  uart_trans_frame_cg26.sample();
endfunction : perform_coverage26

`endif

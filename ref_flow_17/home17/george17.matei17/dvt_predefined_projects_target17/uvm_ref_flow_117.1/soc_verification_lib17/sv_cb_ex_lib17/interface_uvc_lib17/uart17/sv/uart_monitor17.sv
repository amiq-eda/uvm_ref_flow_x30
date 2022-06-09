/*-------------------------------------------------------------------------
File17 name   : uart_monitor17.sv
Title17       : monitor17 file for uart17 uvc17
Project17     :
Created17     :
Description17 : Descirbes17 UART17 Monitor17. Rx17/Tx17 monitors17 should be derived17 form17
            : this uart_monitor17 base class
Notes17       :  
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH17
`define UART_MONITOR_SVH17

virtual class uart_monitor17 extends uvm_monitor;
   uvm_analysis_port #(uart_frame17) frame_collected_port17;

  // virtual interface 
  virtual interface uart_if17 vif17;

  // Handle17 to  a cfg class
  uart_config17 cfg; 

  int num_frames17;
  bit sample_clk17;
  bit baud_clk17;
  bit [15:0] ua_brgr17;
  bit [7:0] ua_bdiv17;
  int num_of_bits_rcvd17;
  int transmit_delay17;
  bit sop_detected17;
  bit tmp_bit017;
  bit serial_d117;
  bit serial_bit17;
  bit serial_b17;
  bit [1:0]  msb_lsb_data17;

  bit checks_enable17 = 1;   // enable protocol17 checking
  bit coverage_enable17 = 1; // control17 coverage17 in the monitor17
  uart_frame17 cur_frame17;

  `uvm_field_utils_begin(uart_monitor17)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable17, UVM_DEFAULT)
      `uvm_field_int(coverage_enable17, UVM_DEFAULT)
      `uvm_field_object(cur_frame17, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg17;
    NUM_STOP_BITS17 : coverpoint cfg.nbstop17 {
      bins ONE17 = {0};
      bins TWO17 = {1};
    }
    DATA_LENGTH17 : coverpoint cfg.char_length17 {
      bins EIGHT17 = {0,1};
      bins SEVEN17 = {2};
      bins SIX17 = {3};
    }
    PARITY_MODE17 : coverpoint cfg.parity_mode17 {
      bins EVEN17  = {0};
      bins ODD17   = {1};
      bins SPACE17 = {2};
      bins MARK17  = {3};
    }
    PARITY_ERROR17: coverpoint cur_frame17.error_bits17[1]
      {
        bins good17 = { 0 };
        bins bad17 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE17: cross DATA_LENGTH17, PARITY_MODE17;
    PARITY_ERROR_x_PARITY_MODE17: cross PARITY_ERROR17, PARITY_MODE17;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg17 = new();
    uart_trans_frame_cg17.set_inst_name ("uart_trans_frame_cg17");
    frame_collected_port17 = new("frame_collected_port17", this);
  endfunction: new

  // Additional17 class methods17;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate17(ref bit [15:0] ua_brgr17, ref bit sample_clk17, ref bit sop_detected17);
  extern virtual task start_synchronizer17(ref bit serial_d117, ref bit serial_b17);
  extern virtual protected function void perform_coverage17();
  extern virtual task collect_frame17();
  extern virtual task wait_for_sop17(ref bit sop_detected17);
  extern virtual task sample_and_store17();
endclass: uart_monitor17

// UVM build_phase
function void uart_monitor17::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config17)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG17", "uart_config17 not set for this somponent17")
endfunction : build_phase

function void uart_monitor17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if17)::get(this, "","vif17",vif17))
      `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
endfunction : connect_phase

task uart_monitor17::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start17 Running17", UVM_LOW)
  @(negedge vif17.reset); 
  wait (vif17.reset);
  `uvm_info(get_type_name(), "Detected17 Reset17 Done17", UVM_LOW)
  num_frames17 = 0;
  cur_frame17 = uart_frame17::type_id::create("cur_frame17", this);

  fork
    gen_sample_rate17(ua_brgr17, sample_clk17, sop_detected17);
    start_synchronizer17(serial_d117, serial_b17);
    sample_and_store17();
  join
endtask : run_phase

task uart_monitor17::gen_sample_rate17(ref bit [15:0] ua_brgr17, ref bit sample_clk17, ref bit sop_detected17);
    forever begin
      @(posedge vif17.clock17);
      if ((!vif17.reset) || (sop_detected17)) begin
        `uvm_info(get_type_name(), "sample_clk17- resetting17 ua_brgr17", UVM_HIGH)
        ua_brgr17 = 0;
        sample_clk17 = 0;
        sop_detected17 = 0;
      end else begin
        if ( ua_brgr17 == ({cfg.baud_rate_div17, cfg.baud_rate_gen17})) begin
          ua_brgr17 = 0;
          sample_clk17 = 1;
        end else begin
          sample_clk17 = 0;
          ua_brgr17++;
        end
      end
    end
endtask

task uart_monitor17::start_synchronizer17(ref bit serial_d117, ref bit serial_b17);
endtask

task uart_monitor17::sample_and_store17();
  forever begin
    wait_for_sop17(sop_detected17);
    collect_frame17();
  end
endtask : sample_and_store17

task uart_monitor17::wait_for_sop17(ref bit sop_detected17);
    transmit_delay17 = 0;
    sop_detected17 = 0;
    while (!sop_detected17) begin
      `uvm_info(get_type_name(), "trying17 to detect17 SOP17", UVM_MEDIUM)
      while (!(serial_d117 == 1 && serial_b17 == 0)) begin
        @(negedge vif17.clock17);
        transmit_delay17++;
      end
      if (serial_b17 != 0)
        `uvm_info(get_type_name(), "Encountered17 a glitch17 in serial17 during SOP17, shall17 continue", UVM_LOW)
      else
      begin
        sop_detected17 = 1;
        `uvm_info(get_type_name(), "SOP17 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop17
  

task uart_monitor17::collect_frame17();
  bit [7:0] payload_byte17;
  cur_frame17 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting17 a frame17: %0d", num_frames17+1), UVM_HIGH)
   // Begin17 Transaction17 Recording17
  void'(this.begin_tr(cur_frame17, "UART17 Monitor17", , get_full_name()));
  cur_frame17.transmit_delay17 = transmit_delay17;
  cur_frame17.start_bit17 = 1'b0;
  cur_frame17.parity_type17 = GOOD_PARITY17;
  num_of_bits_rcvd17 = 0;

    while (num_of_bits_rcvd17 < (1 + cfg.char_len_val17 + cfg.parity_en17 + cfg.nbstop17))
    begin
      @(posedge vif17.clock17);
      #1;
      if (sample_clk17) begin
        num_of_bits_rcvd17++;
        if ((num_of_bits_rcvd17 > 0) && (num_of_bits_rcvd17 <= cfg.char_len_val17)) begin // sending17 "data bits" 
          cur_frame17.payload17[num_of_bits_rcvd17-1] = serial_b17;
          payload_byte17 = cur_frame17.payload17[num_of_bits_rcvd17-1];
          `uvm_info(get_type_name(), $psprintf("Received17 a Frame17 data bit:'b%0b", payload_byte17), UVM_HIGH)
        end
        msb_lsb_data17[0] =  cur_frame17.payload17[0] ;
        msb_lsb_data17[1] =  cur_frame17.payload17[cfg.char_len_val17-1] ;
        if ((num_of_bits_rcvd17 == (1 + cfg.char_len_val17)) && (cfg.parity_en17)) begin // sending17 "parity17 bit" if parity17 is enabled
          cur_frame17.parity17 = serial_b17;
          `uvm_info(get_type_name(), $psprintf("Received17 Parity17 bit:'b%0b", cur_frame17.parity17), UVM_HIGH)
          if (serial_b17 == cur_frame17.calc_parity17(cfg.char_len_val17, cfg.parity_mode17))
            `uvm_info(get_type_name(), "Received17 Parity17 is same as calculated17 Parity17", UVM_MEDIUM)
          else if (checks_enable17)
            `uvm_error(get_type_name(), "####### FAIL17 :Received17 Parity17 doesn't match the calculated17 Parity17  ")
        end
        if (num_of_bits_rcvd17 == (1 + cfg.char_len_val17 + cfg.parity_en17)) begin // sending17 "stop/error bits"
          for (int i = 0; i < cfg.nbstop17; i++) begin
            wait (sample_clk17);
            cur_frame17.stop_bits17[i] = serial_b17;
            `uvm_info(get_type_name(), $psprintf("Received17 a Stop bit: 'b%0b", cur_frame17.stop_bits17[i]), UVM_HIGH)
            num_of_bits_rcvd17++;
            wait (!sample_clk17);
          end
        end
        wait (!sample_clk17);
      end
    end
 num_frames17++; 
 `uvm_info(get_type_name(), $psprintf("Collected17 the following17 Frame17 No:%0d\n%s", num_frames17, cur_frame17.sprint()), UVM_MEDIUM)

  if(coverage_enable17) perform_coverage17();
  frame_collected_port17.write(cur_frame17);
  this.end_tr(cur_frame17);
endtask : collect_frame17

function void uart_monitor17::perform_coverage17();
  uart_trans_frame_cg17.sample();
endfunction : perform_coverage17

`endif

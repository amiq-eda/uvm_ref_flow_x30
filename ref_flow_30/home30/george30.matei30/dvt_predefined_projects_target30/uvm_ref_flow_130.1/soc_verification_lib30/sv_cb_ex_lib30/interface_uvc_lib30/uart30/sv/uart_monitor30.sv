/*-------------------------------------------------------------------------
File30 name   : uart_monitor30.sv
Title30       : monitor30 file for uart30 uvc30
Project30     :
Created30     :
Description30 : Descirbes30 UART30 Monitor30. Rx30/Tx30 monitors30 should be derived30 form30
            : this uart_monitor30 base class
Notes30       :  
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH30
`define UART_MONITOR_SVH30

virtual class uart_monitor30 extends uvm_monitor;
   uvm_analysis_port #(uart_frame30) frame_collected_port30;

  // virtual interface 
  virtual interface uart_if30 vif30;

  // Handle30 to  a cfg class
  uart_config30 cfg; 

  int num_frames30;
  bit sample_clk30;
  bit baud_clk30;
  bit [15:0] ua_brgr30;
  bit [7:0] ua_bdiv30;
  int num_of_bits_rcvd30;
  int transmit_delay30;
  bit sop_detected30;
  bit tmp_bit030;
  bit serial_d130;
  bit serial_bit30;
  bit serial_b30;
  bit [1:0]  msb_lsb_data30;

  bit checks_enable30 = 1;   // enable protocol30 checking
  bit coverage_enable30 = 1; // control30 coverage30 in the monitor30
  uart_frame30 cur_frame30;

  `uvm_field_utils_begin(uart_monitor30)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable30, UVM_DEFAULT)
      `uvm_field_int(coverage_enable30, UVM_DEFAULT)
      `uvm_field_object(cur_frame30, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg30;
    NUM_STOP_BITS30 : coverpoint cfg.nbstop30 {
      bins ONE30 = {0};
      bins TWO30 = {1};
    }
    DATA_LENGTH30 : coverpoint cfg.char_length30 {
      bins EIGHT30 = {0,1};
      bins SEVEN30 = {2};
      bins SIX30 = {3};
    }
    PARITY_MODE30 : coverpoint cfg.parity_mode30 {
      bins EVEN30  = {0};
      bins ODD30   = {1};
      bins SPACE30 = {2};
      bins MARK30  = {3};
    }
    PARITY_ERROR30: coverpoint cur_frame30.error_bits30[1]
      {
        bins good30 = { 0 };
        bins bad30 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE30: cross DATA_LENGTH30, PARITY_MODE30;
    PARITY_ERROR_x_PARITY_MODE30: cross PARITY_ERROR30, PARITY_MODE30;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg30 = new();
    uart_trans_frame_cg30.set_inst_name ("uart_trans_frame_cg30");
    frame_collected_port30 = new("frame_collected_port30", this);
  endfunction: new

  // Additional30 class methods30;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate30(ref bit [15:0] ua_brgr30, ref bit sample_clk30, ref bit sop_detected30);
  extern virtual task start_synchronizer30(ref bit serial_d130, ref bit serial_b30);
  extern virtual protected function void perform_coverage30();
  extern virtual task collect_frame30();
  extern virtual task wait_for_sop30(ref bit sop_detected30);
  extern virtual task sample_and_store30();
endclass: uart_monitor30

// UVM build_phase
function void uart_monitor30::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config30)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG30", "uart_config30 not set for this somponent30")
endfunction : build_phase

function void uart_monitor30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if30)::get(this, "","vif30",vif30))
      `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".vif30"})
endfunction : connect_phase

task uart_monitor30::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start30 Running30", UVM_LOW)
  @(negedge vif30.reset); 
  wait (vif30.reset);
  `uvm_info(get_type_name(), "Detected30 Reset30 Done30", UVM_LOW)
  num_frames30 = 0;
  cur_frame30 = uart_frame30::type_id::create("cur_frame30", this);

  fork
    gen_sample_rate30(ua_brgr30, sample_clk30, sop_detected30);
    start_synchronizer30(serial_d130, serial_b30);
    sample_and_store30();
  join
endtask : run_phase

task uart_monitor30::gen_sample_rate30(ref bit [15:0] ua_brgr30, ref bit sample_clk30, ref bit sop_detected30);
    forever begin
      @(posedge vif30.clock30);
      if ((!vif30.reset) || (sop_detected30)) begin
        `uvm_info(get_type_name(), "sample_clk30- resetting30 ua_brgr30", UVM_HIGH)
        ua_brgr30 = 0;
        sample_clk30 = 0;
        sop_detected30 = 0;
      end else begin
        if ( ua_brgr30 == ({cfg.baud_rate_div30, cfg.baud_rate_gen30})) begin
          ua_brgr30 = 0;
          sample_clk30 = 1;
        end else begin
          sample_clk30 = 0;
          ua_brgr30++;
        end
      end
    end
endtask

task uart_monitor30::start_synchronizer30(ref bit serial_d130, ref bit serial_b30);
endtask

task uart_monitor30::sample_and_store30();
  forever begin
    wait_for_sop30(sop_detected30);
    collect_frame30();
  end
endtask : sample_and_store30

task uart_monitor30::wait_for_sop30(ref bit sop_detected30);
    transmit_delay30 = 0;
    sop_detected30 = 0;
    while (!sop_detected30) begin
      `uvm_info(get_type_name(), "trying30 to detect30 SOP30", UVM_MEDIUM)
      while (!(serial_d130 == 1 && serial_b30 == 0)) begin
        @(negedge vif30.clock30);
        transmit_delay30++;
      end
      if (serial_b30 != 0)
        `uvm_info(get_type_name(), "Encountered30 a glitch30 in serial30 during SOP30, shall30 continue", UVM_LOW)
      else
      begin
        sop_detected30 = 1;
        `uvm_info(get_type_name(), "SOP30 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop30
  

task uart_monitor30::collect_frame30();
  bit [7:0] payload_byte30;
  cur_frame30 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting30 a frame30: %0d", num_frames30+1), UVM_HIGH)
   // Begin30 Transaction30 Recording30
  void'(this.begin_tr(cur_frame30, "UART30 Monitor30", , get_full_name()));
  cur_frame30.transmit_delay30 = transmit_delay30;
  cur_frame30.start_bit30 = 1'b0;
  cur_frame30.parity_type30 = GOOD_PARITY30;
  num_of_bits_rcvd30 = 0;

    while (num_of_bits_rcvd30 < (1 + cfg.char_len_val30 + cfg.parity_en30 + cfg.nbstop30))
    begin
      @(posedge vif30.clock30);
      #1;
      if (sample_clk30) begin
        num_of_bits_rcvd30++;
        if ((num_of_bits_rcvd30 > 0) && (num_of_bits_rcvd30 <= cfg.char_len_val30)) begin // sending30 "data bits" 
          cur_frame30.payload30[num_of_bits_rcvd30-1] = serial_b30;
          payload_byte30 = cur_frame30.payload30[num_of_bits_rcvd30-1];
          `uvm_info(get_type_name(), $psprintf("Received30 a Frame30 data bit:'b%0b", payload_byte30), UVM_HIGH)
        end
        msb_lsb_data30[0] =  cur_frame30.payload30[0] ;
        msb_lsb_data30[1] =  cur_frame30.payload30[cfg.char_len_val30-1] ;
        if ((num_of_bits_rcvd30 == (1 + cfg.char_len_val30)) && (cfg.parity_en30)) begin // sending30 "parity30 bit" if parity30 is enabled
          cur_frame30.parity30 = serial_b30;
          `uvm_info(get_type_name(), $psprintf("Received30 Parity30 bit:'b%0b", cur_frame30.parity30), UVM_HIGH)
          if (serial_b30 == cur_frame30.calc_parity30(cfg.char_len_val30, cfg.parity_mode30))
            `uvm_info(get_type_name(), "Received30 Parity30 is same as calculated30 Parity30", UVM_MEDIUM)
          else if (checks_enable30)
            `uvm_error(get_type_name(), "####### FAIL30 :Received30 Parity30 doesn't match the calculated30 Parity30  ")
        end
        if (num_of_bits_rcvd30 == (1 + cfg.char_len_val30 + cfg.parity_en30)) begin // sending30 "stop/error bits"
          for (int i = 0; i < cfg.nbstop30; i++) begin
            wait (sample_clk30);
            cur_frame30.stop_bits30[i] = serial_b30;
            `uvm_info(get_type_name(), $psprintf("Received30 a Stop bit: 'b%0b", cur_frame30.stop_bits30[i]), UVM_HIGH)
            num_of_bits_rcvd30++;
            wait (!sample_clk30);
          end
        end
        wait (!sample_clk30);
      end
    end
 num_frames30++; 
 `uvm_info(get_type_name(), $psprintf("Collected30 the following30 Frame30 No:%0d\n%s", num_frames30, cur_frame30.sprint()), UVM_MEDIUM)

  if(coverage_enable30) perform_coverage30();
  frame_collected_port30.write(cur_frame30);
  this.end_tr(cur_frame30);
endtask : collect_frame30

function void uart_monitor30::perform_coverage30();
  uart_trans_frame_cg30.sample();
endfunction : perform_coverage30

`endif

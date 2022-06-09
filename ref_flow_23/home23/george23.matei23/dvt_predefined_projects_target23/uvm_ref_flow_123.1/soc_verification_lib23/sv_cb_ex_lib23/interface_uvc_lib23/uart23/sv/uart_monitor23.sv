/*-------------------------------------------------------------------------
File23 name   : uart_monitor23.sv
Title23       : monitor23 file for uart23 uvc23
Project23     :
Created23     :
Description23 : Descirbes23 UART23 Monitor23. Rx23/Tx23 monitors23 should be derived23 form23
            : this uart_monitor23 base class
Notes23       :  
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH23
`define UART_MONITOR_SVH23

virtual class uart_monitor23 extends uvm_monitor;
   uvm_analysis_port #(uart_frame23) frame_collected_port23;

  // virtual interface 
  virtual interface uart_if23 vif23;

  // Handle23 to  a cfg class
  uart_config23 cfg; 

  int num_frames23;
  bit sample_clk23;
  bit baud_clk23;
  bit [15:0] ua_brgr23;
  bit [7:0] ua_bdiv23;
  int num_of_bits_rcvd23;
  int transmit_delay23;
  bit sop_detected23;
  bit tmp_bit023;
  bit serial_d123;
  bit serial_bit23;
  bit serial_b23;
  bit [1:0]  msb_lsb_data23;

  bit checks_enable23 = 1;   // enable protocol23 checking
  bit coverage_enable23 = 1; // control23 coverage23 in the monitor23
  uart_frame23 cur_frame23;

  `uvm_field_utils_begin(uart_monitor23)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable23, UVM_DEFAULT)
      `uvm_field_int(coverage_enable23, UVM_DEFAULT)
      `uvm_field_object(cur_frame23, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg23;
    NUM_STOP_BITS23 : coverpoint cfg.nbstop23 {
      bins ONE23 = {0};
      bins TWO23 = {1};
    }
    DATA_LENGTH23 : coverpoint cfg.char_length23 {
      bins EIGHT23 = {0,1};
      bins SEVEN23 = {2};
      bins SIX23 = {3};
    }
    PARITY_MODE23 : coverpoint cfg.parity_mode23 {
      bins EVEN23  = {0};
      bins ODD23   = {1};
      bins SPACE23 = {2};
      bins MARK23  = {3};
    }
    PARITY_ERROR23: coverpoint cur_frame23.error_bits23[1]
      {
        bins good23 = { 0 };
        bins bad23 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE23: cross DATA_LENGTH23, PARITY_MODE23;
    PARITY_ERROR_x_PARITY_MODE23: cross PARITY_ERROR23, PARITY_MODE23;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg23 = new();
    uart_trans_frame_cg23.set_inst_name ("uart_trans_frame_cg23");
    frame_collected_port23 = new("frame_collected_port23", this);
  endfunction: new

  // Additional23 class methods23;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate23(ref bit [15:0] ua_brgr23, ref bit sample_clk23, ref bit sop_detected23);
  extern virtual task start_synchronizer23(ref bit serial_d123, ref bit serial_b23);
  extern virtual protected function void perform_coverage23();
  extern virtual task collect_frame23();
  extern virtual task wait_for_sop23(ref bit sop_detected23);
  extern virtual task sample_and_store23();
endclass: uart_monitor23

// UVM build_phase
function void uart_monitor23::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config23)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG23", "uart_config23 not set for this somponent23")
endfunction : build_phase

function void uart_monitor23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if23)::get(this, "","vif23",vif23))
      `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".vif23"})
endfunction : connect_phase

task uart_monitor23::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start23 Running23", UVM_LOW)
  @(negedge vif23.reset); 
  wait (vif23.reset);
  `uvm_info(get_type_name(), "Detected23 Reset23 Done23", UVM_LOW)
  num_frames23 = 0;
  cur_frame23 = uart_frame23::type_id::create("cur_frame23", this);

  fork
    gen_sample_rate23(ua_brgr23, sample_clk23, sop_detected23);
    start_synchronizer23(serial_d123, serial_b23);
    sample_and_store23();
  join
endtask : run_phase

task uart_monitor23::gen_sample_rate23(ref bit [15:0] ua_brgr23, ref bit sample_clk23, ref bit sop_detected23);
    forever begin
      @(posedge vif23.clock23);
      if ((!vif23.reset) || (sop_detected23)) begin
        `uvm_info(get_type_name(), "sample_clk23- resetting23 ua_brgr23", UVM_HIGH)
        ua_brgr23 = 0;
        sample_clk23 = 0;
        sop_detected23 = 0;
      end else begin
        if ( ua_brgr23 == ({cfg.baud_rate_div23, cfg.baud_rate_gen23})) begin
          ua_brgr23 = 0;
          sample_clk23 = 1;
        end else begin
          sample_clk23 = 0;
          ua_brgr23++;
        end
      end
    end
endtask

task uart_monitor23::start_synchronizer23(ref bit serial_d123, ref bit serial_b23);
endtask

task uart_monitor23::sample_and_store23();
  forever begin
    wait_for_sop23(sop_detected23);
    collect_frame23();
  end
endtask : sample_and_store23

task uart_monitor23::wait_for_sop23(ref bit sop_detected23);
    transmit_delay23 = 0;
    sop_detected23 = 0;
    while (!sop_detected23) begin
      `uvm_info(get_type_name(), "trying23 to detect23 SOP23", UVM_MEDIUM)
      while (!(serial_d123 == 1 && serial_b23 == 0)) begin
        @(negedge vif23.clock23);
        transmit_delay23++;
      end
      if (serial_b23 != 0)
        `uvm_info(get_type_name(), "Encountered23 a glitch23 in serial23 during SOP23, shall23 continue", UVM_LOW)
      else
      begin
        sop_detected23 = 1;
        `uvm_info(get_type_name(), "SOP23 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop23
  

task uart_monitor23::collect_frame23();
  bit [7:0] payload_byte23;
  cur_frame23 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting23 a frame23: %0d", num_frames23+1), UVM_HIGH)
   // Begin23 Transaction23 Recording23
  void'(this.begin_tr(cur_frame23, "UART23 Monitor23", , get_full_name()));
  cur_frame23.transmit_delay23 = transmit_delay23;
  cur_frame23.start_bit23 = 1'b0;
  cur_frame23.parity_type23 = GOOD_PARITY23;
  num_of_bits_rcvd23 = 0;

    while (num_of_bits_rcvd23 < (1 + cfg.char_len_val23 + cfg.parity_en23 + cfg.nbstop23))
    begin
      @(posedge vif23.clock23);
      #1;
      if (sample_clk23) begin
        num_of_bits_rcvd23++;
        if ((num_of_bits_rcvd23 > 0) && (num_of_bits_rcvd23 <= cfg.char_len_val23)) begin // sending23 "data bits" 
          cur_frame23.payload23[num_of_bits_rcvd23-1] = serial_b23;
          payload_byte23 = cur_frame23.payload23[num_of_bits_rcvd23-1];
          `uvm_info(get_type_name(), $psprintf("Received23 a Frame23 data bit:'b%0b", payload_byte23), UVM_HIGH)
        end
        msb_lsb_data23[0] =  cur_frame23.payload23[0] ;
        msb_lsb_data23[1] =  cur_frame23.payload23[cfg.char_len_val23-1] ;
        if ((num_of_bits_rcvd23 == (1 + cfg.char_len_val23)) && (cfg.parity_en23)) begin // sending23 "parity23 bit" if parity23 is enabled
          cur_frame23.parity23 = serial_b23;
          `uvm_info(get_type_name(), $psprintf("Received23 Parity23 bit:'b%0b", cur_frame23.parity23), UVM_HIGH)
          if (serial_b23 == cur_frame23.calc_parity23(cfg.char_len_val23, cfg.parity_mode23))
            `uvm_info(get_type_name(), "Received23 Parity23 is same as calculated23 Parity23", UVM_MEDIUM)
          else if (checks_enable23)
            `uvm_error(get_type_name(), "####### FAIL23 :Received23 Parity23 doesn't match the calculated23 Parity23  ")
        end
        if (num_of_bits_rcvd23 == (1 + cfg.char_len_val23 + cfg.parity_en23)) begin // sending23 "stop/error bits"
          for (int i = 0; i < cfg.nbstop23; i++) begin
            wait (sample_clk23);
            cur_frame23.stop_bits23[i] = serial_b23;
            `uvm_info(get_type_name(), $psprintf("Received23 a Stop bit: 'b%0b", cur_frame23.stop_bits23[i]), UVM_HIGH)
            num_of_bits_rcvd23++;
            wait (!sample_clk23);
          end
        end
        wait (!sample_clk23);
      end
    end
 num_frames23++; 
 `uvm_info(get_type_name(), $psprintf("Collected23 the following23 Frame23 No:%0d\n%s", num_frames23, cur_frame23.sprint()), UVM_MEDIUM)

  if(coverage_enable23) perform_coverage23();
  frame_collected_port23.write(cur_frame23);
  this.end_tr(cur_frame23);
endtask : collect_frame23

function void uart_monitor23::perform_coverage23();
  uart_trans_frame_cg23.sample();
endfunction : perform_coverage23

`endif

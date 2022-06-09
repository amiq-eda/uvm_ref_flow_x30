/*-------------------------------------------------------------------------
File29 name   : uart_monitor29.sv
Title29       : monitor29 file for uart29 uvc29
Project29     :
Created29     :
Description29 : Descirbes29 UART29 Monitor29. Rx29/Tx29 monitors29 should be derived29 form29
            : this uart_monitor29 base class
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH29
`define UART_MONITOR_SVH29

virtual class uart_monitor29 extends uvm_monitor;
   uvm_analysis_port #(uart_frame29) frame_collected_port29;

  // virtual interface 
  virtual interface uart_if29 vif29;

  // Handle29 to  a cfg class
  uart_config29 cfg; 

  int num_frames29;
  bit sample_clk29;
  bit baud_clk29;
  bit [15:0] ua_brgr29;
  bit [7:0] ua_bdiv29;
  int num_of_bits_rcvd29;
  int transmit_delay29;
  bit sop_detected29;
  bit tmp_bit029;
  bit serial_d129;
  bit serial_bit29;
  bit serial_b29;
  bit [1:0]  msb_lsb_data29;

  bit checks_enable29 = 1;   // enable protocol29 checking
  bit coverage_enable29 = 1; // control29 coverage29 in the monitor29
  uart_frame29 cur_frame29;

  `uvm_field_utils_begin(uart_monitor29)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable29, UVM_DEFAULT)
      `uvm_field_int(coverage_enable29, UVM_DEFAULT)
      `uvm_field_object(cur_frame29, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg29;
    NUM_STOP_BITS29 : coverpoint cfg.nbstop29 {
      bins ONE29 = {0};
      bins TWO29 = {1};
    }
    DATA_LENGTH29 : coverpoint cfg.char_length29 {
      bins EIGHT29 = {0,1};
      bins SEVEN29 = {2};
      bins SIX29 = {3};
    }
    PARITY_MODE29 : coverpoint cfg.parity_mode29 {
      bins EVEN29  = {0};
      bins ODD29   = {1};
      bins SPACE29 = {2};
      bins MARK29  = {3};
    }
    PARITY_ERROR29: coverpoint cur_frame29.error_bits29[1]
      {
        bins good29 = { 0 };
        bins bad29 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE29: cross DATA_LENGTH29, PARITY_MODE29;
    PARITY_ERROR_x_PARITY_MODE29: cross PARITY_ERROR29, PARITY_MODE29;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg29 = new();
    uart_trans_frame_cg29.set_inst_name ("uart_trans_frame_cg29");
    frame_collected_port29 = new("frame_collected_port29", this);
  endfunction: new

  // Additional29 class methods29;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate29(ref bit [15:0] ua_brgr29, ref bit sample_clk29, ref bit sop_detected29);
  extern virtual task start_synchronizer29(ref bit serial_d129, ref bit serial_b29);
  extern virtual protected function void perform_coverage29();
  extern virtual task collect_frame29();
  extern virtual task wait_for_sop29(ref bit sop_detected29);
  extern virtual task sample_and_store29();
endclass: uart_monitor29

// UVM build_phase
function void uart_monitor29::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config29)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG29", "uart_config29 not set for this somponent29")
endfunction : build_phase

function void uart_monitor29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if29)::get(this, "","vif29",vif29))
      `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".vif29"})
endfunction : connect_phase

task uart_monitor29::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start29 Running29", UVM_LOW)
  @(negedge vif29.reset); 
  wait (vif29.reset);
  `uvm_info(get_type_name(), "Detected29 Reset29 Done29", UVM_LOW)
  num_frames29 = 0;
  cur_frame29 = uart_frame29::type_id::create("cur_frame29", this);

  fork
    gen_sample_rate29(ua_brgr29, sample_clk29, sop_detected29);
    start_synchronizer29(serial_d129, serial_b29);
    sample_and_store29();
  join
endtask : run_phase

task uart_monitor29::gen_sample_rate29(ref bit [15:0] ua_brgr29, ref bit sample_clk29, ref bit sop_detected29);
    forever begin
      @(posedge vif29.clock29);
      if ((!vif29.reset) || (sop_detected29)) begin
        `uvm_info(get_type_name(), "sample_clk29- resetting29 ua_brgr29", UVM_HIGH)
        ua_brgr29 = 0;
        sample_clk29 = 0;
        sop_detected29 = 0;
      end else begin
        if ( ua_brgr29 == ({cfg.baud_rate_div29, cfg.baud_rate_gen29})) begin
          ua_brgr29 = 0;
          sample_clk29 = 1;
        end else begin
          sample_clk29 = 0;
          ua_brgr29++;
        end
      end
    end
endtask

task uart_monitor29::start_synchronizer29(ref bit serial_d129, ref bit serial_b29);
endtask

task uart_monitor29::sample_and_store29();
  forever begin
    wait_for_sop29(sop_detected29);
    collect_frame29();
  end
endtask : sample_and_store29

task uart_monitor29::wait_for_sop29(ref bit sop_detected29);
    transmit_delay29 = 0;
    sop_detected29 = 0;
    while (!sop_detected29) begin
      `uvm_info(get_type_name(), "trying29 to detect29 SOP29", UVM_MEDIUM)
      while (!(serial_d129 == 1 && serial_b29 == 0)) begin
        @(negedge vif29.clock29);
        transmit_delay29++;
      end
      if (serial_b29 != 0)
        `uvm_info(get_type_name(), "Encountered29 a glitch29 in serial29 during SOP29, shall29 continue", UVM_LOW)
      else
      begin
        sop_detected29 = 1;
        `uvm_info(get_type_name(), "SOP29 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop29
  

task uart_monitor29::collect_frame29();
  bit [7:0] payload_byte29;
  cur_frame29 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting29 a frame29: %0d", num_frames29+1), UVM_HIGH)
   // Begin29 Transaction29 Recording29
  void'(this.begin_tr(cur_frame29, "UART29 Monitor29", , get_full_name()));
  cur_frame29.transmit_delay29 = transmit_delay29;
  cur_frame29.start_bit29 = 1'b0;
  cur_frame29.parity_type29 = GOOD_PARITY29;
  num_of_bits_rcvd29 = 0;

    while (num_of_bits_rcvd29 < (1 + cfg.char_len_val29 + cfg.parity_en29 + cfg.nbstop29))
    begin
      @(posedge vif29.clock29);
      #1;
      if (sample_clk29) begin
        num_of_bits_rcvd29++;
        if ((num_of_bits_rcvd29 > 0) && (num_of_bits_rcvd29 <= cfg.char_len_val29)) begin // sending29 "data bits" 
          cur_frame29.payload29[num_of_bits_rcvd29-1] = serial_b29;
          payload_byte29 = cur_frame29.payload29[num_of_bits_rcvd29-1];
          `uvm_info(get_type_name(), $psprintf("Received29 a Frame29 data bit:'b%0b", payload_byte29), UVM_HIGH)
        end
        msb_lsb_data29[0] =  cur_frame29.payload29[0] ;
        msb_lsb_data29[1] =  cur_frame29.payload29[cfg.char_len_val29-1] ;
        if ((num_of_bits_rcvd29 == (1 + cfg.char_len_val29)) && (cfg.parity_en29)) begin // sending29 "parity29 bit" if parity29 is enabled
          cur_frame29.parity29 = serial_b29;
          `uvm_info(get_type_name(), $psprintf("Received29 Parity29 bit:'b%0b", cur_frame29.parity29), UVM_HIGH)
          if (serial_b29 == cur_frame29.calc_parity29(cfg.char_len_val29, cfg.parity_mode29))
            `uvm_info(get_type_name(), "Received29 Parity29 is same as calculated29 Parity29", UVM_MEDIUM)
          else if (checks_enable29)
            `uvm_error(get_type_name(), "####### FAIL29 :Received29 Parity29 doesn't match the calculated29 Parity29  ")
        end
        if (num_of_bits_rcvd29 == (1 + cfg.char_len_val29 + cfg.parity_en29)) begin // sending29 "stop/error bits"
          for (int i = 0; i < cfg.nbstop29; i++) begin
            wait (sample_clk29);
            cur_frame29.stop_bits29[i] = serial_b29;
            `uvm_info(get_type_name(), $psprintf("Received29 a Stop bit: 'b%0b", cur_frame29.stop_bits29[i]), UVM_HIGH)
            num_of_bits_rcvd29++;
            wait (!sample_clk29);
          end
        end
        wait (!sample_clk29);
      end
    end
 num_frames29++; 
 `uvm_info(get_type_name(), $psprintf("Collected29 the following29 Frame29 No:%0d\n%s", num_frames29, cur_frame29.sprint()), UVM_MEDIUM)

  if(coverage_enable29) perform_coverage29();
  frame_collected_port29.write(cur_frame29);
  this.end_tr(cur_frame29);
endtask : collect_frame29

function void uart_monitor29::perform_coverage29();
  uart_trans_frame_cg29.sample();
endfunction : perform_coverage29

`endif

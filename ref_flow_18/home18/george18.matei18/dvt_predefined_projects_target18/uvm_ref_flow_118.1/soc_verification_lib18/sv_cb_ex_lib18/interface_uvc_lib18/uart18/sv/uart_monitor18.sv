/*-------------------------------------------------------------------------
File18 name   : uart_monitor18.sv
Title18       : monitor18 file for uart18 uvc18
Project18     :
Created18     :
Description18 : Descirbes18 UART18 Monitor18. Rx18/Tx18 monitors18 should be derived18 form18
            : this uart_monitor18 base class
Notes18       :  
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH18
`define UART_MONITOR_SVH18

virtual class uart_monitor18 extends uvm_monitor;
   uvm_analysis_port #(uart_frame18) frame_collected_port18;

  // virtual interface 
  virtual interface uart_if18 vif18;

  // Handle18 to  a cfg class
  uart_config18 cfg; 

  int num_frames18;
  bit sample_clk18;
  bit baud_clk18;
  bit [15:0] ua_brgr18;
  bit [7:0] ua_bdiv18;
  int num_of_bits_rcvd18;
  int transmit_delay18;
  bit sop_detected18;
  bit tmp_bit018;
  bit serial_d118;
  bit serial_bit18;
  bit serial_b18;
  bit [1:0]  msb_lsb_data18;

  bit checks_enable18 = 1;   // enable protocol18 checking
  bit coverage_enable18 = 1; // control18 coverage18 in the monitor18
  uart_frame18 cur_frame18;

  `uvm_field_utils_begin(uart_monitor18)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable18, UVM_DEFAULT)
      `uvm_field_int(coverage_enable18, UVM_DEFAULT)
      `uvm_field_object(cur_frame18, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg18;
    NUM_STOP_BITS18 : coverpoint cfg.nbstop18 {
      bins ONE18 = {0};
      bins TWO18 = {1};
    }
    DATA_LENGTH18 : coverpoint cfg.char_length18 {
      bins EIGHT18 = {0,1};
      bins SEVEN18 = {2};
      bins SIX18 = {3};
    }
    PARITY_MODE18 : coverpoint cfg.parity_mode18 {
      bins EVEN18  = {0};
      bins ODD18   = {1};
      bins SPACE18 = {2};
      bins MARK18  = {3};
    }
    PARITY_ERROR18: coverpoint cur_frame18.error_bits18[1]
      {
        bins good18 = { 0 };
        bins bad18 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE18: cross DATA_LENGTH18, PARITY_MODE18;
    PARITY_ERROR_x_PARITY_MODE18: cross PARITY_ERROR18, PARITY_MODE18;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg18 = new();
    uart_trans_frame_cg18.set_inst_name ("uart_trans_frame_cg18");
    frame_collected_port18 = new("frame_collected_port18", this);
  endfunction: new

  // Additional18 class methods18;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate18(ref bit [15:0] ua_brgr18, ref bit sample_clk18, ref bit sop_detected18);
  extern virtual task start_synchronizer18(ref bit serial_d118, ref bit serial_b18);
  extern virtual protected function void perform_coverage18();
  extern virtual task collect_frame18();
  extern virtual task wait_for_sop18(ref bit sop_detected18);
  extern virtual task sample_and_store18();
endclass: uart_monitor18

// UVM build_phase
function void uart_monitor18::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config18)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG18", "uart_config18 not set for this somponent18")
endfunction : build_phase

function void uart_monitor18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if18)::get(this, "","vif18",vif18))
      `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".vif18"})
endfunction : connect_phase

task uart_monitor18::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start18 Running18", UVM_LOW)
  @(negedge vif18.reset); 
  wait (vif18.reset);
  `uvm_info(get_type_name(), "Detected18 Reset18 Done18", UVM_LOW)
  num_frames18 = 0;
  cur_frame18 = uart_frame18::type_id::create("cur_frame18", this);

  fork
    gen_sample_rate18(ua_brgr18, sample_clk18, sop_detected18);
    start_synchronizer18(serial_d118, serial_b18);
    sample_and_store18();
  join
endtask : run_phase

task uart_monitor18::gen_sample_rate18(ref bit [15:0] ua_brgr18, ref bit sample_clk18, ref bit sop_detected18);
    forever begin
      @(posedge vif18.clock18);
      if ((!vif18.reset) || (sop_detected18)) begin
        `uvm_info(get_type_name(), "sample_clk18- resetting18 ua_brgr18", UVM_HIGH)
        ua_brgr18 = 0;
        sample_clk18 = 0;
        sop_detected18 = 0;
      end else begin
        if ( ua_brgr18 == ({cfg.baud_rate_div18, cfg.baud_rate_gen18})) begin
          ua_brgr18 = 0;
          sample_clk18 = 1;
        end else begin
          sample_clk18 = 0;
          ua_brgr18++;
        end
      end
    end
endtask

task uart_monitor18::start_synchronizer18(ref bit serial_d118, ref bit serial_b18);
endtask

task uart_monitor18::sample_and_store18();
  forever begin
    wait_for_sop18(sop_detected18);
    collect_frame18();
  end
endtask : sample_and_store18

task uart_monitor18::wait_for_sop18(ref bit sop_detected18);
    transmit_delay18 = 0;
    sop_detected18 = 0;
    while (!sop_detected18) begin
      `uvm_info(get_type_name(), "trying18 to detect18 SOP18", UVM_MEDIUM)
      while (!(serial_d118 == 1 && serial_b18 == 0)) begin
        @(negedge vif18.clock18);
        transmit_delay18++;
      end
      if (serial_b18 != 0)
        `uvm_info(get_type_name(), "Encountered18 a glitch18 in serial18 during SOP18, shall18 continue", UVM_LOW)
      else
      begin
        sop_detected18 = 1;
        `uvm_info(get_type_name(), "SOP18 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop18
  

task uart_monitor18::collect_frame18();
  bit [7:0] payload_byte18;
  cur_frame18 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting18 a frame18: %0d", num_frames18+1), UVM_HIGH)
   // Begin18 Transaction18 Recording18
  void'(this.begin_tr(cur_frame18, "UART18 Monitor18", , get_full_name()));
  cur_frame18.transmit_delay18 = transmit_delay18;
  cur_frame18.start_bit18 = 1'b0;
  cur_frame18.parity_type18 = GOOD_PARITY18;
  num_of_bits_rcvd18 = 0;

    while (num_of_bits_rcvd18 < (1 + cfg.char_len_val18 + cfg.parity_en18 + cfg.nbstop18))
    begin
      @(posedge vif18.clock18);
      #1;
      if (sample_clk18) begin
        num_of_bits_rcvd18++;
        if ((num_of_bits_rcvd18 > 0) && (num_of_bits_rcvd18 <= cfg.char_len_val18)) begin // sending18 "data bits" 
          cur_frame18.payload18[num_of_bits_rcvd18-1] = serial_b18;
          payload_byte18 = cur_frame18.payload18[num_of_bits_rcvd18-1];
          `uvm_info(get_type_name(), $psprintf("Received18 a Frame18 data bit:'b%0b", payload_byte18), UVM_HIGH)
        end
        msb_lsb_data18[0] =  cur_frame18.payload18[0] ;
        msb_lsb_data18[1] =  cur_frame18.payload18[cfg.char_len_val18-1] ;
        if ((num_of_bits_rcvd18 == (1 + cfg.char_len_val18)) && (cfg.parity_en18)) begin // sending18 "parity18 bit" if parity18 is enabled
          cur_frame18.parity18 = serial_b18;
          `uvm_info(get_type_name(), $psprintf("Received18 Parity18 bit:'b%0b", cur_frame18.parity18), UVM_HIGH)
          if (serial_b18 == cur_frame18.calc_parity18(cfg.char_len_val18, cfg.parity_mode18))
            `uvm_info(get_type_name(), "Received18 Parity18 is same as calculated18 Parity18", UVM_MEDIUM)
          else if (checks_enable18)
            `uvm_error(get_type_name(), "####### FAIL18 :Received18 Parity18 doesn't match the calculated18 Parity18  ")
        end
        if (num_of_bits_rcvd18 == (1 + cfg.char_len_val18 + cfg.parity_en18)) begin // sending18 "stop/error bits"
          for (int i = 0; i < cfg.nbstop18; i++) begin
            wait (sample_clk18);
            cur_frame18.stop_bits18[i] = serial_b18;
            `uvm_info(get_type_name(), $psprintf("Received18 a Stop bit: 'b%0b", cur_frame18.stop_bits18[i]), UVM_HIGH)
            num_of_bits_rcvd18++;
            wait (!sample_clk18);
          end
        end
        wait (!sample_clk18);
      end
    end
 num_frames18++; 
 `uvm_info(get_type_name(), $psprintf("Collected18 the following18 Frame18 No:%0d\n%s", num_frames18, cur_frame18.sprint()), UVM_MEDIUM)

  if(coverage_enable18) perform_coverage18();
  frame_collected_port18.write(cur_frame18);
  this.end_tr(cur_frame18);
endtask : collect_frame18

function void uart_monitor18::perform_coverage18();
  uart_trans_frame_cg18.sample();
endfunction : perform_coverage18

`endif

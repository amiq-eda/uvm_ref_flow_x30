/*-------------------------------------------------------------------------
File21 name   : uart_monitor21.sv
Title21       : monitor21 file for uart21 uvc21
Project21     :
Created21     :
Description21 : Descirbes21 UART21 Monitor21. Rx21/Tx21 monitors21 should be derived21 form21
            : this uart_monitor21 base class
Notes21       :  
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH21
`define UART_MONITOR_SVH21

virtual class uart_monitor21 extends uvm_monitor;
   uvm_analysis_port #(uart_frame21) frame_collected_port21;

  // virtual interface 
  virtual interface uart_if21 vif21;

  // Handle21 to  a cfg class
  uart_config21 cfg; 

  int num_frames21;
  bit sample_clk21;
  bit baud_clk21;
  bit [15:0] ua_brgr21;
  bit [7:0] ua_bdiv21;
  int num_of_bits_rcvd21;
  int transmit_delay21;
  bit sop_detected21;
  bit tmp_bit021;
  bit serial_d121;
  bit serial_bit21;
  bit serial_b21;
  bit [1:0]  msb_lsb_data21;

  bit checks_enable21 = 1;   // enable protocol21 checking
  bit coverage_enable21 = 1; // control21 coverage21 in the monitor21
  uart_frame21 cur_frame21;

  `uvm_field_utils_begin(uart_monitor21)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable21, UVM_DEFAULT)
      `uvm_field_int(coverage_enable21, UVM_DEFAULT)
      `uvm_field_object(cur_frame21, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg21;
    NUM_STOP_BITS21 : coverpoint cfg.nbstop21 {
      bins ONE21 = {0};
      bins TWO21 = {1};
    }
    DATA_LENGTH21 : coverpoint cfg.char_length21 {
      bins EIGHT21 = {0,1};
      bins SEVEN21 = {2};
      bins SIX21 = {3};
    }
    PARITY_MODE21 : coverpoint cfg.parity_mode21 {
      bins EVEN21  = {0};
      bins ODD21   = {1};
      bins SPACE21 = {2};
      bins MARK21  = {3};
    }
    PARITY_ERROR21: coverpoint cur_frame21.error_bits21[1]
      {
        bins good21 = { 0 };
        bins bad21 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE21: cross DATA_LENGTH21, PARITY_MODE21;
    PARITY_ERROR_x_PARITY_MODE21: cross PARITY_ERROR21, PARITY_MODE21;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg21 = new();
    uart_trans_frame_cg21.set_inst_name ("uart_trans_frame_cg21");
    frame_collected_port21 = new("frame_collected_port21", this);
  endfunction: new

  // Additional21 class methods21;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate21(ref bit [15:0] ua_brgr21, ref bit sample_clk21, ref bit sop_detected21);
  extern virtual task start_synchronizer21(ref bit serial_d121, ref bit serial_b21);
  extern virtual protected function void perform_coverage21();
  extern virtual task collect_frame21();
  extern virtual task wait_for_sop21(ref bit sop_detected21);
  extern virtual task sample_and_store21();
endclass: uart_monitor21

// UVM build_phase
function void uart_monitor21::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config21)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG21", "uart_config21 not set for this somponent21")
endfunction : build_phase

function void uart_monitor21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if21)::get(this, "","vif21",vif21))
      `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".vif21"})
endfunction : connect_phase

task uart_monitor21::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start21 Running21", UVM_LOW)
  @(negedge vif21.reset); 
  wait (vif21.reset);
  `uvm_info(get_type_name(), "Detected21 Reset21 Done21", UVM_LOW)
  num_frames21 = 0;
  cur_frame21 = uart_frame21::type_id::create("cur_frame21", this);

  fork
    gen_sample_rate21(ua_brgr21, sample_clk21, sop_detected21);
    start_synchronizer21(serial_d121, serial_b21);
    sample_and_store21();
  join
endtask : run_phase

task uart_monitor21::gen_sample_rate21(ref bit [15:0] ua_brgr21, ref bit sample_clk21, ref bit sop_detected21);
    forever begin
      @(posedge vif21.clock21);
      if ((!vif21.reset) || (sop_detected21)) begin
        `uvm_info(get_type_name(), "sample_clk21- resetting21 ua_brgr21", UVM_HIGH)
        ua_brgr21 = 0;
        sample_clk21 = 0;
        sop_detected21 = 0;
      end else begin
        if ( ua_brgr21 == ({cfg.baud_rate_div21, cfg.baud_rate_gen21})) begin
          ua_brgr21 = 0;
          sample_clk21 = 1;
        end else begin
          sample_clk21 = 0;
          ua_brgr21++;
        end
      end
    end
endtask

task uart_monitor21::start_synchronizer21(ref bit serial_d121, ref bit serial_b21);
endtask

task uart_monitor21::sample_and_store21();
  forever begin
    wait_for_sop21(sop_detected21);
    collect_frame21();
  end
endtask : sample_and_store21

task uart_monitor21::wait_for_sop21(ref bit sop_detected21);
    transmit_delay21 = 0;
    sop_detected21 = 0;
    while (!sop_detected21) begin
      `uvm_info(get_type_name(), "trying21 to detect21 SOP21", UVM_MEDIUM)
      while (!(serial_d121 == 1 && serial_b21 == 0)) begin
        @(negedge vif21.clock21);
        transmit_delay21++;
      end
      if (serial_b21 != 0)
        `uvm_info(get_type_name(), "Encountered21 a glitch21 in serial21 during SOP21, shall21 continue", UVM_LOW)
      else
      begin
        sop_detected21 = 1;
        `uvm_info(get_type_name(), "SOP21 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop21
  

task uart_monitor21::collect_frame21();
  bit [7:0] payload_byte21;
  cur_frame21 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting21 a frame21: %0d", num_frames21+1), UVM_HIGH)
   // Begin21 Transaction21 Recording21
  void'(this.begin_tr(cur_frame21, "UART21 Monitor21", , get_full_name()));
  cur_frame21.transmit_delay21 = transmit_delay21;
  cur_frame21.start_bit21 = 1'b0;
  cur_frame21.parity_type21 = GOOD_PARITY21;
  num_of_bits_rcvd21 = 0;

    while (num_of_bits_rcvd21 < (1 + cfg.char_len_val21 + cfg.parity_en21 + cfg.nbstop21))
    begin
      @(posedge vif21.clock21);
      #1;
      if (sample_clk21) begin
        num_of_bits_rcvd21++;
        if ((num_of_bits_rcvd21 > 0) && (num_of_bits_rcvd21 <= cfg.char_len_val21)) begin // sending21 "data bits" 
          cur_frame21.payload21[num_of_bits_rcvd21-1] = serial_b21;
          payload_byte21 = cur_frame21.payload21[num_of_bits_rcvd21-1];
          `uvm_info(get_type_name(), $psprintf("Received21 a Frame21 data bit:'b%0b", payload_byte21), UVM_HIGH)
        end
        msb_lsb_data21[0] =  cur_frame21.payload21[0] ;
        msb_lsb_data21[1] =  cur_frame21.payload21[cfg.char_len_val21-1] ;
        if ((num_of_bits_rcvd21 == (1 + cfg.char_len_val21)) && (cfg.parity_en21)) begin // sending21 "parity21 bit" if parity21 is enabled
          cur_frame21.parity21 = serial_b21;
          `uvm_info(get_type_name(), $psprintf("Received21 Parity21 bit:'b%0b", cur_frame21.parity21), UVM_HIGH)
          if (serial_b21 == cur_frame21.calc_parity21(cfg.char_len_val21, cfg.parity_mode21))
            `uvm_info(get_type_name(), "Received21 Parity21 is same as calculated21 Parity21", UVM_MEDIUM)
          else if (checks_enable21)
            `uvm_error(get_type_name(), "####### FAIL21 :Received21 Parity21 doesn't match the calculated21 Parity21  ")
        end
        if (num_of_bits_rcvd21 == (1 + cfg.char_len_val21 + cfg.parity_en21)) begin // sending21 "stop/error bits"
          for (int i = 0; i < cfg.nbstop21; i++) begin
            wait (sample_clk21);
            cur_frame21.stop_bits21[i] = serial_b21;
            `uvm_info(get_type_name(), $psprintf("Received21 a Stop bit: 'b%0b", cur_frame21.stop_bits21[i]), UVM_HIGH)
            num_of_bits_rcvd21++;
            wait (!sample_clk21);
          end
        end
        wait (!sample_clk21);
      end
    end
 num_frames21++; 
 `uvm_info(get_type_name(), $psprintf("Collected21 the following21 Frame21 No:%0d\n%s", num_frames21, cur_frame21.sprint()), UVM_MEDIUM)

  if(coverage_enable21) perform_coverage21();
  frame_collected_port21.write(cur_frame21);
  this.end_tr(cur_frame21);
endtask : collect_frame21

function void uart_monitor21::perform_coverage21();
  uart_trans_frame_cg21.sample();
endfunction : perform_coverage21

`endif

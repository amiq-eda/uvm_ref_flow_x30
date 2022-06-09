/*-------------------------------------------------------------------------
File19 name   : uart_monitor19.sv
Title19       : monitor19 file for uart19 uvc19
Project19     :
Created19     :
Description19 : Descirbes19 UART19 Monitor19. Rx19/Tx19 monitors19 should be derived19 form19
            : this uart_monitor19 base class
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH19
`define UART_MONITOR_SVH19

virtual class uart_monitor19 extends uvm_monitor;
   uvm_analysis_port #(uart_frame19) frame_collected_port19;

  // virtual interface 
  virtual interface uart_if19 vif19;

  // Handle19 to  a cfg class
  uart_config19 cfg; 

  int num_frames19;
  bit sample_clk19;
  bit baud_clk19;
  bit [15:0] ua_brgr19;
  bit [7:0] ua_bdiv19;
  int num_of_bits_rcvd19;
  int transmit_delay19;
  bit sop_detected19;
  bit tmp_bit019;
  bit serial_d119;
  bit serial_bit19;
  bit serial_b19;
  bit [1:0]  msb_lsb_data19;

  bit checks_enable19 = 1;   // enable protocol19 checking
  bit coverage_enable19 = 1; // control19 coverage19 in the monitor19
  uart_frame19 cur_frame19;

  `uvm_field_utils_begin(uart_monitor19)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable19, UVM_DEFAULT)
      `uvm_field_int(coverage_enable19, UVM_DEFAULT)
      `uvm_field_object(cur_frame19, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg19;
    NUM_STOP_BITS19 : coverpoint cfg.nbstop19 {
      bins ONE19 = {0};
      bins TWO19 = {1};
    }
    DATA_LENGTH19 : coverpoint cfg.char_length19 {
      bins EIGHT19 = {0,1};
      bins SEVEN19 = {2};
      bins SIX19 = {3};
    }
    PARITY_MODE19 : coverpoint cfg.parity_mode19 {
      bins EVEN19  = {0};
      bins ODD19   = {1};
      bins SPACE19 = {2};
      bins MARK19  = {3};
    }
    PARITY_ERROR19: coverpoint cur_frame19.error_bits19[1]
      {
        bins good19 = { 0 };
        bins bad19 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE19: cross DATA_LENGTH19, PARITY_MODE19;
    PARITY_ERROR_x_PARITY_MODE19: cross PARITY_ERROR19, PARITY_MODE19;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg19 = new();
    uart_trans_frame_cg19.set_inst_name ("uart_trans_frame_cg19");
    frame_collected_port19 = new("frame_collected_port19", this);
  endfunction: new

  // Additional19 class methods19;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate19(ref bit [15:0] ua_brgr19, ref bit sample_clk19, ref bit sop_detected19);
  extern virtual task start_synchronizer19(ref bit serial_d119, ref bit serial_b19);
  extern virtual protected function void perform_coverage19();
  extern virtual task collect_frame19();
  extern virtual task wait_for_sop19(ref bit sop_detected19);
  extern virtual task sample_and_store19();
endclass: uart_monitor19

// UVM build_phase
function void uart_monitor19::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config19)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG19", "uart_config19 not set for this somponent19")
endfunction : build_phase

function void uart_monitor19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if19)::get(this, "","vif19",vif19))
      `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".vif19"})
endfunction : connect_phase

task uart_monitor19::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start19 Running19", UVM_LOW)
  @(negedge vif19.reset); 
  wait (vif19.reset);
  `uvm_info(get_type_name(), "Detected19 Reset19 Done19", UVM_LOW)
  num_frames19 = 0;
  cur_frame19 = uart_frame19::type_id::create("cur_frame19", this);

  fork
    gen_sample_rate19(ua_brgr19, sample_clk19, sop_detected19);
    start_synchronizer19(serial_d119, serial_b19);
    sample_and_store19();
  join
endtask : run_phase

task uart_monitor19::gen_sample_rate19(ref bit [15:0] ua_brgr19, ref bit sample_clk19, ref bit sop_detected19);
    forever begin
      @(posedge vif19.clock19);
      if ((!vif19.reset) || (sop_detected19)) begin
        `uvm_info(get_type_name(), "sample_clk19- resetting19 ua_brgr19", UVM_HIGH)
        ua_brgr19 = 0;
        sample_clk19 = 0;
        sop_detected19 = 0;
      end else begin
        if ( ua_brgr19 == ({cfg.baud_rate_div19, cfg.baud_rate_gen19})) begin
          ua_brgr19 = 0;
          sample_clk19 = 1;
        end else begin
          sample_clk19 = 0;
          ua_brgr19++;
        end
      end
    end
endtask

task uart_monitor19::start_synchronizer19(ref bit serial_d119, ref bit serial_b19);
endtask

task uart_monitor19::sample_and_store19();
  forever begin
    wait_for_sop19(sop_detected19);
    collect_frame19();
  end
endtask : sample_and_store19

task uart_monitor19::wait_for_sop19(ref bit sop_detected19);
    transmit_delay19 = 0;
    sop_detected19 = 0;
    while (!sop_detected19) begin
      `uvm_info(get_type_name(), "trying19 to detect19 SOP19", UVM_MEDIUM)
      while (!(serial_d119 == 1 && serial_b19 == 0)) begin
        @(negedge vif19.clock19);
        transmit_delay19++;
      end
      if (serial_b19 != 0)
        `uvm_info(get_type_name(), "Encountered19 a glitch19 in serial19 during SOP19, shall19 continue", UVM_LOW)
      else
      begin
        sop_detected19 = 1;
        `uvm_info(get_type_name(), "SOP19 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop19
  

task uart_monitor19::collect_frame19();
  bit [7:0] payload_byte19;
  cur_frame19 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting19 a frame19: %0d", num_frames19+1), UVM_HIGH)
   // Begin19 Transaction19 Recording19
  void'(this.begin_tr(cur_frame19, "UART19 Monitor19", , get_full_name()));
  cur_frame19.transmit_delay19 = transmit_delay19;
  cur_frame19.start_bit19 = 1'b0;
  cur_frame19.parity_type19 = GOOD_PARITY19;
  num_of_bits_rcvd19 = 0;

    while (num_of_bits_rcvd19 < (1 + cfg.char_len_val19 + cfg.parity_en19 + cfg.nbstop19))
    begin
      @(posedge vif19.clock19);
      #1;
      if (sample_clk19) begin
        num_of_bits_rcvd19++;
        if ((num_of_bits_rcvd19 > 0) && (num_of_bits_rcvd19 <= cfg.char_len_val19)) begin // sending19 "data bits" 
          cur_frame19.payload19[num_of_bits_rcvd19-1] = serial_b19;
          payload_byte19 = cur_frame19.payload19[num_of_bits_rcvd19-1];
          `uvm_info(get_type_name(), $psprintf("Received19 a Frame19 data bit:'b%0b", payload_byte19), UVM_HIGH)
        end
        msb_lsb_data19[0] =  cur_frame19.payload19[0] ;
        msb_lsb_data19[1] =  cur_frame19.payload19[cfg.char_len_val19-1] ;
        if ((num_of_bits_rcvd19 == (1 + cfg.char_len_val19)) && (cfg.parity_en19)) begin // sending19 "parity19 bit" if parity19 is enabled
          cur_frame19.parity19 = serial_b19;
          `uvm_info(get_type_name(), $psprintf("Received19 Parity19 bit:'b%0b", cur_frame19.parity19), UVM_HIGH)
          if (serial_b19 == cur_frame19.calc_parity19(cfg.char_len_val19, cfg.parity_mode19))
            `uvm_info(get_type_name(), "Received19 Parity19 is same as calculated19 Parity19", UVM_MEDIUM)
          else if (checks_enable19)
            `uvm_error(get_type_name(), "####### FAIL19 :Received19 Parity19 doesn't match the calculated19 Parity19  ")
        end
        if (num_of_bits_rcvd19 == (1 + cfg.char_len_val19 + cfg.parity_en19)) begin // sending19 "stop/error bits"
          for (int i = 0; i < cfg.nbstop19; i++) begin
            wait (sample_clk19);
            cur_frame19.stop_bits19[i] = serial_b19;
            `uvm_info(get_type_name(), $psprintf("Received19 a Stop bit: 'b%0b", cur_frame19.stop_bits19[i]), UVM_HIGH)
            num_of_bits_rcvd19++;
            wait (!sample_clk19);
          end
        end
        wait (!sample_clk19);
      end
    end
 num_frames19++; 
 `uvm_info(get_type_name(), $psprintf("Collected19 the following19 Frame19 No:%0d\n%s", num_frames19, cur_frame19.sprint()), UVM_MEDIUM)

  if(coverage_enable19) perform_coverage19();
  frame_collected_port19.write(cur_frame19);
  this.end_tr(cur_frame19);
endtask : collect_frame19

function void uart_monitor19::perform_coverage19();
  uart_trans_frame_cg19.sample();
endfunction : perform_coverage19

`endif

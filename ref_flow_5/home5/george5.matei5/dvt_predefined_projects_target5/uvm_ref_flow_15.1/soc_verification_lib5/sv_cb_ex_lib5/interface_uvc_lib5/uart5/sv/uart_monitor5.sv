/*-------------------------------------------------------------------------
File5 name   : uart_monitor5.sv
Title5       : monitor5 file for uart5 uvc5
Project5     :
Created5     :
Description5 : Descirbes5 UART5 Monitor5. Rx5/Tx5 monitors5 should be derived5 form5
            : this uart_monitor5 base class
Notes5       :  
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH5
`define UART_MONITOR_SVH5

virtual class uart_monitor5 extends uvm_monitor;
   uvm_analysis_port #(uart_frame5) frame_collected_port5;

  // virtual interface 
  virtual interface uart_if5 vif5;

  // Handle5 to  a cfg class
  uart_config5 cfg; 

  int num_frames5;
  bit sample_clk5;
  bit baud_clk5;
  bit [15:0] ua_brgr5;
  bit [7:0] ua_bdiv5;
  int num_of_bits_rcvd5;
  int transmit_delay5;
  bit sop_detected5;
  bit tmp_bit05;
  bit serial_d15;
  bit serial_bit5;
  bit serial_b5;
  bit [1:0]  msb_lsb_data5;

  bit checks_enable5 = 1;   // enable protocol5 checking
  bit coverage_enable5 = 1; // control5 coverage5 in the monitor5
  uart_frame5 cur_frame5;

  `uvm_field_utils_begin(uart_monitor5)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable5, UVM_DEFAULT)
      `uvm_field_int(coverage_enable5, UVM_DEFAULT)
      `uvm_field_object(cur_frame5, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg5;
    NUM_STOP_BITS5 : coverpoint cfg.nbstop5 {
      bins ONE5 = {0};
      bins TWO5 = {1};
    }
    DATA_LENGTH5 : coverpoint cfg.char_length5 {
      bins EIGHT5 = {0,1};
      bins SEVEN5 = {2};
      bins SIX5 = {3};
    }
    PARITY_MODE5 : coverpoint cfg.parity_mode5 {
      bins EVEN5  = {0};
      bins ODD5   = {1};
      bins SPACE5 = {2};
      bins MARK5  = {3};
    }
    PARITY_ERROR5: coverpoint cur_frame5.error_bits5[1]
      {
        bins good5 = { 0 };
        bins bad5 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE5: cross DATA_LENGTH5, PARITY_MODE5;
    PARITY_ERROR_x_PARITY_MODE5: cross PARITY_ERROR5, PARITY_MODE5;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg5 = new();
    uart_trans_frame_cg5.set_inst_name ("uart_trans_frame_cg5");
    frame_collected_port5 = new("frame_collected_port5", this);
  endfunction: new

  // Additional5 class methods5;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate5(ref bit [15:0] ua_brgr5, ref bit sample_clk5, ref bit sop_detected5);
  extern virtual task start_synchronizer5(ref bit serial_d15, ref bit serial_b5);
  extern virtual protected function void perform_coverage5();
  extern virtual task collect_frame5();
  extern virtual task wait_for_sop5(ref bit sop_detected5);
  extern virtual task sample_and_store5();
endclass: uart_monitor5

// UVM build_phase
function void uart_monitor5::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config5)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG5", "uart_config5 not set for this somponent5")
endfunction : build_phase

function void uart_monitor5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if5)::get(this, "","vif5",vif5))
      `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".vif5"})
endfunction : connect_phase

task uart_monitor5::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start5 Running5", UVM_LOW)
  @(negedge vif5.reset); 
  wait (vif5.reset);
  `uvm_info(get_type_name(), "Detected5 Reset5 Done5", UVM_LOW)
  num_frames5 = 0;
  cur_frame5 = uart_frame5::type_id::create("cur_frame5", this);

  fork
    gen_sample_rate5(ua_brgr5, sample_clk5, sop_detected5);
    start_synchronizer5(serial_d15, serial_b5);
    sample_and_store5();
  join
endtask : run_phase

task uart_monitor5::gen_sample_rate5(ref bit [15:0] ua_brgr5, ref bit sample_clk5, ref bit sop_detected5);
    forever begin
      @(posedge vif5.clock5);
      if ((!vif5.reset) || (sop_detected5)) begin
        `uvm_info(get_type_name(), "sample_clk5- resetting5 ua_brgr5", UVM_HIGH)
        ua_brgr5 = 0;
        sample_clk5 = 0;
        sop_detected5 = 0;
      end else begin
        if ( ua_brgr5 == ({cfg.baud_rate_div5, cfg.baud_rate_gen5})) begin
          ua_brgr5 = 0;
          sample_clk5 = 1;
        end else begin
          sample_clk5 = 0;
          ua_brgr5++;
        end
      end
    end
endtask

task uart_monitor5::start_synchronizer5(ref bit serial_d15, ref bit serial_b5);
endtask

task uart_monitor5::sample_and_store5();
  forever begin
    wait_for_sop5(sop_detected5);
    collect_frame5();
  end
endtask : sample_and_store5

task uart_monitor5::wait_for_sop5(ref bit sop_detected5);
    transmit_delay5 = 0;
    sop_detected5 = 0;
    while (!sop_detected5) begin
      `uvm_info(get_type_name(), "trying5 to detect5 SOP5", UVM_MEDIUM)
      while (!(serial_d15 == 1 && serial_b5 == 0)) begin
        @(negedge vif5.clock5);
        transmit_delay5++;
      end
      if (serial_b5 != 0)
        `uvm_info(get_type_name(), "Encountered5 a glitch5 in serial5 during SOP5, shall5 continue", UVM_LOW)
      else
      begin
        sop_detected5 = 1;
        `uvm_info(get_type_name(), "SOP5 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop5
  

task uart_monitor5::collect_frame5();
  bit [7:0] payload_byte5;
  cur_frame5 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting5 a frame5: %0d", num_frames5+1), UVM_HIGH)
   // Begin5 Transaction5 Recording5
  void'(this.begin_tr(cur_frame5, "UART5 Monitor5", , get_full_name()));
  cur_frame5.transmit_delay5 = transmit_delay5;
  cur_frame5.start_bit5 = 1'b0;
  cur_frame5.parity_type5 = GOOD_PARITY5;
  num_of_bits_rcvd5 = 0;

    while (num_of_bits_rcvd5 < (1 + cfg.char_len_val5 + cfg.parity_en5 + cfg.nbstop5))
    begin
      @(posedge vif5.clock5);
      #1;
      if (sample_clk5) begin
        num_of_bits_rcvd5++;
        if ((num_of_bits_rcvd5 > 0) && (num_of_bits_rcvd5 <= cfg.char_len_val5)) begin // sending5 "data bits" 
          cur_frame5.payload5[num_of_bits_rcvd5-1] = serial_b5;
          payload_byte5 = cur_frame5.payload5[num_of_bits_rcvd5-1];
          `uvm_info(get_type_name(), $psprintf("Received5 a Frame5 data bit:'b%0b", payload_byte5), UVM_HIGH)
        end
        msb_lsb_data5[0] =  cur_frame5.payload5[0] ;
        msb_lsb_data5[1] =  cur_frame5.payload5[cfg.char_len_val5-1] ;
        if ((num_of_bits_rcvd5 == (1 + cfg.char_len_val5)) && (cfg.parity_en5)) begin // sending5 "parity5 bit" if parity5 is enabled
          cur_frame5.parity5 = serial_b5;
          `uvm_info(get_type_name(), $psprintf("Received5 Parity5 bit:'b%0b", cur_frame5.parity5), UVM_HIGH)
          if (serial_b5 == cur_frame5.calc_parity5(cfg.char_len_val5, cfg.parity_mode5))
            `uvm_info(get_type_name(), "Received5 Parity5 is same as calculated5 Parity5", UVM_MEDIUM)
          else if (checks_enable5)
            `uvm_error(get_type_name(), "####### FAIL5 :Received5 Parity5 doesn't match the calculated5 Parity5  ")
        end
        if (num_of_bits_rcvd5 == (1 + cfg.char_len_val5 + cfg.parity_en5)) begin // sending5 "stop/error bits"
          for (int i = 0; i < cfg.nbstop5; i++) begin
            wait (sample_clk5);
            cur_frame5.stop_bits5[i] = serial_b5;
            `uvm_info(get_type_name(), $psprintf("Received5 a Stop bit: 'b%0b", cur_frame5.stop_bits5[i]), UVM_HIGH)
            num_of_bits_rcvd5++;
            wait (!sample_clk5);
          end
        end
        wait (!sample_clk5);
      end
    end
 num_frames5++; 
 `uvm_info(get_type_name(), $psprintf("Collected5 the following5 Frame5 No:%0d\n%s", num_frames5, cur_frame5.sprint()), UVM_MEDIUM)

  if(coverage_enable5) perform_coverage5();
  frame_collected_port5.write(cur_frame5);
  this.end_tr(cur_frame5);
endtask : collect_frame5

function void uart_monitor5::perform_coverage5();
  uart_trans_frame_cg5.sample();
endfunction : perform_coverage5

`endif

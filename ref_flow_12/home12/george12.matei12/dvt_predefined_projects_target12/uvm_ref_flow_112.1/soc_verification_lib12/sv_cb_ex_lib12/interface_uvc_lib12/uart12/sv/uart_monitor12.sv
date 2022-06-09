/*-------------------------------------------------------------------------
File12 name   : uart_monitor12.sv
Title12       : monitor12 file for uart12 uvc12
Project12     :
Created12     :
Description12 : Descirbes12 UART12 Monitor12. Rx12/Tx12 monitors12 should be derived12 form12
            : this uart_monitor12 base class
Notes12       :  
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH12
`define UART_MONITOR_SVH12

virtual class uart_monitor12 extends uvm_monitor;
   uvm_analysis_port #(uart_frame12) frame_collected_port12;

  // virtual interface 
  virtual interface uart_if12 vif12;

  // Handle12 to  a cfg class
  uart_config12 cfg; 

  int num_frames12;
  bit sample_clk12;
  bit baud_clk12;
  bit [15:0] ua_brgr12;
  bit [7:0] ua_bdiv12;
  int num_of_bits_rcvd12;
  int transmit_delay12;
  bit sop_detected12;
  bit tmp_bit012;
  bit serial_d112;
  bit serial_bit12;
  bit serial_b12;
  bit [1:0]  msb_lsb_data12;

  bit checks_enable12 = 1;   // enable protocol12 checking
  bit coverage_enable12 = 1; // control12 coverage12 in the monitor12
  uart_frame12 cur_frame12;

  `uvm_field_utils_begin(uart_monitor12)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable12, UVM_DEFAULT)
      `uvm_field_int(coverage_enable12, UVM_DEFAULT)
      `uvm_field_object(cur_frame12, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg12;
    NUM_STOP_BITS12 : coverpoint cfg.nbstop12 {
      bins ONE12 = {0};
      bins TWO12 = {1};
    }
    DATA_LENGTH12 : coverpoint cfg.char_length12 {
      bins EIGHT12 = {0,1};
      bins SEVEN12 = {2};
      bins SIX12 = {3};
    }
    PARITY_MODE12 : coverpoint cfg.parity_mode12 {
      bins EVEN12  = {0};
      bins ODD12   = {1};
      bins SPACE12 = {2};
      bins MARK12  = {3};
    }
    PARITY_ERROR12: coverpoint cur_frame12.error_bits12[1]
      {
        bins good12 = { 0 };
        bins bad12 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE12: cross DATA_LENGTH12, PARITY_MODE12;
    PARITY_ERROR_x_PARITY_MODE12: cross PARITY_ERROR12, PARITY_MODE12;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg12 = new();
    uart_trans_frame_cg12.set_inst_name ("uart_trans_frame_cg12");
    frame_collected_port12 = new("frame_collected_port12", this);
  endfunction: new

  // Additional12 class methods12;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate12(ref bit [15:0] ua_brgr12, ref bit sample_clk12, ref bit sop_detected12);
  extern virtual task start_synchronizer12(ref bit serial_d112, ref bit serial_b12);
  extern virtual protected function void perform_coverage12();
  extern virtual task collect_frame12();
  extern virtual task wait_for_sop12(ref bit sop_detected12);
  extern virtual task sample_and_store12();
endclass: uart_monitor12

// UVM build_phase
function void uart_monitor12::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config12)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG12", "uart_config12 not set for this somponent12")
endfunction : build_phase

function void uart_monitor12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if12)::get(this, "","vif12",vif12))
      `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".vif12"})
endfunction : connect_phase

task uart_monitor12::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start12 Running12", UVM_LOW)
  @(negedge vif12.reset); 
  wait (vif12.reset);
  `uvm_info(get_type_name(), "Detected12 Reset12 Done12", UVM_LOW)
  num_frames12 = 0;
  cur_frame12 = uart_frame12::type_id::create("cur_frame12", this);

  fork
    gen_sample_rate12(ua_brgr12, sample_clk12, sop_detected12);
    start_synchronizer12(serial_d112, serial_b12);
    sample_and_store12();
  join
endtask : run_phase

task uart_monitor12::gen_sample_rate12(ref bit [15:0] ua_brgr12, ref bit sample_clk12, ref bit sop_detected12);
    forever begin
      @(posedge vif12.clock12);
      if ((!vif12.reset) || (sop_detected12)) begin
        `uvm_info(get_type_name(), "sample_clk12- resetting12 ua_brgr12", UVM_HIGH)
        ua_brgr12 = 0;
        sample_clk12 = 0;
        sop_detected12 = 0;
      end else begin
        if ( ua_brgr12 == ({cfg.baud_rate_div12, cfg.baud_rate_gen12})) begin
          ua_brgr12 = 0;
          sample_clk12 = 1;
        end else begin
          sample_clk12 = 0;
          ua_brgr12++;
        end
      end
    end
endtask

task uart_monitor12::start_synchronizer12(ref bit serial_d112, ref bit serial_b12);
endtask

task uart_monitor12::sample_and_store12();
  forever begin
    wait_for_sop12(sop_detected12);
    collect_frame12();
  end
endtask : sample_and_store12

task uart_monitor12::wait_for_sop12(ref bit sop_detected12);
    transmit_delay12 = 0;
    sop_detected12 = 0;
    while (!sop_detected12) begin
      `uvm_info(get_type_name(), "trying12 to detect12 SOP12", UVM_MEDIUM)
      while (!(serial_d112 == 1 && serial_b12 == 0)) begin
        @(negedge vif12.clock12);
        transmit_delay12++;
      end
      if (serial_b12 != 0)
        `uvm_info(get_type_name(), "Encountered12 a glitch12 in serial12 during SOP12, shall12 continue", UVM_LOW)
      else
      begin
        sop_detected12 = 1;
        `uvm_info(get_type_name(), "SOP12 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop12
  

task uart_monitor12::collect_frame12();
  bit [7:0] payload_byte12;
  cur_frame12 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting12 a frame12: %0d", num_frames12+1), UVM_HIGH)
   // Begin12 Transaction12 Recording12
  void'(this.begin_tr(cur_frame12, "UART12 Monitor12", , get_full_name()));
  cur_frame12.transmit_delay12 = transmit_delay12;
  cur_frame12.start_bit12 = 1'b0;
  cur_frame12.parity_type12 = GOOD_PARITY12;
  num_of_bits_rcvd12 = 0;

    while (num_of_bits_rcvd12 < (1 + cfg.char_len_val12 + cfg.parity_en12 + cfg.nbstop12))
    begin
      @(posedge vif12.clock12);
      #1;
      if (sample_clk12) begin
        num_of_bits_rcvd12++;
        if ((num_of_bits_rcvd12 > 0) && (num_of_bits_rcvd12 <= cfg.char_len_val12)) begin // sending12 "data bits" 
          cur_frame12.payload12[num_of_bits_rcvd12-1] = serial_b12;
          payload_byte12 = cur_frame12.payload12[num_of_bits_rcvd12-1];
          `uvm_info(get_type_name(), $psprintf("Received12 a Frame12 data bit:'b%0b", payload_byte12), UVM_HIGH)
        end
        msb_lsb_data12[0] =  cur_frame12.payload12[0] ;
        msb_lsb_data12[1] =  cur_frame12.payload12[cfg.char_len_val12-1] ;
        if ((num_of_bits_rcvd12 == (1 + cfg.char_len_val12)) && (cfg.parity_en12)) begin // sending12 "parity12 bit" if parity12 is enabled
          cur_frame12.parity12 = serial_b12;
          `uvm_info(get_type_name(), $psprintf("Received12 Parity12 bit:'b%0b", cur_frame12.parity12), UVM_HIGH)
          if (serial_b12 == cur_frame12.calc_parity12(cfg.char_len_val12, cfg.parity_mode12))
            `uvm_info(get_type_name(), "Received12 Parity12 is same as calculated12 Parity12", UVM_MEDIUM)
          else if (checks_enable12)
            `uvm_error(get_type_name(), "####### FAIL12 :Received12 Parity12 doesn't match the calculated12 Parity12  ")
        end
        if (num_of_bits_rcvd12 == (1 + cfg.char_len_val12 + cfg.parity_en12)) begin // sending12 "stop/error bits"
          for (int i = 0; i < cfg.nbstop12; i++) begin
            wait (sample_clk12);
            cur_frame12.stop_bits12[i] = serial_b12;
            `uvm_info(get_type_name(), $psprintf("Received12 a Stop bit: 'b%0b", cur_frame12.stop_bits12[i]), UVM_HIGH)
            num_of_bits_rcvd12++;
            wait (!sample_clk12);
          end
        end
        wait (!sample_clk12);
      end
    end
 num_frames12++; 
 `uvm_info(get_type_name(), $psprintf("Collected12 the following12 Frame12 No:%0d\n%s", num_frames12, cur_frame12.sprint()), UVM_MEDIUM)

  if(coverage_enable12) perform_coverage12();
  frame_collected_port12.write(cur_frame12);
  this.end_tr(cur_frame12);
endtask : collect_frame12

function void uart_monitor12::perform_coverage12();
  uart_trans_frame_cg12.sample();
endfunction : perform_coverage12

`endif

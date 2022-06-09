/*-------------------------------------------------------------------------
File13 name   : uart_monitor13.sv
Title13       : monitor13 file for uart13 uvc13
Project13     :
Created13     :
Description13 : Descirbes13 UART13 Monitor13. Rx13/Tx13 monitors13 should be derived13 form13
            : this uart_monitor13 base class
Notes13       :  
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH13
`define UART_MONITOR_SVH13

virtual class uart_monitor13 extends uvm_monitor;
   uvm_analysis_port #(uart_frame13) frame_collected_port13;

  // virtual interface 
  virtual interface uart_if13 vif13;

  // Handle13 to  a cfg class
  uart_config13 cfg; 

  int num_frames13;
  bit sample_clk13;
  bit baud_clk13;
  bit [15:0] ua_brgr13;
  bit [7:0] ua_bdiv13;
  int num_of_bits_rcvd13;
  int transmit_delay13;
  bit sop_detected13;
  bit tmp_bit013;
  bit serial_d113;
  bit serial_bit13;
  bit serial_b13;
  bit [1:0]  msb_lsb_data13;

  bit checks_enable13 = 1;   // enable protocol13 checking
  bit coverage_enable13 = 1; // control13 coverage13 in the monitor13
  uart_frame13 cur_frame13;

  `uvm_field_utils_begin(uart_monitor13)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable13, UVM_DEFAULT)
      `uvm_field_int(coverage_enable13, UVM_DEFAULT)
      `uvm_field_object(cur_frame13, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg13;
    NUM_STOP_BITS13 : coverpoint cfg.nbstop13 {
      bins ONE13 = {0};
      bins TWO13 = {1};
    }
    DATA_LENGTH13 : coverpoint cfg.char_length13 {
      bins EIGHT13 = {0,1};
      bins SEVEN13 = {2};
      bins SIX13 = {3};
    }
    PARITY_MODE13 : coverpoint cfg.parity_mode13 {
      bins EVEN13  = {0};
      bins ODD13   = {1};
      bins SPACE13 = {2};
      bins MARK13  = {3};
    }
    PARITY_ERROR13: coverpoint cur_frame13.error_bits13[1]
      {
        bins good13 = { 0 };
        bins bad13 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE13: cross DATA_LENGTH13, PARITY_MODE13;
    PARITY_ERROR_x_PARITY_MODE13: cross PARITY_ERROR13, PARITY_MODE13;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg13 = new();
    uart_trans_frame_cg13.set_inst_name ("uart_trans_frame_cg13");
    frame_collected_port13 = new("frame_collected_port13", this);
  endfunction: new

  // Additional13 class methods13;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate13(ref bit [15:0] ua_brgr13, ref bit sample_clk13, ref bit sop_detected13);
  extern virtual task start_synchronizer13(ref bit serial_d113, ref bit serial_b13);
  extern virtual protected function void perform_coverage13();
  extern virtual task collect_frame13();
  extern virtual task wait_for_sop13(ref bit sop_detected13);
  extern virtual task sample_and_store13();
endclass: uart_monitor13

// UVM build_phase
function void uart_monitor13::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config13)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG13", "uart_config13 not set for this somponent13")
endfunction : build_phase

function void uart_monitor13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if13)::get(this, "","vif13",vif13))
      `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
endfunction : connect_phase

task uart_monitor13::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start13 Running13", UVM_LOW)
  @(negedge vif13.reset); 
  wait (vif13.reset);
  `uvm_info(get_type_name(), "Detected13 Reset13 Done13", UVM_LOW)
  num_frames13 = 0;
  cur_frame13 = uart_frame13::type_id::create("cur_frame13", this);

  fork
    gen_sample_rate13(ua_brgr13, sample_clk13, sop_detected13);
    start_synchronizer13(serial_d113, serial_b13);
    sample_and_store13();
  join
endtask : run_phase

task uart_monitor13::gen_sample_rate13(ref bit [15:0] ua_brgr13, ref bit sample_clk13, ref bit sop_detected13);
    forever begin
      @(posedge vif13.clock13);
      if ((!vif13.reset) || (sop_detected13)) begin
        `uvm_info(get_type_name(), "sample_clk13- resetting13 ua_brgr13", UVM_HIGH)
        ua_brgr13 = 0;
        sample_clk13 = 0;
        sop_detected13 = 0;
      end else begin
        if ( ua_brgr13 == ({cfg.baud_rate_div13, cfg.baud_rate_gen13})) begin
          ua_brgr13 = 0;
          sample_clk13 = 1;
        end else begin
          sample_clk13 = 0;
          ua_brgr13++;
        end
      end
    end
endtask

task uart_monitor13::start_synchronizer13(ref bit serial_d113, ref bit serial_b13);
endtask

task uart_monitor13::sample_and_store13();
  forever begin
    wait_for_sop13(sop_detected13);
    collect_frame13();
  end
endtask : sample_and_store13

task uart_monitor13::wait_for_sop13(ref bit sop_detected13);
    transmit_delay13 = 0;
    sop_detected13 = 0;
    while (!sop_detected13) begin
      `uvm_info(get_type_name(), "trying13 to detect13 SOP13", UVM_MEDIUM)
      while (!(serial_d113 == 1 && serial_b13 == 0)) begin
        @(negedge vif13.clock13);
        transmit_delay13++;
      end
      if (serial_b13 != 0)
        `uvm_info(get_type_name(), "Encountered13 a glitch13 in serial13 during SOP13, shall13 continue", UVM_LOW)
      else
      begin
        sop_detected13 = 1;
        `uvm_info(get_type_name(), "SOP13 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop13
  

task uart_monitor13::collect_frame13();
  bit [7:0] payload_byte13;
  cur_frame13 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting13 a frame13: %0d", num_frames13+1), UVM_HIGH)
   // Begin13 Transaction13 Recording13
  void'(this.begin_tr(cur_frame13, "UART13 Monitor13", , get_full_name()));
  cur_frame13.transmit_delay13 = transmit_delay13;
  cur_frame13.start_bit13 = 1'b0;
  cur_frame13.parity_type13 = GOOD_PARITY13;
  num_of_bits_rcvd13 = 0;

    while (num_of_bits_rcvd13 < (1 + cfg.char_len_val13 + cfg.parity_en13 + cfg.nbstop13))
    begin
      @(posedge vif13.clock13);
      #1;
      if (sample_clk13) begin
        num_of_bits_rcvd13++;
        if ((num_of_bits_rcvd13 > 0) && (num_of_bits_rcvd13 <= cfg.char_len_val13)) begin // sending13 "data bits" 
          cur_frame13.payload13[num_of_bits_rcvd13-1] = serial_b13;
          payload_byte13 = cur_frame13.payload13[num_of_bits_rcvd13-1];
          `uvm_info(get_type_name(), $psprintf("Received13 a Frame13 data bit:'b%0b", payload_byte13), UVM_HIGH)
        end
        msb_lsb_data13[0] =  cur_frame13.payload13[0] ;
        msb_lsb_data13[1] =  cur_frame13.payload13[cfg.char_len_val13-1] ;
        if ((num_of_bits_rcvd13 == (1 + cfg.char_len_val13)) && (cfg.parity_en13)) begin // sending13 "parity13 bit" if parity13 is enabled
          cur_frame13.parity13 = serial_b13;
          `uvm_info(get_type_name(), $psprintf("Received13 Parity13 bit:'b%0b", cur_frame13.parity13), UVM_HIGH)
          if (serial_b13 == cur_frame13.calc_parity13(cfg.char_len_val13, cfg.parity_mode13))
            `uvm_info(get_type_name(), "Received13 Parity13 is same as calculated13 Parity13", UVM_MEDIUM)
          else if (checks_enable13)
            `uvm_error(get_type_name(), "####### FAIL13 :Received13 Parity13 doesn't match the calculated13 Parity13  ")
        end
        if (num_of_bits_rcvd13 == (1 + cfg.char_len_val13 + cfg.parity_en13)) begin // sending13 "stop/error bits"
          for (int i = 0; i < cfg.nbstop13; i++) begin
            wait (sample_clk13);
            cur_frame13.stop_bits13[i] = serial_b13;
            `uvm_info(get_type_name(), $psprintf("Received13 a Stop bit: 'b%0b", cur_frame13.stop_bits13[i]), UVM_HIGH)
            num_of_bits_rcvd13++;
            wait (!sample_clk13);
          end
        end
        wait (!sample_clk13);
      end
    end
 num_frames13++; 
 `uvm_info(get_type_name(), $psprintf("Collected13 the following13 Frame13 No:%0d\n%s", num_frames13, cur_frame13.sprint()), UVM_MEDIUM)

  if(coverage_enable13) perform_coverage13();
  frame_collected_port13.write(cur_frame13);
  this.end_tr(cur_frame13);
endtask : collect_frame13

function void uart_monitor13::perform_coverage13();
  uart_trans_frame_cg13.sample();
endfunction : perform_coverage13

`endif

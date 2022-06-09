/*-------------------------------------------------------------------------
File11 name   : uart_monitor11.sv
Title11       : monitor11 file for uart11 uvc11
Project11     :
Created11     :
Description11 : Descirbes11 UART11 Monitor11. Rx11/Tx11 monitors11 should be derived11 form11
            : this uart_monitor11 base class
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH11
`define UART_MONITOR_SVH11

virtual class uart_monitor11 extends uvm_monitor;
   uvm_analysis_port #(uart_frame11) frame_collected_port11;

  // virtual interface 
  virtual interface uart_if11 vif11;

  // Handle11 to  a cfg class
  uart_config11 cfg; 

  int num_frames11;
  bit sample_clk11;
  bit baud_clk11;
  bit [15:0] ua_brgr11;
  bit [7:0] ua_bdiv11;
  int num_of_bits_rcvd11;
  int transmit_delay11;
  bit sop_detected11;
  bit tmp_bit011;
  bit serial_d111;
  bit serial_bit11;
  bit serial_b11;
  bit [1:0]  msb_lsb_data11;

  bit checks_enable11 = 1;   // enable protocol11 checking
  bit coverage_enable11 = 1; // control11 coverage11 in the monitor11
  uart_frame11 cur_frame11;

  `uvm_field_utils_begin(uart_monitor11)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable11, UVM_DEFAULT)
      `uvm_field_int(coverage_enable11, UVM_DEFAULT)
      `uvm_field_object(cur_frame11, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg11;
    NUM_STOP_BITS11 : coverpoint cfg.nbstop11 {
      bins ONE11 = {0};
      bins TWO11 = {1};
    }
    DATA_LENGTH11 : coverpoint cfg.char_length11 {
      bins EIGHT11 = {0,1};
      bins SEVEN11 = {2};
      bins SIX11 = {3};
    }
    PARITY_MODE11 : coverpoint cfg.parity_mode11 {
      bins EVEN11  = {0};
      bins ODD11   = {1};
      bins SPACE11 = {2};
      bins MARK11  = {3};
    }
    PARITY_ERROR11: coverpoint cur_frame11.error_bits11[1]
      {
        bins good11 = { 0 };
        bins bad11 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE11: cross DATA_LENGTH11, PARITY_MODE11;
    PARITY_ERROR_x_PARITY_MODE11: cross PARITY_ERROR11, PARITY_MODE11;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg11 = new();
    uart_trans_frame_cg11.set_inst_name ("uart_trans_frame_cg11");
    frame_collected_port11 = new("frame_collected_port11", this);
  endfunction: new

  // Additional11 class methods11;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate11(ref bit [15:0] ua_brgr11, ref bit sample_clk11, ref bit sop_detected11);
  extern virtual task start_synchronizer11(ref bit serial_d111, ref bit serial_b11);
  extern virtual protected function void perform_coverage11();
  extern virtual task collect_frame11();
  extern virtual task wait_for_sop11(ref bit sop_detected11);
  extern virtual task sample_and_store11();
endclass: uart_monitor11

// UVM build_phase
function void uart_monitor11::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config11)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG11", "uart_config11 not set for this somponent11")
endfunction : build_phase

function void uart_monitor11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if11)::get(this, "","vif11",vif11))
      `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".vif11"})
endfunction : connect_phase

task uart_monitor11::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start11 Running11", UVM_LOW)
  @(negedge vif11.reset); 
  wait (vif11.reset);
  `uvm_info(get_type_name(), "Detected11 Reset11 Done11", UVM_LOW)
  num_frames11 = 0;
  cur_frame11 = uart_frame11::type_id::create("cur_frame11", this);

  fork
    gen_sample_rate11(ua_brgr11, sample_clk11, sop_detected11);
    start_synchronizer11(serial_d111, serial_b11);
    sample_and_store11();
  join
endtask : run_phase

task uart_monitor11::gen_sample_rate11(ref bit [15:0] ua_brgr11, ref bit sample_clk11, ref bit sop_detected11);
    forever begin
      @(posedge vif11.clock11);
      if ((!vif11.reset) || (sop_detected11)) begin
        `uvm_info(get_type_name(), "sample_clk11- resetting11 ua_brgr11", UVM_HIGH)
        ua_brgr11 = 0;
        sample_clk11 = 0;
        sop_detected11 = 0;
      end else begin
        if ( ua_brgr11 == ({cfg.baud_rate_div11, cfg.baud_rate_gen11})) begin
          ua_brgr11 = 0;
          sample_clk11 = 1;
        end else begin
          sample_clk11 = 0;
          ua_brgr11++;
        end
      end
    end
endtask

task uart_monitor11::start_synchronizer11(ref bit serial_d111, ref bit serial_b11);
endtask

task uart_monitor11::sample_and_store11();
  forever begin
    wait_for_sop11(sop_detected11);
    collect_frame11();
  end
endtask : sample_and_store11

task uart_monitor11::wait_for_sop11(ref bit sop_detected11);
    transmit_delay11 = 0;
    sop_detected11 = 0;
    while (!sop_detected11) begin
      `uvm_info(get_type_name(), "trying11 to detect11 SOP11", UVM_MEDIUM)
      while (!(serial_d111 == 1 && serial_b11 == 0)) begin
        @(negedge vif11.clock11);
        transmit_delay11++;
      end
      if (serial_b11 != 0)
        `uvm_info(get_type_name(), "Encountered11 a glitch11 in serial11 during SOP11, shall11 continue", UVM_LOW)
      else
      begin
        sop_detected11 = 1;
        `uvm_info(get_type_name(), "SOP11 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop11
  

task uart_monitor11::collect_frame11();
  bit [7:0] payload_byte11;
  cur_frame11 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting11 a frame11: %0d", num_frames11+1), UVM_HIGH)
   // Begin11 Transaction11 Recording11
  void'(this.begin_tr(cur_frame11, "UART11 Monitor11", , get_full_name()));
  cur_frame11.transmit_delay11 = transmit_delay11;
  cur_frame11.start_bit11 = 1'b0;
  cur_frame11.parity_type11 = GOOD_PARITY11;
  num_of_bits_rcvd11 = 0;

    while (num_of_bits_rcvd11 < (1 + cfg.char_len_val11 + cfg.parity_en11 + cfg.nbstop11))
    begin
      @(posedge vif11.clock11);
      #1;
      if (sample_clk11) begin
        num_of_bits_rcvd11++;
        if ((num_of_bits_rcvd11 > 0) && (num_of_bits_rcvd11 <= cfg.char_len_val11)) begin // sending11 "data bits" 
          cur_frame11.payload11[num_of_bits_rcvd11-1] = serial_b11;
          payload_byte11 = cur_frame11.payload11[num_of_bits_rcvd11-1];
          `uvm_info(get_type_name(), $psprintf("Received11 a Frame11 data bit:'b%0b", payload_byte11), UVM_HIGH)
        end
        msb_lsb_data11[0] =  cur_frame11.payload11[0] ;
        msb_lsb_data11[1] =  cur_frame11.payload11[cfg.char_len_val11-1] ;
        if ((num_of_bits_rcvd11 == (1 + cfg.char_len_val11)) && (cfg.parity_en11)) begin // sending11 "parity11 bit" if parity11 is enabled
          cur_frame11.parity11 = serial_b11;
          `uvm_info(get_type_name(), $psprintf("Received11 Parity11 bit:'b%0b", cur_frame11.parity11), UVM_HIGH)
          if (serial_b11 == cur_frame11.calc_parity11(cfg.char_len_val11, cfg.parity_mode11))
            `uvm_info(get_type_name(), "Received11 Parity11 is same as calculated11 Parity11", UVM_MEDIUM)
          else if (checks_enable11)
            `uvm_error(get_type_name(), "####### FAIL11 :Received11 Parity11 doesn't match the calculated11 Parity11  ")
        end
        if (num_of_bits_rcvd11 == (1 + cfg.char_len_val11 + cfg.parity_en11)) begin // sending11 "stop/error bits"
          for (int i = 0; i < cfg.nbstop11; i++) begin
            wait (sample_clk11);
            cur_frame11.stop_bits11[i] = serial_b11;
            `uvm_info(get_type_name(), $psprintf("Received11 a Stop bit: 'b%0b", cur_frame11.stop_bits11[i]), UVM_HIGH)
            num_of_bits_rcvd11++;
            wait (!sample_clk11);
          end
        end
        wait (!sample_clk11);
      end
    end
 num_frames11++; 
 `uvm_info(get_type_name(), $psprintf("Collected11 the following11 Frame11 No:%0d\n%s", num_frames11, cur_frame11.sprint()), UVM_MEDIUM)

  if(coverage_enable11) perform_coverage11();
  frame_collected_port11.write(cur_frame11);
  this.end_tr(cur_frame11);
endtask : collect_frame11

function void uart_monitor11::perform_coverage11();
  uart_trans_frame_cg11.sample();
endfunction : perform_coverage11

`endif

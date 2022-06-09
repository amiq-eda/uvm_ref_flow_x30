/*-------------------------------------------------------------------------
File2 name   : uart_monitor2.sv
Title2       : monitor2 file for uart2 uvc2
Project2     :
Created2     :
Description2 : Descirbes2 UART2 Monitor2. Rx2/Tx2 monitors2 should be derived2 form2
            : this uart_monitor2 base class
Notes2       :  
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH2
`define UART_MONITOR_SVH2

virtual class uart_monitor2 extends uvm_monitor;
   uvm_analysis_port #(uart_frame2) frame_collected_port2;

  // virtual interface 
  virtual interface uart_if2 vif2;

  // Handle2 to  a cfg class
  uart_config2 cfg; 

  int num_frames2;
  bit sample_clk2;
  bit baud_clk2;
  bit [15:0] ua_brgr2;
  bit [7:0] ua_bdiv2;
  int num_of_bits_rcvd2;
  int transmit_delay2;
  bit sop_detected2;
  bit tmp_bit02;
  bit serial_d12;
  bit serial_bit2;
  bit serial_b2;
  bit [1:0]  msb_lsb_data2;

  bit checks_enable2 = 1;   // enable protocol2 checking
  bit coverage_enable2 = 1; // control2 coverage2 in the monitor2
  uart_frame2 cur_frame2;

  `uvm_field_utils_begin(uart_monitor2)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable2, UVM_DEFAULT)
      `uvm_field_int(coverage_enable2, UVM_DEFAULT)
      `uvm_field_object(cur_frame2, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg2;
    NUM_STOP_BITS2 : coverpoint cfg.nbstop2 {
      bins ONE2 = {0};
      bins TWO2 = {1};
    }
    DATA_LENGTH2 : coverpoint cfg.char_length2 {
      bins EIGHT2 = {0,1};
      bins SEVEN2 = {2};
      bins SIX2 = {3};
    }
    PARITY_MODE2 : coverpoint cfg.parity_mode2 {
      bins EVEN2  = {0};
      bins ODD2   = {1};
      bins SPACE2 = {2};
      bins MARK2  = {3};
    }
    PARITY_ERROR2: coverpoint cur_frame2.error_bits2[1]
      {
        bins good2 = { 0 };
        bins bad2 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE2: cross DATA_LENGTH2, PARITY_MODE2;
    PARITY_ERROR_x_PARITY_MODE2: cross PARITY_ERROR2, PARITY_MODE2;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg2 = new();
    uart_trans_frame_cg2.set_inst_name ("uart_trans_frame_cg2");
    frame_collected_port2 = new("frame_collected_port2", this);
  endfunction: new

  // Additional2 class methods2;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate2(ref bit [15:0] ua_brgr2, ref bit sample_clk2, ref bit sop_detected2);
  extern virtual task start_synchronizer2(ref bit serial_d12, ref bit serial_b2);
  extern virtual protected function void perform_coverage2();
  extern virtual task collect_frame2();
  extern virtual task wait_for_sop2(ref bit sop_detected2);
  extern virtual task sample_and_store2();
endclass: uart_monitor2

// UVM build_phase
function void uart_monitor2::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config2)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG2", "uart_config2 not set for this somponent2")
endfunction : build_phase

function void uart_monitor2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if2)::get(this, "","vif2",vif2))
      `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".vif2"})
endfunction : connect_phase

task uart_monitor2::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start2 Running2", UVM_LOW)
  @(negedge vif2.reset); 
  wait (vif2.reset);
  `uvm_info(get_type_name(), "Detected2 Reset2 Done2", UVM_LOW)
  num_frames2 = 0;
  cur_frame2 = uart_frame2::type_id::create("cur_frame2", this);

  fork
    gen_sample_rate2(ua_brgr2, sample_clk2, sop_detected2);
    start_synchronizer2(serial_d12, serial_b2);
    sample_and_store2();
  join
endtask : run_phase

task uart_monitor2::gen_sample_rate2(ref bit [15:0] ua_brgr2, ref bit sample_clk2, ref bit sop_detected2);
    forever begin
      @(posedge vif2.clock2);
      if ((!vif2.reset) || (sop_detected2)) begin
        `uvm_info(get_type_name(), "sample_clk2- resetting2 ua_brgr2", UVM_HIGH)
        ua_brgr2 = 0;
        sample_clk2 = 0;
        sop_detected2 = 0;
      end else begin
        if ( ua_brgr2 == ({cfg.baud_rate_div2, cfg.baud_rate_gen2})) begin
          ua_brgr2 = 0;
          sample_clk2 = 1;
        end else begin
          sample_clk2 = 0;
          ua_brgr2++;
        end
      end
    end
endtask

task uart_monitor2::start_synchronizer2(ref bit serial_d12, ref bit serial_b2);
endtask

task uart_monitor2::sample_and_store2();
  forever begin
    wait_for_sop2(sop_detected2);
    collect_frame2();
  end
endtask : sample_and_store2

task uart_monitor2::wait_for_sop2(ref bit sop_detected2);
    transmit_delay2 = 0;
    sop_detected2 = 0;
    while (!sop_detected2) begin
      `uvm_info(get_type_name(), "trying2 to detect2 SOP2", UVM_MEDIUM)
      while (!(serial_d12 == 1 && serial_b2 == 0)) begin
        @(negedge vif2.clock2);
        transmit_delay2++;
      end
      if (serial_b2 != 0)
        `uvm_info(get_type_name(), "Encountered2 a glitch2 in serial2 during SOP2, shall2 continue", UVM_LOW)
      else
      begin
        sop_detected2 = 1;
        `uvm_info(get_type_name(), "SOP2 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop2
  

task uart_monitor2::collect_frame2();
  bit [7:0] payload_byte2;
  cur_frame2 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting2 a frame2: %0d", num_frames2+1), UVM_HIGH)
   // Begin2 Transaction2 Recording2
  void'(this.begin_tr(cur_frame2, "UART2 Monitor2", , get_full_name()));
  cur_frame2.transmit_delay2 = transmit_delay2;
  cur_frame2.start_bit2 = 1'b0;
  cur_frame2.parity_type2 = GOOD_PARITY2;
  num_of_bits_rcvd2 = 0;

    while (num_of_bits_rcvd2 < (1 + cfg.char_len_val2 + cfg.parity_en2 + cfg.nbstop2))
    begin
      @(posedge vif2.clock2);
      #1;
      if (sample_clk2) begin
        num_of_bits_rcvd2++;
        if ((num_of_bits_rcvd2 > 0) && (num_of_bits_rcvd2 <= cfg.char_len_val2)) begin // sending2 "data bits" 
          cur_frame2.payload2[num_of_bits_rcvd2-1] = serial_b2;
          payload_byte2 = cur_frame2.payload2[num_of_bits_rcvd2-1];
          `uvm_info(get_type_name(), $psprintf("Received2 a Frame2 data bit:'b%0b", payload_byte2), UVM_HIGH)
        end
        msb_lsb_data2[0] =  cur_frame2.payload2[0] ;
        msb_lsb_data2[1] =  cur_frame2.payload2[cfg.char_len_val2-1] ;
        if ((num_of_bits_rcvd2 == (1 + cfg.char_len_val2)) && (cfg.parity_en2)) begin // sending2 "parity2 bit" if parity2 is enabled
          cur_frame2.parity2 = serial_b2;
          `uvm_info(get_type_name(), $psprintf("Received2 Parity2 bit:'b%0b", cur_frame2.parity2), UVM_HIGH)
          if (serial_b2 == cur_frame2.calc_parity2(cfg.char_len_val2, cfg.parity_mode2))
            `uvm_info(get_type_name(), "Received2 Parity2 is same as calculated2 Parity2", UVM_MEDIUM)
          else if (checks_enable2)
            `uvm_error(get_type_name(), "####### FAIL2 :Received2 Parity2 doesn't match the calculated2 Parity2  ")
        end
        if (num_of_bits_rcvd2 == (1 + cfg.char_len_val2 + cfg.parity_en2)) begin // sending2 "stop/error bits"
          for (int i = 0; i < cfg.nbstop2; i++) begin
            wait (sample_clk2);
            cur_frame2.stop_bits2[i] = serial_b2;
            `uvm_info(get_type_name(), $psprintf("Received2 a Stop bit: 'b%0b", cur_frame2.stop_bits2[i]), UVM_HIGH)
            num_of_bits_rcvd2++;
            wait (!sample_clk2);
          end
        end
        wait (!sample_clk2);
      end
    end
 num_frames2++; 
 `uvm_info(get_type_name(), $psprintf("Collected2 the following2 Frame2 No:%0d\n%s", num_frames2, cur_frame2.sprint()), UVM_MEDIUM)

  if(coverage_enable2) perform_coverage2();
  frame_collected_port2.write(cur_frame2);
  this.end_tr(cur_frame2);
endtask : collect_frame2

function void uart_monitor2::perform_coverage2();
  uart_trans_frame_cg2.sample();
endfunction : perform_coverage2

`endif

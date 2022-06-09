/*-------------------------------------------------------------------------
File16 name   : uart_monitor16.sv
Title16       : monitor16 file for uart16 uvc16
Project16     :
Created16     :
Description16 : Descirbes16 UART16 Monitor16. Rx16/Tx16 monitors16 should be derived16 form16
            : this uart_monitor16 base class
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef UART_MONITOR_SVH16
`define UART_MONITOR_SVH16

virtual class uart_monitor16 extends uvm_monitor;
   uvm_analysis_port #(uart_frame16) frame_collected_port16;

  // virtual interface 
  virtual interface uart_if16 vif16;

  // Handle16 to  a cfg class
  uart_config16 cfg; 

  int num_frames16;
  bit sample_clk16;
  bit baud_clk16;
  bit [15:0] ua_brgr16;
  bit [7:0] ua_bdiv16;
  int num_of_bits_rcvd16;
  int transmit_delay16;
  bit sop_detected16;
  bit tmp_bit016;
  bit serial_d116;
  bit serial_bit16;
  bit serial_b16;
  bit [1:0]  msb_lsb_data16;

  bit checks_enable16 = 1;   // enable protocol16 checking
  bit coverage_enable16 = 1; // control16 coverage16 in the monitor16
  uart_frame16 cur_frame16;

  `uvm_field_utils_begin(uart_monitor16)
      `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
      `uvm_field_int(checks_enable16, UVM_DEFAULT)
      `uvm_field_int(coverage_enable16, UVM_DEFAULT)
      `uvm_field_object(cur_frame16, UVM_DEFAULT | UVM_NOPRINT)
  `uvm_field_utils_end

  covergroup uart_trans_frame_cg16;
    NUM_STOP_BITS16 : coverpoint cfg.nbstop16 {
      bins ONE16 = {0};
      bins TWO16 = {1};
    }
    DATA_LENGTH16 : coverpoint cfg.char_length16 {
      bins EIGHT16 = {0,1};
      bins SEVEN16 = {2};
      bins SIX16 = {3};
    }
    PARITY_MODE16 : coverpoint cfg.parity_mode16 {
      bins EVEN16  = {0};
      bins ODD16   = {1};
      bins SPACE16 = {2};
      bins MARK16  = {3};
    }
    PARITY_ERROR16: coverpoint cur_frame16.error_bits16[1]
      {
        bins good16 = { 0 };
        bins bad16 = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE16: cross DATA_LENGTH16, PARITY_MODE16;
    PARITY_ERROR_x_PARITY_MODE16: cross PARITY_ERROR16, PARITY_MODE16;

  endgroup

  function new (string name = "", uvm_component parent);
    super.new(name, parent);
    uart_trans_frame_cg16 = new();
    uart_trans_frame_cg16.set_inst_name ("uart_trans_frame_cg16");
    frame_collected_port16 = new("frame_collected_port16", this);
  endfunction: new

  // Additional16 class methods16;
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task gen_sample_rate16(ref bit [15:0] ua_brgr16, ref bit sample_clk16, ref bit sop_detected16);
  extern virtual task start_synchronizer16(ref bit serial_d116, ref bit serial_b16);
  extern virtual protected function void perform_coverage16();
  extern virtual task collect_frame16();
  extern virtual task wait_for_sop16(ref bit sop_detected16);
  extern virtual task sample_and_store16();
endclass: uart_monitor16

// UVM build_phase
function void uart_monitor16::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null)
    if (!uvm_config_db#(uart_config16)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG16", "uart_config16 not set for this somponent16")
endfunction : build_phase

function void uart_monitor16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if16)::get(this, "","vif16",vif16))
      `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".vif16"})
endfunction : connect_phase

task uart_monitor16::run_phase(uvm_phase phase);
 `uvm_info(get_type_name(),"Start16 Running16", UVM_LOW)
  @(negedge vif16.reset); 
  wait (vif16.reset);
  `uvm_info(get_type_name(), "Detected16 Reset16 Done16", UVM_LOW)
  num_frames16 = 0;
  cur_frame16 = uart_frame16::type_id::create("cur_frame16", this);

  fork
    gen_sample_rate16(ua_brgr16, sample_clk16, sop_detected16);
    start_synchronizer16(serial_d116, serial_b16);
    sample_and_store16();
  join
endtask : run_phase

task uart_monitor16::gen_sample_rate16(ref bit [15:0] ua_brgr16, ref bit sample_clk16, ref bit sop_detected16);
    forever begin
      @(posedge vif16.clock16);
      if ((!vif16.reset) || (sop_detected16)) begin
        `uvm_info(get_type_name(), "sample_clk16- resetting16 ua_brgr16", UVM_HIGH)
        ua_brgr16 = 0;
        sample_clk16 = 0;
        sop_detected16 = 0;
      end else begin
        if ( ua_brgr16 == ({cfg.baud_rate_div16, cfg.baud_rate_gen16})) begin
          ua_brgr16 = 0;
          sample_clk16 = 1;
        end else begin
          sample_clk16 = 0;
          ua_brgr16++;
        end
      end
    end
endtask

task uart_monitor16::start_synchronizer16(ref bit serial_d116, ref bit serial_b16);
endtask

task uart_monitor16::sample_and_store16();
  forever begin
    wait_for_sop16(sop_detected16);
    collect_frame16();
  end
endtask : sample_and_store16

task uart_monitor16::wait_for_sop16(ref bit sop_detected16);
    transmit_delay16 = 0;
    sop_detected16 = 0;
    while (!sop_detected16) begin
      `uvm_info(get_type_name(), "trying16 to detect16 SOP16", UVM_MEDIUM)
      while (!(serial_d116 == 1 && serial_b16 == 0)) begin
        @(negedge vif16.clock16);
        transmit_delay16++;
      end
      if (serial_b16 != 0)
        `uvm_info(get_type_name(), "Encountered16 a glitch16 in serial16 during SOP16, shall16 continue", UVM_LOW)
      else
      begin
        sop_detected16 = 1;
        `uvm_info(get_type_name(), "SOP16 detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop16
  

task uart_monitor16::collect_frame16();
  bit [7:0] payload_byte16;
  cur_frame16 = new;
 `uvm_info(get_type_name(), $psprintf("Collecting16 a frame16: %0d", num_frames16+1), UVM_HIGH)
   // Begin16 Transaction16 Recording16
  void'(this.begin_tr(cur_frame16, "UART16 Monitor16", , get_full_name()));
  cur_frame16.transmit_delay16 = transmit_delay16;
  cur_frame16.start_bit16 = 1'b0;
  cur_frame16.parity_type16 = GOOD_PARITY16;
  num_of_bits_rcvd16 = 0;

    while (num_of_bits_rcvd16 < (1 + cfg.char_len_val16 + cfg.parity_en16 + cfg.nbstop16))
    begin
      @(posedge vif16.clock16);
      #1;
      if (sample_clk16) begin
        num_of_bits_rcvd16++;
        if ((num_of_bits_rcvd16 > 0) && (num_of_bits_rcvd16 <= cfg.char_len_val16)) begin // sending16 "data bits" 
          cur_frame16.payload16[num_of_bits_rcvd16-1] = serial_b16;
          payload_byte16 = cur_frame16.payload16[num_of_bits_rcvd16-1];
          `uvm_info(get_type_name(), $psprintf("Received16 a Frame16 data bit:'b%0b", payload_byte16), UVM_HIGH)
        end
        msb_lsb_data16[0] =  cur_frame16.payload16[0] ;
        msb_lsb_data16[1] =  cur_frame16.payload16[cfg.char_len_val16-1] ;
        if ((num_of_bits_rcvd16 == (1 + cfg.char_len_val16)) && (cfg.parity_en16)) begin // sending16 "parity16 bit" if parity16 is enabled
          cur_frame16.parity16 = serial_b16;
          `uvm_info(get_type_name(), $psprintf("Received16 Parity16 bit:'b%0b", cur_frame16.parity16), UVM_HIGH)
          if (serial_b16 == cur_frame16.calc_parity16(cfg.char_len_val16, cfg.parity_mode16))
            `uvm_info(get_type_name(), "Received16 Parity16 is same as calculated16 Parity16", UVM_MEDIUM)
          else if (checks_enable16)
            `uvm_error(get_type_name(), "####### FAIL16 :Received16 Parity16 doesn't match the calculated16 Parity16  ")
        end
        if (num_of_bits_rcvd16 == (1 + cfg.char_len_val16 + cfg.parity_en16)) begin // sending16 "stop/error bits"
          for (int i = 0; i < cfg.nbstop16; i++) begin
            wait (sample_clk16);
            cur_frame16.stop_bits16[i] = serial_b16;
            `uvm_info(get_type_name(), $psprintf("Received16 a Stop bit: 'b%0b", cur_frame16.stop_bits16[i]), UVM_HIGH)
            num_of_bits_rcvd16++;
            wait (!sample_clk16);
          end
        end
        wait (!sample_clk16);
      end
    end
 num_frames16++; 
 `uvm_info(get_type_name(), $psprintf("Collected16 the following16 Frame16 No:%0d\n%s", num_frames16, cur_frame16.sprint()), UVM_MEDIUM)

  if(coverage_enable16) perform_coverage16();
  frame_collected_port16.write(cur_frame16);
  this.end_tr(cur_frame16);
endtask : collect_frame16

function void uart_monitor16::perform_coverage16();
  uart_trans_frame_cg16.sample();
endfunction : perform_coverage16

`endif

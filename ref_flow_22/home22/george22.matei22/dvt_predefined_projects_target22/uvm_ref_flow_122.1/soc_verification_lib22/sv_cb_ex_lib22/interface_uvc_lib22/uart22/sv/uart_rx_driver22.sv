/*-------------------------------------------------------------------------
File22 name   : uart_rx_driver22.sv
Title22       : RX22 Driver22
Project22     :
Created22     :
Description22 : Describes22 UART22 Receiver22 Driver22 for UART22 UVC22
Notes22       :  
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

`ifndef UART_RX_DRIVER22
`define UART_RX_DRIVER22

class uart_rx_driver22 extends uvm_driver #(uart_frame22) ;

  // The virtual interface used to drive22 and view22 HDL signals22.
  virtual interface uart_if22 vif22;

  // handle to  a cfg class
  uart_config22 cfg;

  bit sample_clk22;
  bit [15:0] ua_brgr22;
  bit [7:0] ua_bdiv22;
  int num_of_bits_sent22;
  int num_frames_sent22;

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver22)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr22, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv22, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor22 - required22 UVM syntax22
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional22 class methods22
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive22();
  extern virtual task gen_sample_rate22(ref bit [15:0] ua_brgr22, ref bit sample_clk22);
  extern virtual task send_rx_frame22(input uart_frame22 frame22);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver22

// UVM build_phase
function void uart_rx_driver22::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config22)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG22", "uart_config22 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if22)::get(this, "", "vif22", vif22))
   `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".vif22"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver22::run_phase(uvm_phase phase);
  fork
    get_and_drive22();
    gen_sample_rate22(ua_brgr22, sample_clk22);
  join
endtask : run_phase

// reset
task uart_rx_driver22::reset();
  @(negedge vif22.reset);
  `uvm_info(get_type_name(), "Reset22 Asserted22", UVM_MEDIUM)
   vif22.rxd22 = 1;        //Receive22 Data
   vif22.cts_n22 = 0;      //Clear to Send22
   vif22.dsr_n22 = 0;      //Data Set Ready22
   vif22.ri_n22 = 0;       //Ring22 Indicator22
   vif22.baud_clk22 = 0;   //Baud22 Clk22 - NOT22 USED22
endtask : reset

//  get_and22 drive22
task uart_rx_driver22::get_and_drive22();
  while (1) begin
    reset();
    fork
      @(negedge vif22.reset)
        `uvm_info(get_type_name(), "Reset22 asserted22", UVM_LOW)
    begin
      forever begin
        @(posedge vif22.clock22 iff (vif22.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame22(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If22 we22 are in the middle22 of a transfer22, need to end the rx22. Also22,
    //do any reset cleanup22 here22. The only way22 we22 got22 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive22

task uart_rx_driver22::gen_sample_rate22(ref bit [15:0] ua_brgr22, ref bit sample_clk22);
  forever begin
    @(posedge vif22.clock22);
    if (!vif22.reset) begin
      ua_brgr22 = 0;
      sample_clk22 = 0;
    end else begin
      if (ua_brgr22 == ({cfg.baud_rate_div22, cfg.baud_rate_gen22})) begin
        ua_brgr22 = 0;
        sample_clk22 = 1;
      end else begin
        sample_clk22 = 0;
        ua_brgr22++;
      end
    end
  end
endtask : gen_sample_rate22

// -------------------
// send_rx_frame22
// -------------------
task uart_rx_driver22::send_rx_frame22(input uart_frame22 frame22);
  bit [7:0] payload_byte22;
  num_of_bits_sent22 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver22 Sending22 RX22 Frame22...\n%s", frame22.sprint()),
            UVM_HIGH)
 
  repeat (frame22.transmit_delay22)
    @(posedge vif22.clock22);
  void'(this.begin_tr(frame22));
   
  wait((!cfg.rts_en22)||(!vif22.cts_n22));
  `uvm_info(get_type_name(), "Driver22 - Modem22 RTS22 or CTS22 asserted22", UVM_HIGH)

  while (num_of_bits_sent22 <= (1 + cfg.char_len_val22 + cfg.parity_en22 + cfg.nbstop22)) begin
    @(posedge vif22.clock22);
    #1;
    if (sample_clk22) begin
      if (num_of_bits_sent22 == 0) begin
        // Start22 sending22 rx_frame22 with "start bit"
        vif22.rxd22 = frame22.start_bit22;
        `uvm_info(get_type_name(),
                  $psprintf("Driver22 Sending22 Frame22 SOP22: %b", frame22.start_bit22),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent22 > 0) && (num_of_bits_sent22 < (1 + cfg.char_len_val22))) begin
        // sending22 "data bits" 
        payload_byte22 = frame22.payload22[num_of_bits_sent22-1] ;
        vif22.rxd22 = frame22.payload22[num_of_bits_sent22-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver22 Sending22 Frame22 data bit number22:%0d value:'b%b",
             (num_of_bits_sent22-1), payload_byte22), UVM_HIGH)
      end
      if ((num_of_bits_sent22 == (1 + cfg.char_len_val22)) && (cfg.parity_en22)) begin
        // sending22 "parity22 bit" if parity22 is enabled
        vif22.rxd22 = frame22.calc_parity22(cfg.char_len_val22, cfg.parity_mode22);
        `uvm_info(get_type_name(),
             $psprintf("Driver22 Sending22 Frame22 Parity22 bit:'b%b",
             frame22.calc_parity22(cfg.char_len_val22, cfg.parity_mode22)), UVM_HIGH)
      end
      if (num_of_bits_sent22 == (1 + cfg.char_len_val22 + cfg.parity_en22)) begin
        // sending22 "stop/error bits"
        for (int i = 0; i < cfg.nbstop22; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver22 Sending22 Frame22 Stop bit:'b%b",
               frame22.stop_bits22[i]), UVM_HIGH)
          wait (sample_clk22);
          if (frame22.error_bits22[i]) begin
            vif22.rxd22 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver22 intensionally22 corrupting22 Stop bit since22 error_bits22['b%b] is 'b%b", i, frame22.error_bits22[i]),
                 UVM_HIGH)
          end else
          vif22.rxd22 = frame22.stop_bits22[i];
          num_of_bits_sent22++;
          wait (!sample_clk22);
        end
      end
    num_of_bits_sent22++;
    wait (!sample_clk22);
    end
  end
  
  num_frames_sent22++;
  `uvm_info(get_type_name(),
       $psprintf("Frame22 **%0d** Sent22...", num_frames_sent22), UVM_MEDIUM)
  wait (sample_clk22);
  vif22.rxd22 = 1;

  `uvm_info(get_type_name(), "Frame22 complete...", UVM_MEDIUM)
  this.end_tr(frame22);
   
endtask : send_rx_frame22

//UVM report_phase
function void uart_rx_driver22::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART22 Frames22 Sent22:%0d", num_frames_sent22),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER22

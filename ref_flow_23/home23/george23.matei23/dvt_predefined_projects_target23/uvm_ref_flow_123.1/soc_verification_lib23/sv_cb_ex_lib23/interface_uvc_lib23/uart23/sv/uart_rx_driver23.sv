/*-------------------------------------------------------------------------
File23 name   : uart_rx_driver23.sv
Title23       : RX23 Driver23
Project23     :
Created23     :
Description23 : Describes23 UART23 Receiver23 Driver23 for UART23 UVC23
Notes23       :  
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

`ifndef UART_RX_DRIVER23
`define UART_RX_DRIVER23

class uart_rx_driver23 extends uvm_driver #(uart_frame23) ;

  // The virtual interface used to drive23 and view23 HDL signals23.
  virtual interface uart_if23 vif23;

  // handle to  a cfg class
  uart_config23 cfg;

  bit sample_clk23;
  bit [15:0] ua_brgr23;
  bit [7:0] ua_bdiv23;
  int num_of_bits_sent23;
  int num_frames_sent23;

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver23)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr23, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv23, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor23 - required23 UVM syntax23
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional23 class methods23
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive23();
  extern virtual task gen_sample_rate23(ref bit [15:0] ua_brgr23, ref bit sample_clk23);
  extern virtual task send_rx_frame23(input uart_frame23 frame23);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver23

// UVM build_phase
function void uart_rx_driver23::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config23)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG23", "uart_config23 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if23)::get(this, "", "vif23", vif23))
   `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".vif23"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver23::run_phase(uvm_phase phase);
  fork
    get_and_drive23();
    gen_sample_rate23(ua_brgr23, sample_clk23);
  join
endtask : run_phase

// reset
task uart_rx_driver23::reset();
  @(negedge vif23.reset);
  `uvm_info(get_type_name(), "Reset23 Asserted23", UVM_MEDIUM)
   vif23.rxd23 = 1;        //Receive23 Data
   vif23.cts_n23 = 0;      //Clear to Send23
   vif23.dsr_n23 = 0;      //Data Set Ready23
   vif23.ri_n23 = 0;       //Ring23 Indicator23
   vif23.baud_clk23 = 0;   //Baud23 Clk23 - NOT23 USED23
endtask : reset

//  get_and23 drive23
task uart_rx_driver23::get_and_drive23();
  while (1) begin
    reset();
    fork
      @(negedge vif23.reset)
        `uvm_info(get_type_name(), "Reset23 asserted23", UVM_LOW)
    begin
      forever begin
        @(posedge vif23.clock23 iff (vif23.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame23(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If23 we23 are in the middle23 of a transfer23, need to end the rx23. Also23,
    //do any reset cleanup23 here23. The only way23 we23 got23 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive23

task uart_rx_driver23::gen_sample_rate23(ref bit [15:0] ua_brgr23, ref bit sample_clk23);
  forever begin
    @(posedge vif23.clock23);
    if (!vif23.reset) begin
      ua_brgr23 = 0;
      sample_clk23 = 0;
    end else begin
      if (ua_brgr23 == ({cfg.baud_rate_div23, cfg.baud_rate_gen23})) begin
        ua_brgr23 = 0;
        sample_clk23 = 1;
      end else begin
        sample_clk23 = 0;
        ua_brgr23++;
      end
    end
  end
endtask : gen_sample_rate23

// -------------------
// send_rx_frame23
// -------------------
task uart_rx_driver23::send_rx_frame23(input uart_frame23 frame23);
  bit [7:0] payload_byte23;
  num_of_bits_sent23 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver23 Sending23 RX23 Frame23...\n%s", frame23.sprint()),
            UVM_HIGH)
 
  repeat (frame23.transmit_delay23)
    @(posedge vif23.clock23);
  void'(this.begin_tr(frame23));
   
  wait((!cfg.rts_en23)||(!vif23.cts_n23));
  `uvm_info(get_type_name(), "Driver23 - Modem23 RTS23 or CTS23 asserted23", UVM_HIGH)

  while (num_of_bits_sent23 <= (1 + cfg.char_len_val23 + cfg.parity_en23 + cfg.nbstop23)) begin
    @(posedge vif23.clock23);
    #1;
    if (sample_clk23) begin
      if (num_of_bits_sent23 == 0) begin
        // Start23 sending23 rx_frame23 with "start bit"
        vif23.rxd23 = frame23.start_bit23;
        `uvm_info(get_type_name(),
                  $psprintf("Driver23 Sending23 Frame23 SOP23: %b", frame23.start_bit23),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent23 > 0) && (num_of_bits_sent23 < (1 + cfg.char_len_val23))) begin
        // sending23 "data bits" 
        payload_byte23 = frame23.payload23[num_of_bits_sent23-1] ;
        vif23.rxd23 = frame23.payload23[num_of_bits_sent23-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver23 Sending23 Frame23 data bit number23:%0d value:'b%b",
             (num_of_bits_sent23-1), payload_byte23), UVM_HIGH)
      end
      if ((num_of_bits_sent23 == (1 + cfg.char_len_val23)) && (cfg.parity_en23)) begin
        // sending23 "parity23 bit" if parity23 is enabled
        vif23.rxd23 = frame23.calc_parity23(cfg.char_len_val23, cfg.parity_mode23);
        `uvm_info(get_type_name(),
             $psprintf("Driver23 Sending23 Frame23 Parity23 bit:'b%b",
             frame23.calc_parity23(cfg.char_len_val23, cfg.parity_mode23)), UVM_HIGH)
      end
      if (num_of_bits_sent23 == (1 + cfg.char_len_val23 + cfg.parity_en23)) begin
        // sending23 "stop/error bits"
        for (int i = 0; i < cfg.nbstop23; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver23 Sending23 Frame23 Stop bit:'b%b",
               frame23.stop_bits23[i]), UVM_HIGH)
          wait (sample_clk23);
          if (frame23.error_bits23[i]) begin
            vif23.rxd23 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver23 intensionally23 corrupting23 Stop bit since23 error_bits23['b%b] is 'b%b", i, frame23.error_bits23[i]),
                 UVM_HIGH)
          end else
          vif23.rxd23 = frame23.stop_bits23[i];
          num_of_bits_sent23++;
          wait (!sample_clk23);
        end
      end
    num_of_bits_sent23++;
    wait (!sample_clk23);
    end
  end
  
  num_frames_sent23++;
  `uvm_info(get_type_name(),
       $psprintf("Frame23 **%0d** Sent23...", num_frames_sent23), UVM_MEDIUM)
  wait (sample_clk23);
  vif23.rxd23 = 1;

  `uvm_info(get_type_name(), "Frame23 complete...", UVM_MEDIUM)
  this.end_tr(frame23);
   
endtask : send_rx_frame23

//UVM report_phase
function void uart_rx_driver23::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART23 Frames23 Sent23:%0d", num_frames_sent23),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER23

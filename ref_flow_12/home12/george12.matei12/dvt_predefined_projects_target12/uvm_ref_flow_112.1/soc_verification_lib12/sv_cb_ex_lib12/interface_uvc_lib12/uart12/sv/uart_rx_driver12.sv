/*-------------------------------------------------------------------------
File12 name   : uart_rx_driver12.sv
Title12       : RX12 Driver12
Project12     :
Created12     :
Description12 : Describes12 UART12 Receiver12 Driver12 for UART12 UVC12
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

`ifndef UART_RX_DRIVER12
`define UART_RX_DRIVER12

class uart_rx_driver12 extends uvm_driver #(uart_frame12) ;

  // The virtual interface used to drive12 and view12 HDL signals12.
  virtual interface uart_if12 vif12;

  // handle to  a cfg class
  uart_config12 cfg;

  bit sample_clk12;
  bit [15:0] ua_brgr12;
  bit [7:0] ua_bdiv12;
  int num_of_bits_sent12;
  int num_frames_sent12;

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver12)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr12, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv12, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor12 - required12 UVM syntax12
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional12 class methods12
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive12();
  extern virtual task gen_sample_rate12(ref bit [15:0] ua_brgr12, ref bit sample_clk12);
  extern virtual task send_rx_frame12(input uart_frame12 frame12);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver12

// UVM build_phase
function void uart_rx_driver12::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config12)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG12", "uart_config12 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if12)::get(this, "", "vif12", vif12))
   `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".vif12"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver12::run_phase(uvm_phase phase);
  fork
    get_and_drive12();
    gen_sample_rate12(ua_brgr12, sample_clk12);
  join
endtask : run_phase

// reset
task uart_rx_driver12::reset();
  @(negedge vif12.reset);
  `uvm_info(get_type_name(), "Reset12 Asserted12", UVM_MEDIUM)
   vif12.rxd12 = 1;        //Receive12 Data
   vif12.cts_n12 = 0;      //Clear to Send12
   vif12.dsr_n12 = 0;      //Data Set Ready12
   vif12.ri_n12 = 0;       //Ring12 Indicator12
   vif12.baud_clk12 = 0;   //Baud12 Clk12 - NOT12 USED12
endtask : reset

//  get_and12 drive12
task uart_rx_driver12::get_and_drive12();
  while (1) begin
    reset();
    fork
      @(negedge vif12.reset)
        `uvm_info(get_type_name(), "Reset12 asserted12", UVM_LOW)
    begin
      forever begin
        @(posedge vif12.clock12 iff (vif12.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame12(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If12 we12 are in the middle12 of a transfer12, need to end the rx12. Also12,
    //do any reset cleanup12 here12. The only way12 we12 got12 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive12

task uart_rx_driver12::gen_sample_rate12(ref bit [15:0] ua_brgr12, ref bit sample_clk12);
  forever begin
    @(posedge vif12.clock12);
    if (!vif12.reset) begin
      ua_brgr12 = 0;
      sample_clk12 = 0;
    end else begin
      if (ua_brgr12 == ({cfg.baud_rate_div12, cfg.baud_rate_gen12})) begin
        ua_brgr12 = 0;
        sample_clk12 = 1;
      end else begin
        sample_clk12 = 0;
        ua_brgr12++;
      end
    end
  end
endtask : gen_sample_rate12

// -------------------
// send_rx_frame12
// -------------------
task uart_rx_driver12::send_rx_frame12(input uart_frame12 frame12);
  bit [7:0] payload_byte12;
  num_of_bits_sent12 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver12 Sending12 RX12 Frame12...\n%s", frame12.sprint()),
            UVM_HIGH)
 
  repeat (frame12.transmit_delay12)
    @(posedge vif12.clock12);
  void'(this.begin_tr(frame12));
   
  wait((!cfg.rts_en12)||(!vif12.cts_n12));
  `uvm_info(get_type_name(), "Driver12 - Modem12 RTS12 or CTS12 asserted12", UVM_HIGH)

  while (num_of_bits_sent12 <= (1 + cfg.char_len_val12 + cfg.parity_en12 + cfg.nbstop12)) begin
    @(posedge vif12.clock12);
    #1;
    if (sample_clk12) begin
      if (num_of_bits_sent12 == 0) begin
        // Start12 sending12 rx_frame12 with "start bit"
        vif12.rxd12 = frame12.start_bit12;
        `uvm_info(get_type_name(),
                  $psprintf("Driver12 Sending12 Frame12 SOP12: %b", frame12.start_bit12),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent12 > 0) && (num_of_bits_sent12 < (1 + cfg.char_len_val12))) begin
        // sending12 "data bits" 
        payload_byte12 = frame12.payload12[num_of_bits_sent12-1] ;
        vif12.rxd12 = frame12.payload12[num_of_bits_sent12-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver12 Sending12 Frame12 data bit number12:%0d value:'b%b",
             (num_of_bits_sent12-1), payload_byte12), UVM_HIGH)
      end
      if ((num_of_bits_sent12 == (1 + cfg.char_len_val12)) && (cfg.parity_en12)) begin
        // sending12 "parity12 bit" if parity12 is enabled
        vif12.rxd12 = frame12.calc_parity12(cfg.char_len_val12, cfg.parity_mode12);
        `uvm_info(get_type_name(),
             $psprintf("Driver12 Sending12 Frame12 Parity12 bit:'b%b",
             frame12.calc_parity12(cfg.char_len_val12, cfg.parity_mode12)), UVM_HIGH)
      end
      if (num_of_bits_sent12 == (1 + cfg.char_len_val12 + cfg.parity_en12)) begin
        // sending12 "stop/error bits"
        for (int i = 0; i < cfg.nbstop12; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver12 Sending12 Frame12 Stop bit:'b%b",
               frame12.stop_bits12[i]), UVM_HIGH)
          wait (sample_clk12);
          if (frame12.error_bits12[i]) begin
            vif12.rxd12 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver12 intensionally12 corrupting12 Stop bit since12 error_bits12['b%b] is 'b%b", i, frame12.error_bits12[i]),
                 UVM_HIGH)
          end else
          vif12.rxd12 = frame12.stop_bits12[i];
          num_of_bits_sent12++;
          wait (!sample_clk12);
        end
      end
    num_of_bits_sent12++;
    wait (!sample_clk12);
    end
  end
  
  num_frames_sent12++;
  `uvm_info(get_type_name(),
       $psprintf("Frame12 **%0d** Sent12...", num_frames_sent12), UVM_MEDIUM)
  wait (sample_clk12);
  vif12.rxd12 = 1;

  `uvm_info(get_type_name(), "Frame12 complete...", UVM_MEDIUM)
  this.end_tr(frame12);
   
endtask : send_rx_frame12

//UVM report_phase
function void uart_rx_driver12::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART12 Frames12 Sent12:%0d", num_frames_sent12),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER12

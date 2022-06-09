/*-------------------------------------------------------------------------
File26 name   : uart_rx_driver26.sv
Title26       : RX26 Driver26
Project26     :
Created26     :
Description26 : Describes26 UART26 Receiver26 Driver26 for UART26 UVC26
Notes26       :  
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

`ifndef UART_RX_DRIVER26
`define UART_RX_DRIVER26

class uart_rx_driver26 extends uvm_driver #(uart_frame26) ;

  // The virtual interface used to drive26 and view26 HDL signals26.
  virtual interface uart_if26 vif26;

  // handle to  a cfg class
  uart_config26 cfg;

  bit sample_clk26;
  bit [15:0] ua_brgr26;
  bit [7:0] ua_bdiv26;
  int num_of_bits_sent26;
  int num_frames_sent26;

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver26)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr26, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv26, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor26 - required26 UVM syntax26
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional26 class methods26
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive26();
  extern virtual task gen_sample_rate26(ref bit [15:0] ua_brgr26, ref bit sample_clk26);
  extern virtual task send_rx_frame26(input uart_frame26 frame26);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver26

// UVM build_phase
function void uart_rx_driver26::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config26)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG26", "uart_config26 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if26)::get(this, "", "vif26", vif26))
   `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver26::run_phase(uvm_phase phase);
  fork
    get_and_drive26();
    gen_sample_rate26(ua_brgr26, sample_clk26);
  join
endtask : run_phase

// reset
task uart_rx_driver26::reset();
  @(negedge vif26.reset);
  `uvm_info(get_type_name(), "Reset26 Asserted26", UVM_MEDIUM)
   vif26.rxd26 = 1;        //Receive26 Data
   vif26.cts_n26 = 0;      //Clear to Send26
   vif26.dsr_n26 = 0;      //Data Set Ready26
   vif26.ri_n26 = 0;       //Ring26 Indicator26
   vif26.baud_clk26 = 0;   //Baud26 Clk26 - NOT26 USED26
endtask : reset

//  get_and26 drive26
task uart_rx_driver26::get_and_drive26();
  while (1) begin
    reset();
    fork
      @(negedge vif26.reset)
        `uvm_info(get_type_name(), "Reset26 asserted26", UVM_LOW)
    begin
      forever begin
        @(posedge vif26.clock26 iff (vif26.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame26(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If26 we26 are in the middle26 of a transfer26, need to end the rx26. Also26,
    //do any reset cleanup26 here26. The only way26 we26 got26 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive26

task uart_rx_driver26::gen_sample_rate26(ref bit [15:0] ua_brgr26, ref bit sample_clk26);
  forever begin
    @(posedge vif26.clock26);
    if (!vif26.reset) begin
      ua_brgr26 = 0;
      sample_clk26 = 0;
    end else begin
      if (ua_brgr26 == ({cfg.baud_rate_div26, cfg.baud_rate_gen26})) begin
        ua_brgr26 = 0;
        sample_clk26 = 1;
      end else begin
        sample_clk26 = 0;
        ua_brgr26++;
      end
    end
  end
endtask : gen_sample_rate26

// -------------------
// send_rx_frame26
// -------------------
task uart_rx_driver26::send_rx_frame26(input uart_frame26 frame26);
  bit [7:0] payload_byte26;
  num_of_bits_sent26 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver26 Sending26 RX26 Frame26...\n%s", frame26.sprint()),
            UVM_HIGH)
 
  repeat (frame26.transmit_delay26)
    @(posedge vif26.clock26);
  void'(this.begin_tr(frame26));
   
  wait((!cfg.rts_en26)||(!vif26.cts_n26));
  `uvm_info(get_type_name(), "Driver26 - Modem26 RTS26 or CTS26 asserted26", UVM_HIGH)

  while (num_of_bits_sent26 <= (1 + cfg.char_len_val26 + cfg.parity_en26 + cfg.nbstop26)) begin
    @(posedge vif26.clock26);
    #1;
    if (sample_clk26) begin
      if (num_of_bits_sent26 == 0) begin
        // Start26 sending26 rx_frame26 with "start bit"
        vif26.rxd26 = frame26.start_bit26;
        `uvm_info(get_type_name(),
                  $psprintf("Driver26 Sending26 Frame26 SOP26: %b", frame26.start_bit26),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent26 > 0) && (num_of_bits_sent26 < (1 + cfg.char_len_val26))) begin
        // sending26 "data bits" 
        payload_byte26 = frame26.payload26[num_of_bits_sent26-1] ;
        vif26.rxd26 = frame26.payload26[num_of_bits_sent26-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver26 Sending26 Frame26 data bit number26:%0d value:'b%b",
             (num_of_bits_sent26-1), payload_byte26), UVM_HIGH)
      end
      if ((num_of_bits_sent26 == (1 + cfg.char_len_val26)) && (cfg.parity_en26)) begin
        // sending26 "parity26 bit" if parity26 is enabled
        vif26.rxd26 = frame26.calc_parity26(cfg.char_len_val26, cfg.parity_mode26);
        `uvm_info(get_type_name(),
             $psprintf("Driver26 Sending26 Frame26 Parity26 bit:'b%b",
             frame26.calc_parity26(cfg.char_len_val26, cfg.parity_mode26)), UVM_HIGH)
      end
      if (num_of_bits_sent26 == (1 + cfg.char_len_val26 + cfg.parity_en26)) begin
        // sending26 "stop/error bits"
        for (int i = 0; i < cfg.nbstop26; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver26 Sending26 Frame26 Stop bit:'b%b",
               frame26.stop_bits26[i]), UVM_HIGH)
          wait (sample_clk26);
          if (frame26.error_bits26[i]) begin
            vif26.rxd26 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver26 intensionally26 corrupting26 Stop bit since26 error_bits26['b%b] is 'b%b", i, frame26.error_bits26[i]),
                 UVM_HIGH)
          end else
          vif26.rxd26 = frame26.stop_bits26[i];
          num_of_bits_sent26++;
          wait (!sample_clk26);
        end
      end
    num_of_bits_sent26++;
    wait (!sample_clk26);
    end
  end
  
  num_frames_sent26++;
  `uvm_info(get_type_name(),
       $psprintf("Frame26 **%0d** Sent26...", num_frames_sent26), UVM_MEDIUM)
  wait (sample_clk26);
  vif26.rxd26 = 1;

  `uvm_info(get_type_name(), "Frame26 complete...", UVM_MEDIUM)
  this.end_tr(frame26);
   
endtask : send_rx_frame26

//UVM report_phase
function void uart_rx_driver26::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART26 Frames26 Sent26:%0d", num_frames_sent26),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER26

/*-------------------------------------------------------------------------
File17 name   : uart_tx_driver17.sv
Title17       : TX17 Driver17
Project17     :
Created17     :
Description17 : Describes17 UART17 Trasmit17 Driver17 for UART17 UVC17
Notes17       :  
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER17
`define UART_TX_DRIVER17

class uart_tx_driver17 extends uvm_driver #(uart_frame17) ;

  // The virtual interface used to drive17 and view17 HDL signals17.
  virtual interface uart_if17 vif17;

  // handle to  a cfg class
  uart_config17 cfg;

  bit sample_clk17;
  bit baud_clk17;
  bit [15:0] ua_brgr17;
  bit [7:0] ua_bdiv17;
  int num_of_bits_sent17;
  int num_frames_sent17;

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver17)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk17, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk17, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr17, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv17, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor17 - required17 UVM syntax17
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional17 class methods17
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive17();
  extern virtual task gen_sample_rate17(ref bit [15:0] ua_brgr17, ref bit sample_clk17);
  extern virtual task send_tx_frame17(input uart_frame17 frame17);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver17

// UVM build_phase
function void uart_tx_driver17::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config17)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG17", "uart_config17 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if17)::get(this, "", "vif17", vif17))
   `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver17::run_phase(uvm_phase phase);
  fork
    get_and_drive17();
    gen_sample_rate17(ua_brgr17, sample_clk17);
  join
endtask : run_phase

// reset
task uart_tx_driver17::reset();
  @(negedge vif17.reset);
  `uvm_info(get_type_name(), "Reset17 Asserted17", UVM_MEDIUM)
   vif17.txd17 = 1;        //Transmit17 Data
   vif17.rts_n17 = 0;      //Request17 to Send17
   vif17.dtr_n17 = 0;      //Data Terminal17 Ready17
   vif17.dcd_n17 = 0;      //Data Carrier17 Detect17
   vif17.baud_clk17 = 0;       //Baud17 Data
endtask : reset

//  get_and17 drive17
task uart_tx_driver17::get_and_drive17();
  while (1) begin
    reset();
    fork
      @(negedge vif17.reset)
        `uvm_info(get_type_name(), "Reset17 asserted17", UVM_LOW)
    begin
      forever begin
        @(posedge vif17.clock17 iff (vif17.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame17(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If17 we17 are in the middle17 of a transfer17, need to end the tx17. Also17,
    //do any reset cleanup17 here17. The only way17 we17 got17 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive17

task uart_tx_driver17::gen_sample_rate17(ref bit [15:0] ua_brgr17, ref bit sample_clk17);
  forever begin
    @(posedge vif17.clock17);
    if (!vif17.reset) begin
      ua_brgr17 = 0;
      sample_clk17 = 0;
    end else begin
      if (ua_brgr17 == ({cfg.baud_rate_div17, cfg.baud_rate_gen17})) begin
        ua_brgr17 = 0;
        sample_clk17 = 1;
      end else begin
        sample_clk17 = 0;
        ua_brgr17++;
      end
    end
  end
endtask : gen_sample_rate17

// -------------------
// send_tx_frame17
// -------------------
task uart_tx_driver17::send_tx_frame17(input uart_frame17 frame17);
  bit [7:0] payload_byte17;
  num_of_bits_sent17 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver17 Sending17 TX17 Frame17...\n%s", frame17.sprint()),
            UVM_HIGH)
 
  repeat (frame17.transmit_delay17)
    @(posedge vif17.clock17);
  void'(this.begin_tr(frame17));
   
  wait((!cfg.rts_en17)||(!vif17.cts_n17));
  `uvm_info(get_type_name(), "Driver17 - Modem17 RTS17 or CTS17 asserted17", UVM_HIGH)

  while (num_of_bits_sent17 <= (1 + cfg.char_len_val17 + cfg.parity_en17 + cfg.nbstop17)) begin
    @(posedge vif17.clock17);
    #1;
    if (sample_clk17) begin
      if (num_of_bits_sent17 == 0) begin
        // Start17 sending17 tx_frame17 with "start bit"
        vif17.txd17 = frame17.start_bit17;
        `uvm_info(get_type_name(),
                  $psprintf("Driver17 Sending17 Frame17 SOP17: %b", frame17.start_bit17),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent17 > 0) && (num_of_bits_sent17 < (1 + cfg.char_len_val17))) begin
        // sending17 "data bits" 
        payload_byte17 = frame17.payload17[num_of_bits_sent17-1] ;
        vif17.txd17 = frame17.payload17[num_of_bits_sent17-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver17 Sending17 Frame17 data bit number17:%0d value:'b%b",
             (num_of_bits_sent17-1), payload_byte17), UVM_HIGH)
      end
      if ((num_of_bits_sent17 == (1 + cfg.char_len_val17)) && (cfg.parity_en17)) begin
        // sending17 "parity17 bit" if parity17 is enabled
        vif17.txd17 = frame17.calc_parity17(cfg.char_len_val17, cfg.parity_mode17);
        `uvm_info(get_type_name(),
             $psprintf("Driver17 Sending17 Frame17 Parity17 bit:'b%b",
             frame17.calc_parity17(cfg.char_len_val17, cfg.parity_mode17)), UVM_HIGH)
      end
      if (num_of_bits_sent17 == (1 + cfg.char_len_val17 + cfg.parity_en17)) begin
        // sending17 "stop/error bits"
        for (int i = 0; i < cfg.nbstop17; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver17 Sending17 Frame17 Stop bit:'b%b",
               frame17.stop_bits17[i]), UVM_HIGH)
          wait (sample_clk17);
          if (frame17.error_bits17[i]) begin
            vif17.txd17 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver17 intensionally17 corrupting17 Stop bit since17 error_bits17['b%b] is 'b%b", i, frame17.error_bits17[i]),
                 UVM_HIGH)
          end else
          vif17.txd17 = frame17.stop_bits17[i];
          num_of_bits_sent17++;
          wait (!sample_clk17);
        end
      end
    num_of_bits_sent17++;
    wait (!sample_clk17);
    end
  end
  
  num_frames_sent17++;
  `uvm_info(get_type_name(),
       $psprintf("Frame17 **%0d** Sent17...", num_frames_sent17), UVM_MEDIUM)
  wait (sample_clk17);
  vif17.txd17 = 1;

  `uvm_info(get_type_name(), "Frame17 complete...", UVM_MEDIUM)
  this.end_tr(frame17);
   
endtask : send_tx_frame17

//UVM report_phase
function void uart_tx_driver17::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART17 Frames17 Sent17:%0d", num_frames_sent17),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER17

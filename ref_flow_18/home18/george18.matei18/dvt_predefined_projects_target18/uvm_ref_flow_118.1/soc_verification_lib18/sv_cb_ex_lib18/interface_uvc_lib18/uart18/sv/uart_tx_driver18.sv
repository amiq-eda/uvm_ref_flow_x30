/*-------------------------------------------------------------------------
File18 name   : uart_tx_driver18.sv
Title18       : TX18 Driver18
Project18     :
Created18     :
Description18 : Describes18 UART18 Trasmit18 Driver18 for UART18 UVC18
Notes18       :  
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER18
`define UART_TX_DRIVER18

class uart_tx_driver18 extends uvm_driver #(uart_frame18) ;

  // The virtual interface used to drive18 and view18 HDL signals18.
  virtual interface uart_if18 vif18;

  // handle to  a cfg class
  uart_config18 cfg;

  bit sample_clk18;
  bit baud_clk18;
  bit [15:0] ua_brgr18;
  bit [7:0] ua_bdiv18;
  int num_of_bits_sent18;
  int num_frames_sent18;

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver18)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk18, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk18, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr18, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv18, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor18 - required18 UVM syntax18
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive18();
  extern virtual task gen_sample_rate18(ref bit [15:0] ua_brgr18, ref bit sample_clk18);
  extern virtual task send_tx_frame18(input uart_frame18 frame18);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver18

// UVM build_phase
function void uart_tx_driver18::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config18)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG18", "uart_config18 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if18)::get(this, "", "vif18", vif18))
   `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".vif18"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver18::run_phase(uvm_phase phase);
  fork
    get_and_drive18();
    gen_sample_rate18(ua_brgr18, sample_clk18);
  join
endtask : run_phase

// reset
task uart_tx_driver18::reset();
  @(negedge vif18.reset);
  `uvm_info(get_type_name(), "Reset18 Asserted18", UVM_MEDIUM)
   vif18.txd18 = 1;        //Transmit18 Data
   vif18.rts_n18 = 0;      //Request18 to Send18
   vif18.dtr_n18 = 0;      //Data Terminal18 Ready18
   vif18.dcd_n18 = 0;      //Data Carrier18 Detect18
   vif18.baud_clk18 = 0;       //Baud18 Data
endtask : reset

//  get_and18 drive18
task uart_tx_driver18::get_and_drive18();
  while (1) begin
    reset();
    fork
      @(negedge vif18.reset)
        `uvm_info(get_type_name(), "Reset18 asserted18", UVM_LOW)
    begin
      forever begin
        @(posedge vif18.clock18 iff (vif18.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame18(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If18 we18 are in the middle18 of a transfer18, need to end the tx18. Also18,
    //do any reset cleanup18 here18. The only way18 we18 got18 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive18

task uart_tx_driver18::gen_sample_rate18(ref bit [15:0] ua_brgr18, ref bit sample_clk18);
  forever begin
    @(posedge vif18.clock18);
    if (!vif18.reset) begin
      ua_brgr18 = 0;
      sample_clk18 = 0;
    end else begin
      if (ua_brgr18 == ({cfg.baud_rate_div18, cfg.baud_rate_gen18})) begin
        ua_brgr18 = 0;
        sample_clk18 = 1;
      end else begin
        sample_clk18 = 0;
        ua_brgr18++;
      end
    end
  end
endtask : gen_sample_rate18

// -------------------
// send_tx_frame18
// -------------------
task uart_tx_driver18::send_tx_frame18(input uart_frame18 frame18);
  bit [7:0] payload_byte18;
  num_of_bits_sent18 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver18 Sending18 TX18 Frame18...\n%s", frame18.sprint()),
            UVM_HIGH)
 
  repeat (frame18.transmit_delay18)
    @(posedge vif18.clock18);
  void'(this.begin_tr(frame18));
   
  wait((!cfg.rts_en18)||(!vif18.cts_n18));
  `uvm_info(get_type_name(), "Driver18 - Modem18 RTS18 or CTS18 asserted18", UVM_HIGH)

  while (num_of_bits_sent18 <= (1 + cfg.char_len_val18 + cfg.parity_en18 + cfg.nbstop18)) begin
    @(posedge vif18.clock18);
    #1;
    if (sample_clk18) begin
      if (num_of_bits_sent18 == 0) begin
        // Start18 sending18 tx_frame18 with "start bit"
        vif18.txd18 = frame18.start_bit18;
        `uvm_info(get_type_name(),
                  $psprintf("Driver18 Sending18 Frame18 SOP18: %b", frame18.start_bit18),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent18 > 0) && (num_of_bits_sent18 < (1 + cfg.char_len_val18))) begin
        // sending18 "data bits" 
        payload_byte18 = frame18.payload18[num_of_bits_sent18-1] ;
        vif18.txd18 = frame18.payload18[num_of_bits_sent18-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver18 Sending18 Frame18 data bit number18:%0d value:'b%b",
             (num_of_bits_sent18-1), payload_byte18), UVM_HIGH)
      end
      if ((num_of_bits_sent18 == (1 + cfg.char_len_val18)) && (cfg.parity_en18)) begin
        // sending18 "parity18 bit" if parity18 is enabled
        vif18.txd18 = frame18.calc_parity18(cfg.char_len_val18, cfg.parity_mode18);
        `uvm_info(get_type_name(),
             $psprintf("Driver18 Sending18 Frame18 Parity18 bit:'b%b",
             frame18.calc_parity18(cfg.char_len_val18, cfg.parity_mode18)), UVM_HIGH)
      end
      if (num_of_bits_sent18 == (1 + cfg.char_len_val18 + cfg.parity_en18)) begin
        // sending18 "stop/error bits"
        for (int i = 0; i < cfg.nbstop18; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver18 Sending18 Frame18 Stop bit:'b%b",
               frame18.stop_bits18[i]), UVM_HIGH)
          wait (sample_clk18);
          if (frame18.error_bits18[i]) begin
            vif18.txd18 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver18 intensionally18 corrupting18 Stop bit since18 error_bits18['b%b] is 'b%b", i, frame18.error_bits18[i]),
                 UVM_HIGH)
          end else
          vif18.txd18 = frame18.stop_bits18[i];
          num_of_bits_sent18++;
          wait (!sample_clk18);
        end
      end
    num_of_bits_sent18++;
    wait (!sample_clk18);
    end
  end
  
  num_frames_sent18++;
  `uvm_info(get_type_name(),
       $psprintf("Frame18 **%0d** Sent18...", num_frames_sent18), UVM_MEDIUM)
  wait (sample_clk18);
  vif18.txd18 = 1;

  `uvm_info(get_type_name(), "Frame18 complete...", UVM_MEDIUM)
  this.end_tr(frame18);
   
endtask : send_tx_frame18

//UVM report_phase
function void uart_tx_driver18::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART18 Frames18 Sent18:%0d", num_frames_sent18),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER18

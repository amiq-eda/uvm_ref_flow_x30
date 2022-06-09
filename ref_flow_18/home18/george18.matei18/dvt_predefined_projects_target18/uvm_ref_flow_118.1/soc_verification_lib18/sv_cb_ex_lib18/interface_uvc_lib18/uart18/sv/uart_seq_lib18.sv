/*-------------------------------------------------------------------------
File18 name   : uart_seq_lib18.sv
Title18       : sequence library file for uart18 uvc18
Project18     :
Created18     :
Description18 : describes18 all UART18 UVC18 sequences
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

//-------------------------------------------------
// SEQUENCE18: uart_base_seq18
//-------------------------------------------------
class uart_base_seq18 extends uvm_sequence #(uart_frame18);
  function new(string name="uart_base_seq18");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq18)
  `uvm_declare_p_sequencer(uart_sequencer18)

  // Use a base sequence to raise/drop18 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running18 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq18

//-------------------------------------------------
// SEQUENCE18: uart_incr_payload_seq18
//-------------------------------------------------
class uart_incr_payload_seq18 extends uart_base_seq18;
    rand int unsigned cnt;
    rand bit [7:0] start_payload18;

    function new(string name="uart_incr_payload_seq18");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq18)
   `uvm_declare_p_sequencer(uart_sequencer18)

    constraint count_ct18 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART18 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload18 == (start_payload18 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq18

//-------------------------------------------------
// SEQUENCE18: uart_bad_parity_seq18
//-------------------------------------------------
class uart_bad_parity_seq18 extends uart_base_seq18;
    rand int unsigned cnt;
    rand bit [7:0] start_payload18;

    function new(string name="uart_bad_parity_seq18");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq18)
   `uvm_declare_p_sequencer(uart_sequencer18)

    constraint count_ct18 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART18 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create18 the frame18
        `uvm_create(req)
         // Nullify18 the constrain18 on the parity18
         req.default_parity_type18.constraint_mode(0);
   
         // Now18 send the packed with parity18 constrained18 to BAD_PARITY18
        `uvm_rand_send_with(req, { req.parity_type18 == BAD_PARITY18;})
      end
    endtask
endclass: uart_bad_parity_seq18

//-------------------------------------------------
// SEQUENCE18: uart_transmit_seq18
//-------------------------------------------------
class uart_transmit_seq18 extends uart_base_seq18;

   rand int unsigned num_of_tx18;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq18)
   `uvm_declare_p_sequencer(uart_sequencer18)
   
   function new(string name="uart_transmit_seq18");
      super.new(name);
   endfunction

   constraint num_of_tx_ct18 { num_of_tx18 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART18 sequencer: Executing %0d Frames18", num_of_tx18), UVM_LOW)
     for (int i = 0; i < num_of_tx18; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq18

//-------------------------------------------------
// SEQUENCE18: uart_no_activity_seq18
//-------------------------------------------------
class no_activity_seq18 extends uart_base_seq18;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq18)
  `uvm_declare_p_sequencer(uart_sequencer18)

  function new(string name="no_activity_seq18");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART18 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq18

//-------------------------------------------------
// SEQUENCE18: uart_short_transmit_seq18
//-------------------------------------------------
class uart_short_transmit_seq18 extends uart_base_seq18;

   rand int unsigned num_of_tx18;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq18)
   `uvm_declare_p_sequencer(uart_sequencer18)
   
   function new(string name="uart_short_transmit_seq18");
      super.new(name);
   endfunction

   constraint num_of_tx_ct18 { num_of_tx18 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART18 sequencer: Executing %0d Frames18", num_of_tx18), UVM_LOW)
     for (int i = 0; i < num_of_tx18; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq18

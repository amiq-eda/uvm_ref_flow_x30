/*-------------------------------------------------------------------------
File28 name   : uart_seq_lib28.sv
Title28       : sequence library file for uart28 uvc28
Project28     :
Created28     :
Description28 : describes28 all UART28 UVC28 sequences
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE28: uart_base_seq28
//-------------------------------------------------
class uart_base_seq28 extends uvm_sequence #(uart_frame28);
  function new(string name="uart_base_seq28");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq28)
  `uvm_declare_p_sequencer(uart_sequencer28)

  // Use a base sequence to raise/drop28 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running28 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq28

//-------------------------------------------------
// SEQUENCE28: uart_incr_payload_seq28
//-------------------------------------------------
class uart_incr_payload_seq28 extends uart_base_seq28;
    rand int unsigned cnt;
    rand bit [7:0] start_payload28;

    function new(string name="uart_incr_payload_seq28");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq28)
   `uvm_declare_p_sequencer(uart_sequencer28)

    constraint count_ct28 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART28 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload28 == (start_payload28 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq28

//-------------------------------------------------
// SEQUENCE28: uart_bad_parity_seq28
//-------------------------------------------------
class uart_bad_parity_seq28 extends uart_base_seq28;
    rand int unsigned cnt;
    rand bit [7:0] start_payload28;

    function new(string name="uart_bad_parity_seq28");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq28)
   `uvm_declare_p_sequencer(uart_sequencer28)

    constraint count_ct28 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART28 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create28 the frame28
        `uvm_create(req)
         // Nullify28 the constrain28 on the parity28
         req.default_parity_type28.constraint_mode(0);
   
         // Now28 send the packed with parity28 constrained28 to BAD_PARITY28
        `uvm_rand_send_with(req, { req.parity_type28 == BAD_PARITY28;})
      end
    endtask
endclass: uart_bad_parity_seq28

//-------------------------------------------------
// SEQUENCE28: uart_transmit_seq28
//-------------------------------------------------
class uart_transmit_seq28 extends uart_base_seq28;

   rand int unsigned num_of_tx28;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq28)
   `uvm_declare_p_sequencer(uart_sequencer28)
   
   function new(string name="uart_transmit_seq28");
      super.new(name);
   endfunction

   constraint num_of_tx_ct28 { num_of_tx28 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART28 sequencer: Executing %0d Frames28", num_of_tx28), UVM_LOW)
     for (int i = 0; i < num_of_tx28; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq28

//-------------------------------------------------
// SEQUENCE28: uart_no_activity_seq28
//-------------------------------------------------
class no_activity_seq28 extends uart_base_seq28;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq28)
  `uvm_declare_p_sequencer(uart_sequencer28)

  function new(string name="no_activity_seq28");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART28 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq28

//-------------------------------------------------
// SEQUENCE28: uart_short_transmit_seq28
//-------------------------------------------------
class uart_short_transmit_seq28 extends uart_base_seq28;

   rand int unsigned num_of_tx28;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq28)
   `uvm_declare_p_sequencer(uart_sequencer28)
   
   function new(string name="uart_short_transmit_seq28");
      super.new(name);
   endfunction

   constraint num_of_tx_ct28 { num_of_tx28 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART28 sequencer: Executing %0d Frames28", num_of_tx28), UVM_LOW)
     for (int i = 0; i < num_of_tx28; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq28

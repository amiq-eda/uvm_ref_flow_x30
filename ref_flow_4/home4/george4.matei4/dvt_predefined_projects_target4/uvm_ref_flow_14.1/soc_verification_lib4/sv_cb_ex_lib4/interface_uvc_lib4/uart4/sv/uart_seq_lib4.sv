/*-------------------------------------------------------------------------
File4 name   : uart_seq_lib4.sv
Title4       : sequence library file for uart4 uvc4
Project4     :
Created4     :
Description4 : describes4 all UART4 UVC4 sequences
Notes4       :  
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE4: uart_base_seq4
//-------------------------------------------------
class uart_base_seq4 extends uvm_sequence #(uart_frame4);
  function new(string name="uart_base_seq4");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq4)
  `uvm_declare_p_sequencer(uart_sequencer4)

  // Use a base sequence to raise/drop4 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running4 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq4

//-------------------------------------------------
// SEQUENCE4: uart_incr_payload_seq4
//-------------------------------------------------
class uart_incr_payload_seq4 extends uart_base_seq4;
    rand int unsigned cnt;
    rand bit [7:0] start_payload4;

    function new(string name="uart_incr_payload_seq4");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq4)
   `uvm_declare_p_sequencer(uart_sequencer4)

    constraint count_ct4 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART4 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload4 == (start_payload4 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq4

//-------------------------------------------------
// SEQUENCE4: uart_bad_parity_seq4
//-------------------------------------------------
class uart_bad_parity_seq4 extends uart_base_seq4;
    rand int unsigned cnt;
    rand bit [7:0] start_payload4;

    function new(string name="uart_bad_parity_seq4");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq4)
   `uvm_declare_p_sequencer(uart_sequencer4)

    constraint count_ct4 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART4 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create4 the frame4
        `uvm_create(req)
         // Nullify4 the constrain4 on the parity4
         req.default_parity_type4.constraint_mode(0);
   
         // Now4 send the packed with parity4 constrained4 to BAD_PARITY4
        `uvm_rand_send_with(req, { req.parity_type4 == BAD_PARITY4;})
      end
    endtask
endclass: uart_bad_parity_seq4

//-------------------------------------------------
// SEQUENCE4: uart_transmit_seq4
//-------------------------------------------------
class uart_transmit_seq4 extends uart_base_seq4;

   rand int unsigned num_of_tx4;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq4)
   `uvm_declare_p_sequencer(uart_sequencer4)
   
   function new(string name="uart_transmit_seq4");
      super.new(name);
   endfunction

   constraint num_of_tx_ct4 { num_of_tx4 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART4 sequencer: Executing %0d Frames4", num_of_tx4), UVM_LOW)
     for (int i = 0; i < num_of_tx4; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq4

//-------------------------------------------------
// SEQUENCE4: uart_no_activity_seq4
//-------------------------------------------------
class no_activity_seq4 extends uart_base_seq4;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq4)
  `uvm_declare_p_sequencer(uart_sequencer4)

  function new(string name="no_activity_seq4");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART4 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq4

//-------------------------------------------------
// SEQUENCE4: uart_short_transmit_seq4
//-------------------------------------------------
class uart_short_transmit_seq4 extends uart_base_seq4;

   rand int unsigned num_of_tx4;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq4)
   `uvm_declare_p_sequencer(uart_sequencer4)
   
   function new(string name="uart_short_transmit_seq4");
      super.new(name);
   endfunction

   constraint num_of_tx_ct4 { num_of_tx4 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART4 sequencer: Executing %0d Frames4", num_of_tx4), UVM_LOW)
     for (int i = 0; i < num_of_tx4; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq4

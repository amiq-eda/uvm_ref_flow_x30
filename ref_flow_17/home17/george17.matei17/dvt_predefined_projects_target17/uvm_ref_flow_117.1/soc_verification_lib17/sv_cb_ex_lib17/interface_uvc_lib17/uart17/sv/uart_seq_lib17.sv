/*-------------------------------------------------------------------------
File17 name   : uart_seq_lib17.sv
Title17       : sequence library file for uart17 uvc17
Project17     :
Created17     :
Description17 : describes17 all UART17 UVC17 sequences
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

//-------------------------------------------------
// SEQUENCE17: uart_base_seq17
//-------------------------------------------------
class uart_base_seq17 extends uvm_sequence #(uart_frame17);
  function new(string name="uart_base_seq17");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq17)
  `uvm_declare_p_sequencer(uart_sequencer17)

  // Use a base sequence to raise/drop17 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running17 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq17

//-------------------------------------------------
// SEQUENCE17: uart_incr_payload_seq17
//-------------------------------------------------
class uart_incr_payload_seq17 extends uart_base_seq17;
    rand int unsigned cnt;
    rand bit [7:0] start_payload17;

    function new(string name="uart_incr_payload_seq17");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq17)
   `uvm_declare_p_sequencer(uart_sequencer17)

    constraint count_ct17 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART17 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload17 == (start_payload17 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq17

//-------------------------------------------------
// SEQUENCE17: uart_bad_parity_seq17
//-------------------------------------------------
class uart_bad_parity_seq17 extends uart_base_seq17;
    rand int unsigned cnt;
    rand bit [7:0] start_payload17;

    function new(string name="uart_bad_parity_seq17");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq17)
   `uvm_declare_p_sequencer(uart_sequencer17)

    constraint count_ct17 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART17 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create17 the frame17
        `uvm_create(req)
         // Nullify17 the constrain17 on the parity17
         req.default_parity_type17.constraint_mode(0);
   
         // Now17 send the packed with parity17 constrained17 to BAD_PARITY17
        `uvm_rand_send_with(req, { req.parity_type17 == BAD_PARITY17;})
      end
    endtask
endclass: uart_bad_parity_seq17

//-------------------------------------------------
// SEQUENCE17: uart_transmit_seq17
//-------------------------------------------------
class uart_transmit_seq17 extends uart_base_seq17;

   rand int unsigned num_of_tx17;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq17)
   `uvm_declare_p_sequencer(uart_sequencer17)
   
   function new(string name="uart_transmit_seq17");
      super.new(name);
   endfunction

   constraint num_of_tx_ct17 { num_of_tx17 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART17 sequencer: Executing %0d Frames17", num_of_tx17), UVM_LOW)
     for (int i = 0; i < num_of_tx17; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq17

//-------------------------------------------------
// SEQUENCE17: uart_no_activity_seq17
//-------------------------------------------------
class no_activity_seq17 extends uart_base_seq17;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq17)
  `uvm_declare_p_sequencer(uart_sequencer17)

  function new(string name="no_activity_seq17");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART17 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq17

//-------------------------------------------------
// SEQUENCE17: uart_short_transmit_seq17
//-------------------------------------------------
class uart_short_transmit_seq17 extends uart_base_seq17;

   rand int unsigned num_of_tx17;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq17)
   `uvm_declare_p_sequencer(uart_sequencer17)
   
   function new(string name="uart_short_transmit_seq17");
      super.new(name);
   endfunction

   constraint num_of_tx_ct17 { num_of_tx17 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART17 sequencer: Executing %0d Frames17", num_of_tx17), UVM_LOW)
     for (int i = 0; i < num_of_tx17; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq17

/*-------------------------------------------------------------------------
File26 name   : uart_seq_lib26.sv
Title26       : sequence library file for uart26 uvc26
Project26     :
Created26     :
Description26 : describes26 all UART26 UVC26 sequences
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

//-------------------------------------------------
// SEQUENCE26: uart_base_seq26
//-------------------------------------------------
class uart_base_seq26 extends uvm_sequence #(uart_frame26);
  function new(string name="uart_base_seq26");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq26)
  `uvm_declare_p_sequencer(uart_sequencer26)

  // Use a base sequence to raise/drop26 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running26 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq26

//-------------------------------------------------
// SEQUENCE26: uart_incr_payload_seq26
//-------------------------------------------------
class uart_incr_payload_seq26 extends uart_base_seq26;
    rand int unsigned cnt;
    rand bit [7:0] start_payload26;

    function new(string name="uart_incr_payload_seq26");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq26)
   `uvm_declare_p_sequencer(uart_sequencer26)

    constraint count_ct26 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART26 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload26 == (start_payload26 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq26

//-------------------------------------------------
// SEQUENCE26: uart_bad_parity_seq26
//-------------------------------------------------
class uart_bad_parity_seq26 extends uart_base_seq26;
    rand int unsigned cnt;
    rand bit [7:0] start_payload26;

    function new(string name="uart_bad_parity_seq26");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq26)
   `uvm_declare_p_sequencer(uart_sequencer26)

    constraint count_ct26 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART26 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create26 the frame26
        `uvm_create(req)
         // Nullify26 the constrain26 on the parity26
         req.default_parity_type26.constraint_mode(0);
   
         // Now26 send the packed with parity26 constrained26 to BAD_PARITY26
        `uvm_rand_send_with(req, { req.parity_type26 == BAD_PARITY26;})
      end
    endtask
endclass: uart_bad_parity_seq26

//-------------------------------------------------
// SEQUENCE26: uart_transmit_seq26
//-------------------------------------------------
class uart_transmit_seq26 extends uart_base_seq26;

   rand int unsigned num_of_tx26;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq26)
   `uvm_declare_p_sequencer(uart_sequencer26)
   
   function new(string name="uart_transmit_seq26");
      super.new(name);
   endfunction

   constraint num_of_tx_ct26 { num_of_tx26 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART26 sequencer: Executing %0d Frames26", num_of_tx26), UVM_LOW)
     for (int i = 0; i < num_of_tx26; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq26

//-------------------------------------------------
// SEQUENCE26: uart_no_activity_seq26
//-------------------------------------------------
class no_activity_seq26 extends uart_base_seq26;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq26)
  `uvm_declare_p_sequencer(uart_sequencer26)

  function new(string name="no_activity_seq26");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART26 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq26

//-------------------------------------------------
// SEQUENCE26: uart_short_transmit_seq26
//-------------------------------------------------
class uart_short_transmit_seq26 extends uart_base_seq26;

   rand int unsigned num_of_tx26;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq26)
   `uvm_declare_p_sequencer(uart_sequencer26)
   
   function new(string name="uart_short_transmit_seq26");
      super.new(name);
   endfunction

   constraint num_of_tx_ct26 { num_of_tx26 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART26 sequencer: Executing %0d Frames26", num_of_tx26), UVM_LOW)
     for (int i = 0; i < num_of_tx26; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq26

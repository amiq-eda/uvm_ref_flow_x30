/*-------------------------------------------------------------------------
File23 name   : uart_seq_lib23.sv
Title23       : sequence library file for uart23 uvc23
Project23     :
Created23     :
Description23 : describes23 all UART23 UVC23 sequences
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

//-------------------------------------------------
// SEQUENCE23: uart_base_seq23
//-------------------------------------------------
class uart_base_seq23 extends uvm_sequence #(uart_frame23);
  function new(string name="uart_base_seq23");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq23)
  `uvm_declare_p_sequencer(uart_sequencer23)

  // Use a base sequence to raise/drop23 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running23 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq23

//-------------------------------------------------
// SEQUENCE23: uart_incr_payload_seq23
//-------------------------------------------------
class uart_incr_payload_seq23 extends uart_base_seq23;
    rand int unsigned cnt;
    rand bit [7:0] start_payload23;

    function new(string name="uart_incr_payload_seq23");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq23)
   `uvm_declare_p_sequencer(uart_sequencer23)

    constraint count_ct23 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART23 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload23 == (start_payload23 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq23

//-------------------------------------------------
// SEQUENCE23: uart_bad_parity_seq23
//-------------------------------------------------
class uart_bad_parity_seq23 extends uart_base_seq23;
    rand int unsigned cnt;
    rand bit [7:0] start_payload23;

    function new(string name="uart_bad_parity_seq23");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq23)
   `uvm_declare_p_sequencer(uart_sequencer23)

    constraint count_ct23 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART23 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create23 the frame23
        `uvm_create(req)
         // Nullify23 the constrain23 on the parity23
         req.default_parity_type23.constraint_mode(0);
   
         // Now23 send the packed with parity23 constrained23 to BAD_PARITY23
        `uvm_rand_send_with(req, { req.parity_type23 == BAD_PARITY23;})
      end
    endtask
endclass: uart_bad_parity_seq23

//-------------------------------------------------
// SEQUENCE23: uart_transmit_seq23
//-------------------------------------------------
class uart_transmit_seq23 extends uart_base_seq23;

   rand int unsigned num_of_tx23;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq23)
   `uvm_declare_p_sequencer(uart_sequencer23)
   
   function new(string name="uart_transmit_seq23");
      super.new(name);
   endfunction

   constraint num_of_tx_ct23 { num_of_tx23 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART23 sequencer: Executing %0d Frames23", num_of_tx23), UVM_LOW)
     for (int i = 0; i < num_of_tx23; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq23

//-------------------------------------------------
// SEQUENCE23: uart_no_activity_seq23
//-------------------------------------------------
class no_activity_seq23 extends uart_base_seq23;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq23)
  `uvm_declare_p_sequencer(uart_sequencer23)

  function new(string name="no_activity_seq23");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART23 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq23

//-------------------------------------------------
// SEQUENCE23: uart_short_transmit_seq23
//-------------------------------------------------
class uart_short_transmit_seq23 extends uart_base_seq23;

   rand int unsigned num_of_tx23;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq23)
   `uvm_declare_p_sequencer(uart_sequencer23)
   
   function new(string name="uart_short_transmit_seq23");
      super.new(name);
   endfunction

   constraint num_of_tx_ct23 { num_of_tx23 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART23 sequencer: Executing %0d Frames23", num_of_tx23), UVM_LOW)
     for (int i = 0; i < num_of_tx23; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq23

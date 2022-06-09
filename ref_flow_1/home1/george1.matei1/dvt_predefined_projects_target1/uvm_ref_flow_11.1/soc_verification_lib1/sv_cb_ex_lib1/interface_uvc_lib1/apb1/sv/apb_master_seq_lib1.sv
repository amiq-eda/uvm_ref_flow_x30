/*******************************************************************************
  FILE : apb_master_seq_lib1.sv
*******************************************************************************/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV1
`define APB_MASTER_SEQ_LIB_SV1

//------------------------------------------------------------------------------
// SEQUENCE1: read_byte_seq1
//------------------------------------------------------------------------------
class apb_master_base_seq1 extends uvm_sequence #(apb_transfer1);
  // NOTE1: KATHLEEN1 - ALSO1 NEED1 TO HANDLE1 KILL1 HERE1??

  function new(string name="apb_master_base_seq1");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq1)
  `uvm_declare_p_sequencer(apb_master_sequencer1)

// Use a base sequence to raise/drop1 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running1 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq1

//------------------------------------------------------------------------------
// SEQUENCE1: read_byte_seq1
//------------------------------------------------------------------------------
class read_byte_seq1 extends apb_master_base_seq1;
  rand bit [31:0] start_addr1;
  rand int unsigned transmit_del1;

  function new(string name="read_byte_seq1");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq1)

  constraint transmit_del_ct1 { (transmit_del1 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr1;
        req.direction1 == APB_READ1;
        req.transmit_delay1 == transmit_del1; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr1 = 'h%0h, req_data1 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr1 = 'h%0h, rsp_data1 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq1

// SEQUENCE1: write_byte_seq1
class write_byte_seq1 extends apb_master_base_seq1;
  rand bit [31:0] start_addr1;
  rand bit [7:0] write_data1;
  rand int unsigned transmit_del1;

  function new(string name="write_byte_seq1");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq1)

  constraint transmit_del_ct1 { (transmit_del1 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr1;
        req.direction1 == APB_WRITE1;
        req.data == write_data1;
        req.transmit_delay1 == transmit_del1; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq1

//------------------------------------------------------------------------------
// SEQUENCE1: read_word_seq1
//------------------------------------------------------------------------------
class read_word_seq1 extends apb_master_base_seq1;
  rand bit [31:0] start_addr1;
  rand int unsigned transmit_del1;

  function new(string name="read_word_seq1");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq1)

  constraint transmit_del_ct1 { (transmit_del1 <= 10); }
  constraint addr_ct1 {(start_addr1[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr1;
        req.direction1 == APB_READ1;
        req.transmit_delay1 == transmit_del1; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr1 = 'h%0h, req_data1 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr1 = 'h%0h, rsp_data1 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq1

// SEQUENCE1: write_word_seq1
class write_word_seq1 extends apb_master_base_seq1;
  rand bit [31:0] start_addr1;
  rand bit [31:0] write_data1;
  rand int unsigned transmit_del1;

  function new(string name="write_word_seq1");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq1)

  constraint transmit_del_ct1 { (transmit_del1 <= 10); }
  constraint addr_ct1 {(start_addr1[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr1;
        req.direction1 == APB_WRITE1;
        req.data == write_data1;
        req.transmit_delay1 == transmit_del1; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq1

// SEQUENCE1: read_after_write_seq1
class read_after_write_seq1 extends apb_master_base_seq1;

  rand bit [31:0] start_addr1;
  rand bit [31:0] write_data1;
  rand int unsigned transmit_del1;

  function new(string name="read_after_write_seq1");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq1)

  constraint transmit_del_ct1 { (transmit_del1 <= 10); }
  constraint addr_ct1 {(start_addr1[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr1;
        req.direction1 == APB_WRITE1;
        req.data == write_data1;
        req.transmit_delay1 == transmit_del1; } )
    `uvm_do_with(req, 
      { req.addr == start_addr1;
        req.direction1 == APB_READ1;
        req.transmit_delay1 == transmit_del1; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq1

// SEQUENCE1: multiple_read_after_write_seq1
class multiple_read_after_write_seq1 extends apb_master_base_seq1;

    read_after_write_seq1 raw_seq1;
    write_byte_seq1 w_seq1;
    read_byte_seq1 r_seq1;
    rand int unsigned num_of_seq1;

    function new(string name="multiple_read_after_write_seq1");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq1)

    constraint num_of_seq_c1 { num_of_seq1 <= 10; num_of_seq1 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq1; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq1)
      end
      repeat (3) `uvm_do_with(w_seq1, {transmit_del1 == 1;} )
      repeat (3) `uvm_do_with(r_seq1, {transmit_del1 == 1;} )
    endtask
endclass : multiple_read_after_write_seq1
`endif // APB_MASTER_SEQ_LIB_SV1

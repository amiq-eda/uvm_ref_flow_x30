/*******************************************************************************
  FILE : apb_master_seq_lib2.sv
*******************************************************************************/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV2
`define APB_MASTER_SEQ_LIB_SV2

//------------------------------------------------------------------------------
// SEQUENCE2: read_byte_seq2
//------------------------------------------------------------------------------
class apb_master_base_seq2 extends uvm_sequence #(apb_transfer2);
  // NOTE2: KATHLEEN2 - ALSO2 NEED2 TO HANDLE2 KILL2 HERE2??

  function new(string name="apb_master_base_seq2");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq2)
  `uvm_declare_p_sequencer(apb_master_sequencer2)

// Use a base sequence to raise/drop2 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running2 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq2

//------------------------------------------------------------------------------
// SEQUENCE2: read_byte_seq2
//------------------------------------------------------------------------------
class read_byte_seq2 extends apb_master_base_seq2;
  rand bit [31:0] start_addr2;
  rand int unsigned transmit_del2;

  function new(string name="read_byte_seq2");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq2)

  constraint transmit_del_ct2 { (transmit_del2 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr2;
        req.direction2 == APB_READ2;
        req.transmit_delay2 == transmit_del2; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr2 = 'h%0h, req_data2 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr2 = 'h%0h, rsp_data2 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq2

// SEQUENCE2: write_byte_seq2
class write_byte_seq2 extends apb_master_base_seq2;
  rand bit [31:0] start_addr2;
  rand bit [7:0] write_data2;
  rand int unsigned transmit_del2;

  function new(string name="write_byte_seq2");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq2)

  constraint transmit_del_ct2 { (transmit_del2 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr2;
        req.direction2 == APB_WRITE2;
        req.data == write_data2;
        req.transmit_delay2 == transmit_del2; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq2

//------------------------------------------------------------------------------
// SEQUENCE2: read_word_seq2
//------------------------------------------------------------------------------
class read_word_seq2 extends apb_master_base_seq2;
  rand bit [31:0] start_addr2;
  rand int unsigned transmit_del2;

  function new(string name="read_word_seq2");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq2)

  constraint transmit_del_ct2 { (transmit_del2 <= 10); }
  constraint addr_ct2 {(start_addr2[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr2;
        req.direction2 == APB_READ2;
        req.transmit_delay2 == transmit_del2; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr2 = 'h%0h, req_data2 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr2 = 'h%0h, rsp_data2 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq2

// SEQUENCE2: write_word_seq2
class write_word_seq2 extends apb_master_base_seq2;
  rand bit [31:0] start_addr2;
  rand bit [31:0] write_data2;
  rand int unsigned transmit_del2;

  function new(string name="write_word_seq2");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq2)

  constraint transmit_del_ct2 { (transmit_del2 <= 10); }
  constraint addr_ct2 {(start_addr2[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr2;
        req.direction2 == APB_WRITE2;
        req.data == write_data2;
        req.transmit_delay2 == transmit_del2; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq2

// SEQUENCE2: read_after_write_seq2
class read_after_write_seq2 extends apb_master_base_seq2;

  rand bit [31:0] start_addr2;
  rand bit [31:0] write_data2;
  rand int unsigned transmit_del2;

  function new(string name="read_after_write_seq2");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq2)

  constraint transmit_del_ct2 { (transmit_del2 <= 10); }
  constraint addr_ct2 {(start_addr2[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr2;
        req.direction2 == APB_WRITE2;
        req.data == write_data2;
        req.transmit_delay2 == transmit_del2; } )
    `uvm_do_with(req, 
      { req.addr == start_addr2;
        req.direction2 == APB_READ2;
        req.transmit_delay2 == transmit_del2; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq2

// SEQUENCE2: multiple_read_after_write_seq2
class multiple_read_after_write_seq2 extends apb_master_base_seq2;

    read_after_write_seq2 raw_seq2;
    write_byte_seq2 w_seq2;
    read_byte_seq2 r_seq2;
    rand int unsigned num_of_seq2;

    function new(string name="multiple_read_after_write_seq2");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq2)

    constraint num_of_seq_c2 { num_of_seq2 <= 10; num_of_seq2 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq2; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq2)
      end
      repeat (3) `uvm_do_with(w_seq2, {transmit_del2 == 1;} )
      repeat (3) `uvm_do_with(r_seq2, {transmit_del2 == 1;} )
    endtask
endclass : multiple_read_after_write_seq2
`endif // APB_MASTER_SEQ_LIB_SV2

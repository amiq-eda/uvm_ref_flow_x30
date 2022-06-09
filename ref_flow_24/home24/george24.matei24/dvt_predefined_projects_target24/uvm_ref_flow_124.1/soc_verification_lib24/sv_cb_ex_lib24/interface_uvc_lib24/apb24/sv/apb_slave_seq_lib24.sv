/*******************************************************************************
  FILE : apb_slave_seq_lib24.sv
*******************************************************************************/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV24
`define APB_SLAVE_SEQ_LIB_SV24

//------------------------------------------------------------------------------
// SEQUENCE24: simple_response_seq24
//------------------------------------------------------------------------------

class simple_response_seq24 extends uvm_sequence #(apb_transfer24);

  function new(string name="simple_response_seq24");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq24)
  `uvm_declare_p_sequencer(apb_slave_sequencer24)

  apb_transfer24 req;
  apb_transfer24 util_transfer24;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port24.peek(util_transfer24);
      if((util_transfer24.direction24 == APB_READ24) && 
        (p_sequencer.cfg.check_address_range24(util_transfer24.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range24 Matching24 read.  Responding24...", util_transfer24.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction24 == APB_READ24; } )
      end
    end
  endtask : body

endclass : simple_response_seq24

//------------------------------------------------------------------------------
// SEQUENCE24: mem_response_seq24
//------------------------------------------------------------------------------
class mem_response_seq24 extends uvm_sequence #(apb_transfer24);

  function new(string name="mem_response_seq24");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data24;

  `uvm_object_utils(mem_response_seq24)
  `uvm_declare_p_sequencer(apb_slave_sequencer24)

  //simple24 assoc24 array to hold24 values
  logic [31:0] slave_mem24[int];

  apb_transfer24 req;
  apb_transfer24 util_transfer24;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port24.peek(util_transfer24);
      if((util_transfer24.direction24 == APB_READ24) && 
        (p_sequencer.cfg.check_address_range24(util_transfer24.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range24 Matching24 APB_READ24.  Responding24...", util_transfer24.addr), UVM_MEDIUM);
        if (slave_mem24.exists(util_transfer24.addr))
        `uvm_do_with(req, { req.direction24 == APB_READ24;
                            req.addr == util_transfer24.addr;
                            req.data == slave_mem24[util_transfer24.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction24 == APB_READ24;
                            req.addr == util_transfer24.addr;
                            req.data == mem_data24; } )
         mem_data24++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range24(util_transfer24.addr) == 1) begin
        slave_mem24[util_transfer24.addr] = util_transfer24.data;
        // DUMMY24 response with same information
        `uvm_do_with(req, { req.direction24 == APB_WRITE24;
                            req.addr == util_transfer24.addr;
                            req.data == util_transfer24.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq24

`endif // APB_SLAVE_SEQ_LIB_SV24

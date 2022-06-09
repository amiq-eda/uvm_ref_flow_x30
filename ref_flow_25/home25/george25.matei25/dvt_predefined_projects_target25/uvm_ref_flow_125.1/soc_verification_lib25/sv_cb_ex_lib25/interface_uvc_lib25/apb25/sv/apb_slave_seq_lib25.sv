/*******************************************************************************
  FILE : apb_slave_seq_lib25.sv
*******************************************************************************/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV25
`define APB_SLAVE_SEQ_LIB_SV25

//------------------------------------------------------------------------------
// SEQUENCE25: simple_response_seq25
//------------------------------------------------------------------------------

class simple_response_seq25 extends uvm_sequence #(apb_transfer25);

  function new(string name="simple_response_seq25");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq25)
  `uvm_declare_p_sequencer(apb_slave_sequencer25)

  apb_transfer25 req;
  apb_transfer25 util_transfer25;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port25.peek(util_transfer25);
      if((util_transfer25.direction25 == APB_READ25) && 
        (p_sequencer.cfg.check_address_range25(util_transfer25.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range25 Matching25 read.  Responding25...", util_transfer25.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction25 == APB_READ25; } )
      end
    end
  endtask : body

endclass : simple_response_seq25

//------------------------------------------------------------------------------
// SEQUENCE25: mem_response_seq25
//------------------------------------------------------------------------------
class mem_response_seq25 extends uvm_sequence #(apb_transfer25);

  function new(string name="mem_response_seq25");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data25;

  `uvm_object_utils(mem_response_seq25)
  `uvm_declare_p_sequencer(apb_slave_sequencer25)

  //simple25 assoc25 array to hold25 values
  logic [31:0] slave_mem25[int];

  apb_transfer25 req;
  apb_transfer25 util_transfer25;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port25.peek(util_transfer25);
      if((util_transfer25.direction25 == APB_READ25) && 
        (p_sequencer.cfg.check_address_range25(util_transfer25.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range25 Matching25 APB_READ25.  Responding25...", util_transfer25.addr), UVM_MEDIUM);
        if (slave_mem25.exists(util_transfer25.addr))
        `uvm_do_with(req, { req.direction25 == APB_READ25;
                            req.addr == util_transfer25.addr;
                            req.data == slave_mem25[util_transfer25.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction25 == APB_READ25;
                            req.addr == util_transfer25.addr;
                            req.data == mem_data25; } )
         mem_data25++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range25(util_transfer25.addr) == 1) begin
        slave_mem25[util_transfer25.addr] = util_transfer25.data;
        // DUMMY25 response with same information
        `uvm_do_with(req, { req.direction25 == APB_WRITE25;
                            req.addr == util_transfer25.addr;
                            req.data == util_transfer25.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq25

`endif // APB_SLAVE_SEQ_LIB_SV25

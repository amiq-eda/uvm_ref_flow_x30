/*******************************************************************************
  FILE : apb_slave_seq_lib15.sv
*******************************************************************************/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV15
`define APB_SLAVE_SEQ_LIB_SV15

//------------------------------------------------------------------------------
// SEQUENCE15: simple_response_seq15
//------------------------------------------------------------------------------

class simple_response_seq15 extends uvm_sequence #(apb_transfer15);

  function new(string name="simple_response_seq15");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq15)
  `uvm_declare_p_sequencer(apb_slave_sequencer15)

  apb_transfer15 req;
  apb_transfer15 util_transfer15;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port15.peek(util_transfer15);
      if((util_transfer15.direction15 == APB_READ15) && 
        (p_sequencer.cfg.check_address_range15(util_transfer15.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range15 Matching15 read.  Responding15...", util_transfer15.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction15 == APB_READ15; } )
      end
    end
  endtask : body

endclass : simple_response_seq15

//------------------------------------------------------------------------------
// SEQUENCE15: mem_response_seq15
//------------------------------------------------------------------------------
class mem_response_seq15 extends uvm_sequence #(apb_transfer15);

  function new(string name="mem_response_seq15");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data15;

  `uvm_object_utils(mem_response_seq15)
  `uvm_declare_p_sequencer(apb_slave_sequencer15)

  //simple15 assoc15 array to hold15 values
  logic [31:0] slave_mem15[int];

  apb_transfer15 req;
  apb_transfer15 util_transfer15;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port15.peek(util_transfer15);
      if((util_transfer15.direction15 == APB_READ15) && 
        (p_sequencer.cfg.check_address_range15(util_transfer15.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range15 Matching15 APB_READ15.  Responding15...", util_transfer15.addr), UVM_MEDIUM);
        if (slave_mem15.exists(util_transfer15.addr))
        `uvm_do_with(req, { req.direction15 == APB_READ15;
                            req.addr == util_transfer15.addr;
                            req.data == slave_mem15[util_transfer15.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction15 == APB_READ15;
                            req.addr == util_transfer15.addr;
                            req.data == mem_data15; } )
         mem_data15++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range15(util_transfer15.addr) == 1) begin
        slave_mem15[util_transfer15.addr] = util_transfer15.data;
        // DUMMY15 response with same information
        `uvm_do_with(req, { req.direction15 == APB_WRITE15;
                            req.addr == util_transfer15.addr;
                            req.data == util_transfer15.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq15

`endif // APB_SLAVE_SEQ_LIB_SV15

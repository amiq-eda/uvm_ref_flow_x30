/*-------------------------------------------------------------------------
File23 name   : reg_to_ahb_adapter23.sv
Title23       : Register Operations23 to AHB23 Transactions23 Adapter Sequence
Project23     :
Created23     :
Description23 : UVM_REG - Adapter Sequence converts23 UVM register operations23
            : to AHB23 bus transactions
Notes23       : This23 example23 does not provide23 any random transfer23 delay
            : for the transaction.  This23 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright23 1999-2011 Cadence23 Design23 Systems23, Inc23.
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

class reg_to_ahb_adapter23 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter23)

  function new(string name="reg_to_ahb_adapter23");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer23 transfer23;
    transfer23 = ahb_transfer23::type_id::create("transfer23");
    transfer23.address = rw.addr;
    transfer23.data = rw.data;
    transfer23.direction23 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer23);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer23 transfer23;
    if (!$cast(transfer23, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE23",
       "Provided bus_item is not of the correct23 type. Expecting23 ahb_transfer23")
       return;
    end
    rw.kind =  (transfer23.direction23 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer23.address;
    rw.data = transfer23.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter23

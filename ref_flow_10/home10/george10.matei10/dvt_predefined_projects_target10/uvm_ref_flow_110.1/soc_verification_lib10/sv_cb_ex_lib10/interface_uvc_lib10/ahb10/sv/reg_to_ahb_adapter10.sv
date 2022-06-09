/*-------------------------------------------------------------------------
File10 name   : reg_to_ahb_adapter10.sv
Title10       : Register Operations10 to AHB10 Transactions10 Adapter Sequence
Project10     :
Created10     :
Description10 : UVM_REG - Adapter Sequence converts10 UVM register operations10
            : to AHB10 bus transactions
Notes10       : This10 example10 does not provide10 any random transfer10 delay
            : for the transaction.  This10 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright10 1999-2011 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

class reg_to_ahb_adapter10 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter10)

  function new(string name="reg_to_ahb_adapter10");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer10 transfer10;
    transfer10 = ahb_transfer10::type_id::create("transfer10");
    transfer10.address = rw.addr;
    transfer10.data = rw.data;
    transfer10.direction10 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer10);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer10 transfer10;
    if (!$cast(transfer10, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE10",
       "Provided bus_item is not of the correct10 type. Expecting10 ahb_transfer10")
       return;
    end
    rw.kind =  (transfer10.direction10 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer10.address;
    rw.data = transfer10.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter10

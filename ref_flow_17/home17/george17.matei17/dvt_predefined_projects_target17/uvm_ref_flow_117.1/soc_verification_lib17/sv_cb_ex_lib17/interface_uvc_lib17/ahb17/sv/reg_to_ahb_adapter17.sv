/*-------------------------------------------------------------------------
File17 name   : reg_to_ahb_adapter17.sv
Title17       : Register Operations17 to AHB17 Transactions17 Adapter Sequence
Project17     :
Created17     :
Description17 : UVM_REG - Adapter Sequence converts17 UVM register operations17
            : to AHB17 bus transactions
Notes17       : This17 example17 does not provide17 any random transfer17 delay
            : for the transaction.  This17 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright17 1999-2011 Cadence17 Design17 Systems17, Inc17.
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

class reg_to_ahb_adapter17 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter17)

  function new(string name="reg_to_ahb_adapter17");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer17 transfer17;
    transfer17 = ahb_transfer17::type_id::create("transfer17");
    transfer17.address = rw.addr;
    transfer17.data = rw.data;
    transfer17.direction17 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer17);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer17 transfer17;
    if (!$cast(transfer17, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE17",
       "Provided bus_item is not of the correct17 type. Expecting17 ahb_transfer17")
       return;
    end
    rw.kind =  (transfer17.direction17 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer17.address;
    rw.data = transfer17.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter17

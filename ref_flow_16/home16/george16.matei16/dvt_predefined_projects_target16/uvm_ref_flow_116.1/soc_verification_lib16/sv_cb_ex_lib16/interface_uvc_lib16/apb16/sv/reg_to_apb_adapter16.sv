/*-------------------------------------------------------------------------
File16 name   : reg_to_apb_adapter16.sv
Title16       : Register Operations16 to APB16 Transactions16 Adapter Sequence
Project16     :
Created16     :
Description16 : UVM_REG - Adapter Sequence converts16 UVM register operations16
            : to APB16 bus transactions
Notes16       : This16 example16 does not provide16 any random transfer16 delay
            : for the transaction.  This16 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright16 1999-2011 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

class reg_to_apb_adapter16 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter16)

  function new(string name="reg_to_apb_adapter16");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transfer16 transfer16;
    transfer16 = apb_transfer16::type_id::create("transfer16");
    transfer16.addr = rw.addr;
    transfer16.data = rw.data;
    transfer16.direction16 = (rw.kind == UVM_READ) ? APB_READ16 : APB_WRITE16;
    return (transfer16);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transfer16 transfer16;
    if (!$cast(transfer16, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE16",
       "Provided bus_item is not of the correct16 type. Expecting16 apb_transfer16")
       return;
    end
    rw.kind =  (transfer16.direction16 == APB_READ16) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer16.addr;
    rw.data = transfer16.data;
    //rw.byte_en = 'h0;   // Set this to -1 or DO16 NOT16 SET IT16 AT16 ALL16 - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter16

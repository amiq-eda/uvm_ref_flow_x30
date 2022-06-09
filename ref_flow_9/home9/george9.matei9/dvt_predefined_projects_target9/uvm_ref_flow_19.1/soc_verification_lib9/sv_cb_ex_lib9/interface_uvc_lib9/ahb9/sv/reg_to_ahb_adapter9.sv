/*-------------------------------------------------------------------------
File9 name   : reg_to_ahb_adapter9.sv
Title9       : Register Operations9 to AHB9 Transactions9 Adapter Sequence
Project9     :
Created9     :
Description9 : UVM_REG - Adapter Sequence converts9 UVM register operations9
            : to AHB9 bus transactions
Notes9       : This9 example9 does not provide9 any random transfer9 delay
            : for the transaction.  This9 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright9 1999-2011 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

class reg_to_ahb_adapter9 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter9)

  function new(string name="reg_to_ahb_adapter9");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer9 transfer9;
    transfer9 = ahb_transfer9::type_id::create("transfer9");
    transfer9.address = rw.addr;
    transfer9.data = rw.data;
    transfer9.direction9 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer9);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer9 transfer9;
    if (!$cast(transfer9, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE9",
       "Provided bus_item is not of the correct9 type. Expecting9 ahb_transfer9")
       return;
    end
    rw.kind =  (transfer9.direction9 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer9.address;
    rw.data = transfer9.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter9

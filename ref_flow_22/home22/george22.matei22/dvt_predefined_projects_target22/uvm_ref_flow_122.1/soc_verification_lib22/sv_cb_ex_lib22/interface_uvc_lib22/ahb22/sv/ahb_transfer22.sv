// IVB22 checksum22: 2173772784
/*-----------------------------------------------------------------
File22 name     : ahb_transfer22.sv
Created22       : Wed22 May22 19 15:42:20 2010
Description22   :  This22 file declares22 the OVC22 transfer22. It is
              :  used by both master22 and slave22.
Notes22         :
-----------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV22
`define AHB_TRANSFER_SV22

//------------------------------------------------------------------------------
//
// ahb22 transfer22 enums22, parameters22, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE22 = 0,
		HALFWORD22 = 1,
		WORD22 = 2,
		TWO_WORDS22 = 3,
		FOUR_WORDS22 = 4,
		EIGHT_WORDS22 = 5,
		SIXTEEN_WORDS22 = 6,
		K_BITS22 = 7
} ahb_transfer_size22;
typedef enum logic[1:0]  {
		IDLE22 = 0,
		BUSY22 = 1,
		NONSEQ22 = 2,
		SEQ = 3
} ahb_transfer_kind22;
typedef enum logic[1:0]  {
		OKAY22 = 0,
		ERROR22 = 1,
		RETRY22 = 2,
		SPLIT22 = 3
} ahb_response_kind22;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction22;
typedef enum logic[2:0]  {
		SINGLE22 = 0,
		INCR = 1,
		WRAP422 = 2,
		INCR422 = 3,
		WRAP822 = 4,
		INCR822 = 5,
		WRAP1622 = 6,
		INCR1622 = 7
} ahb_burst_kind22;
 
//------------------------------------------------------------------------------
//
// CLASS22: ahb_transfer22
//
//------------------------------------------------------------------------------

class ahb_transfer22 extends uvm_sequence_item;

  /***************************************************************************
   IVB22-NOTE22 : REQUIRED22 : transfer22 definitions22 : Item22 definitions22
   ---------------------------------------------------------------------------
   Adjust22 the transfer22 attribute22 names as required22 and add any 
   necessary22 attributes22.
   Note22 that if you change an attribute22 name, you must change it in all of your22
   OVC22 files.
   Make22 sure22 to edit22 the uvm_object_utils_begin to get various22 utilities22 (like22
   print and copy) for each attribute22 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH22-1:0] data;
  rand logic [`AHB_ADDR_WIDTH22-1:0] address;
  rand ahb_direction22 direction22 ;
  rand ahb_transfer_size22  hsize22;
  rand ahb_burst_kind22  burst;
  rand logic [3:0] prot22 ;
 
  `uvm_object_utils_begin(ahb_transfer22)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction22,direction22, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size22,hsize22, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind22,burst, UVM_ALL_ON)
    `uvm_field_int(prot22, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor22 - required22 syntax22 for UVM automation22 and utilities22
  function new (string name = "unnamed22-ahb_transfer22");
    super.new(name);
  endfunction : new

endclass : ahb_transfer22

`endif // AHB_TRANSFER_SV22


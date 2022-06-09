// IVB9 checksum9: 2173772784
/*-----------------------------------------------------------------
File9 name     : ahb_transfer9.sv
Created9       : Wed9 May9 19 15:42:20 2010
Description9   :  This9 file declares9 the OVC9 transfer9. It is
              :  used by both master9 and slave9.
Notes9         :
-----------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
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


`ifndef AHB_TRANSFER_SV9
`define AHB_TRANSFER_SV9

//------------------------------------------------------------------------------
//
// ahb9 transfer9 enums9, parameters9, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE9 = 0,
		HALFWORD9 = 1,
		WORD9 = 2,
		TWO_WORDS9 = 3,
		FOUR_WORDS9 = 4,
		EIGHT_WORDS9 = 5,
		SIXTEEN_WORDS9 = 6,
		K_BITS9 = 7
} ahb_transfer_size9;
typedef enum logic[1:0]  {
		IDLE9 = 0,
		BUSY9 = 1,
		NONSEQ9 = 2,
		SEQ = 3
} ahb_transfer_kind9;
typedef enum logic[1:0]  {
		OKAY9 = 0,
		ERROR9 = 1,
		RETRY9 = 2,
		SPLIT9 = 3
} ahb_response_kind9;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction9;
typedef enum logic[2:0]  {
		SINGLE9 = 0,
		INCR = 1,
		WRAP49 = 2,
		INCR49 = 3,
		WRAP89 = 4,
		INCR89 = 5,
		WRAP169 = 6,
		INCR169 = 7
} ahb_burst_kind9;
 
//------------------------------------------------------------------------------
//
// CLASS9: ahb_transfer9
//
//------------------------------------------------------------------------------

class ahb_transfer9 extends uvm_sequence_item;

  /***************************************************************************
   IVB9-NOTE9 : REQUIRED9 : transfer9 definitions9 : Item9 definitions9
   ---------------------------------------------------------------------------
   Adjust9 the transfer9 attribute9 names as required9 and add any 
   necessary9 attributes9.
   Note9 that if you change an attribute9 name, you must change it in all of your9
   OVC9 files.
   Make9 sure9 to edit9 the uvm_object_utils_begin to get various9 utilities9 (like9
   print and copy) for each attribute9 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH9-1:0] data;
  rand logic [`AHB_ADDR_WIDTH9-1:0] address;
  rand ahb_direction9 direction9 ;
  rand ahb_transfer_size9  hsize9;
  rand ahb_burst_kind9  burst;
  rand logic [3:0] prot9 ;
 
  `uvm_object_utils_begin(ahb_transfer9)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction9,direction9, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size9,hsize9, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind9,burst, UVM_ALL_ON)
    `uvm_field_int(prot9, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor9 - required9 syntax9 for UVM automation9 and utilities9
  function new (string name = "unnamed9-ahb_transfer9");
    super.new(name);
  endfunction : new

endclass : ahb_transfer9

`endif // AHB_TRANSFER_SV9


// IVB16 checksum16: 2173772784
/*-----------------------------------------------------------------
File16 name     : ahb_transfer16.sv
Created16       : Wed16 May16 19 15:42:20 2010
Description16   :  This16 file declares16 the OVC16 transfer16. It is
              :  used by both master16 and slave16.
Notes16         :
-----------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
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


`ifndef AHB_TRANSFER_SV16
`define AHB_TRANSFER_SV16

//------------------------------------------------------------------------------
//
// ahb16 transfer16 enums16, parameters16, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE16 = 0,
		HALFWORD16 = 1,
		WORD16 = 2,
		TWO_WORDS16 = 3,
		FOUR_WORDS16 = 4,
		EIGHT_WORDS16 = 5,
		SIXTEEN_WORDS16 = 6,
		K_BITS16 = 7
} ahb_transfer_size16;
typedef enum logic[1:0]  {
		IDLE16 = 0,
		BUSY16 = 1,
		NONSEQ16 = 2,
		SEQ = 3
} ahb_transfer_kind16;
typedef enum logic[1:0]  {
		OKAY16 = 0,
		ERROR16 = 1,
		RETRY16 = 2,
		SPLIT16 = 3
} ahb_response_kind16;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction16;
typedef enum logic[2:0]  {
		SINGLE16 = 0,
		INCR = 1,
		WRAP416 = 2,
		INCR416 = 3,
		WRAP816 = 4,
		INCR816 = 5,
		WRAP1616 = 6,
		INCR1616 = 7
} ahb_burst_kind16;
 
//------------------------------------------------------------------------------
//
// CLASS16: ahb_transfer16
//
//------------------------------------------------------------------------------

class ahb_transfer16 extends uvm_sequence_item;

  /***************************************************************************
   IVB16-NOTE16 : REQUIRED16 : transfer16 definitions16 : Item16 definitions16
   ---------------------------------------------------------------------------
   Adjust16 the transfer16 attribute16 names as required16 and add any 
   necessary16 attributes16.
   Note16 that if you change an attribute16 name, you must change it in all of your16
   OVC16 files.
   Make16 sure16 to edit16 the uvm_object_utils_begin to get various16 utilities16 (like16
   print and copy) for each attribute16 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH16-1:0] data;
  rand logic [`AHB_ADDR_WIDTH16-1:0] address;
  rand ahb_direction16 direction16 ;
  rand ahb_transfer_size16  hsize16;
  rand ahb_burst_kind16  burst;
  rand logic [3:0] prot16 ;
 
  `uvm_object_utils_begin(ahb_transfer16)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction16,direction16, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size16,hsize16, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind16,burst, UVM_ALL_ON)
    `uvm_field_int(prot16, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor16 - required16 syntax16 for UVM automation16 and utilities16
  function new (string name = "unnamed16-ahb_transfer16");
    super.new(name);
  endfunction : new

endclass : ahb_transfer16

`endif // AHB_TRANSFER_SV16


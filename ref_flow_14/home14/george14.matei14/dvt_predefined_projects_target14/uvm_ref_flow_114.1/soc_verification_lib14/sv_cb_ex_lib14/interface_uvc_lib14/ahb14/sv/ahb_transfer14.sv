// IVB14 checksum14: 2173772784
/*-----------------------------------------------------------------
File14 name     : ahb_transfer14.sv
Created14       : Wed14 May14 19 15:42:20 2010
Description14   :  This14 file declares14 the OVC14 transfer14. It is
              :  used by both master14 and slave14.
Notes14         :
-----------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV14
`define AHB_TRANSFER_SV14

//------------------------------------------------------------------------------
//
// ahb14 transfer14 enums14, parameters14, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE14 = 0,
		HALFWORD14 = 1,
		WORD14 = 2,
		TWO_WORDS14 = 3,
		FOUR_WORDS14 = 4,
		EIGHT_WORDS14 = 5,
		SIXTEEN_WORDS14 = 6,
		K_BITS14 = 7
} ahb_transfer_size14;
typedef enum logic[1:0]  {
		IDLE14 = 0,
		BUSY14 = 1,
		NONSEQ14 = 2,
		SEQ = 3
} ahb_transfer_kind14;
typedef enum logic[1:0]  {
		OKAY14 = 0,
		ERROR14 = 1,
		RETRY14 = 2,
		SPLIT14 = 3
} ahb_response_kind14;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction14;
typedef enum logic[2:0]  {
		SINGLE14 = 0,
		INCR = 1,
		WRAP414 = 2,
		INCR414 = 3,
		WRAP814 = 4,
		INCR814 = 5,
		WRAP1614 = 6,
		INCR1614 = 7
} ahb_burst_kind14;
 
//------------------------------------------------------------------------------
//
// CLASS14: ahb_transfer14
//
//------------------------------------------------------------------------------

class ahb_transfer14 extends uvm_sequence_item;

  /***************************************************************************
   IVB14-NOTE14 : REQUIRED14 : transfer14 definitions14 : Item14 definitions14
   ---------------------------------------------------------------------------
   Adjust14 the transfer14 attribute14 names as required14 and add any 
   necessary14 attributes14.
   Note14 that if you change an attribute14 name, you must change it in all of your14
   OVC14 files.
   Make14 sure14 to edit14 the uvm_object_utils_begin to get various14 utilities14 (like14
   print and copy) for each attribute14 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH14-1:0] data;
  rand logic [`AHB_ADDR_WIDTH14-1:0] address;
  rand ahb_direction14 direction14 ;
  rand ahb_transfer_size14  hsize14;
  rand ahb_burst_kind14  burst;
  rand logic [3:0] prot14 ;
 
  `uvm_object_utils_begin(ahb_transfer14)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction14,direction14, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size14,hsize14, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind14,burst, UVM_ALL_ON)
    `uvm_field_int(prot14, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor14 - required14 syntax14 for UVM automation14 and utilities14
  function new (string name = "unnamed14-ahb_transfer14");
    super.new(name);
  endfunction : new

endclass : ahb_transfer14

`endif // AHB_TRANSFER_SV14


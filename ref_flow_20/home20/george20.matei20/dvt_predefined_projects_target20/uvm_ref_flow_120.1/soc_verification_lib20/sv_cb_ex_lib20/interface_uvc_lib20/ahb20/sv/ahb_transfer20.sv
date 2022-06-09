// IVB20 checksum20: 2173772784
/*-----------------------------------------------------------------
File20 name     : ahb_transfer20.sv
Created20       : Wed20 May20 19 15:42:20 2010
Description20   :  This20 file declares20 the OVC20 transfer20. It is
              :  used by both master20 and slave20.
Notes20         :
-----------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV20
`define AHB_TRANSFER_SV20

//------------------------------------------------------------------------------
//
// ahb20 transfer20 enums20, parameters20, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE20 = 0,
		HALFWORD20 = 1,
		WORD20 = 2,
		TWO_WORDS20 = 3,
		FOUR_WORDS20 = 4,
		EIGHT_WORDS20 = 5,
		SIXTEEN_WORDS20 = 6,
		K_BITS20 = 7
} ahb_transfer_size20;
typedef enum logic[1:0]  {
		IDLE20 = 0,
		BUSY20 = 1,
		NONSEQ20 = 2,
		SEQ = 3
} ahb_transfer_kind20;
typedef enum logic[1:0]  {
		OKAY20 = 0,
		ERROR20 = 1,
		RETRY20 = 2,
		SPLIT20 = 3
} ahb_response_kind20;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction20;
typedef enum logic[2:0]  {
		SINGLE20 = 0,
		INCR = 1,
		WRAP420 = 2,
		INCR420 = 3,
		WRAP820 = 4,
		INCR820 = 5,
		WRAP1620 = 6,
		INCR1620 = 7
} ahb_burst_kind20;
 
//------------------------------------------------------------------------------
//
// CLASS20: ahb_transfer20
//
//------------------------------------------------------------------------------

class ahb_transfer20 extends uvm_sequence_item;

  /***************************************************************************
   IVB20-NOTE20 : REQUIRED20 : transfer20 definitions20 : Item20 definitions20
   ---------------------------------------------------------------------------
   Adjust20 the transfer20 attribute20 names as required20 and add any 
   necessary20 attributes20.
   Note20 that if you change an attribute20 name, you must change it in all of your20
   OVC20 files.
   Make20 sure20 to edit20 the uvm_object_utils_begin to get various20 utilities20 (like20
   print and copy) for each attribute20 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH20-1:0] data;
  rand logic [`AHB_ADDR_WIDTH20-1:0] address;
  rand ahb_direction20 direction20 ;
  rand ahb_transfer_size20  hsize20;
  rand ahb_burst_kind20  burst;
  rand logic [3:0] prot20 ;
 
  `uvm_object_utils_begin(ahb_transfer20)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction20,direction20, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size20,hsize20, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind20,burst, UVM_ALL_ON)
    `uvm_field_int(prot20, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor20 - required20 syntax20 for UVM automation20 and utilities20
  function new (string name = "unnamed20-ahb_transfer20");
    super.new(name);
  endfunction : new

endclass : ahb_transfer20

`endif // AHB_TRANSFER_SV20


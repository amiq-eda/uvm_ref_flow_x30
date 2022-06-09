// IVB25 checksum25: 2173772784
/*-----------------------------------------------------------------
File25 name     : ahb_transfer25.sv
Created25       : Wed25 May25 19 15:42:20 2010
Description25   :  This25 file declares25 the OVC25 transfer25. It is
              :  used by both master25 and slave25.
Notes25         :
-----------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV25
`define AHB_TRANSFER_SV25

//------------------------------------------------------------------------------
//
// ahb25 transfer25 enums25, parameters25, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE25 = 0,
		HALFWORD25 = 1,
		WORD25 = 2,
		TWO_WORDS25 = 3,
		FOUR_WORDS25 = 4,
		EIGHT_WORDS25 = 5,
		SIXTEEN_WORDS25 = 6,
		K_BITS25 = 7
} ahb_transfer_size25;
typedef enum logic[1:0]  {
		IDLE25 = 0,
		BUSY25 = 1,
		NONSEQ25 = 2,
		SEQ = 3
} ahb_transfer_kind25;
typedef enum logic[1:0]  {
		OKAY25 = 0,
		ERROR25 = 1,
		RETRY25 = 2,
		SPLIT25 = 3
} ahb_response_kind25;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction25;
typedef enum logic[2:0]  {
		SINGLE25 = 0,
		INCR = 1,
		WRAP425 = 2,
		INCR425 = 3,
		WRAP825 = 4,
		INCR825 = 5,
		WRAP1625 = 6,
		INCR1625 = 7
} ahb_burst_kind25;
 
//------------------------------------------------------------------------------
//
// CLASS25: ahb_transfer25
//
//------------------------------------------------------------------------------

class ahb_transfer25 extends uvm_sequence_item;

  /***************************************************************************
   IVB25-NOTE25 : REQUIRED25 : transfer25 definitions25 : Item25 definitions25
   ---------------------------------------------------------------------------
   Adjust25 the transfer25 attribute25 names as required25 and add any 
   necessary25 attributes25.
   Note25 that if you change an attribute25 name, you must change it in all of your25
   OVC25 files.
   Make25 sure25 to edit25 the uvm_object_utils_begin to get various25 utilities25 (like25
   print and copy) for each attribute25 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH25-1:0] data;
  rand logic [`AHB_ADDR_WIDTH25-1:0] address;
  rand ahb_direction25 direction25 ;
  rand ahb_transfer_size25  hsize25;
  rand ahb_burst_kind25  burst;
  rand logic [3:0] prot25 ;
 
  `uvm_object_utils_begin(ahb_transfer25)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction25,direction25, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size25,hsize25, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind25,burst, UVM_ALL_ON)
    `uvm_field_int(prot25, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor25 - required25 syntax25 for UVM automation25 and utilities25
  function new (string name = "unnamed25-ahb_transfer25");
    super.new(name);
  endfunction : new

endclass : ahb_transfer25

`endif // AHB_TRANSFER_SV25


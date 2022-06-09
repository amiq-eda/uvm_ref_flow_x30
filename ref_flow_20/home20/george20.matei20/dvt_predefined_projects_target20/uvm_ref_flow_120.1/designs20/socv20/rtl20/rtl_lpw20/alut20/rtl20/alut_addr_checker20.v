//File20 name   : alut_addr_checker20.v
//Title20       : 
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
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

// compiler20 directives20
`include "alut_defines20.v"


module alut_addr_checker20
(   
   // Inputs20
   pclk20,
   n_p_reset20,
   command,
   mac_addr20,
   d_addr20,
   s_addr20,
   s_port20,
   curr_time20,
   mem_read_data_add20,
   age_confirmed20,
   age_ok20,
   clear_reused20,

   //outputs20
   d_port20,
   add_check_active20,
   mem_addr_add20,
   mem_write_add20,
   mem_write_data_add20,
   lst_inv_addr_nrm20,
   lst_inv_port_nrm20,
   check_age20,
   last_accessed20,
   reused20
);



   input               pclk20;               // APB20 clock20                           
   input               n_p_reset20;          // Reset20                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr20;           // address of the switch20              
   input [47:0]        d_addr20;             // address of frame20 to be checked20     
   input [47:0]        s_addr20;             // address of frame20 to be stored20      
   input [1:0]         s_port20;             // source20 port of current frame20       
   input [31:0]        curr_time20;          // current time,for storing20 in mem    
   input [82:0]        mem_read_data_add20;  // read data from mem                 
   input               age_confirmed20;      // valid flag20 from age20 checker        
   input               age_ok20;             // result from age20 checker 
   input               clear_reused20;       // read/clear flag20 for reused20 signal20           

   output [4:0]        d_port20;             // calculated20 destination20 port for tx20 
   output              add_check_active20;   // bit 0 of status register           
   output [7:0]        mem_addr_add20;       // hash20 address for R/W20 to memory     
   output              mem_write_add20;      // R/W20 flag20 (write = high20)            
   output [82:0]       mem_write_data_add20; // write data for memory             
   output [47:0]       lst_inv_addr_nrm20;   // last invalidated20 addr normal20 op    
   output [1:0]        lst_inv_port_nrm20;   // last invalidated20 port normal20 op    
   output              check_age20;          // request flag20 for age20 check
   output [31:0]       last_accessed20;      // time field sent20 for age20 check
   output              reused20;             // indicates20 ALUT20 location20 overwritten20

   reg   [2:0]         add_chk_state20;      // current address checker state
   reg   [2:0]         nxt_add_chk_state20;  // current address checker state
   reg   [4:0]         d_port20;             // calculated20 destination20 port for tx20 
   reg   [3:0]         port_mem20;           // bitwise20 conversion20 of 2bit port
   reg   [7:0]         mem_addr_add20;       // hash20 address for R/W20 to memory
   reg                 mem_write_add20;      // R/W20 flag20 (write = high20)            
   reg                 reused20;             // indicates20 ALUT20 location20 overwritten20
   reg   [47:0]        lst_inv_addr_nrm20;   // last invalidated20 addr normal20 op    
   reg   [1:0]         lst_inv_port_nrm20;   // last invalidated20 port normal20 op    
   reg                 check_age20;          // request flag20 for age20 checker
   reg   [31:0]        last_accessed20;      // time field sent20 for age20 check


   wire   [7:0]        s_addr_hash20;        // hash20 of address for storing20
   wire   [7:0]        d_addr_hash20;        // hash20 of address for checking
   wire   [82:0]       mem_write_data_add20; // write data for memory  
   wire                add_check_active20;   // bit 0 of status register           


// Parameters20 for Address Checking20 FSM20 states20
   parameter idle20           = 3'b000;
   parameter mac_addr_chk20   = 3'b001;
   parameter read_dest_add20  = 3'b010;
   parameter valid_chk20      = 3'b011;
   parameter age_chk20        = 3'b100;
   parameter addr_chk20       = 3'b101;
   parameter read_src_add20   = 3'b110;
   parameter write_src20      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash20 conversion20 of source20 and destination20 addresses20
// -----------------------------------------------------------------------------
   assign s_addr_hash20 = s_addr20[7:0] ^ s_addr20[15:8] ^ s_addr20[23:16] ^
                        s_addr20[31:24] ^ s_addr20[39:32] ^ s_addr20[47:40];

   assign d_addr_hash20 = d_addr20[7:0] ^ d_addr20[15:8] ^ d_addr20[23:16] ^
                        d_addr20[31:24] ^ d_addr20[39:32] ^ d_addr20[47:40];



// -----------------------------------------------------------------------------
//   State20 Machine20 For20 handling20 the destination20 address checking process and
//   and storing20 of new source20 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state20 or age_confirmed20 or age_ok20)
   begin
      case (add_chk_state20)
      
      idle20:
         if (command == 2'b01)
            nxt_add_chk_state20 = mac_addr_chk20;
         else
            nxt_add_chk_state20 = idle20;

      mac_addr_chk20:   // check if destination20 address match MAC20 switch20 address
         if (d_addr20 == mac_addr20)
            nxt_add_chk_state20 = idle20;  // return dest20 port as 5'b1_0000
         else
            nxt_add_chk_state20 = read_dest_add20;

      read_dest_add20:       // read data from memory using hash20 of destination20 address
            nxt_add_chk_state20 = valid_chk20;

      valid_chk20:      // check if read data had20 valid bit set
         nxt_add_chk_state20 = age_chk20;

      age_chk20:        // request age20 checker to check if still in date20
         if (age_confirmed20)
            nxt_add_chk_state20 = addr_chk20;
         else
            nxt_add_chk_state20 = age_chk20; 

      addr_chk20:       // perform20 compare between dest20 and read addresses20
            nxt_add_chk_state20 = read_src_add20; // return read port from ALUT20 mem

      read_src_add20:   // read from memory location20 about20 to be overwritten20
            nxt_add_chk_state20 = write_src20; 

      write_src20:      // write new source20 data (addr and port) to memory
            nxt_add_chk_state20 = idle20; 

      default:
            nxt_add_chk_state20 = idle20;
      endcase
   end


// destination20 check FSM20 current state
always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20)
      add_chk_state20 <= idle20;
   else
      add_chk_state20 <= nxt_add_chk_state20;
   end



// -----------------------------------------------------------------------------
//   Generate20 returned value of port for sending20 new frame20 to
// -----------------------------------------------------------------------------
always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20)
      d_port20 <= 5'b0_1111;
   else if ((add_chk_state20 == mac_addr_chk20) & (d_addr20 == mac_addr20))
      d_port20 <= 5'b1_0000;
   else if (((add_chk_state20 == valid_chk20) & ~mem_read_data_add20[82]) |
            ((add_chk_state20 == age_chk20) & ~(age_confirmed20 & age_ok20)) |
            ((add_chk_state20 == addr_chk20) & (d_addr20 != mem_read_data_add20[47:0])))
      d_port20 <= 5'b0_1111 & ~( 1 << s_port20 );
   else if ((add_chk_state20 == addr_chk20) & (d_addr20 == mem_read_data_add20[47:0]))
      d_port20 <= {1'b0, port_mem20} & ~( 1 << s_port20 );
   else
      d_port20 <= d_port20;
   end


// -----------------------------------------------------------------------------
//   convert read port source20 value from 2bits to bitwise20 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20)
      port_mem20 <= 4'b1111;
   else begin
      case (mem_read_data_add20[49:48])
         2'b00: port_mem20 <= 4'b0001;
         2'b01: port_mem20 <= 4'b0010;
         2'b10: port_mem20 <= 4'b0100;
         2'b11: port_mem20 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded20 off20 add_chk_state20
// -----------------------------------------------------------------------------
assign add_check_active20 = (add_chk_state20 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate20 memory addressing20 signals20.
//   The check address command will be taken20 as the indication20 from SW20 that the 
//   source20 fields (address and port) can be written20 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20) 
   begin
       mem_write_add20 <= 1'b0;
       mem_addr_add20  <= 8'd0;
   end
   else if (add_chk_state20 == read_dest_add20)
   begin
       mem_write_add20 <= 1'b0;
       mem_addr_add20  <= d_addr_hash20;
   end
// Need20 to set address two20 cycles20 before check
   else if ( (add_chk_state20 == age_chk20) && age_confirmed20 )
   begin
       mem_write_add20 <= 1'b0;
       mem_addr_add20  <= s_addr_hash20;
   end
   else if (add_chk_state20 == write_src20)
   begin
       mem_write_add20 <= 1'b1;
       mem_addr_add20  <= s_addr_hash20;
   end
   else
   begin
       mem_write_add20 <= 1'b0;
       mem_addr_add20  <= d_addr_hash20;
   end
   end


// -----------------------------------------------------------------------------
//   Generate20 databus20 for writing to memory
//   Data written20 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add20 = {1'b1, curr_time20, s_port20, s_addr20};



// -----------------------------------------------------------------------------
//   Evaluate20 read back data that is about20 to be overwritten20 with new source20 
//   address and port values. Decide20 whether20 the reused20 flag20 must be set and
//   last_inval20 address and port values updated.
//   reused20 needs20 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20) 
   begin
      reused20 <= 1'b0;
      lst_inv_addr_nrm20 <= 48'd0;
      lst_inv_port_nrm20 <= 2'd0;
   end
   else if ((add_chk_state20 == read_src_add20) & mem_read_data_add20[82] &
            (s_addr20 != mem_read_data_add20[47:0]))
   begin
      reused20 <= 1'b1;
      lst_inv_addr_nrm20 <= mem_read_data_add20[47:0];
      lst_inv_port_nrm20 <= mem_read_data_add20[49:48];
   end
   else if (clear_reused20)
   begin
      reused20 <= 1'b0;
      lst_inv_addr_nrm20 <= lst_inv_addr_nrm20;
      lst_inv_port_nrm20 <= lst_inv_addr_nrm20;
   end
   else 
   begin
      reused20 <= reused20;
      lst_inv_addr_nrm20 <= lst_inv_addr_nrm20;
      lst_inv_port_nrm20 <= lst_inv_addr_nrm20;
   end
   end


// -----------------------------------------------------------------------------
//   Generate20 signals20 for age20 checker to perform20 in-date20 check
// -----------------------------------------------------------------------------
always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20) 
   begin
      check_age20 <= 1'b0;  
      last_accessed20 <= 32'd0;
   end
   else if (check_age20)
   begin
      check_age20 <= 1'b0;  
      last_accessed20 <= mem_read_data_add20[81:50];
   end
   else if (add_chk_state20 == age_chk20)
   begin
      check_age20 <= 1'b1;  
      last_accessed20 <= mem_read_data_add20[81:50];
   end
   else 
   begin
      check_age20 <= 1'b0;  
      last_accessed20 <= 32'd0;
   end
   end


`ifdef ABV_ON20

// psl20 default clock20 = (posedge pclk20);

// ASSERTION20 CHECKS20
/* Commented20 out as also checking in toplevel20
// it should never be possible20 for the destination20 port to indicate20 the MAC20
// switch20 address and one of the other 4 Ethernets20
// psl20 assert_valid_dest_port20 : assert never (d_port20[4] & |{d_port20[3:0]});


// COVER20 SANITY20 CHECKS20
// check all values of destination20 port can be returned.
// psl20 cover_d_port_020 : cover { d_port20 == 5'b0_0001 };
// psl20 cover_d_port_120 : cover { d_port20 == 5'b0_0010 };
// psl20 cover_d_port_220 : cover { d_port20 == 5'b0_0100 };
// psl20 cover_d_port_320 : cover { d_port20 == 5'b0_1000 };
// psl20 cover_d_port_420 : cover { d_port20 == 5'b1_0000 };
// psl20 cover_d_port_all20 : cover { d_port20 == 5'b0_1111 };
*/
`endif


endmodule 










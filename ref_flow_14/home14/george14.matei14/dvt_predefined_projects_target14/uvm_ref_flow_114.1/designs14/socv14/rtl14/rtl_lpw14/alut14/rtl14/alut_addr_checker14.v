//File14 name   : alut_addr_checker14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
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

// compiler14 directives14
`include "alut_defines14.v"


module alut_addr_checker14
(   
   // Inputs14
   pclk14,
   n_p_reset14,
   command,
   mac_addr14,
   d_addr14,
   s_addr14,
   s_port14,
   curr_time14,
   mem_read_data_add14,
   age_confirmed14,
   age_ok14,
   clear_reused14,

   //outputs14
   d_port14,
   add_check_active14,
   mem_addr_add14,
   mem_write_add14,
   mem_write_data_add14,
   lst_inv_addr_nrm14,
   lst_inv_port_nrm14,
   check_age14,
   last_accessed14,
   reused14
);



   input               pclk14;               // APB14 clock14                           
   input               n_p_reset14;          // Reset14                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr14;           // address of the switch14              
   input [47:0]        d_addr14;             // address of frame14 to be checked14     
   input [47:0]        s_addr14;             // address of frame14 to be stored14      
   input [1:0]         s_port14;             // source14 port of current frame14       
   input [31:0]        curr_time14;          // current time,for storing14 in mem    
   input [82:0]        mem_read_data_add14;  // read data from mem                 
   input               age_confirmed14;      // valid flag14 from age14 checker        
   input               age_ok14;             // result from age14 checker 
   input               clear_reused14;       // read/clear flag14 for reused14 signal14           

   output [4:0]        d_port14;             // calculated14 destination14 port for tx14 
   output              add_check_active14;   // bit 0 of status register           
   output [7:0]        mem_addr_add14;       // hash14 address for R/W14 to memory     
   output              mem_write_add14;      // R/W14 flag14 (write = high14)            
   output [82:0]       mem_write_data_add14; // write data for memory             
   output [47:0]       lst_inv_addr_nrm14;   // last invalidated14 addr normal14 op    
   output [1:0]        lst_inv_port_nrm14;   // last invalidated14 port normal14 op    
   output              check_age14;          // request flag14 for age14 check
   output [31:0]       last_accessed14;      // time field sent14 for age14 check
   output              reused14;             // indicates14 ALUT14 location14 overwritten14

   reg   [2:0]         add_chk_state14;      // current address checker state
   reg   [2:0]         nxt_add_chk_state14;  // current address checker state
   reg   [4:0]         d_port14;             // calculated14 destination14 port for tx14 
   reg   [3:0]         port_mem14;           // bitwise14 conversion14 of 2bit port
   reg   [7:0]         mem_addr_add14;       // hash14 address for R/W14 to memory
   reg                 mem_write_add14;      // R/W14 flag14 (write = high14)            
   reg                 reused14;             // indicates14 ALUT14 location14 overwritten14
   reg   [47:0]        lst_inv_addr_nrm14;   // last invalidated14 addr normal14 op    
   reg   [1:0]         lst_inv_port_nrm14;   // last invalidated14 port normal14 op    
   reg                 check_age14;          // request flag14 for age14 checker
   reg   [31:0]        last_accessed14;      // time field sent14 for age14 check


   wire   [7:0]        s_addr_hash14;        // hash14 of address for storing14
   wire   [7:0]        d_addr_hash14;        // hash14 of address for checking
   wire   [82:0]       mem_write_data_add14; // write data for memory  
   wire                add_check_active14;   // bit 0 of status register           


// Parameters14 for Address Checking14 FSM14 states14
   parameter idle14           = 3'b000;
   parameter mac_addr_chk14   = 3'b001;
   parameter read_dest_add14  = 3'b010;
   parameter valid_chk14      = 3'b011;
   parameter age_chk14        = 3'b100;
   parameter addr_chk14       = 3'b101;
   parameter read_src_add14   = 3'b110;
   parameter write_src14      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash14 conversion14 of source14 and destination14 addresses14
// -----------------------------------------------------------------------------
   assign s_addr_hash14 = s_addr14[7:0] ^ s_addr14[15:8] ^ s_addr14[23:16] ^
                        s_addr14[31:24] ^ s_addr14[39:32] ^ s_addr14[47:40];

   assign d_addr_hash14 = d_addr14[7:0] ^ d_addr14[15:8] ^ d_addr14[23:16] ^
                        d_addr14[31:24] ^ d_addr14[39:32] ^ d_addr14[47:40];



// -----------------------------------------------------------------------------
//   State14 Machine14 For14 handling14 the destination14 address checking process and
//   and storing14 of new source14 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state14 or age_confirmed14 or age_ok14)
   begin
      case (add_chk_state14)
      
      idle14:
         if (command == 2'b01)
            nxt_add_chk_state14 = mac_addr_chk14;
         else
            nxt_add_chk_state14 = idle14;

      mac_addr_chk14:   // check if destination14 address match MAC14 switch14 address
         if (d_addr14 == mac_addr14)
            nxt_add_chk_state14 = idle14;  // return dest14 port as 5'b1_0000
         else
            nxt_add_chk_state14 = read_dest_add14;

      read_dest_add14:       // read data from memory using hash14 of destination14 address
            nxt_add_chk_state14 = valid_chk14;

      valid_chk14:      // check if read data had14 valid bit set
         nxt_add_chk_state14 = age_chk14;

      age_chk14:        // request age14 checker to check if still in date14
         if (age_confirmed14)
            nxt_add_chk_state14 = addr_chk14;
         else
            nxt_add_chk_state14 = age_chk14; 

      addr_chk14:       // perform14 compare between dest14 and read addresses14
            nxt_add_chk_state14 = read_src_add14; // return read port from ALUT14 mem

      read_src_add14:   // read from memory location14 about14 to be overwritten14
            nxt_add_chk_state14 = write_src14; 

      write_src14:      // write new source14 data (addr and port) to memory
            nxt_add_chk_state14 = idle14; 

      default:
            nxt_add_chk_state14 = idle14;
      endcase
   end


// destination14 check FSM14 current state
always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14)
      add_chk_state14 <= idle14;
   else
      add_chk_state14 <= nxt_add_chk_state14;
   end



// -----------------------------------------------------------------------------
//   Generate14 returned value of port for sending14 new frame14 to
// -----------------------------------------------------------------------------
always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14)
      d_port14 <= 5'b0_1111;
   else if ((add_chk_state14 == mac_addr_chk14) & (d_addr14 == mac_addr14))
      d_port14 <= 5'b1_0000;
   else if (((add_chk_state14 == valid_chk14) & ~mem_read_data_add14[82]) |
            ((add_chk_state14 == age_chk14) & ~(age_confirmed14 & age_ok14)) |
            ((add_chk_state14 == addr_chk14) & (d_addr14 != mem_read_data_add14[47:0])))
      d_port14 <= 5'b0_1111 & ~( 1 << s_port14 );
   else if ((add_chk_state14 == addr_chk14) & (d_addr14 == mem_read_data_add14[47:0]))
      d_port14 <= {1'b0, port_mem14} & ~( 1 << s_port14 );
   else
      d_port14 <= d_port14;
   end


// -----------------------------------------------------------------------------
//   convert read port source14 value from 2bits to bitwise14 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14)
      port_mem14 <= 4'b1111;
   else begin
      case (mem_read_data_add14[49:48])
         2'b00: port_mem14 <= 4'b0001;
         2'b01: port_mem14 <= 4'b0010;
         2'b10: port_mem14 <= 4'b0100;
         2'b11: port_mem14 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded14 off14 add_chk_state14
// -----------------------------------------------------------------------------
assign add_check_active14 = (add_chk_state14 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate14 memory addressing14 signals14.
//   The check address command will be taken14 as the indication14 from SW14 that the 
//   source14 fields (address and port) can be written14 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14) 
   begin
       mem_write_add14 <= 1'b0;
       mem_addr_add14  <= 8'd0;
   end
   else if (add_chk_state14 == read_dest_add14)
   begin
       mem_write_add14 <= 1'b0;
       mem_addr_add14  <= d_addr_hash14;
   end
// Need14 to set address two14 cycles14 before check
   else if ( (add_chk_state14 == age_chk14) && age_confirmed14 )
   begin
       mem_write_add14 <= 1'b0;
       mem_addr_add14  <= s_addr_hash14;
   end
   else if (add_chk_state14 == write_src14)
   begin
       mem_write_add14 <= 1'b1;
       mem_addr_add14  <= s_addr_hash14;
   end
   else
   begin
       mem_write_add14 <= 1'b0;
       mem_addr_add14  <= d_addr_hash14;
   end
   end


// -----------------------------------------------------------------------------
//   Generate14 databus14 for writing to memory
//   Data written14 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add14 = {1'b1, curr_time14, s_port14, s_addr14};



// -----------------------------------------------------------------------------
//   Evaluate14 read back data that is about14 to be overwritten14 with new source14 
//   address and port values. Decide14 whether14 the reused14 flag14 must be set and
//   last_inval14 address and port values updated.
//   reused14 needs14 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14) 
   begin
      reused14 <= 1'b0;
      lst_inv_addr_nrm14 <= 48'd0;
      lst_inv_port_nrm14 <= 2'd0;
   end
   else if ((add_chk_state14 == read_src_add14) & mem_read_data_add14[82] &
            (s_addr14 != mem_read_data_add14[47:0]))
   begin
      reused14 <= 1'b1;
      lst_inv_addr_nrm14 <= mem_read_data_add14[47:0];
      lst_inv_port_nrm14 <= mem_read_data_add14[49:48];
   end
   else if (clear_reused14)
   begin
      reused14 <= 1'b0;
      lst_inv_addr_nrm14 <= lst_inv_addr_nrm14;
      lst_inv_port_nrm14 <= lst_inv_addr_nrm14;
   end
   else 
   begin
      reused14 <= reused14;
      lst_inv_addr_nrm14 <= lst_inv_addr_nrm14;
      lst_inv_port_nrm14 <= lst_inv_addr_nrm14;
   end
   end


// -----------------------------------------------------------------------------
//   Generate14 signals14 for age14 checker to perform14 in-date14 check
// -----------------------------------------------------------------------------
always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14) 
   begin
      check_age14 <= 1'b0;  
      last_accessed14 <= 32'd0;
   end
   else if (check_age14)
   begin
      check_age14 <= 1'b0;  
      last_accessed14 <= mem_read_data_add14[81:50];
   end
   else if (add_chk_state14 == age_chk14)
   begin
      check_age14 <= 1'b1;  
      last_accessed14 <= mem_read_data_add14[81:50];
   end
   else 
   begin
      check_age14 <= 1'b0;  
      last_accessed14 <= 32'd0;
   end
   end


`ifdef ABV_ON14

// psl14 default clock14 = (posedge pclk14);

// ASSERTION14 CHECKS14
/* Commented14 out as also checking in toplevel14
// it should never be possible14 for the destination14 port to indicate14 the MAC14
// switch14 address and one of the other 4 Ethernets14
// psl14 assert_valid_dest_port14 : assert never (d_port14[4] & |{d_port14[3:0]});


// COVER14 SANITY14 CHECKS14
// check all values of destination14 port can be returned.
// psl14 cover_d_port_014 : cover { d_port14 == 5'b0_0001 };
// psl14 cover_d_port_114 : cover { d_port14 == 5'b0_0010 };
// psl14 cover_d_port_214 : cover { d_port14 == 5'b0_0100 };
// psl14 cover_d_port_314 : cover { d_port14 == 5'b0_1000 };
// psl14 cover_d_port_414 : cover { d_port14 == 5'b1_0000 };
// psl14 cover_d_port_all14 : cover { d_port14 == 5'b0_1111 };
*/
`endif


endmodule 










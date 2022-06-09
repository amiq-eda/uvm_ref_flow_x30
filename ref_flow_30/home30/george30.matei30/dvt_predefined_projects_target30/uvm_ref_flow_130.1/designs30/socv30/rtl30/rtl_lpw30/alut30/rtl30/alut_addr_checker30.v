//File30 name   : alut_addr_checker30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

// compiler30 directives30
`include "alut_defines30.v"


module alut_addr_checker30
(   
   // Inputs30
   pclk30,
   n_p_reset30,
   command,
   mac_addr30,
   d_addr30,
   s_addr30,
   s_port30,
   curr_time30,
   mem_read_data_add30,
   age_confirmed30,
   age_ok30,
   clear_reused30,

   //outputs30
   d_port30,
   add_check_active30,
   mem_addr_add30,
   mem_write_add30,
   mem_write_data_add30,
   lst_inv_addr_nrm30,
   lst_inv_port_nrm30,
   check_age30,
   last_accessed30,
   reused30
);



   input               pclk30;               // APB30 clock30                           
   input               n_p_reset30;          // Reset30                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr30;           // address of the switch30              
   input [47:0]        d_addr30;             // address of frame30 to be checked30     
   input [47:0]        s_addr30;             // address of frame30 to be stored30      
   input [1:0]         s_port30;             // source30 port of current frame30       
   input [31:0]        curr_time30;          // current time,for storing30 in mem    
   input [82:0]        mem_read_data_add30;  // read data from mem                 
   input               age_confirmed30;      // valid flag30 from age30 checker        
   input               age_ok30;             // result from age30 checker 
   input               clear_reused30;       // read/clear flag30 for reused30 signal30           

   output [4:0]        d_port30;             // calculated30 destination30 port for tx30 
   output              add_check_active30;   // bit 0 of status register           
   output [7:0]        mem_addr_add30;       // hash30 address for R/W30 to memory     
   output              mem_write_add30;      // R/W30 flag30 (write = high30)            
   output [82:0]       mem_write_data_add30; // write data for memory             
   output [47:0]       lst_inv_addr_nrm30;   // last invalidated30 addr normal30 op    
   output [1:0]        lst_inv_port_nrm30;   // last invalidated30 port normal30 op    
   output              check_age30;          // request flag30 for age30 check
   output [31:0]       last_accessed30;      // time field sent30 for age30 check
   output              reused30;             // indicates30 ALUT30 location30 overwritten30

   reg   [2:0]         add_chk_state30;      // current address checker state
   reg   [2:0]         nxt_add_chk_state30;  // current address checker state
   reg   [4:0]         d_port30;             // calculated30 destination30 port for tx30 
   reg   [3:0]         port_mem30;           // bitwise30 conversion30 of 2bit port
   reg   [7:0]         mem_addr_add30;       // hash30 address for R/W30 to memory
   reg                 mem_write_add30;      // R/W30 flag30 (write = high30)            
   reg                 reused30;             // indicates30 ALUT30 location30 overwritten30
   reg   [47:0]        lst_inv_addr_nrm30;   // last invalidated30 addr normal30 op    
   reg   [1:0]         lst_inv_port_nrm30;   // last invalidated30 port normal30 op    
   reg                 check_age30;          // request flag30 for age30 checker
   reg   [31:0]        last_accessed30;      // time field sent30 for age30 check


   wire   [7:0]        s_addr_hash30;        // hash30 of address for storing30
   wire   [7:0]        d_addr_hash30;        // hash30 of address for checking
   wire   [82:0]       mem_write_data_add30; // write data for memory  
   wire                add_check_active30;   // bit 0 of status register           


// Parameters30 for Address Checking30 FSM30 states30
   parameter idle30           = 3'b000;
   parameter mac_addr_chk30   = 3'b001;
   parameter read_dest_add30  = 3'b010;
   parameter valid_chk30      = 3'b011;
   parameter age_chk30        = 3'b100;
   parameter addr_chk30       = 3'b101;
   parameter read_src_add30   = 3'b110;
   parameter write_src30      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash30 conversion30 of source30 and destination30 addresses30
// -----------------------------------------------------------------------------
   assign s_addr_hash30 = s_addr30[7:0] ^ s_addr30[15:8] ^ s_addr30[23:16] ^
                        s_addr30[31:24] ^ s_addr30[39:32] ^ s_addr30[47:40];

   assign d_addr_hash30 = d_addr30[7:0] ^ d_addr30[15:8] ^ d_addr30[23:16] ^
                        d_addr30[31:24] ^ d_addr30[39:32] ^ d_addr30[47:40];



// -----------------------------------------------------------------------------
//   State30 Machine30 For30 handling30 the destination30 address checking process and
//   and storing30 of new source30 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state30 or age_confirmed30 or age_ok30)
   begin
      case (add_chk_state30)
      
      idle30:
         if (command == 2'b01)
            nxt_add_chk_state30 = mac_addr_chk30;
         else
            nxt_add_chk_state30 = idle30;

      mac_addr_chk30:   // check if destination30 address match MAC30 switch30 address
         if (d_addr30 == mac_addr30)
            nxt_add_chk_state30 = idle30;  // return dest30 port as 5'b1_0000
         else
            nxt_add_chk_state30 = read_dest_add30;

      read_dest_add30:       // read data from memory using hash30 of destination30 address
            nxt_add_chk_state30 = valid_chk30;

      valid_chk30:      // check if read data had30 valid bit set
         nxt_add_chk_state30 = age_chk30;

      age_chk30:        // request age30 checker to check if still in date30
         if (age_confirmed30)
            nxt_add_chk_state30 = addr_chk30;
         else
            nxt_add_chk_state30 = age_chk30; 

      addr_chk30:       // perform30 compare between dest30 and read addresses30
            nxt_add_chk_state30 = read_src_add30; // return read port from ALUT30 mem

      read_src_add30:   // read from memory location30 about30 to be overwritten30
            nxt_add_chk_state30 = write_src30; 

      write_src30:      // write new source30 data (addr and port) to memory
            nxt_add_chk_state30 = idle30; 

      default:
            nxt_add_chk_state30 = idle30;
      endcase
   end


// destination30 check FSM30 current state
always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30)
      add_chk_state30 <= idle30;
   else
      add_chk_state30 <= nxt_add_chk_state30;
   end



// -----------------------------------------------------------------------------
//   Generate30 returned value of port for sending30 new frame30 to
// -----------------------------------------------------------------------------
always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30)
      d_port30 <= 5'b0_1111;
   else if ((add_chk_state30 == mac_addr_chk30) & (d_addr30 == mac_addr30))
      d_port30 <= 5'b1_0000;
   else if (((add_chk_state30 == valid_chk30) & ~mem_read_data_add30[82]) |
            ((add_chk_state30 == age_chk30) & ~(age_confirmed30 & age_ok30)) |
            ((add_chk_state30 == addr_chk30) & (d_addr30 != mem_read_data_add30[47:0])))
      d_port30 <= 5'b0_1111 & ~( 1 << s_port30 );
   else if ((add_chk_state30 == addr_chk30) & (d_addr30 == mem_read_data_add30[47:0]))
      d_port30 <= {1'b0, port_mem30} & ~( 1 << s_port30 );
   else
      d_port30 <= d_port30;
   end


// -----------------------------------------------------------------------------
//   convert read port source30 value from 2bits to bitwise30 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30)
      port_mem30 <= 4'b1111;
   else begin
      case (mem_read_data_add30[49:48])
         2'b00: port_mem30 <= 4'b0001;
         2'b01: port_mem30 <= 4'b0010;
         2'b10: port_mem30 <= 4'b0100;
         2'b11: port_mem30 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded30 off30 add_chk_state30
// -----------------------------------------------------------------------------
assign add_check_active30 = (add_chk_state30 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate30 memory addressing30 signals30.
//   The check address command will be taken30 as the indication30 from SW30 that the 
//   source30 fields (address and port) can be written30 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30) 
   begin
       mem_write_add30 <= 1'b0;
       mem_addr_add30  <= 8'd0;
   end
   else if (add_chk_state30 == read_dest_add30)
   begin
       mem_write_add30 <= 1'b0;
       mem_addr_add30  <= d_addr_hash30;
   end
// Need30 to set address two30 cycles30 before check
   else if ( (add_chk_state30 == age_chk30) && age_confirmed30 )
   begin
       mem_write_add30 <= 1'b0;
       mem_addr_add30  <= s_addr_hash30;
   end
   else if (add_chk_state30 == write_src30)
   begin
       mem_write_add30 <= 1'b1;
       mem_addr_add30  <= s_addr_hash30;
   end
   else
   begin
       mem_write_add30 <= 1'b0;
       mem_addr_add30  <= d_addr_hash30;
   end
   end


// -----------------------------------------------------------------------------
//   Generate30 databus30 for writing to memory
//   Data written30 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add30 = {1'b1, curr_time30, s_port30, s_addr30};



// -----------------------------------------------------------------------------
//   Evaluate30 read back data that is about30 to be overwritten30 with new source30 
//   address and port values. Decide30 whether30 the reused30 flag30 must be set and
//   last_inval30 address and port values updated.
//   reused30 needs30 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30) 
   begin
      reused30 <= 1'b0;
      lst_inv_addr_nrm30 <= 48'd0;
      lst_inv_port_nrm30 <= 2'd0;
   end
   else if ((add_chk_state30 == read_src_add30) & mem_read_data_add30[82] &
            (s_addr30 != mem_read_data_add30[47:0]))
   begin
      reused30 <= 1'b1;
      lst_inv_addr_nrm30 <= mem_read_data_add30[47:0];
      lst_inv_port_nrm30 <= mem_read_data_add30[49:48];
   end
   else if (clear_reused30)
   begin
      reused30 <= 1'b0;
      lst_inv_addr_nrm30 <= lst_inv_addr_nrm30;
      lst_inv_port_nrm30 <= lst_inv_addr_nrm30;
   end
   else 
   begin
      reused30 <= reused30;
      lst_inv_addr_nrm30 <= lst_inv_addr_nrm30;
      lst_inv_port_nrm30 <= lst_inv_addr_nrm30;
   end
   end


// -----------------------------------------------------------------------------
//   Generate30 signals30 for age30 checker to perform30 in-date30 check
// -----------------------------------------------------------------------------
always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30) 
   begin
      check_age30 <= 1'b0;  
      last_accessed30 <= 32'd0;
   end
   else if (check_age30)
   begin
      check_age30 <= 1'b0;  
      last_accessed30 <= mem_read_data_add30[81:50];
   end
   else if (add_chk_state30 == age_chk30)
   begin
      check_age30 <= 1'b1;  
      last_accessed30 <= mem_read_data_add30[81:50];
   end
   else 
   begin
      check_age30 <= 1'b0;  
      last_accessed30 <= 32'd0;
   end
   end


`ifdef ABV_ON30

// psl30 default clock30 = (posedge pclk30);

// ASSERTION30 CHECKS30
/* Commented30 out as also checking in toplevel30
// it should never be possible30 for the destination30 port to indicate30 the MAC30
// switch30 address and one of the other 4 Ethernets30
// psl30 assert_valid_dest_port30 : assert never (d_port30[4] & |{d_port30[3:0]});


// COVER30 SANITY30 CHECKS30
// check all values of destination30 port can be returned.
// psl30 cover_d_port_030 : cover { d_port30 == 5'b0_0001 };
// psl30 cover_d_port_130 : cover { d_port30 == 5'b0_0010 };
// psl30 cover_d_port_230 : cover { d_port30 == 5'b0_0100 };
// psl30 cover_d_port_330 : cover { d_port30 == 5'b0_1000 };
// psl30 cover_d_port_430 : cover { d_port30 == 5'b1_0000 };
// psl30 cover_d_port_all30 : cover { d_port30 == 5'b0_1111 };
*/
`endif


endmodule 










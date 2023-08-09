----------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis Sánchez Márquez
--						Ricardo Flores Martínez
-- Asesor: 			M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	Mensaje5
-- Descripción: 	>>>>>>>>>>>>>>>>>
-----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mensaje5 is

    port( clk,rst,listo_in:	in      STD_LOGIC;
          LCD_E, LCD_RS, LCD_RW:  inout   STD_LOGIC;
	  listo_out: out STD_LOGIC;
          DATA:  inout STD_LOGIC_VECTOR( 0 to 3 ) );

end mensaje5;

architecture Behavioral of mensaje5 is

    signal CNTR:    STD_LOGIC_VECTOR( 0 to 31 ) := X"00000000";   
    signal index:   integer:=0;
    -- Tengamos una definición tipo ROM :  D Y C0 C1 C2 C3 C4 C5
	 -- Y contiene (LDC_E, LCD_RS, LCD_RW, 0)
    type ROM_TYPE is array( 0 to 67 ) of STD_LOGIC_VECTOR( 0 to 39 );   
    
signal ROM: ROM_TYPE:= (

				-- Seleccionar DDRAM
				X"88000007D0", -- 40us
				X"800000000C", -- 230ns
				X"0800000032", -- 1us
				X"000000000C", -- 230ns

				-- Escribiendo datos
				X"3C00FFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns
											
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns
								
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns
									
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns
									
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns
									
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns
									
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns 
									
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns
									
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns 
									
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns
															
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns
									
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns 
									
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns	
				
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns
				
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C", -- 230ns
				
				X"3C1EAFFFFF", -- 335ms	--	>
				X"340000000C", -- 230ns
				X"EC00000032", -- 1us
				X"E40000000C"  -- 230ns
									
			);	

begin
    
process(CLK,RST,CNTR,index) is
    begin
    if RST = '1' then
        INDEX <=0;
	listo_out <='0';
        CNTR <= (others=>'0');
    elsif rising_edge( CLK ) and listo_in = '1' then
    
            if CNTR >= ROM(index)(8 to 39) then
                        
                CNTR <= (others=>'0');
                DATA(0 to 3) <= ROM(index)(0 to 3);
                LCD_E   <= ROM(index)(4);
                LCD_RS  <= ROM(index)(5);
                LCD_RW  <= ROM(index)(6);
                        
                if index < ROM'high then 
                        index <= index + 1;
                else    
                        index <= index;
			listo_out <= '1';
                end if;                                 
            else            
                CNTR <= CNTR + 1;                                                               
            end if;                 
    end if;
end process;                    
end Behavioral;

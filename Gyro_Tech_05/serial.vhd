---------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis Sánchez Márquez
--						Ricardo Flores Martínez
-- Asesor: 			M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	serial 
-- Descripción: 	Transmite las tramas a una velocidad de 9600 baudios
---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity serial is
  port (clk, rst: in  STD_LOGIC;
        V,T,P: in STD_LOGIC_VECTOR(15 downto 0);
        etx: in STD_LOGIC;
		  tx: out  STD_LOGIC);		  		 
end serial;

architecture Arq of serial is

signal regtx:  STD_LOGIC_VECTOR (7 downto 0);
signal cnttx:	STD_LOGIC_VECTOR (15 downto 0);
signal ttx:		STD_LOGIC_VECTOR (3 downto 0);

signal cargador:	STD_LOGIC_VECTOR (3 downto 0);
signal V1,V2:	STD_LOGIC_VECTOR (7 downto 0);
signal T1,T2:	STD_LOGIC_VECTOR (7 downto 0);
signal P1,P2:	STD_LOGIC_VECTOR (7 downto 0);
 
-------------- VELOCIDAD DE TRANSMISIÓN ----------------------------
constant baudtx: STD_LOGIC_VECTOR(15 downto 0):="0001010001011000"; -- ---(1/9600)/20ns  = 5208
 																						
begin 

	
-- Proceso para cargar los datos  
 process(rst, etx)
  begin  
	if rst='1' then
		V1<=(others=>'1');
		V2<=(others=>'1');
		T1<=(others=>'1');
		T2<=(others=>'1');
		P1<=(others=>'1');
		P2<=(others=>'1');
	
	elsif(etx'event and etx='0')then	
		
		V1<= '1' & V(14 downto 8);   
		V2<=V(7 downto 0);  	 	
		
		T1<='1' & T(14 downto 8);   
		T2<=T(7 downto 0);  
		
		P1<='1' & P(14 downto 8);    
		P2<=P(7 downto 0); 
		
	end if;
 end process;	
  
-- Reloj de transmisión
 process (clk,rst,etx,cnttx,ttx)
  begin
	if (rst='1' or etx='0')then
	 	 cnttx <= (others=>'0');
		 ttx   <= "0000";
	    cargador <= "0000";
	elsif (clk'event and clk='1' and etx='1')then
		 cnttx <= cnttx+1;
		if (cnttx=baudtx)then
			ttx<=ttx+1;
			cnttx<=(others=>'0');
		if (ttx="1010")then
			cargador <= cargador + 1;
			ttx <= "0000";
		end if;
		end if;
	end if;
end process;	  

-- Asignacion de Caracter
with cargador select
	regtx <=	V1	when "0000", 
				V2	when "0001", 
				T1	when "0010", 
				T2	when "0011", 
				P1	when "0100", 
				P2	when "0101", 
				X"00"	when others;
	
-- Protocolo de transmisión
with ttx select
		tx	<=	'1' when "0000",
			   '0' when "0001",	--bit de start
		 regtx(0) when "0010",	--inicia transmision de dato
		 regtx(1) when "0011",
		 regtx(2) when "0100",
		 regtx(3) when "0101",
		 regtx(4) when "0110",
		 regtx(5) when "0111",
		 regtx(6) when "1000",
		 regtx(7) when "1001",	--fin de transmision de dato
				'1' when "1010",	--bit de stop
				'1'		when others;
end Arq;


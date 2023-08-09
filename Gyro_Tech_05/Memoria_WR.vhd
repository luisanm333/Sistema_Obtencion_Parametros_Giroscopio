----------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis Sánchez Márquez
--						Ricardo Flores Martínez
-- Asesor: 			M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	Memoria
-- Descripción: 	Lee o Escribe los datos de Temperatura, Velocidad y Periodo
-----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Memoria is
  port(	Temrx, Velrx, Periodo: in std_logic_vector (15 downto 0);
			rst, rst_int, rstx, IND, Guarda, etx: in std_logic;	
			V,T,P: out std_logic_vector (15 downto 0)	 );
end Memoria;

architecture Arq of Memoria is

signal address : integer range 0 to 20 :=0; 

type ram_t is array(0 to 20) of STD_LOGIC_VECTOR(15 downto 0);	-- 20 datos de 16 bits cada uno
signal Tem: ram_t;
signal Vel: ram_t;
signal Per: ram_t;
signal Senal_1,Senal_2,WE:std_logic;


begin

process (rst_int, rst)
begin
	if rst='1'  then
		WE <= '1';
	elsif rst_int'event and rst_int = '0' then
		WE <= '0';
	end if;	
end process;

process(Senal_1,WE)
begin

	if Senal_1'event and Senal_1='1' then
		if(WE='1') then     -- Almacena los datos en la memoria
			Tem(address) <= Temrx;
			Vel(address) <= Velrx;
			Per(address) <= Periodo;
		else                -- Lee los datos de la memoria	                
			T <= Tem(address);
			V <= Vel(address);
			P <= Per(address);
		end if;
	end if;
	
end process;

process(rst, rst_int, Senal_2, address,Tem)
begin

	if rst='1' or rst_int='1' or rstx='1' then
		address <= 0;
	elsif Senal_2'event and Senal_2='1' then --Cambio de dirección
		if address < Tem'high then
			address <= address + 1;
		else
			address <= 0;
		end if;
	end if;
	
end process;


-- Senal_1 y Senal_2 se asignan de acuerdo a si se lee o se escribe en la memoria
with WE select
	senal_1<= Guarda when '1',
				 etx	  when '0',
				 '0'	  when others;
with we select
	senal_2<= IND 	  when '1',
				 etx	  when '0',
				 '0'	  when others;

end Arq;
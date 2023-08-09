-------------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis Sanchez Marquez
--						Ricardo Flores Martinez
-- Asesor: 	    	M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	GPS
-- Descripcion:   Calcula el Periodo del giro del motor
-------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.Componentes_pkg.ALL;

entity GPS is
    Port (  clk,rst,IR,rst_int : in  STD_LOGIC;
				Motor_Listo: in std_logic;
				Periodo: out std_logic_vector (15 downto 0);
				Per_Listo: inout std_logic
			);
end GPS;

architecture Arq of GPS is

signal clk1,cnt1:std_logic_vector(15 downto 0);
signal ref, Listo, SinReb, alto: std_logic;


begin

process (rst_int, rst)
begin
	if rst='1' then
		alto <= '0';
	elsif rst_int'event and rst_int = '0' then
		alto <= '1';
	end if;	
end process;

--Detecta el pulso enviado por la maquina de estados
process(rst,Per_Listo, Motor_Listo)
begin
	if rst='1' or Per_Listo='1' then
		Listo <= '0';
	elsif Motor_Listo'event and Motor_Listo='0' then 
		Listo <='1';
	end if;
end process;

--Reloj de 1ms
process(clk,rst,clk1)
begin
	if rst='1'  or clk1 = x"C350" then --110010 
		clk1<=(others=>'0');
	elsif clk'event and clk='0' then
		clk1 <= clk1 + 1;
	end if;
end process;


-- Señal de Referencia 
process (SinReb,rst,Listo,alto)
begin
	if rst='1' or alto='1' then 
		ref <= '0';
	elsif SinReb'event and SinReb='1' and Listo='1' then  
	   ref <= not ref;
	end if;
end process;


-- Contador de pulsos de 1ms en una vuelta
process (clk1(15),rst,ref)
begin
	if rst='1' or ref='0' then
		cnt1 <= (others => '0');
	elsif clk1(15)'event and clk1(15)='0' and ref='1' then--cuando se inicializa clk1
		cnt1 <= cnt1 + 1 ;
	end if;	
end process;


-- Calcula el Periodo
process (ref,rst,Motor_Listo)
begin
	if rst='1' or Motor_Listo='1' then 
		Periodo <= (others => '0');
		Per_Listo <='0';
	elsif ref'event and ref='0' then
	   Periodo <= cnt1; -- hay que hacer en labview la multiplicacion: Periodo x 1ms
		Per_Listo <='1';
	end if;
end process;

com1: Antirrebote port map (clk1(15),IR,SinReb);

end Arq;

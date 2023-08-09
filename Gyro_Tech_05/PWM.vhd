----------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis Sánchez Márquez
--						Ricardo Flores Martínez
-- Asesor: 			M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	PWM
-- Descripción: 	Módulo que proporciona los diferentes PWM de prueba
-----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM is
    Port (	clk,rst,IND, rst_int: in  STD_LOGIC;
				giro: out std_logic_vector(1 downto 0);
   			sal_pwm : out std_logic);
end PWM;

architecture Arq of PWM is


signal cnt: std_logic_vector (12 downto 0);
signal aux, a: std_logic_vector (11 downto 0);
signal clk1M, alto:  std_logic; 
signal sel: std_logic_vector(4 downto 0);


begin

process (rst_int, rst)
begin
	if rst='1' then
		alto <= '0';
	elsif rst_int'event and rst_int = '0' then
		alto <= '1';
	end if;	
end process;

-- Señal de Referencia (50% ciclo útil)
process (clk,rst,cnt)
begin
	if rst='1' or cnt=X"032" then -- 20ns * 50 ciclos = referencia 1us
	   cnt <= (others => '0');
		clk1M <= '1';
		
	elsif clk'event and clk='1' then
		cnt <= cnt + 1 ;
		if cnt= X"019" then	--20ns * 25 ciclos = 1/2 Periodo
			clk1M <= '0';
		end if;
	end if;
end process;	


process (clk1M,rst,aux,a)
begin
	if rst='1' or aux=X"3E8" then  -- Tiempo (1000us) x064=100_d 
	   aux <= (others => '0');
		sal_pwm <= '1';
	elsif clk1M'event and clk1M='1' then
		aux <= aux + 1 ;
		if aux = a then
			sal_pwm <= '0';
		end if;
	end if;
end process;

--Detecta la señal IND de la maquina de estados para incrementar el contador "sel"
process(rst,IND,alto)
begin
	if rst='1' or alto='1' then
		sel <= (others => '0');
	elsif IND'event and IND ='1' then
		sel <= sel+1;
	end if;
end process;

--"Seleccona" el %CU del PWM
process (clk1M,rst,alto)
	begin
		if rst ='1' or alto='1' then
			a <= x"012";		--valor con el que inicia al resetear
			giro <= "01";
		elsif clk1M'event and clk1M ='1' then
			
			if sel="01011" then--Si ya llegó a la velocidad máxima entonces cambia el sentido de giro
				giro<="10";			
			end if;
			
			case(sel) is
				--Aumentando el PWM
				when "00000" => a <= x"012";--pwm
				when "00001" => a <= x"03E";--pwm63us
				when "00010" => a <= x"04F";--pwm80us
				when "00011" => a <= x"063";--pwm100us
				when "00100" => a <= x"077";--pwm120us
				when "00101" => a <= x"08B";--pwm140us
				when "00110" => a <= x"09F";--pwm160us
				when "00111" => a <= x"0B3";--pwm180us
				when "01000" => a <= x"0C7";--pwm200us
				when "01001" => a <= x"0DB";--pwm220us
				when "01010" => a <= x"0F6";--pwm247us
				--Decrementando el PWM
				when "01011" => a <= x"0F6";--pwm247us
				when "01100" => a <= x"0DB";--pwm220us
				when "01101" => a <= x"0C7";--pwm200us
				when "01110" => a <= x"0B3";--pwm180us
				when "01111" => a <= x"09F";--pwm160us
				when "10000" => a <= x"08B";--pwm140us
				when "10001" => a <= x"077";--pwm120us
				when "10010" => a <= x"063";--pwm100us
				when "10011" => a <= x"04F";--pwm80us
				when "10100" => a <= x"03E";--pwm63us
				when others => null;
			end case;
		end if;
end process;

end Arq;
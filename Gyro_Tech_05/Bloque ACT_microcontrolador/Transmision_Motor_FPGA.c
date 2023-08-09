#define F_CPU 4000000UL
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>


void init_ADC(void);
void init_USART(void);
void TX_USART(unsigned long int MS, unsigned long int LS);

unsigned int contador=0;


//	Prom_Temp_LS: Se almacena el promedio de los bits menos significativos de la temperatura
//	Prom_Temp_MS: Se almacena el promedio de los bits más significativos de la temperatura


//	Prom_w_LS: Se almacena el promedio de los bits menos significativos de la velocidad angular (w)
//	Prom_w_MS: Se almacena el promedio de los bits más significativos de la velocidad angular (w)


int main(void)
	{

		unsigned long int Temp=0;
		unsigned long int Prom_Temp=0;
		unsigned long int Prom_Temp_LS=0;
		unsigned long int Prom_Temp_MS=0;

		unsigned long int w=0;
		unsigned long int Prom_w=0;
		unsigned long int Prom_w_LS=0;
		unsigned long int Prom_w_MS=0;



		init_ADC();
		init_USART();

		do{
			
			contador=0;
			Temp=0;
			Prom_Temp=0;
			Prom_Temp_LS=0;
			Prom_Temp_MS=0;
			w=0;
			Prom_w=0;
			Prom_w_LS=0;
			Prom_w_MS=0;

			do{
					
					
					if(contador==0)				//Se coloca por un problema al simplemente seleccionar ADMUX=Canal este problema lo vi ben simulación
						ADMUX |= 0x05;
					else
						ADMUX |= _BV(MUX0); 	//Enciende el bit MUX0 (Selección del canal 5)
					
					ADCSRA |= _BV(ADSC);		//Inicia la conversión
					
					
					loop_until_bit_is_set(ADCSRA,ADIF);
						
					ADCSRA |= _BV(ADIF);		//a ADCSRA asignale lo que ya contiene y además borra al bit ADIF

										
					w = w + ADC;			
										
					
					/****** Se repite para el canal 4 ********/										
					ADMUX &= ~(_BV(MUX0));		// Borra el bit MUX0 de ADMUX (Selección canal 4)
					ADCSRA |= _BV(ADSC);		//Inicia la conversión

					loop_until_bit_is_set(ADCSRA,ADIF);
					
					ADCSRA |= _BV(ADIF);
					
					Temp = Temp + ADC;				
					
					contador = contador + 1;

				}while(contador<16);		//ciclo para las 16 mediciones de ambos canales
				
		    
		
			Prom_w = w/16;

			// Separando en dos bytes
			Prom_w_MS = Prom_w/256;
			Prom_w_LS = Prom_w%256;
			
			_delay_ms(301);				//Retardo que servirá para para saber cuándo inicia la trama (sincronizar Transmisor y Receptor)
			
			TX_USART(Prom_w_MS,Prom_w_LS);			

			Prom_Temp = Temp/16;

			// Separando en dos bytes
			Prom_Temp_MS = Prom_Temp/256;
			Prom_Temp_LS = Prom_Temp%256;	
					
			TX_USART(Prom_Temp_MS,Prom_Temp_LS);			
			
		}while(1); //ciclo infinito


	}//Fin del main()

void init_ADC() 
	{
		DDRC = 0x00; //Para los canales ADC4 y ADC5 entradas
		DDRD=0xFF;
		ADCSRB = 0x00;
		ADCSRA = _BV(ADEN)|_BV(ADPS2)|_BV(ADPS0); //Modo conversión simple
		//125 kHZ @4 MHZ
		ADMUX=_BV(REFS0);
		PORTD = 0x01;
	}


void init_USART(void)
	{
		UBRR0L=25;			//Configura USART para
		UCSR0B=_BV(TXEN0);	//baud rate 9600 a 4 Mhz
		UCSR0C=(3<<UCSZ00); //Asíncrona, Pariedad desactivada, 1 bits de parada, 8 bits de datos
	
	}


	
	void TX_USART(unsigned long int MS, unsigned long int LS)
	{
		
		loop_until_bit_is_set(UCSR0A,UDRE0); //Espera que el buffer de transmision este vacio
		
		UDR0=MS;   // Envia dato
		loop_until_bit_is_set(UCSR0A,UDRE0);
				
		UDR0=LS;
		loop_until_bit_is_set(UCSR0A,UDRE0);
		
	}
	
	
	
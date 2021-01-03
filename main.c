#include "stm32f10x.h"

uint32_t APB2ENR;

int main(void)
{
	//Structure to hold configuration for PORTA
	GPIO_InitTypeDef PortA_config;

	//Enable GPIOA peripheral
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	
	//Configure PORTA, pin PA8
	PortA_config.GPIO_Pin = GPIO_Pin_8;
	PortA_config.GPIO_Speed = GPIO_Speed_2MHz;
	PortA_config.GPIO_Mode = GPIO_Mode_Out_PP;
	
	GPIO_Init(GPIOA, &PortA_config);
	
	//Set pin 8 on PORTA high
	GPIO_SetBits(GPIOA, GPIO_Pin_8);	

	while(1){}
}




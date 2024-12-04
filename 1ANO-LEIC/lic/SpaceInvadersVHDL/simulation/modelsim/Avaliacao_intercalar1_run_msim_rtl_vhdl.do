transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/uni/LEIC 2 ANO/2semestre/LIC/TUDO_Funciona_(1.0)[1]/TUDO Funciona (1.0)/FFD.vhd}
vcom -93 -work work {C:/uni/LEIC 2 ANO/2semestre/LIC/TUDO_Funciona_(1.0)[1]/TUDO Funciona (1.0)/Shift_Register_7bits.vhd}


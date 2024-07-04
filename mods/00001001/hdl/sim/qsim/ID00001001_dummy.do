onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -label clk /ID00001001_dummyTb/clk
add wave -noupdate -label reset /ID00001001_dummyTb/rst_a

add wave -noupdate -divider {Interface}
add wave -noupdate -label DIN -radix hexadecimal -radixshowbase 0 /ID00001001_dummyTb/data_in
add wave -noupdate -label DOUT -radix hexadecimal -radixshowbase 0 /ID00001001_dummyTb/data_out
add wave -noupdate -label CONF -radix hexadecimal -radixshowbase 0 /ID00001001_dummyTb/conf_dbus
add wave -noupdate -label RD /ID00001001_dummyTb/read
add wave -noupdate -label WR /ID00001001_dummyTb/write
add wave -noupdate -label ST /ID00001001_dummyTb/start
add wave -noupdate -label INT /ID00001001_dummyTb/int_req

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {135 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 221
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {127 ps} {147 ps}
run -all

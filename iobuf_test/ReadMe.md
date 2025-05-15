# IOBUF

I found Xilinx Desription of the IOBUF ip to be fairly confusing.
You can find it [here](https://docs.amd.com/r/en-US/ug953-vivado-7series-libraries/IOBUF).
This folder contains a small test model to check how it behaves.

![IOBUF Waveform View](Wave.png)

What the Waveform reveals it the IOBUF behavior for tristate signal high and low. 
If tristate is high, w_in and w_out are high impedance than the out pin of the IOBUF follows the io pin.

If tristate is low, o and io are high impedance than the io pin of the IOBUF follows the i pin.



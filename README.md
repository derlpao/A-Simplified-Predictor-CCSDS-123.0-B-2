The entropy encoding section includes 12 codebooks, a codebook selector, and an encode module. 
Data is input to the compression core via the AXI-S protocol from the host system, 
where it is parsed into the data stream required by the compression core. 
The data undergoes prediction, weight update, encoding selection, Golomb-Rice encoding/low-entropy encoding, 
and statistical coding to form a code stream. 
The data is then packed into 64-bit groups and output via the AXI-S protocol.

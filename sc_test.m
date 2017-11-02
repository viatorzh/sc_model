clear all ;

fs = 80000000 ;
T = 1/fs ;
t = 0:1/fs:0.01 ;
fi = 324000 ;
fi = 2000000 ;
phase = 0.25 * pi ;
s = sin(2*pi*fi*t + phase) + 0.001*randn(size(t));
fm = fi + 1000 ;
mix_sin = sin(2*pi*fm*t) ;
mix_cos = cos(2*pi*fm*t) ;
data_a_mix = s .* mix_sin ;
data_b_mix = s .* mix_cos ;
L = length(s) ;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y 
z = fft(data_a_mix) ;
ff = fs/2*linspace(0,1,NFFT/2);
plot(ff,abs(z(1:NFFT/2))) 

D = 20; % decimation factor 
% N = D ; % delay buffer depth
%delayBuffer = zeros(1,N/D); 
delayBuffer0 = 0 ;
delayBuffer1 = 0 ;
delayBuffer2 = 0 ;
delayBuffer3 = 0 ;
delayBuffer4 = 0 ;
intOut0 = 0; 
intOut1 = 0; 
intOut2 = 0; 
intOut3 = 0; 
intOut4 = 0; 
combOut0 = 0 ;
combOut1 = 0 ;
combOut2 = 0 ;
combOut3 = 0 ;
combOut4 = 0 ;

cic_a_out = [] ;

for ii = 1:length(data_a_mix) 
% integrator 
intOut0 = intOut0 + data_a_mix(ii);
intOut1 = intOut0 + intOut1 ;
if mod(ii,D)==1 
% comb section 
combOut4 = combOut3 - delayBuffer4 ;
delayBuffer4 = combOut4 ;
combOut3 = combOut2 - delayBuffer3 ;
delayBuffer3 = combOut3 ;
combOut2 = combOut1 - delayBuffer2 ;
delayBuffer2 = combOut2 ;
combOut1 = combOut0 - delayBuffer1 ;
delayBuffer1 = combOut1 ;
combOut0 = intOut4 - delayBuffer0; 
delayBuffer0 = combOut0 ;

cic_a_out = [cic_a_out combOut4] ;
end
end
figure ;

L = length(cic_a_out) ;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y 
z = fft(cic_a_out) ;
ff = fs/D/2*linspace(0,1,NFFT/2);
plot(ff,abs(z(1:NFFT/2))) 



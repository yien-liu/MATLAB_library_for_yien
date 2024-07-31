% FFT_copy_material

ydata=readmatrix("name.csv");
y=ydata(:,2);
A=abs(fft(y))/(length(y)/2);
A(1)=A(1)/2;
P=angle(fft(y));
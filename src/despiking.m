function Sdes=despiking(S);

dS=[0;diff(S)];
M=median(dS);
MAD=median(abs(dS-M));
Zt=0.6745*(dS-M)/MAD;
Zt=abs(Zt);
tau=10*median(Zt);
Ind=double(Zt<tau);
len=1;
while min(medfilt1(Ind,2*len+1))<=0;
    len=len+1;
end
w=medfilt1(Ind,2*len+1);
Sdes=medfilt1(S.*Ind,2*len+1)./w;
Sout=S;
Sout(Ind==0)=Sdes(Ind==0);
$offsymxref
$offsymlist
option limrow=0;
option limcol=0;
option sysout=off;
option solprint=on;
option optcr=0;

POSITIVE VARIABLES
         xA,xA1,xA4
         xB,xB1,xB2,xB3,xB4
         xC,xC2,xC3,xCcaro,xCbarato
         Cb,Cb1,Cb4
         Cc,Cc2,Cc3
         ;

BINARY VARIABLES
         y1 variables bianria asociada a Y1
         y2 variables bianria asociada a Y2
         y3 variables bianria asociada a Y3
         y4 variables bianria asociada a Y4

VARIABLES
         z valor de la funcion objetivo a minimizar
         ;

EQUATIONS
         fo
         ec0

         Rest1
         disg1,disg2,disg3
         ec1,ec2,ec3
         lim1,lim2

         Rest2
         disg4,disg5,disg6
         ec4,ec5,ec6,ec7
         lim3,lim4

         ;

fo..     z =e= 1800*xCcaro+1500*xCbarato-Cb-Cc;
ec0..    xC =e= xCcaro+xCbarato;

Rest1..  y1+y4 =g= 1;
disg1..  xB =e= xB1+xB4;
disg2..  xA =e= xA1+xA4;
disg3..  Cb =e= Cb1+Cb4;
ec1..    xB1 =e= xA1*0.9;
ec2..    Cb1 =e= 1000*y1+xA1*250+500*xA1;
ec3..    Cb4 =e= xB4*950;
lim1..   xA1 =l= 16*y1;
lim2..   xB4 =l= (15/0.82)*y4;

Rest2..  y2+y3 =e= 1;
disg4..  xB =e= xB2+xB3;
disg5..  xC =e= xC2+xC3;
disg6..  Cc =e= Cc2+Cc3;
ec4..    xC2 =e= 0.82*xB2;
ec5..    Cc2 =e= 1500*y2+400*xB2;
ec6..    xC3 =e= xB3*0.95;
ec7..    Cc3 =e= 2000*y3+xB3*550;
lim3..   xC2 =l= 15*y2;
lim4..   xC3 =l= 15*y3;

xA.up=16;
xC.up=15;

xCcaro.up=10;
         ;

MODEL P3b /all/;

SOLVE P3b using MINLP maximize z;

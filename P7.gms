$offsymxref
$offsymlist
option limrow=0;
option limcol=0;
option sysout=off;
option solprint=on;
option optcr=0;
option MINLP=Sbb

SETS
         i etapa /1*15/;

SCALAR
         M valor de la M grande
         /100/
         Cetap coste de una etapa en euros por h
         /50/
         k constante de equilibrio
         /0.8/
         Pext precio de extractante en euros por kmol
         /10/
         Ro caudal molar de agua en Ro
         /100/
         Ros caudal molar de soluto en Ro
         /1/
         xmax
         /0.0001/
         ;

BINARY VARIABLES
         y(i) variable binaria asociada a la existencia o no de la etapa j
         ;

POSITIVE VARIABLE
         R(i) caudal molar de soluto en la etapa i
         xR(i) fraccion molar de soluto en la corriente R(i)
         E(i) caudal molar de soluto en la etapa i
         xE(i) fraccion molar de soluto en la corriente E(i)
         C(i) coste etapa i
         Eo caudal de disolvente
         ;

VARIABLE
         z valor de la función ojetivo a minimizar
         ;

EQUATIONS
         fo
         rest
         ec1,ec2,ec3,ec4,ec5,ec6,ec7,ec8,ec9,ec10
         bm1,bm15,bm
         ;

fo..     z =e= Pext*Eo+sum(i,C(i));

*Restricciones:
*1 --> etapa 1 existe
*2 --> si existe etapa i debe existir etapa i-1

rest(i)$(ord(i) gt 1).. (1-y(i))+y(i-1) =g= 1;

*M grande a cada disyunción
ec1(i).. C(i)-Cetap =g= -M*(1-y(i));
ec2(i).. C(i)-Cetap =l= M*(1-y(i));

ec3(i).. xE(i)-k*xR(i) =g= -M*(1-y(i));
ec4(i).. xE(i)-k*xR(i) =l= M*(1-y(i));
ec5(i).. xE(i)*(E(i)+Eo) =e= E(i);
ec6(i).. xR(i)*(R(i)+Ro) =e= R(i);

ec7(i).. R(i)-R(i-1) =g= -M*y(i);
ec8(i).. R(i)-R(i-1) =l= M*y(i);
ec9(i).. E(i)-E(i+1) =g= -M*y(i);
ec10(i)..E(i)-E(i+1) =l= M*y(i);

*Balances de materia
bm1..    Ros+E('2') =e= R('1')+E('1');
bm15..   R('14') =e= R('15')+E('15');
bm(i)$(ord(i) ge 2 and ord(i) le 14).. R(i-1)+E(i+1) =e= R(i)+E(i);
*'ge' es mayor o igual y 'le' es menor o igual
*Concentración de soluto admitida en la salida de R

*LIMITES
*del problema
xR.up('15')=xmax;
y.fx('1')=1;
*para ayudar a que converja
*E.lo(i)=0.000000001;
*R.lo(i)=0.000000001;
*Eo.lo=0.000001;
*R.up(i)=1;

MODEL P7 /all/;

SOLVE P7 using MINLP minimize z;






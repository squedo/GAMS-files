$offsymxref
$offsymlist
option limrow=0;
option limcol=0;
option sysout=off;
option solprint=on;
option optcr=0;

SETS
         i reactor /r1*r8/
         k bypass /1*4/
         j componente /A,B,C/
         ;

SCALAR
         PventB Precio de venta del producto B en la corriente de salida P
         /100/
         PenA Penalización por la presencia de A en la corriente de salida P
         /10/
         PenC Penalización por la presencia de C en la corriente de salida P
         /20/
         ;

PARAMETERS
         tau(i) tiempo de residencia en h
         /r1=0.1,r2=0.4,r3=0.1,r4=0.2,r5=0.7,r6=0.2,r7=0.9,r8=0.5/
         Cf1(i)
         /r1=10,r2=20,r3=50,r4=20,r5=60,r6=10,r7=50,r8=100/
         Cf2(i)
         /r1=5,r2=10,r3=25,r4=10,r5=30,r6=20,r7=25,r8=50/
         Cv1(i)
         /r1=1,r2=2,r3=1,r4=1,r5=2,r6=1,r7=3,r8=5/
         Cv2(i)
         /r1=8,r2=10,r3=9,r4=50,r5=70,r6=10,r7=15,r8=10/
         F(j) flujo molar de componente j que llega con el alimento
         /A=10,B=0,C=0/
         xalim(j) composición del alimento
         /A=1,B=0,C=0/
         ;


BINARY VARIABLE
         y(i) variable binaria asociada a la existencia del reactor i
         w1(i),w2(i)
         zb(k) variable binaria asociada a la existencia del bypass k
         ;

POSITIVE VARIABLE
         E(i,j) flujo molar de componente j que entra al reactor i
         E1(i,j),E2(i,j)
         S(i,j) flujo molar de componente j que sale del reactor i
         P(j) flujo molar de componente j en la corriente P
         By(k,j) flujo molar de componente j en el bypass k
         C(i) coste del reactor i
         C1(i),C2(i)
         ;

VARIABLE
         z valor de la función ojetivo a maximizar
         ;

EQUATIONS
         fo
         rest1,rest2,rest3,rest4,rest5
         r1,r2,r3
         ec1,ec2,ec3,ec4,ec5,ec6,ec7,ec8,ec9,ec10
         bm1,bm2,bm3,bm4,bm5
         ;

*FO y RESTRICCIONES
fo..     z =e= P('B')*PventB-P('A')*PenA-P('C')*PenC-sum(i,C(i));

rest1..  y('r1')+y('r2')+zb('1') =e= 1;
rest2..  y('r3')+y('r4')+y('r5')+zb('2') =e= 1;
rest3..  y('r6')+y('r7')+zb('3') =e= 1;
rest4..  y('r8')+zb('4') =e= 1;

rest5(i)..  w1(i)+w2(i) =e= y(i);

*REACTORES y BYPASS
r1(i)..  S(i,'A') =e= E(i,'A')*exp(-tau(i));
r2(i)..  S(i,'B') =e= (E(i,'A')*tau(i)+E(i,'B'))*exp(-tau(i));
r3(i)..  S(i,'C') =e= E(i,'C')+(E(i,'A')-S(i,'A'))-(S(i,'B')-E(i,'B'));

*envolvente convexa de las disyunciones de los reactores en los tramos 1 y 2 de costes
ec1(i)..  E(i,'A') =e= E1(i,'A')+E2(i,'A');
ec2(i)..  C(i) =e= C1(i)+C2(i);

ec3(i)..  C1(i) =e= Cf1(i)*w1(i)+Cv1(i)*E1(i,'A');
ec4(i)..  E1(i,'A') =l= 7*w1(i);

ec5(i)..  C2(i) =e= Cf2(i)*w2(i)+Cv2(i)*E2(i,'A');
ec6(i)..  E2(i,'A') =g= 7*w2(i);
ec7(i)..  E2(i,'A') =l= 10*w2(i);

*envolvente convexa en los reactores
ec8(i)..  E(i,'B') =l= 10*y(i);

*envolvente convexa de las disyunciones de los bypass
ec9(k)..  By(k,'A') =l= 10*zb(k);
ec10(k).. By(k,'B') =l= 10*zb(k);


*BALANCES DE MATERIA EN LOS NODOS

*nodo1 (divisor)  pero como quiero problema lineal, y ademas no quiero obligar
*a que tenga q coger uno de los reactores, no hace falta que haga lo de las
*igualdad de las fracciones molares
bm1(j).. F(j) =e= E('r1',j)+E('r2',j)+By('1',j);
*nodo2 (mezclador)
bm2(j).. S('r1',j)+S('r2',j)+By('1',j) =e= E('r3',j)+E('r4',j)+E('r5',j)+By('2',j);
*nodo3 (mezclador)
bm3(j).. S('r3',j)+S('r4',j)+S('r5',j)+By('2',j) =e= E('r6',j)+E('r7',j)+By('3',j);
*nodo4 (mezclador)
bm4(j).. S('r6',j)+S('r7',j)+By('3',j) =e= E('r8',j)+By('4',j);
*nodo5 (mezclador)
bm5(j).. S('r8',j)+By('4',j) =e= P(j);

MODEL P9 /all/;

SOLVE P9 using MIP maximize z;



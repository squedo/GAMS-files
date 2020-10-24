$offsymxref
$offsymlist
option limrow=0;
option limcol=0;
option sysout=off;
option solprint=on;
option optcr=0;

SETS
         i módulo /m1*m3/
         t tipo /t1*t4/
         j componentes /A,B/
         ;

SCALAR
         Falim
         /100/
         ;

PARAMETERS
         Cf(t)
         /t1=100,t2=90,t3=80,t4=70/
         Cv(t)
         /t1=30,t2=15,t3=9,t4=9/
         alfaA(t)
         /t1=0.95,t2=0.90,t3=0.85,t4=0.80/
         alfaB(t)
         /t1=0.3,t2=0.4,t3=0.5,t4=0.6/
         xalim(j)
         /A=0.4,B=0.6/
         Fmax(j)
         /A=200,B=200/
         ;

BINARY VARIABLES
         y(i) variable binaria asociada a la existencia del modulo i
         w(i,t) variable asociada a la existencia del tipo t cuando se usa el modulo i
         yb21,yb22
         yb31,yb32
         yr21,yr22
         yr31,yr32
         ;

POSITIVE VARIABLES
         F(i,j),FF(i,t,j)
         D(i,j),DD(i,t,j)
         P(i,j)
         BY2(j),BY3(j)
         PY2(j),PY3(j)
         R2(j),R3(j)
         S1(j),S2(j)
         C(i),Cst(i,t)
         ;

VARIABLES
         z valor de la funcion objetivo a maximizar
         ;

EQUATIONS
         fo
         rest1,rest2,rest3,rest4,rest5
         ec1,ec2,ec3,ec4,ec5,ec6,ec7,ec8,ec9,ec10,ec11,ec12,ec13,ec14,ec15,ec16
         bm1,bm2,bm3,bm4,bm5,bm6,bm7,bm8
         ;

*FO y RESTRICCIONES
fo..       z =e= 100*(S1('A')+S2('B'))-50*(S1('B')+S2('A'))-sum(i,C(i));

rest1(i).. sum(t,w(i,t))=e= y(i);

rest2..    yb21+yb22 =e= 1;
rest3..    yb31+yb32 =e= 1;
rest4..    yr21+yr22 =e= 1;
rest5..    yr31+yr32 =e= 1;

*DISYUNCIONES
ec1(i)..   C(i) =e= sum(t,Cst(i,t));
ec2(i,j).. D(i,j) =e= sum(t,DD(i,t,j));
ec3(i,j).. F(i,j) =e= sum(t,FF(i,t,j));

ec4(i,t).. Cst(i,t) =e= Cf(t)*w(i,t)+Cv(t)*DD(i,t,'A');
ec5(i,t).. DD(i,t,'A') =e= alfaA(t)*FF(i,t,'A');
ec6(i,t).. DD(i,t,'B') =e= alfaB(t)*FF(i,t,'B');
ec7(i,t).. FF(i,t,'A') =l= Fmax('A')*w(i,t);
ec8(i,t).. FF(i,t,'B') =l= Fmax('B')*w(i,t);

ec9(j)..   BY2(j) =l= Fmax(j)*yb21;
ec10(j)..  F('m2',j) =l= Fmax(j)*yb22;
ec11(j)..  BY3(j) =l= Fmax(j)*yb31;
ec12(j)..  F('m3',j) =l= Fmax(j)*yb32;

ec13(j)..  R2(j) =l= Fmax(j)*yr21;
ec14(j)..  PY2(j) =l= Fmax(j)*yr22;
ec15(j)..  R3(j) =l= Fmax(j)*yr31;
ec16(j)..  PY3(j) =l= Fmax(j)*yr32;

*BALANCES de MATERIA
*nodo1
bm1(j)..   Falim*xalim(j)+R2(j) =e= F('m1',j);
*nodo2
bm2(j)..   D('m1',j)+R3(j) =e= F('m2',j)+BY2(j);
*nodo3
bm3(j)..   D('m2',j) =e= F('m3',j)+BY3(j);
*nodo4
bm4(j)..   P('m2',j) =e= R2(j)+PY2(j);
*nodo5
bm5(j)..   P('m3',j) =e= R3(j)+PY3(j);
*nodo6
bm6(j)..   S1(j) =e= D('m3',j)+BY2(j)+BY3(j);
*nodo7
bm7(j)..   S2(j) =e= P('m1',j)+PY2(j)+PY3(j);
*BM en los modulos
bm8(i,j).. F(i,j) =e= D(i,j)+P(i,j);

MODEL P10 /all/;

SOLVE P10 using MIP maximize z;

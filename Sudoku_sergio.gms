$offsymxref
$offsymlist
option limrow=0;
option limcol=0;
option sysout=off;
option solprint=on;
option optcr=0;

SETS
         i filas /1*9/
         j columnas /1*9/
         k valor celda/1*9/
         ;

PARAMETERS
         numero(k)
         /1=1,2=2,3=3,4=4,5=5,6=6,7=7,8=8,9=9/
         ;

BINARY VARIABLES
         y(i,j,k)
         ;

VARIABLES
         z valor de la funcion objetivo a minimizar
         ;

POSITIVE VARIABLES
         a(i,j),aa(i,j,k)
         ;

EQUATIONS
         fo
         ec1,ec2,ec3
***ec4,ec5
         ec6,ec7,ec8,ec9,ec10
         ec11,ec12,ec13,ec14,ec15
         ec16,ec17,ec18,ec19,ec20
         ec21,ec22,ec23,ec24,ec25
         ;

fo..     z =e= 1;

*envolvente convexa
ec6(i,j)..  a(i,j) =e= sum(k,aa(i,j,k));
ec7(i,j,k)..aa(i,j,k) =e= numero(k)*y(i,j,k);

*en cada fila solo puede haber un mismo valor k
ec1(i,k).. sum(j,y(i,j,k)) =e= 1;
*en cada columna solo puede haber un mismo valor k
ec2(j,k).. sum(i,y(i,j,k)) =e= 1;
*en cada celda solo puedo tener un valor k
ec3(i,j).. sum(k,y(i,j,k)) =e= 1;

*sumando los valores en cada fila la suma debe ser 1+2+3+4+5+6+7+8+9=45
***ec4(i)..   sum(j,a(i,j)) =e= 45;
*sumando los valores en cada columna la suma debe ser 1+2+3+4+5+6+7+8+9=45
***ec5(j)..   sum(i,a(i,j)) =e= 45;

*En cada submatriz 3x3 debe cumplirse
*1--> la suma de los valores debe ser 1+2+3+4+5+6+7+8+9=45
*2--> solo puede tenerse un valor k
*Submatriz 1
ec8..       a('1','1')+a('2','1')+a('3','1')+a('1','2')+a('2','2')+a('3','2')+a('1','3')+a('2','3')+a('3','3') =e= 45;
ec9(k)..    y('1','1',k)+y('2','1',k)+y('3','1',k)+y('1','2',k)+y('2','2',k)+y('3','2',k)+y('1','3',k)+y('2','3',k)+y('3','3',k) =e= 1;

*Submatriz 2
ec10..      a('1','4')+a('1','5')+a('1','6')+a('2','4')+a('2','5')+a('2','6')+a('3','4')+a('3','5')+a('3','6') =e= 45;
ec11(k)..   y('1','4',k)+y('1','5',k)+y('1','6',k)+y('2','4',k)+y('2','5',k)+y('2','6',k)+y('3','4',k)+y('3','5',k)+y('3','6',k) =e= 1;

*Submatriz 3
ec12..      a('1','7')+a('1','8')+a('1','9')+a('2','7')+a('2','8')+a('2','9')+a('3','7')+a('3','8')+a('3','9') =e= 45;
ec13(k)..   y('1','7',k)+y('1','8',k)+y('1','9',k)+y('2','7',k)+y('2','8',k)+y('2','9',k)+y('3','7',k)+y('3','8',k)+y('3','9',k) =e= 1;

*Submatriz 4
ec14..      a('4','1')+a('5','1')+a('6','1')+a('4','2')+a('5','2')+a('6','2')+a('4','3')+a('5','3')+a('6','3') =e= 45;
ec15(k)..   y('4','1',k)+y('5','1',k)+y('6','1',k)+y('4','2',k)+y('5','2',k)+y('6','2',k)+y('4','3',k)+y('5','3',k)+y('6','3',k) =e= 1;

*Submatriz 5
ec16..      a('4','4')+a('5','4')+a('6','4')+a('4','5')+a('5','5')+a('6','5')+a('4','6')+a('5','6')+a('6','6') =e= 45;
ec17(k)..   y('4','4',k)+y('5','4',k)+y('6','4',k)+y('4','5',k)+y('5','5',k)+y('6','5',k)+y('4','6',k)+y('5','6',k)+y('6','6',k) =e= 1;

*Submatriz 6
ec18..      a('4','7')+a('5','7')+a('6','7')+a('4','8')+a('5','8')+a('6','8')+a('4','9')+a('5','9')+a('6','9') =e= 45;
ec19(k)..   y('4','7',k)+y('5','7',k)+y('6','7',k)+y('4','8',k)+y('5','8',k)+y('6','8',k)+y('4','9',k)+y('5','9',k)+y('6','9',k) =e= 1;

*Submatriz 7
ec20..      a('7','1')+a('8','1')+a('9','1')+a('7','2')+a('8','2')+a('9','2')+a('7','3')+a('8','3')+a('9','3') =e= 45;
ec21(k)..   y('7','1',k)+y('8','1',k)+y('9','1',k)+y('7','2',k)+y('8','2',k)+y('9','2',k)+y('7','3',k)+y('8','3',k)+y('9','3',k) =e= 1;

*Submatriz 8
ec22..      a('7','4')+a('8','4')+a('9','4')+a('7','5')+a('8','5')+a('9','5')+a('7','6')+a('8','6')+a('9','6') =e= 45;
ec23(k)..   y('7','4',k)+y('8','4',k)+y('9','4',k)+y('7','5',k)+y('8','5',k)+y('9','5',k)+y('7','6',k)+y('8','6',k)+y('9','6',k) =e= 1;

*Submatriz 9
ec24..      a('7','7')+a('8','7')+a('9','7')+a('7','8')+a('8','8')+a('9','8')+a('7','9')+a('8','9')+a('9','9') =e= 45;
ec25(k)..   y('7','7',k)+y('8','7',k)+y('9','7',k)+y('7','8',k)+y('8','8',k)+y('9','8',k)+y('7','9',k)+y('8','9',k)+y('9','9',k) =e= 1;


$ontext
*Valores de inicio del sudoku en cuestion: sudoku buscado en una pagina de internet

. . .  . . 6  7 . 5
5 . .  4 7 .  2 . .
7 2 .  . . .  8 4 6

8 . .  . 6 .  4 . .
. 5 3  9 . 8  6 . .
. . .  . 2 4  . . 8

. . 7  3 . .  5 . .
6 . .  . 5 .  . 2 7
. 3 .  . . .  . . .

Fijo las binarias necesarias para tener los valores de inicio del sudoku.
$offtext

y.fx('1','6','6')=1;
y.fx('1','7','7')=1;
y.fx('1','9','5')=1;

y.fx('2','1','5')=1;
y.fx('2','4','4')=1;
y.fx('2','5','7')=1;
y.fx('2','7','2')=1;

y.fx('3','1','7')=1;
y.fx('3','2','2')=1;
y.fx('3','7','8')=1;
y.fx('3','8','4')=1;
y.fx('3','9','6')=1;

y.fx('4','1','8')=1;
y.fx('4','5','6')=1;
y.fx('4','7','4')=1;

y.fx('5','2','5')=1;
y.fx('5','3','3')=1;
y.fx('5','4','9')=1;
y.fx('5','6','8')=1;
y.fx('5','7','6')=1;

y.fx('6','5','2')=1;
y.fx('6','6','4')=1;
y.fx('6','9','8')=1;

y.fx('7','3','7')=1;
y.fx('7','4','3')=1;
y.fx('7','7','5')=1;

y.fx('8','1','6')=1;
y.fx('8','5','5')=1;
y.fx('8','8','2')=1;
y.fx('8','9','7')=1;

y.fx('9','2','3')=1;

MODEL sudoku /all/;

SOLVE sudoku using MIP minimize z;


*******************
PARAMETER
Solucion(i,j);
Solucion(i,j) = a.l(i,j);

display Solucion;
*******************





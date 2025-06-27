{
   1. Archivos Secuenciales
Una empresa que comercializa fármacos recibe de cada una de sus 30 sucursales un resumen 
mensual de las ventas y desea analizar la información para la toma de futuras decisiones.
El formato de los archivos que recibe la empresa es: cod_farmaco, nombre, fecha, cantidad_vendida, 
forma_pago (campo String indicando contado o tarjeta).
• Los archivos de ventas están ordenados por: cod_farmaco y fecha.
Cada sucursal puede vender cero, uno o más veces determinado fármaco el mismo día, y la forma de 
pago podría variar en cada venta. Realizar los siguientes procedimientos:
.a) Recibe los 30 archivos de ventas e informa por pantalla el fármaco con mayor cantidad_vendida.
→ Recibe los 30 archivos de ventas e informa por pantalla la fecha en la que se produjeron más
ventas al contado mostrando fecha y cantidad de pagos contado.
c) Recibe los 30 archivos de ventas y guarda en un archivo de texto un resumen de ventas por fecha y 
fármaco con el siguiente formato: cod_farmaco, nombre, fecha, cantidad_total_vendida. (el archivo de 
exto deberá estar organizado de manera tal que al tener que utilizarlo pueda recorrer el archivo 
realizando la menor cantidad de lecturas posibles). Nota: en el archivo de texto por fecha, cada 
fármaco aparecerá a lo sumo una vez. Además de escribir cada procedimiento deberá declarar
las estructuras de datos utilizadas.
   
   
   
}
// 30 sucursales


program parcial6;

const
	//DF=30;
	DF=2;
	valoralto=9999;
type
	cadena=string[30];
	subRango=1..DF;

	infoDetalle=record
		codigo:integer;
		nombre:cadena;
		fecha:cadena;
		cantidad:integer;
		forma_pago:cadena;
	end;
	
	detalle=file of infoDetalle;
	vecDetalles=array[subRango] of detalle;
	vecRegistros=array[subRango] of infoDetalle;
	
	//orden de los archivos es por cod_farmaco y fecha
	
	//A) recibir los 30 archivos y decir el farmaco con mayor cantidad vendida
	//B) la fecha en que se produjeron mas ventas al contado (mostrar fecha y cantidad de pagos contado)
	//C) guardar en un .txt un resumen formato (cod_farmaco, nomnre, fecha,cantidad_total_vendida)
	
//PROCEDIMIENTO DE LEER 
procedure leer(var det:detalle; var info:infoDetalle);
begin
	if (not eof(det)) then
		read(det,info)
	else
		info.codigo:=valoralto;	
end;

procedure minimo(var vec:vecDetalles; var vecR:vecRegistros;var min:infoDetalle);
var
	i, pos:subRango;
begin
	min.codigo:=valoralto;
	min.fecha:='zzz';
	
	for i:=1 to DF do 
		if((vecR[i].codigo<min.codigo) or (vecR[i].codigo=min.codigo) and (vecR[i].fecha<min.fecha)) then
			begin
				min:=vecR[i];
				pos:=i;
			end;
		if(min.codigo<> valoralto) then
			leer(vec[pos],vecR[pos]);
end;

procedure maximo1(fecha:cadena; cant:integer; var fechaMax:cadena;var max:integer);
begin
	if (cant>max) then 
		begin
			fechaMax:=fecha;
			max:=cant;
		end;
end;	

procedure maximo2(codigo:integer; cant:integer; var codMax:integer; cantMax:integer);
begin
	if (cant>cantMax) then
		begin
			codMax:=codigo;
			cantMax:=cant;
		end;
end;
procedure incisoAyByC(var v:vecDetalles; var txt:text);
var
	vecR:vecRegistros;
	min:infoDetalle;
	i:subRango;
	codigoActual,cantCodigo,cantFecha,cantContados,max1,max2,codMax:integer;
	nombreActual,fechaActual,fechaMax:cadena;
begin
	assign(txt,'informe.txt'); // abre o crea un archivo de texto llamado 'informe.txt'
	rewrite(txt);
	for i:=1 to DF do 
		begin
			reset(v[i]);   // abre el archivo 
			leer(v[i],vecR[i]);	//lee el primer registro de cada archivo de detalle y lo guarda en vecR
		end;
	minimo(v,vecR,min); // busco el menor codigo de medicamente entre todos los archivos abertos
	max1:=-1;
	max2:=-1;
	while (min.codigo<> valoralto) do  // valoralto es el fin significa que no hay mas archivos
		begin
			nombreActual:=min.nombre; 
			codigoActual:=min.codigo;
			cantCodigo:=0;
			while (codigoActual=min.codigo) do 
				begin
					fechaActual:=min.fecha;
					cantFecha:=0;
					cantContados:=0;
					while(codigoActual=min.codigo) and (fechaActual=min.fecha) do
						begin
							cantFecha:=cantFecha+ min.cantidad; //cuenta la cantidad de medicamento codigo actual se vendieron en la fecha actual
							if(min.forma_pago='Contado') then
								cantContados:=cantContados+min.cantidad; //si fueron contados se cuentan
							minimo(v,vecR,min); // vuelvo a buscar el proximo registro minimo ente todos los archivos
						end;
					writeln(txt,codigoActual,cantFecha,nombreActual); // Escribe en el archvivo de texto
					writeln(txt,fechaActual);
					maximo1(fechaActual,cantContados,fechaMax,max2); // si en esa fecha se tiene mas ventas al contado que max2
					cantCodigo:=cantCodigo+cantFecha; //Acumula  la cantida vendida de ese codigo de medicamento 
				end;
			maximo2(codigoActual,cantCodigo,codMax,max1); // guarda el codigo que realizo la maxima cantidad de ventas totales porque recibe como parametro cantidaCodigo
		end;
	for i:=1 to DF do // ciero los archivos 
		close(v[i]); 
	writeln('El farmaco con mayor cantidad vendida es: ', codMax);
	writeln('La fecha en la que se produjeron mas ventas al contado es: ', fechaMax,' con ', max2, 'compras. ' );
	close(txt); //cierro el txt con el resumen
end;
procedure crearUnSoloDetalle(var det:detalle);
var 
	carga:text;
	nombre:cadena;
	infoDet:infoDetalle;
begin
	writeln('ingrese la ruta del detalle') ;
	readln(nombre);
	assign(carga,nombre);
	reset(carga); 
	writeln('Ingrese un nombre para el archivo detalle');
	readln(nombre);
	assign(det,nombre);
	rewrite(det);
	while ( not eof(carga))do
		begin
			readln(carga,infoDet.codigo,infoDet.cantidad,infoDet.nombre);
			readln(carga,infoDet.fecha);
			readln(carga,infoDet.forma_pago);
			write(det,infoDet);
		end;
	writeln('Archivo binario de detalle creado');
	close(det);
end;

procedure cargarDetalles(var vec:vecDetalles);
var
	i:subRango;
begin
	for i:=1 to DF do 
		crearUnSoloDetalle(vec[i]);
end;
var 
	v:vecDetalles;
	txt:text;
	
BEGIN
	cargarDetalles(v);
	incisoAyByC(v,txt);
	
END.


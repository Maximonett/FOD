{
   1. Archivos Secuenciales
Un supermercado tiene 25 cajas que registran diariamente las ventas de productos. De cada venta se dispone:
número de ticket, código del producto y cantidad de unidades vendidas del producto.
Al finalizar el día, los archivos correspondientes a las cajas se ordenan por código de 
roducto para luego actualizar el archivo de productos. Los registros del archivo de productos 
contienen el código del producto, la descripción, la cantidad en existencia, el stock mínimo y 
el precio de venta actual. Implementar un programa que permita:
a) Dada la cantidad de cajas, actualizar la existencia de cada producto registrando la cantidad vendida en la jornada.
Tenga en cuenta que el stock no puede quedar por debajo de cero.
b) Informar aquellos productos que dispongan unidades en existencia y no hayan sido vendidos.
c) Informar aquellos productos vendidos que quedaron por debajo del stock mínimo.
d) Informar para cada código de producto, el nombre y el monto total vendido, y también informar el monto total
facturado en el día para todos los productos.
NOTA: No debe implementar el ordenamiento de los archivos. Todos los archivos deben recorrerse una única
vez
   
   
}


program parcial3;

const
	valoralto=999;
	DF=2;
	//DF=25;



type
	subRango=1..DF;
	
	producto=record
		codigoP:integer;
		descripcion:string[50];
		stockActual:integer;
		stockMin:integer;
		precioActual:real;
	end;
	
	venta=record
		numeroT:integer;
		codigoP:integer;
		cantVend:integer;
	end;
	
	arcMaestro=file of producto;
	arcDetalle=file of venta;
	vecDetalles=array[subRango] of arcDetalle;
	vecRegistros=array[subRango] of venta;
	
procedure crearMaestro(var mae: arcMaestro); // Procedimiento que crea el archivo binario maestro a partir de un archivo de texto
var 
    txt: text;                   // Variable para el archivo de texto (entrada)
    p: producto;          // Variable temporal para guardar un producto leído
begin
    assign(txt, 'maestro.txt'); // Asocia la variable 'txt' con el archivo físico 'maestro.txt'
    reset(txt);                 // Abre el archivo de texto para lectura (debe existir)

    assign(mae, 'ArchivoMaestro'); // Asocia la variable 'mae' con el archivo binario 'ArchivoMaestro'
    rewrite(mae);                  // Crea o abre el archivo binario para escritura (borra contenido previo si existía)

    while not eof(txt) do         // Mientras no se llegue al final del archivo de texto
    begin
        with p do          // Accede a los campos de la variable 'producto' sin repetir su nombre
        begin 
            readln(txt, codigoP, stockActual, stockMin, precioActual, descripcion);
            // Lee una línea del archivo de texto y guarda los datos en los campos del registro 'producto'

            write(mae, p); // Escribe el registro completo en el archivo binario maestro
        end;
    end;

    write('archivo binario maestro creado'); // Muestra mensaje por consola indicando éxito

    close(txt); // Cierra el archivo de texto
    close(mae); // Cierra el archivo binario
end;

procedure crearUnSoloDetalle(var det:arcDetalle);
var
	carga:text; 
	nombre:string;
	infoDet:venta;
begin
	write('Ingrese la ruta del detalle');
	readln(nombre);
	assign(det,nombre);
	rewrite(det);
	while(not eof(carga)) do
		begin
			with (infoDet) do 
				begin
					readln(carga,numeroT,codigoP,cantVend);
					write(det,infoDet);
				end;
		end;
	writeln('Archivo binario de detalle creado');
	close(det);
	close(carga);
end;

procedure crearDetalles(var vec:vecDetalles);
var 
	i:subRango;
begin
	for i:=1 to DF do 
		crearUnSoloDetalle(vec[i]);
end;

procedure leer(var det:arcDetalle; var r:venta);
begin
	if (not eof(det)) then
		read(det,r)
	else
		r.codigoP:=valoralto;
end;

procedure minimo(var vecDet:vecDetalles;var vecReg:vecRegistros; var min:venta);
var 
	i, pos:subRango;
begin
	min.codigoP:=valoralto;
	for i:=1 to DF do 
		if (vecReg[i].codigoP< min.codigoP) then
			begin
				min:=vecReg[i];
				pos:=i;
			end;
	if (min.codigoP<>valoralto) then 
		leer(vecDet[pos],vecReg[pos]);
end;
procedure imprimirMaestro(var mae:arcMaestro);
var
	p:producto;
begin
	while (not EOF(mae)) do 
		begin
			read(mae,p);
			write(p.codigoP, 'Stock Actual= ',p.stockActual);
		end;
	close(mae);
end;

procedure actualizarMaestro(var mae:arcMaestro;var vecDet:vecDetalles);
var
	monto,montoTotal:real;
	vecReg:vecRegistros;
	comprados:integer;
	p:producto;
	min:venta;
	i:subRango;
begin
	montoTotal:=0;
	for i:=1 to DF do 
		begin
			reset(vecDet[i]);
			leer(vecDet[i],vecReg[i]);
		end;
	reset(mae);
	minimo(vecDet,vecReg,min);
	while(min.codigoP<>valoralto) do 
		begin
			read(mae,p);
			while (p.codigoP<> min.codigoP) do 
				read(mae,p);
			monto:=0;
			comprados:=0;
			while (p.codigoP=min.codigoP) do 
				begin
					if(min.cantVend>p.stockActual) then 
						begin
							comprados:=comprados+p.stockActual;
							p.stockActual:=0;
						end
					else
						begin
							comprados:=comprados+min.cantVend;
							p.stockActual:=p.stockActual-min.cantVend;
						end;
					minimo(vecDet,vecReg,min);
				end;
			monto:=p.precioActual*comprados;
			if (p.stockActual<p.stockMin) then
				writeln(p.codigoP,'StockActual= ', p.stockActual);
			seek(mae,filepos(mae)-1);
			write(mae,p);
			montoTotal:=montoTotal+monto;
			writeln(p.codigoP,'Desc= ', p.descripcion, 'Monto= ',monto);
		end;
		close(mae);
		for i:=1 to DF do
			close(vecDet[i]);
		writeln('El monto total recaudado es: ' , montoTotal:0:2);
end;

var 
	mae:arcMaestro;
	vecDet:vecDetalles;
	
BEGIN
	crearMaestro(mae);
	crearDetalles(vecDet);
	actualizarMaestro(mae,vecDet);
	imprimirMaestro(mae);
	
END.


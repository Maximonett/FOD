{
   1. Archivos Secuenciales
Un supermercado tiene 25 cajas que registran diariamente las ventas de productos. De cada venta se dispone:
número de ticket, código del producto y cantidad de unidades vendidas del producto.
Al finalizar el día, los archivos correspondientes a las cajas se ordenan por código de 
roducto para luego actualizar el archivo de productos. Los registros del archivo de productos 
contienen el código del producto, la descripción, la cantidad en existencia, el stock mínimo y 
el precio de venta actual. Implementar un programa que permita:
a) Dada la cantidad de cajas, actualizar la existencia de cada producto registrando la 
cantidad vendida en la jornada.
Tenga en cuenta que el stock no puede quedar por debajo de cero.
b) Informar aquellos productos que dispongan unidades en existencia y no hayan sido vendidos.
c) Informar aquellos productos vendidos que quedaron por debajo del stock mínimo.
d) Informar para cada código de producto, el nombre y el monto total vendido, y también 
informar el monto total facturado en el día para todos los productos.
NOTA: No debe implementar el ordenamiento de los archivos. Todos los archivos deben recorrerse una única
vez
   
   
}

program maestroDetalles;

const
	VA=9999;
	DF=25;
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
	
	maestro=file of producto;
	detalle=file of venta;
	vecDetalles=array[subRango] of detalle;
	vecRegistros=array[subRango] of venta;
	
procedure leer(var det:detalle; var reg:venta);
begin
	if (not eof(det)) then
		read(det,reg)
	else
		reg.codigoP:=VA;
end;

procedure minimo(var vecDet:vecDetalles; var vecReg:vecRegistros;var min:venta);
var
	i,pos:subRango;
begin
	min.codigoP:=VA;
	for i:=1 to DF do begin
		if ( vecReg[i].codigoP<min.codigoP) then begin
			min:=vecReg[i];
			pos:=i;
		end;
	end;
	if (min.codigoP<>VA) then 
		leer(vecDet[pos],vecReg[pos])
end;

procedure actualizarMaestro(var mae:maestro; var vecDet:vecDetalles);
var 
  vecReg: vecRegistros;
  p: producto;
  min: venta;
  i, vendidos: integer;
  montoProd, montoTotal: real;
begin
  montoTotal := 0;

  // Inicializar registros de cada detalle
  for i := 1 to DF do begin
    reset(vecDet[i]);
    leer(vecDet[i], vecReg[i]);
  end;

  reset(mae);

  minimo(vecDet, vecReg, min);

  while min.codigoP <> VA do begin
    // Leer producto del maestro correspondiente
    read(mae, p);
    while p.codigoP <> min.codigoP do
      read(mae, p);

    vendidos := 0;

    // Acumular todas las ventas del producto
    while (min.codigoP = p.codigoP) do begin
      if min.cantVend > p.stockActual then begin
        vendidos := vendidos + p.stockActual;
        p.stockActual := 0;
      end else begin
        vendidos := vendidos + min.cantVend;
        p.stockActual := p.stockActual - min.cantVend;
      end;
      minimo(vecDet, vecReg, min);
    end;

    // Calcular monto vendido del producto
    montoProd := vendidos * p.precioActual;
    montoTotal := montoTotal + montoProd;

    // Mensajes según el stock
    if vendidos = 0 then
      writeln('Producto: ', p.codigoP, ' - ', p.descripcion, ' No se vendió hoy. Stock actual: ', p.stockActual)
    else if p.stockActual < p.stockMin then
      writeln('Producto: ', p.codigoP, ' - ', p.descripcion, ' Vendido, pero quedó debajo del stock mínimo. Stock actual: ', p.stockActual);

    writeln('Producto: ', p.codigoP, ' - ', p.descripcion, ' Monto vendido hoy: $', montoProd:0:2);

    // Actualizar el maestro
    seek(mae, filepos(mae)-1);
    write(mae, p);
  end;

  // Cerrar archivos
  close(mae);
  for i := 1 to DF do
    close(vecDet[i]);

  writeln('Monto total facturado en el dia: $', montoTotal:0:2);
end;



BEGIN
	
	
END.


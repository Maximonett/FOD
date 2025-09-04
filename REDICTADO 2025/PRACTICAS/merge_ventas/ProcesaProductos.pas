{Un hipermercado tiene 30 cajas que van registrando los productos que facturan
en archivos independientes. Los registros de venta de productos contienen el
número de ticket, el código del producto y la cantidad de unidades del producto.
Al finalizar cada jornada, los archivos correspondientes a las cajas se ordenan
por código de producto, para determinar cuántas unidades de cada producto se
vendieron en la jornada y actualizar el archivo de productos.
Los registros del archivo de productos contienen el código del producto, la
descripción, la cantidad en existencia, y el precio de venta actual.
Se realiza un programa para:
a)Descontar de la existencia de cada producto y registrar la cantidad vendida
en la jornada
b)Informar si no se vendió ninguna unidad de algún producto que tenga unidades
en existencia
c)Informar los productos cuyas ventas alcancen o superen el 20% de la cantidad
en existencia previa.
Usualmente hay cajas que no se habilitan en toda una jornada, por lo que el
programa debe funcionar para cualquier número de cajas hasta 30.}

Uses CRT;

Const
    totCajas = 30;
    codProdFin = 65535;

Type
	tRegistroProducto=Record
		codProd: Word;
        descrip: String;
		existencia: Word;
        precio: Real
		End;

	tArchProductos=File of tRegistroProducto;

	tRegistroVenta=Record
		nTicket: LongInt;
        codProd: Word;
		cant: Word
		End;

	tArchVentas=File of tRegistroVenta;

    tCajas=Record
        cantCajas: Byte; {cantidad de cajas que se procesan}
        ventasCaja: Array[1..totCajas] of tArchVentas;
        ventaCaja: Array[1..totCajas] of tRegistroVenta
        end;

Procedure LeerProducto(var app: tArchProductos; var p: tRegistroProducto);
Begin
If eof(app) then p.codProd:=codProdFin else Read(app, p)
end;

Procedure LeerVenta(var avv: tArchVentas; var v: tRegistroVenta);
Begin
If eof(avv) then v.codProd:=codProdFin else Read(avv, v)
end;

Function Min(var cc: tCajas): Byte;
Var iMin, i: Byte;
Begin
iMIn:=1;
With cc do For i:=2 to cantCajas do
    If ventaCaja[i].codProd<ventaCaja[iMin].codProd
    then iMin:=i;
Min:=iMin
end;

Var
   nomArch: String;
   productos: tArchProductos;
   producto: tRegistroProducto;
   cajas: tCajas;
   iCaja: Byte; {indice de caja}
   iCajaCodMin: Byte; {indice de caja con codigo de producto minimo}
   cantVend: Word; {cantidad de productos vendidos de un mismo codigo}

begin
{Inicializaciones}
ClrScr;
WriteLn('ACTUALIZACION E INFORME DE PRODUCTOS');
WriteLn;
Write('Ingrese el nombre del archivo de productos: '); ReadLn(nomArch);
Assign(productos, nomArch); Reset(productos); LeerProducto(productos, producto);
WriteLn;
Write('Ingrese a cantidad de cajas a procesar: '); ReadLn(cajas.cantCajas);
WriteLn;
With cajas do
    For iCaja:=1 to cantCajas do begin
    WriteLn;
    Write('Ingrese el nombre del archivo de ventas de la caja ', iCaja, ': ');
    ReadLn(nomArch);
    Assign(ventasCaja[iCaja], nomArch); Reset(ventasCaja[iCaja]);
    LeerVenta(ventasCaja[iCaja], ventaCaja[iCaja])
    end;
iCajaCodMin:=Min(cajas); cantVend:=0;

{Proceso}
WriteLn; WriteLn;
With producto, cajas do
    While (codProd<>codProdFin) do
        If codProd<ventaCaja[iCajaCodMin].codProd
        then begin {se procesa el producto}
            If (cantVend=0) and (existencia>0)
            then begin {no se vendio ninguna unidad del producto}
                Write('No se vendio ninguna unidad del prod. ', codProd);
                WriteLn(': '+descrip)
                end
            else {(cantVend<>0) or (existencia=0)}
                If cantVend<>0
                then begin {se vendio alguna unidad del producto}
                    If cantVend>=existencia*0.2
                    then begin {se vendio el 20% o mas de la existencia}
                    Write('se vendio el 20% o mas de la existencia del prod. ');
                    WriteLn(codProd, ': '+descrip)
                    end;
                    {Actualizacion del producto}
                    Dec(existencia, cantVend);
                    Seek(productos, FilePos(productos)-1);
                    Write(productos, producto);
                    cantVend:=0;
                    end;
            LeerProducto(productos, producto)
            end
        else While codProd=ventaCaja[iCajaCodMin].codProd do
            begin {se procesa la venta}
            Inc(cantVend, ventaCaja[iCajaCodMin].cant);
            LeerVenta(ventasCaja[iCajaCodMin], ventaCaja[iCajaCodMin]);
            iCajaCodMin:=Min(cajas)
            end;

{Finalizacion}
Close(productos);
For iCaja:=1 to cajas.cantCajas do Close(cajas.ventasCaja[iCaja]);
WriteLn;
Write('Pulse la tecla de ingreso para finalizar...'); ReadLn
end.

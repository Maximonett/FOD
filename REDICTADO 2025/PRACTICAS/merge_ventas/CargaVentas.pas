{Los registros de venta de productos contienen el número de ticket, el código
del producto y la cantidad de unidades del producto}

Uses CRT;

Type
	tRegistroVenta=Record
		nTicket: LongInt;
        codProd: Word;
		cant: Word
		End;

	tArchVentas=File of tRegistroVenta;

Var
   opc: Byte;
   nomArch, nomArch2: String;
   arch: tArchVentas; carga: Text;
   Venta: tRegistroVenta;

begin
Repeat
WriteLn('VENTAS');
WriteLn;
WriteLn('0. Terminar el Programa');
WriteLn('1. Crear un archivo');
WriteLn('2. Abrir un archivo existente');
WriteLn;
Write('Ingrese el nro. de opcion: '); ReadLn(opc);
If (opc=1) or (opc=2) then begin
   WriteLn;
   Write('Nombre del archivo de Ventas: ');
   ReadLn(nomArch);
   Assign(arch, nomArch)
   end;
Case opc of
     1: begin
        Write('Nombre del archivo de carga: ');
        ReadLn(nomArch2);
        Assign(carga, nomArch2); Reset(carga); Rewrite(arch);
        Repeat
        With Venta do
             Read(carga, nTicket, codProd, cant);
        Write(arch, Venta)
        until eof(carga);
        Write('Archivo cargado. Oprima tecla de ingreso para continuar...');
        ReadLn;
        Close(arch); Close(carga)
        end;
     2: begin
        Reset(arch);
        WriteLn;
        Repeat
        Read(arch, Venta);
        With Venta do
             WriteLn(nTicket: 5, codProd: 5, cant:5);
        until eof(arch);
        Close(arch);
        WriteLn;
        Write('Oprima cualquier tecla para continuar...');
        ReadLn
        end;
end;
ClrScr
until opc=0;
end.

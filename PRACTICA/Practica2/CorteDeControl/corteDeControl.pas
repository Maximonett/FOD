{
  CORTE DE CONTROL
   
● El archivo se encuentra ordenado por
provincia, ciudad y sucursal
● En diferentes provincias pueden existir
ciudades con el mismo nombre, y en
diferentes ciudades pueden existir
sucursales con igual denominación.
   
}


program ejemplo;

const
  valor_alto = 'ZZZ';

type
  nombre = string[30];

  reg_venta = record
    vendedor: integer;
    monto: real;
    sucursal: nombre;
    ciudad: nombre;
    provincia: nombre;
  end;

  ventas = file of reg_venta;

var
  reg: reg_venta;
  archivo: ventas;
  total, totProv, totCiudad, totSuc: real;
  prov, ciudad, sucursal: nombre;


procedure crearArchivoBinarioDesdeTexto;
var
	txt:Text;
	bin:file of reg_venta;
	v:reg_venta;
begin
	assign(txt,'archivo_ventas.txt');
	Reset(txt);
	
	assign(bin,'archivo_ventas.dat');
	Rewrite(bin);
	while not eof(txt) do begin
		Readln(txt,v.vendedor,v.monto,v.sucursal,v.ciudad,v.provincia);
		write(bin,v);
	end;
	close(txt);
	close(bin);
	
	writeln('Archivo binario ".dat" creado correctamente.');
end;


// Procedimiento para leer con control de fin de archivo
procedure leer(var archivo: ventas; var dato: reg_venta);
begin
  if not EOF(archivo) then
    read(archivo, dato)
  else
    dato.provincia := valor_alto;
end;

// Programa principal
begin

  crearArchivoBinarioDesdeTexto;		
	
  assign(archivo, 'archivo_ventas.dat');
  reset(archivo);

  total := 0;
  leer(archivo, reg);

  while (reg.provincia <> valor_alto) do
  begin
    writeln('Provincia: ', reg.provincia);
    prov := reg.provincia;
    totProv := 0;

    while (reg.provincia = prov) do
    begin
      writeln('  Ciudad: ', reg.ciudad);
      ciudad := reg.ciudad;
      totCiudad := 0;

      while (reg.provincia = prov) and (reg.ciudad = ciudad) do
      begin
        writeln('    Sucursal: ', reg.sucursal);
        sucursal := reg.sucursal;
        totSuc := 0;

        while (reg.provincia = prov) and (reg.ciudad = ciudad) and (reg.sucursal = sucursal) do
        begin
          writeln('      Vendedor: ', reg.vendedor, ' - Monto: ', reg.monto:0:2);
          totSuc := totSuc + reg.monto;
          leer(archivo, reg);
        end;

        writeln('    Total Sucursal: ', totSuc:0:2);
        totCiudad := totCiudad + totSuc;
      end;

      writeln('  Total Ciudad: ', totCiudad:0:2);
      totProv := totProv + totCiudad;
    end;

    writeln('Total Provincia: ', totProv:0:2);
    total := total + totProv;
  end;

  writeln('TOTAL EMPRESA: ', total:0:2);
  close(archivo);
end.


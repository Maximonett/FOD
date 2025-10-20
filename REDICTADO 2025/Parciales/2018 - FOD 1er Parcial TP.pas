program untitled;

const
	va = 9999;

type
	acceso = record
		ano: integer;       // 1er corte
		mes: integer;       // 2do corte
		dia: integer;       // 3er corte
		idUsuario: integer; // 4to corte
		tiempo: integer;
	end;

	maestro = file of acceso;

procedure leer(var mae: maestro; var reg: acceso);
begin
	if not eof(mae) then
		read(mae, reg)
	else
		reg.ano := va;
end;

procedure informe(var mae: maestro);
var
	reg, act: acceso;
	totalTiempoDia, totalTiempoMes, totalTiempoAno, totalTiempoUsuario: integer;
begin
	reset(mae);
	leer(mae, reg);

	while (reg.ano <> va) do
	begin
		act.ano := reg.ano;
		writeln('Año: ', act.ano);
		totalTiempoAno := 0;

		while (reg.ano = act.ano) do
		begin
			act.mes := reg.mes;
			writeln('  Mes: ', act.mes);
			totalTiempoMes := 0;

			while (reg.ano = act.ano) and (reg.mes = act.mes) do
			begin
				act.dia := reg.dia;
				writeln('    Día: ', act.dia);
				totalTiempoDia := 0;

				while (reg.ano = act.ano) and (reg.mes = act.mes) and (reg.dia = act.dia) do
				begin
					act.idUsuario := reg.idUsuario;
					totalTiempoUsuario := 0;

					while (reg.ano = act.ano) and (reg.mes = act.mes) and
					      (reg.dia = act.dia) and (reg.idUsuario = act.idUsuario) do
					begin
						totalTiempoUsuario := totalTiempoUsuario + reg.tiempo;
						leer(mae, reg);
					end;

					writeln('      Id_Usuario: ', act.idUsuario, 
					        '  Tiempo total acceso en el día ', act.dia, 
					        ' del mes ', act.mes, ' = ', totalTiempoUsuario);

					totalTiempoDia := totalTiempoDia + totalTiempoUsuario;
				end;

				writeln('    Total tiempo acceso día ', act.dia, ': ', totalTiempoDia);
				totalTiempoMes := totalTiempoMes + totalTiempoDia;
			end;

			writeln('  Total tiempo acceso mes ', act.mes, ': ', totalTiempoMes);
			totalTiempoAno := totalTiempoAno + totalTiempoMes;
		end;

		writeln('Total tiempo acceso año ', act.ano, ': ', totalTiempoAno);
		writeln;
	end;

	close(mae);
end;

begin
end.

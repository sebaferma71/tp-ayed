//Sebastian Fermanelli - Fernando Catalano - Florencia Cerroni - Ariana Caro - COMISION 109
program main (input,output);

uses crt,sysutils;

type
  unaProvincia=RECORD
    cod_prov: Char;
    nom_prov: String[20];
  end;
  Provincias= file of unaProvincia;

  unSintoma=RECORD
    cod_sint: String[3];
    desc_sint: String[30];
  end;
  Sintomas= file of unSintoma;

  unaEnfermedad=RECORD
    cod_enf: String[3];
    desc_enf: String[30];
    sintomas: array [1..6] of String[3];
  end;
  Enfermedades= file of unaEnfermedad;

  unPaciente=RECORD
    dni: String[8];
    edad: Integer;
    cod_prov: Char;
    cant_enf: Integer;
    fallecido: Char;
  end;
  Pacientes= file of unPaciente;

  unaFecha=RECORD
    dia: Word;
    mes: Word;
    ano: Word;
  end;
  unaHistoria=RECORD
    dni: String[8];
    cod_enf: String[3];
    curado: Char;
    fecha_ingreso: unaFecha;
    sintomas: Array [1..6] of String[3];
    efector: String[30];
  end;
  Historias= file of unaHistoria;

var
  OP, VOLVER: Integer;
  TERMINAR: Char;

  P, auxP: unaProvincia;
  Pvs: Provincias;

  S, auxS: unSintoma;
  Sints: Sintomas;

  E, auxE: unaEnfermedad;
  Enfs: Enfermedades;

  G, auxG: unPaciente;
  Pacs: Pacientes;

  H: unaHistoria;
  His: Historias;

const
  CANTPROVS= 24;
  CANTSINTS= 20;
  CANTENF= 10;

//-----------------//
//-ASIGNABRE/CLOSE-//
//-----------------//
procedure Asignabre();
   begin
     Assign(Pvs, 'C:\TP3\provincias.dat');
     {$I-}
     Reset(Pvs);
     if(ioresult = 2) then Rewrite(Pvs);
     {$I+}

     Assign(Sints, 'C:\TP3\sintomas.dat');
     {$I-}
     Reset(Sints);
     if(ioresult = 2) then Rewrite(Sints);
     {$I+}

     Assign(Enfs, 'C:\TP3\enfermedades.dat');
     {$I-}
     Reset(Enfs);
     if(ioresult = 2) then Rewrite(Enfs);
     {$I+}

     Assign(Pacs, 'C:\TP3\pacientes.dat');
     {$I-}
     Reset(Pacs);
     if(ioresult = 2) then Rewrite(Pacs);
     {$I+}

     Assign(His, 'C:\TP3\historias.dat');
     {$I-}
     Reset(His);
     if(ioresult = 2) then Rewrite(His);
     {$I+}
   end;

//--------------------------------------------------------------------------------------------------
procedure CerrarArchivos();
  begin
    Close(Pvs);
    Close(Sints);
    Close(Enfs);
    Close(Pacs);
    Close(His);
  end;

//------------//
//-PROVINCIAS-//
//------------//
procedure OrdenarProvincias(var SWITCH: Boolean);
  var
    i,j: Integer;
  begin
    Seek(Pvs, 0);
    for i := 0 to FileSize(Pvs) - 2 do
      begin
        for j := i+1 to FileSize(Pvs) - 1 do
          begin
            Seek(Pvs, i);
            Read(Pvs, P);
            Seek(Pvs, j);
            Read(Pvs, auxP);

            //POR CODIGO
            if (SWITCH = true) then
              begin
                if (P.cod_prov > auxP.cod_prov) then
                  begin
                    Seek(Pvs, i);
                    Write(Pvs, auxP);
                    Seek(Pvs, j);
                    Write(Pvs, P);
                  end;
              end
            //POR NOMBRE
            else
              begin
                if (P.nom_prov > auxP.nom_prov) then
                  begin
                    Seek(Pvs, i);
                    Write(Pvs, auxP);
                    Seek(Pvs, j);
                    Write(Pvs, P);
                  end;
              end;
          end;
      end;
  end;
//--------------------------------------------------------------------------------------------------
procedure MostrarProvincias();
  var
    CAMBIAR: Boolean;
    i, CONT_S: Integer;
  begin
    textColor(green);
    WriteLn('==========================================');
    WriteLn('|                                        |');
    WriteLn('|              PROVINCIAS                |');
    WriteLn('|                                        |');
    WriteLn('==========================================');

    CONT_S := 0;
    Seek(Pvs, 0);
    for i := 0 to FileSize(Pvs) - 1 do
      begin
        Read(Pvs, P);
        if ((P.nom_prov)[1] = 'S') or ((P.nom_prov)[1] = 's') then CONT_S := CONT_S + 1;
      end;

    textColor(yellow);
    WriteLn('Las provincias que empiezan con S son ', CONT_S);

    WriteLn('-------------------------');
    WriteLn('PROVINCIAS ORDENADAS POR CODIGO');

    //ORDENAR
    CAMBIAR := True;
    OrdenarProvincias(CAMBIAR);

    //MOSTRAR EN ORDEN
    Seek(Pvs, 0);
    for i := 0 to FileSize(Pvs) - 1 do
      begin
        Read(Pvs, P);
        WriteLn(P.cod_prov, ' - ', P.nom_prov);
      end;

    WriteLn('-------------------------');
    WriteLn('PROVINCIAS ORDENADAS POR NOMBRE');

    //ORDENAR
    CAMBIAR := False;
    OrdenarProvincias(CAMBIAR);

    //MOSTRAR EN ORDEN
    Seek(Pvs, 0);
    for i := 0 to FileSize(Pvs) - 1 do
      begin
        Read(Pvs, P);
        WriteLn(P.cod_prov, ' - ', P.nom_prov);
      end;
  end;
//--------------------------------------------------------------------------------------------------
procedure CargarProvincia();
  var
    validCOD, validNOM: Boolean;
    i: Integer;

  begin
    Seek(Pvs, FileSize(Pvs));

    if (FilePos(Pvs) = 0) then
      begin
        repeat
          textColor(green);
          WriteLn('==========================================');
          WriteLn('|                                        |');
          WriteLn('|              PROVINCIAS                |');
          WriteLn('|                                        |');
          WriteLn('==========================================');
          WriteLn('===========================================================================');
          WriteLn('|  A - SALTA             |  B - BUENOS AIRES  |  D - SAN LUIS             |');
          WriteLn('|  E - ENTRE RIOS        |  F - LA RIOJA      |  G - SANTIAGO DEL ESTERO  |');
          WriteLn('|  H - CHACO             |  J - SAN JUAN      |  K - CATAMARCA            |');
          WriteLn('|  L - LA PAMPA          |  M - MENDOZA       |  N - MISIONES             |');
          WriteLn('|  P - FORMOSA           |  Q - NEUQUEN       |  R - RIO NEGRO            |');
          WriteLn('|  S - SANTA FE          |  T - TUCUMAN       |  U - CHUBUT               |');
          WriteLn('|  V - TIERRA DEL FUEGO  |  W - CORRIENTES    |  X - CORDOBA              |');
          WriteLn('|  Y - JUJUY             |  Z - SANTA CRUZ    |                           |');
          WriteLn('===========================================================================');

          //CARGA DE CODIGO DE PROVINCIA
          textColor(yellow);
          WriteLn('Ingrese el codigo de la provincia ', FilePos(Pvs) + 1, ' (A/a - Z/z).');
          repeat
            ReadLn(P.cod_prov);

            validCOD := true;
            Seek(Pvs, 0);
            for i := 0 to FileSize(Pvs) - 1 do
              begin
                Read(Pvs, auxP);
                if(auxP.cod_prov = P.cod_prov) then validCOD := false;
              end;
            
            if (validCOD = false) then
              begin
                textColor(red);
                WriteLn('El codigo ya fue ingresado anteriormente.');
                textColor(yellow);
              end;
          until (((P.cod_prov >= 'A') and (P.cod_prov <= 'Z')) or ((P.cod_prov >= 'a') and (P.cod_prov <= 'z'))) and (validCOD = true);

          //CARGA DE NOMBRE DE PROVINCIA
          WriteLn('Ingrese el nombre de la provincia ', FilePos(Pvs) + 1, ' (Max. 20 caracteres).');
          repeat
            repeat
              ReadLn(P.nom_prov);

              if (P.nom_prov = '') then
                begin
                  textColor(red);
                  WriteLn('El nombre no puede estar vacio.');
                  textColor(yellow);
                end;
            until (P.nom_prov <> '');

            validNOM := true;
            Seek(Pvs, 0);
            for i := 0 to FileSize(Pvs) - 1 do
              begin
                Read(Pvs, auxP);
                if(auxP.nom_prov = P.nom_prov) then validNOM := false;
              end;

            if (validNOM = false) then
              begin
                textColor(red);
                WriteLn('El nombre ya fue ingresado anteriormente.');
                textColor(yellow);
              end;
          until (validNOM = true);

          //CARGANDO PROVINICIA
          Write(Pvs, P);

          if (FilePos(Pvs) + 1 < CANTPROVS) then
            begin
              WriteLn('Desea cargar otra provincia? S / N');
              repeat
                ReadLn(TERMINAR);
              until (TERMINAR = 'S') or (TERMINAR = 's') or (TERMINAR = 'N') or (TERMINAR = 'n');
            end;

          clrscr;
        until (TERMINAR = 'N') or (TERMINAR = 'n') or (FilePos(Pvs) + 1 = CANTPROVS);
      end
    else
      begin
        textColor(red);
        WriteLn('Las provincias ya se han cargado.');
        textColor(yellow);
      end;
  end;
//--------------------------------------------------------------------------------------------------
procedure Opcion1();
  begin
    WriteLn('Seleccione 1 para proseguir con la opcion o 0 para volver al menu.');
    repeat
      ReadLn(VOLVER);
    until (VOLVER = 0) or (VOLVER = 1);

    clrscr;

    if (VOLVER = 1) then
      begin
        CargarProvincia();
        MostrarProvincias();
        ReadLn();
      end;

    clrscr;
  end;
//----------//
//-SINTOMAS-//
//----------//
procedure CargarSintoma();
  var
    i: Integer;
    validCOD, validDESC: Boolean;

  begin
    Seek(Sints, FileSize(Sints));

    if (FilePos(Sints) < CANTSINTS) then
      begin
        repeat
          textColor(green);
          WriteLn('==========================================');
          WriteLn('|                                        |');
          WriteLn('|               SINTOMAS                 |');
          WriteLn('|                                        |');
          WriteLn('==========================================');

          textColor(yellow);
          if (FilePos(Sints) > 0) then
            begin
              Seek(Sints, 0);
              for i := 0 to FileSize(Sints) - 1 do
                begin
                  Read(Sints, S);
                  WriteLn('CODIGO: ', S.cod_sint, ' - NOMBRE: ', S.desc_sint);
                end;

              textColor(green);
              WriteLn('==========================================');
            end;

          //CARGA DE CODIGO DE SINTOMA
          textColor(yellow);
          WriteLn('Ingrese el codigo del sintoma ', FilePos(Sints) + 1, ' (Max. 3 caracteres).');
          repeat
            repeat
              ReadLn(S.cod_sint);

              if (S.cod_sint = '') then
                begin
                  textColor(red);
                  WriteLn('El codigo no puede estar vacio.');
                  textColor(yellow);
                end;
              if (Length(S.cod_sint) < 3) then
                begin
                  textColor(red);
                  WriteLn('El codigo debe tener 3 caracteres.');
                  textColor(yellow);
                end;
            until (S.cod_sint <> '') and (Length(S.cod_sint) = 3);

            validCOD := true;
            Seek(Sints, 0);
            for i := 0 to FileSize(Sints) - 1 do
              begin
                Read(Sints, auxS);
                if(auxS.cod_sint = S.cod_sint) then validCOD := false;
              end;

            if (validCOD = false) then
              begin
                textColor(red);
                WriteLn('El codigo ya fue ingresado anteriormente.');
                textColor(yellow);
              end;
          until (validCOD = true);

          //CARGA DE NOMBRE DE SINTOMA
          WriteLn('Ingrese el nombre del sintoma ', FilePos(Sints) + 1, ' (Max. 30 caracteres).');
          repeat
            repeat
              ReadLn(S.desc_sint);

              if (S.desc_sint = '') then
                begin
                  textColor(red);
                  WriteLn('El nombre no puede estar vacio.');
                  textColor(yellow);
                end;
            until (S.desc_sint <> '');

            validDESC := true;
            Seek(Sints, 0);
            for i := 0 to FileSize(Sints) - 1 do
              begin
                Read(Sints, auxS);
                if(auxS.desc_sint = S.desc_sint) then validDESC := false;
              end;
            
            if (validDESC = false) then
              begin
                textColor(red);
                WriteLn('El nombre ya fue ingresado anteriormente.');
                textColor(yellow);
              end;
          until (validDESC = true);
          
          //CARGANDO SINTOMA
          Write(Sints, S);

          if (FilePos(Sints) < CANTSINTS) then
            begin
              WriteLn('Desea cargar otro sintoma? S / N');
              repeat
                ReadLn(TERMINAR);
              until (TERMINAR = 'S') or (TERMINAR = 's') or (TERMINAR = 'N') or (TERMINAR = 'n');
            end;

          clrscr;
        until (TERMINAR = 'N') or (TERMINAR = 'n') or (FilePos(Sints) = CANTSINTS);
      end
    else
      begin
        textColor(red);
        WriteLn('Ya existen 20 sintomas.');
        textColor(yellow);
      end;
  end;
//--------------------------------------------------------------------------------------------------
procedure MostrarSintomas();
  var
    i: Integer;

  begin
    textColor(green);
    WriteLn('==========================================');
    WriteLn('|                                        |');
    WriteLn('|               SINTOMAS                 |');
    WriteLn('|                                        |');
    WriteLn('==========================================');

    textColor(yellow);
    Seek(Sints, 0);
    for i := 0 to FileSize(Sints) - 1 do
      begin
        Read(Sints, S);
        WriteLn('CODIGO: ', S.cod_sint, ' - NOMBRE: ', S.desc_sint);
      end;
  end;
//--------------------------------------------------------------------------------------------------
procedure Opcion2();
  begin
    WriteLn('Seleccione 1 para proseguir con la opcion o 0 para volver al menu.');
    repeat
      ReadLn(VOLVER);
    until (VOLVER = 0) or (VOLVER = 1);

    clrscr;

    if (VOLVER = 1) then
      begin
        CargarSintoma();
        MostrarSintomas();
        ReadLn();
      end;

    clrscr;
  end;

//--------------//
//-ENFERMEDADES-//
//--------------//
procedure MostrarEnfermedades();
  var
    CONT: Integer;

  begin
    Seek(Sints, FileSize(Sints));

    if (FilePos(Sints) <> 0) then
      begin
        textColor(green);
        WriteLn('==========================================');
        WriteLn('|                                        |');
        WriteLn('|             ENFERMEDADES               |');
        WriteLn('|                                        |');
        WriteLn('==========================================');

        textColor(yellow);
        Seek(Enfs, 0);
        repeat
          Read(Enfs, E);
          WriteLn('CODIGO: ', E.cod_enf, ' - NOMBRE: ', E.desc_enf);
          Write('SINTOMAS: ');

          CONT := 0;
          repeat
            CONT := CONT + 1;
            Write(E.sintomas[CONT], ' ');
          until (E.sintomas[CONT] = '') or (CONT = 6);
          
          WriteLn('');
          WriteLn('');
        until (Eof(Enfs));
      end;
  end;
//--------------------------------------------------------------------------------------------------
procedure CargarEnfermedad();
  var
    i, CSE, CONT: Integer;
    OTROSINT: Char;
    validCOD, validDESC, validSINT, validEXIST: Boolean;

  begin
    Seek(Enfs, FileSize(Enfs));
    Seek(Sints, FileSize(Sints));

    if (FilePos(Sints) <> 0) then
      begin 
        if (FilePos(Enfs) < CANTENF) then
          begin
            repeat
              textColor(green);
              WriteLn('==========================================');
              WriteLn('|                                        |');
              WriteLn('|             ENFERMEDADES               |');
              WriteLn('|                                        |');
              WriteLn('==========================================');

              textColor(yellow);
              if (FilePos(Enfs) > 0) then
                begin
                  Seek(Enfs, 0);
                  for i := 0 to FileSize(Enfs) - 1 do
                    begin
                      Read(Enfs, E);
                      WriteLn('CODIGO: ', E.cod_enf, ' - NOMBRE: ', E.desc_enf);
                    end;
                  
                  textColor(green);
                  WriteLn('==========================================');
                end;

              //CARGA DE CODIGO
              textColor(yellow);
              WriteLn('Ingrese el codigo de la enfermedad ', FilePos(Enfs) + 1, ' (Max. 3 caracteres).');
              repeat
                repeat
                  ReadLn(E.cod_enf);

                  if (E.cod_enf = '') then
                    begin
                      textColor(red);
                      WriteLn('El codigo no puede estar vacio.');
                      textColor(yellow);
                    end;
                  if (Length(E.cod_enf) < 3) then
                    begin
                      textColor(red);
                      WriteLn('El codigo debe tener 3 caracteres.');
                      textColor(yellow);
                    end;
                until (E.cod_enf <> '') and (Length(E.cod_enf) = 3);

                validCOD := true;
                Seek(Enfs, 0);
                for i := 0 to FileSize(Enfs) - 1 do
                  begin
                    Read(Enfs, auxE);
                    if(auxE.cod_enf = E.cod_enf) then validCOD := false;
                  end;
                
                if (validCOD = false) then
                  begin
                    textColor(red);
                    WriteLn('El codigo ya fue ingresado anteriormente.');
                    textColor(yellow);
                  end;
              until (validCOD = true);

              //CARGA DE NOMBRE
              WriteLn('Ingrese el nombre de la enfermedad ', FilePos(Enfs) + 1, ' (Max. 30 caracteres).');
              repeat
                repeat
                  ReadLn(E.desc_enf);

                  if (E.desc_enf = '') then
                    begin
                      textColor(red);
                      WriteLn('El nombre no puede estar vacio.');
                      textColor(yellow);
                    end;
                until (E.desc_enf <> '');

                validDESC := true;
                Seek(Enfs, 0);
                for i := 0 to FileSize(Enfs) - 1 do
                  begin
                    Read(Enfs, auxE);
                    if(auxE.desc_enf = E.desc_enf) then validDESC := false;
                  end;
                
                if (validDESC = false) then
                  begin
                    textColor(red);
                    WriteLn('El nombre ya fue ingresado anteriormente.');
                    textColor(yellow);
                  end;
              until (validDESC = true);

              //CARGA DE SINTOMAS
              MostrarSintomas();
              textColor(green);
              WriteLn('==========================================');

              CSE := 0;
              repeat
                CSE := CSE + 1;

                textColor(yellow);
                WriteLn('Ingrese el codigo del sintoma ', CSE,' de la enfermedad ', FilePos(Enfs) + 1);
                repeat
                  repeat
                    ReadLn(E.sintomas[CSE]);
                    
                    if (E.sintomas[CSE] = '') then
                      begin
                        textColor(red);
                        WriteLn('El codigo del sintoma no puede estar vacio.');
                        textColor(yellow);
                      end;
                  until (E.sintomas[CSE] <> '');

                  validSINT := false;
                  Seek(Sints, 0);
                  repeat
                    Read(Sints, S);
                  until (Eof(Sints)) or (S.cod_sint = E.sintomas[CSE]);
                  if (S.cod_sint = E.sintomas[CSE]) then validSINT := true;

                  validEXIST := false;
                  for i := 1 to Pred(CSE) do
                    begin
                      if (E.sintomas[i] = E.sintomas[CSE]) then validEXIST := true;
                    end;
                  
                  if (validSINT = false) then
                    begin
                      textColor(red);
                      WriteLn('El sintoma ingresado no existe.');
                      textColor(yellow);
                    end;
                  if (validEXIST = true) then
                    begin
                      textColor(red);
                      WriteLn('El sintoma ingresado ya existe en esta enfermedad.');
                      textColor(yellow);
                    end;
                until (validSINT = true) and (validEXIST = false);

                if (CSE < 6) then
                  begin
                    WriteLn('Desea cargar otro sintoma a la enfermedad? S / N');
                    repeat
                      ReadLn(OTROSINT);
                    until (OTROSINT = 'S') or (OTROSINT = 's') or (OTROSINT = 'N') or (OTROSINT = 'n');
                  end;
                
                if ((CSE < 6) and ((OTROSINT = 'N') or (OTROSINT = 'n'))) then
                  begin
                    CONT := CSE;
                    repeat
                      CONT := CONT + 1;
                      E.sintomas[CONT] := '';
                    until (CONT = 6);
                  end;
              until (OTROSINT = 'N') or (OTROSINT = 'n') or (CSE = 6);

              //CARGANDO ENFERMEDAD
              Write(Enfs, E);

              if (FilePos(Enfs) < CANTENF) then
                begin
                  WriteLn('Desea cargar otra enfermedad? S / N');
                  repeat
                    ReadLn(TERMINAR);
                  until (TERMINAR = 'S') or (TERMINAR = 's') or (TERMINAR = 'N') or (TERMINAR = 'n');
                end;

              clrscr;
            until (TERMINAR = 'N') or (TERMINAR = 'n') or (FilePos(Enfs) = CANTENF);
          end
        else
          begin
            textColor(red);
            WriteLn('Ya existen 10 enfermedades.');
            textColor(yellow);
          end;
      end
    else
      begin
        textColor(red);
        WriteLn('Para registrar enfermedades primero debe registrar los sintomas.');
        textColor(yellow);
      end;
  end;
//--------------------------------------------------------------------------------------------------
procedure Opcion3();
  begin
    WriteLn('Seleccione 1 para proseguir con la opcion o 0 para volver al menu.');
    repeat
      ReadLn(VOLVER);
    until (VOLVER = 0) or (VOLVER = 1);

    clrscr;

    if (VOLVER = 1) then
      begin
        CargarEnfermedad();
        MostrarEnfermedades();
        ReadLn();
      end;

    clrscr;
  end;

//-----------//
//-PACIENTES-//
//-----------//
procedure CargarPaciente();
  var
    validDNI, validDNINUM, validCODPROV: Boolean;
    i: Integer;

  begin
    Seek(Pvs, FileSize(Pvs));

    if (FilePos(Pvs) <> 0) then
      begin
        Seek(Pacs, FileSize(Pacs));

        repeat
          textColor(green);
          WriteLn('==========================================');
          WriteLn('|                                        |');
          WriteLn('|               PACIENTES                |');
          WriteLn('|                                        |');
          WriteLn('==========================================');

          //CARGA DE DNI
          textColor(yellow);
          WriteLn('Ingrese el DNI del paciente ', FilePos(Pacs) + 1);
          repeat
            repeat
              ReadLn(G.dni);

              if (G.dni = '') then
                begin
                  textColor(red);
                  WriteLn('El DNI no puede estar vacio.');
                  textColor(yellow);
                end;
              if (Length(G.dni) <> 8) then
                begin
                  textColor(red);
                  WriteLn('El DNI tiene que tener 8 digitos.');
                  textColor(yellow);
                end;
            until (Length(G.dni) = 8) and (G.dni <> '');

            validDNI := true;
            Seek(Pacs, 0);
            for i := 0 to FileSize(Pacs) - 1 do
                begin
                  Read(Pacs, auxG);
                  if(auxG.dni = G.dni) then validDNI := false;
                end;
            
            validDNINUM := true;
            for i := 1 to Length(G.dni) do
              if (ord(G.dni[i]) in [0..47]) or (ord(G.dni[i]) in [58..255]) then
                begin
                  validDNINUM := false;
                end;
            
            if (validDNI = false) then
              begin
                textColor(red);
                WriteLn('Un paciente con ese DNI ya existe.');
                textColor(yellow);
              end;
            if (validDNINUM = false) then
              begin
                textColor(red);
                WriteLn('El DNI solo puede contener caracteres numericos.');
                textColor(yellow);
              end;
          until (validDNI = true) and (validDNINUM = true);

          //CARGA DE EDAD
          WriteLn('Ingrese la edad del paciente ', FilePos(Pacs) + 1, ' (Max. 110).');
          repeat
            ReadLn(G.edad);

            if ((G.edad < 1) or (G.edad > 110)) then
              begin
                textColor(red);
                WriteLn('Ingrese la edad entre 1 y 110.');
                textColor(yellow);
              end;
          until (G.edad > 0) and (G.edad <= 110);

          //CARGA DE PROVINCIA DE PACIENTE
          textColor(green);
          WriteLn('==========================================');
          WriteLn('|                                        |');
          WriteLn('|              PROVINCIAS                |');
          WriteLn('|                                        |');
          WriteLn('==========================================');
          textColor(yellow);
          Seek(Pvs, 0);
          for i := 0 to FileSize(Pvs) - 1 do
            begin
              Read(Pvs, P);
              WriteLn('CODIGO: ', P.cod_prov, ' - NOMBRE: ', P.nom_prov);
            end;
          textColor(green);
          WriteLn('==========================================');
          
          textColor(yellow);
          WriteLn('Ingrese el codigo de la provincia (A-Z) del paciente ', FilePos(Pacs) + 1);
          repeat
            ReadLn(G.cod_prov);

            validCODPROV := false;
            Seek(Pvs, 0);
            for i := 0 to FileSize(Pvs) - 1 do
              begin
                Read(Pvs, P);
                if (P.cod_prov = G.cod_prov) then validCODPROV := true;
              end;
            
            if (validCODPROV = false) then
              begin
                textColor(red);
                WriteLn('El codigo de provincia ingresado no existe.');
                textColor(yellow);
              end;
          until (((P.cod_prov >= 'A') and (P.cod_prov <= 'Z')) or ((P.cod_prov >= 'a') and (P.cod_prov <= 'z'))) and (validCODPROV = true);

          //CARGA DE CANTIDAD DE ENFERMEDADES
          Seek(Enfs, FileSize(Enfs));
          WriteLn('Ingrese la cantidad de enfermedades que tenia el paciente ', FilePos(Pacs) + 1, ' (Max. ', FilePos(Enfs),').');
          repeat
            ReadLn(G.cant_enf);

            if (G.cant_enf > FileSize(Enfs)) then
              begin
                textColor(red);
                WriteLn('El numero debe ser menor o igual a ', FilePos(Enfs),'.');
                textColor(yellow);
              end;
          until (G.cant_enf <= FileSize(Enfs));

          //CARGA DE FALLECIO/NO
          WriteLn('Ingrese si el paciente ', FilePos(Pacs) + 1, ' fallecio. S / N');
          repeat
            ReadLn(G.fallecido);
          until (G.fallecido = 'S') or (G.fallecido = 's') or (G.fallecido = 'N') or (G.fallecido = 'n');

          //CARGANDO PACIENTE
          clrscr;

          textColor(green);
          WriteLn('==========================================');

          textColor(yellow);
          WriteLn('DNI: ', G.dni);
          WriteLn('EDAD: ', G.edad);
          WriteLn('PROV.: ', G.cod_prov);
          WriteLn('CANT. ENF.: ', G.cant_enf);
          WriteLn('FALLECIDO: ', G.fallecido);

          textColor(green);
          WriteLn('==========================================');

          Write(Pacs, G);

          textColor(yellow);
          WriteLn('Desea cargar otro paciente? S / N');
          repeat
            ReadLn(TERMINAR);
          until (TERMINAR = 'S') or (TERMINAR = 's') or (TERMINAR = 'N') or (TERMINAR = 'n');

          clrscr;

        until (TERMINAR = 'N') or (TERMINAR = 'n');
      end
    else
      begin
        textColor(red);
        WriteLn('Para registrar pacientes primero debe registrar las provincias.');
        ReadLn();
        textColor(yellow);
      end;
  end;

//--------------------------------------------------------------------------------------------------
procedure Opcion4();
  begin
    WriteLn('Seleccione 1 para proseguir con la opcion o 0 para volver al menu.');
    repeat
      ReadLn(VOLVER);
    until (VOLVER = 0) or (VOLVER = 1);

    clrscr;

    if (VOLVER = 1) then
      begin
        CargarPaciente();
      end;

    clrscr;
  end;

//-----------//
//-HISTORIAS-//
//-----------//
procedure CargarHistoria();
  var
    validDNI, validDNINUM, validENF, validSINT, validEXIST: Boolean;
    CSE, i, CONT: Integer;
    OTROSINT,NUEVOPAC: Char;
    ddia,dmes,dano: Word;

  begin
    Seek(His, FileSize(His));
    Seek(Pacs, FileSize(Pacs));
    Seek(Enfs, FileSize(Enfs));

    if (FilePos(Pacs) <> 0) and (FilePos(Enfs) <> 0) then
      begin
        repeat
          textColor(green);
          WriteLn('==========================================');
          WriteLn('|                                        |');
          WriteLn('|           HISTORIA CLINICA             |');
          WriteLn('|                                        |');
          WriteLn('==========================================');

          //CARGA DE DNI
          textColor(yellow);
          WriteLn('Ingrese el DNI del paciente para generar la historia clinica.');
          repeat
            repeat
              ReadLn(H.dni);

              if (H.dni = '') then
                begin
                  textColor(red);
                  WriteLn('El DNI no puede estar vacio.');
                  textColor(yellow);
                end;
              if (Length(H.dni) <> 8) then
                begin
                  textColor(red);
                  WriteLn('El DNI tiene que tener 8 digitos.');
                  textColor(yellow);
                end;
            until (Length(H.dni) = 8) and (H.dni <> '');

            validDNI := false;
            Seek(Pacs, 0);
            for i := 0 to FileSize(Pacs) - 1 do
              begin
                Read(Pacs, G);
                if (G.dni = H.dni) then validDNI := true;
              end;
            
            validDNINUM := true;
            for i := 1 to Length(H.dni) do
              if (ord(H.dni[i]) in [0..47]) or (ord(H.dni[i]) in [58..255]) then
                begin
                  validDNINUM := false;
                end;

            if (validDNINUM = false) then
              begin
                textColor(red);
                WriteLn('El DNI solo puede contener caracteres numericos.');
                textColor(yellow);
              end;
            if (validDNI = false) then
              begin
                textColor(red);
                WriteLn('No existe un paciente con ese DNI.');
                textColor(yellow);

                WriteLn('Desea cargar un nuevo paciente? S / N');
                repeat
                  ReadLn(NUEVOPAC);
                until (NUEVOPAC = 'S') or (NUEVOPAC = 's') or (NUEVOPAC = 'N') or (NUEVOPAC = 'n');

                clrscr;

                if (NUEVOPAC = 'S') or (NUEVOPAC = 's') then
                  begin
                    CargarPaciente();
                  end;
              end;
          until (validDNI = true) and (validDNINUM = true);

          //CARGA DE ENFERMEDAD DEL PACIENTE
          MostrarEnfermedades();
          textColor(green);
          WriteLn('==========================================');

          textColor(yellow);
          WriteLn('Ingrese el codigo de la enfermedad que posee el paciente.');
          repeat
            repeat
              ReadLn(H.cod_enf);

              if (H.cod_enf = '') then
                begin
                  textColor(red);
                  WriteLn('El codigo de enfermedad no puede estar vacio.');
                  textColor(yellow);
                end;
            until (H.cod_enf <> '');

            validENF := false;
            Seek(Enfs, 0);
            repeat
              Read(Enfs, E);
            until (Eof(Enfs)) or (E.cod_enf = H.cod_enf);
            if (E.cod_enf = H.cod_enf) then validENF := true;
            {for i := 0 to FileSize(Enfs) - 1 do
              begin
                Read(Enfs, E);
                if (E.cod_enf = H.cod_enf) then validENF := true;
              end;}
            
            if (validENF = false) then
              begin
                textColor(red);
                WriteLn('El codigo de enfermedad no existe.');
                textColor(yellow);
              end;
          until (validENF = true);

          //CARGA DE SI SE CURO O NO
          WriteLn('Ingrese si el paciente se curo. S / N');
          repeat
            ReadLn(H.curado);
          until (H.curado = 'S') or (H.curado = 's') or (H.curado = 'N') or (H.curado = 'n');

          //CARGA DE SINTOMAS
          textColor(green);
          WriteLn('==========================================');
          textColor(yellow);
          CONT := 1;
          while ((E.sintomas[CONT] <> '') or (CONT = 6)) do
            begin
              WriteLn('SINTOMA: ', E.sintomas[CONT]);
              CONT := CONT + 1;
            end;
          textColor(green);
          WriteLn('==========================================');
          textColor(yellow);

          CSE := 0;
          repeat
            CSE := CSE + 1;
            WriteLn('Ingrese el codigo del sintoma ', CSE,' que presenta el paciente.');

            repeat
              repeat
                ReadLn(H.sintomas[CSE]);

                if (H.sintomas[CSE] = '') then
                  begin
                    textColor(red);
                    WriteLn('El codigo del sintoma no puede estar vacio.');
                    textColor(yellow);
                  end;
              until (H.sintomas[CSE] <> '');

              validSINT := false;
              CONT := 0;
              repeat
                CONT := CONT + 1;
                if (E.sintomas[CONT] = H.sintomas[CSE]) then validSINT := true;
              until (E.sintomas[CONT] = H.sintomas[CSE]) or (CONT = 6);
              
              validEXIST := false;
              for i := 1 to Pred(CSE) do
                begin
                  if (H.sintomas[i] = H.sintomas[CSE]) then validEXIST := true;
                end;

              if (validSINT = false) then
                begin
                  textColor(red);
                  WriteLn('El sintoma ingresado no existe.');
                  textColor(yellow);
                end;
              if (validEXIST = true) then
                begin
                  textColor(red);
                  WriteLn('Este sintoma ya lo ha ingresado en el historial.');
                  textColor(yellow);
                end;
            until (validSINT = true) and (validEXIST = false);

            if (CSE < 6) then
              begin
                WriteLn('El paciente ha presentado otro sintoma? S / N');
                repeat
                  ReadLn(OTROSINT);
                until (OTROSINT = 'S') or (OTROSINT = 's') or (OTROSINT = 'N') or (OTROSINT = 'n');
              end;
          until (OTROSINT = 'N') or (OTROSINT = 'n') or (CSE = 6);

          //CARGA DE EFECTOR
          WriteLn('Ingrese el efector del paciente (Max. 30 caracteres).');
          repeat
            ReadLn(H.efector);

            if (H.efector = '') then
              begin
                textColor(red);
                WriteLn('El efector no puede ser un campo vacio.');
                textColor(yellow);
              end;
          until (H.efector <> '');

          //CARGANDO HISTORIA
          DecodeDate(Date,dano,dmes,ddia);
          WriteLn('Historia clinica cargada el ',ddia,'/',dmes,'/',dano);
          H.fecha_ingreso.dia := ddia;
          H.fecha_ingreso.mes := dmes;
          H.fecha_ingreso.ano := dano;

          Write(His, H);
      
          WriteLn('Desea cargar otra historia clinica? S / N');
          repeat
            ReadLn(TERMINAR);
          until (TERMINAR = 'S') or (TERMINAR = 's') or (TERMINAR = 'N') or (TERMINAR = 'n');

          clrscr;
        until (TERMINAR = 'N') or (TERMINAR = 'n');
      end
    else
      begin
        textColor(red);
        WriteLn('Para registrar historias clinicas primero debe registrar al menos un paciente y una enfermedad.');
        ReadLn();
        textColor(yellow);
      end;
  end;
//--------------------------------------------------------------------------------------------------
procedure Opcion5();
  begin
    WriteLn('Seleccione 1 para proseguir con la opcion o 0 para volver al menu.');
    repeat
      ReadLn(VOLVER);
    until (VOLVER = 0) or (VOLVER = 1);

    clrscr;

    if (VOLVER = 1) then
      begin
        CargarHistoria();
      end;

    clrscr;
  end;
//--------------//
//-ESTADISTICAS-//
//--------------//
procedure Estadistica1();
  var
    i, j, k, CANTENF: Integer;
  begin
    textColor(green);
    WriteLn('==========================================');
    WriteLn('|                                        |');
    WriteLn('|               SINTOMAS                 |');
    WriteLn('|                                        |');
    WriteLn('==========================================');

    textColor(yellow);
    Seek(Sints, 0);
    for i := 0 to FileSize(Sints) - 1 do
      begin
        Read(Sints, S);
        CANTENF := 0;

        Seek(Enfs, 0);
        for j := 0 to FileSize(Enfs) - 1 do
          begin
            Read(Enfs, E);

            for k := 1 to 6 do
              begin
                if (E.sintomas[k] = S.cod_sint) then CANTENF := CANTENF + 1;
              end;
          end;

        WriteLn('CODIGO: ', S.cod_sint, ' - NOMBRE:', S.desc_sint, ' - APARECE EN: ', CANTENF, ' ENFERMEDADES.');
      end;
    
    ReadLn();
  end;
//--------------------------------------------------------------------------------------------------
procedure Estadistica2();
  var
    i, j, k, CANTPACS, EDADES: Integer;
    PROMEDAD: Real;
  begin
    textColor(green);
    WriteLn('==========================================');
    WriteLn('|                                        |');
    WriteLn('|             ENFERMEDADES               |');
    WriteLn('|                                        |');
    WriteLn('==========================================');

    textColor(yellow);
    Seek(Enfs, 0);
    for i := 0 to FileSize(Enfs) - 1 do
      begin
        Read(Enfs, E);

        CANTPACS := 0;
        EDADES := 0;

        Seek(His, 0);
        for j := 0 to FileSize(His) - 1 do
          begin
            Read(His, H);

            if (E.cod_enf = H.cod_enf) then
              begin
                Seek(Pacs, 0);
                for k := 0 to FileSize(Pacs) - 1 do
                  begin
                    Read(Pacs, G);

                    if (H.dni = G.dni) then
                      begin
                        CANTPACS := CANTPACS + 1;
                        EDADES := EDADES + G.edad;
                      end;
                  end;
              end;
          end;

        if ((EDADES = 0) and (CANTPACS = 0)) then
          begin
            EDADES := 0;
            CANTPACS := 1;
          end;
        PROMEDAD := EDADES / CANTPACS;
        WriteLn('CODIGO: ', E.cod_enf, ' - NOMBRE: ', E.desc_enf, ' - PROMEDIO DE EDADES DE LOS PACIENTES: ', PROMEDAD:4:2);
      end;

    ReadLn();
  end;
//--------------------------------------------------------------------------------------------------
procedure Estadistica3();
  var
    i, j, ATEN, CURA, NCURA: Integer;
  begin
    textColor(green);
    WriteLn('==========================================');
    WriteLn('|                                        |');
    WriteLn('|             ENFERMEDADES               |');
    WriteLn('|                                        |');
    WriteLn('==========================================');

    textColor(yellow);
    Seek(Enfs, 0);
    for i := 0 to FileSize(Enfs) - 1 do
      begin
        Read(Enfs, E);
        ATEN := 0;
        CURA := 0;
        NCURA := 0;

        Seek(His, 0);
        for j := 0 to FileSize(His) - 1 do
          begin
            Read(His, H);

            if (E.cod_enf = H.cod_enf) then
              begin
                if (H.curado = 's') or (H.curado = 'S') then CURA := CURA + 1;
                if (H.curado = 'n') or (H.curado = 'N') then NCURA := NCURA + 1;
                ATEN := ATEN + 1;
              end;
          end;

        WriteLn('CODIGO: ', E.cod_enf, ' - NOMBRE: ', E.desc_enf, ' - ATENDIDOS: ', ATEN, ' - CURADOS: ', CURA, ' - NO CURADOS: ',NCURA);
      end;

    ReadLn();
  end;
//--------------------------------------------------------------------------------------------------
procedure Estadistica4();
  var
    i, EDADMAYOR: Integer;
    DNIMAYOR: String[8];
  begin
    EDADMAYOR := 0;
    DNIMAYOR := '';

    for i := 0 to FileSize(Pacs) - 1 do
      begin
        Seek(Pacs, i);
        Read(Pacs, G);

        if (EDADMAYOR < G.edad) then
          begin
            DNIMAYOR := G.dni;
            EDADMAYOR := G.edad;
          end;
      end;

    WriteLn(DNIMAYOR,' ES EL PACIENTE MAS GRANDE CON ', EDADMAYOR, ' ANOS.');
    ReadLn();
  end;
//--------------------------------------------------------------------------------------------------
procedure Estadistica5();
  var
    i, j, TOTAL, CANT: Integer;
    PROVINCIA: String[30];

  begin
    TOTAL := 0;

    for i := 0 to FileSize(Pvs) - 1 do
      begin
        Seek(Pvs, i);
        Read(Pvs, P);

        CANT := 0;

        for j := 0 to FileSize(Pacs) - 1 do
          begin
            Seek(Pacs, j);
            Read(Pacs, G);

            if (P.cod_prov = G.cod_prov) then
              begin
                CANT := CANT + 1;
              end;
          end;

        if (TOTAL < CANT) then
          begin
            TOTAL := CANT;
            PROVINCIA := P.nom_prov;
          end;
      end;

    WriteLn('LA PROVINCIA ', PROVINCIA, ' FUE LA QUE MAS PACIENTES ATENDIO CON UN TOTAL DE ', TOTAL, ' PACIENTES.');
    ReadLn();
  end;
//--------------------------------------------------------------------------------------------------
procedure Estadistica6();
  var
    i, j, dia, mes, ano: Integer;
    error: Boolean;
  begin
    repeat
      WriteLn('Ingrese el dia (1 - 30).');
      repeat
        ReadLn(dia);
      until (dia >= 1) and (dia <= 30);

      WriteLn('Ingrese el mes (1 - 12).');
      repeat
        ReadLn(mes);
      until (mes >= 1) and (mes <= 12);

      WriteLn('Ingrese el ano (2000 - 2020).');
      repeat
        ReadLn(ano);
      until (ano >= 2000) and (ano <= 2020);

      clrscr;

      textColor(green);
      WriteLn('==========================================');
      WriteLn('               ',dia,'/',mes,'/',ano,'');
      WriteLn('==========================================');

      textColor(yellow);
      error := true;

      for i := 0 to FileSize(His) - 1 do
        begin
          Seek(His, i);
          Read(His, H);

          if (dia = H.fecha_ingreso.dia) and (mes = H.fecha_ingreso.mes) and (ano = H.fecha_ingreso.ano) then
            begin
              for j := 0 to FileSize(Enfs) - 1 do
                begin
                  Seek(Enfs, j);
                  Read(Enfs, E);

                  if (H.cod_enf = E.cod_enf) then WriteLn('DNI: ', H.dni, ' - ENFERMEDAD: ', E.desc_enf);
                  error := false;
                end;
            end;
        end;

      if (error = true) then
        begin
          textColor(red);
          WriteLn('No existe ninguna historia clinica con la fecha ingresada.');
          textColor(yellow);
        end;

      WriteLn('Desea averiguar sobre otra fecha? S / N');
      repeat
        ReadLn(TERMINAR);
      until (TERMINAR = 'S') or (TERMINAR = 's') or (TERMINAR = 'N') or (TERMINAR = 'n');

      clrscr;
    until (TERMINAR = 'N') or (TERMINAR = 'n');
  end;
//--------------------------------------------------------------------------------------------------
procedure Estadistica7();
  var
    CONT, i, k, j: Integer;
    codigo, auxCOD: String[3];
    auxDESC: String[30];
  begin
    repeat
      CONT := 0;
      textColor(green);
      WriteLn('==========================================');
      WriteLn('|                                        |');
      WriteLn('|             ENFERMEDADES               |');
      WriteLn('|                                        |');
      WriteLn('==========================================');

      textColor(yellow);
      for i := 0 to FileSize(Enfs) - 1 do
        begin
          Seek(Enfs, i);
          Read(Enfs, E);
          WriteLn('CODIGO: ', E.cod_enf, ' - NOMBRE: ', E.desc_enf);
        end;

      textColor(green);
      WriteLn('==========================================');

      textColor(yellow);
      WriteLn('Ingrese el codigo de la enfermedad');
      ReadLn(codigo);

      if (codigo <> '') then
        begin
          for i := 0 to FileSize(Enfs) - 1 do
            begin
              Seek(Enfs, i);
              Read(Enfs, E);
              if(E.cod_enf = codigo) then
                begin
                  auxCOD := codigo;
                  auxDESC := E.desc_enf;
                end;
            end;

          if (codigo = auxCOD) then
            begin
              for j := 0 to FileSize(His) - 1 do
                begin
                  Seek(His, j);
                  Read(His, H);

                  for k := 0 to FileSize(Pacs) - 1 do
                    begin
                      Seek(Pacs, k);
                      Read(Pacs, G);

                      if (H.dni = G.dni) and (codigo = H.cod_enf) then
                        begin
                          if (G.fallecido = 's') or (G.fallecido = 'S') then
                            begin
                              CONT := CONT + 1;
                            end;
                        end;       
                    end;
                end;

                WriteLn(CONT, ' PERSONAS FALLECIERON POR ',auxDESC, '.');

                WriteLn('Desea averiguar sobre otra enfermedad? S / N');
                repeat
                  ReadLn(TERMINAR);
                until (TERMINAR = 'S') or (TERMINAR = 's') or (TERMINAR = 'N') or (TERMINAR = 'n');

                clrscr;
            end
          else
            begin
              textColor(red);
              WriteLn('El codigo no existe.');
              textColor(yellow);
              WriteLn('Desea intentarlo de nuevo? S / N');
              repeat
                ReadLn(TERMINAR);
              until (TERMINAR = 'S') or (TERMINAR = 's') or (TERMINAR = 'N') or (TERMINAR = 'n');

              clrscr;
            end;
        end
      else
        begin
          textColor(red);
          WriteLn('El codigo no puede estar vacio.');
          textColor(yellow);
          WriteLn('Desea intentarlo de nuevo? S / N');
          repeat
            ReadLn(TERMINAR);
          until (TERMINAR = 'S') or (TERMINAR = 's') or (TERMINAR = 'N') or (TERMINAR = 'n');

          clrscr;
        end;
    until (TERMINAR = 'N') or (TERMINAR = 'n');
  end;
//--------------------------------------------------------------------------------------------------
procedure Estadistica8();
  var
    i, CONT: Integer;
    efector, auxEF: String[30];
  begin
    repeat
      CONT := 0;
      WriteLn('Ingrese un efector.');
      ReadLn(efector);

      if (efector <> '') then
        begin
          for i := 0 to FileSize(His) - 1 do
            begin
              Seek(His, i);
              Read(His, H);
              if(H.efector = efector) then
                begin
                  auxEF := efector;
                  CONT := CONT + 1;
                end;
            end;

          if (efector = auxEF) then
            begin
                clrscr;

                WriteLn(CONT, ' PERSONAS FUERON ATENDIDAS POR ',  UPCASE(efector), '.');

                WriteLn('Desea averiguar sobre otro efector? S / N');
                repeat
                  ReadLn(TERMINAR);
                until (TERMINAR = 'S') or (TERMINAR = 's') or (TERMINAR = 'N') or (TERMINAR = 'n');

                clrscr;
            end
          else
            begin
              textColor(red);
              WriteLn('El efector no existe.');
              textColor(yellow);
              WriteLn('Desea intentarlo de nuevo? S / N');
              repeat
                ReadLn(TERMINAR);
              until (TERMINAR = 'S') or (TERMINAR = 's') or (TERMINAR = 'N') or (TERMINAR = 'n');

              clrscr;
            end;
        end
      else
        begin
          textColor(red);
          WriteLn('El efector no puede ser un campo vacio.');
          textColor(yellow);
          WriteLn('Desea intentarlo de nuevo? S / N');
          repeat
            ReadLn(TERMINAR);
          until (TERMINAR = 'S') or (TERMINAR = 's') or (TERMINAR = 'N') or (TERMINAR = 'n');

          clrscr;
        end;
    until (TERMINAR = 'n') or (TERMINAR = 'N');
  end;
//--------------------------------------------------------------------------------------------------
procedure Opcion6();
  var
    OP1: Integer;

  begin
    WriteLn('Seleccione 1 para proseguir con la opcion o 0 para volver al menu.');
    repeat
      ReadLn(VOLVER);
    until (VOLVER = 0) or (VOLVER = 1);

    clrscr;

    if (VOLVER = 1) then
      begin
        Seek(Pvs, FileSize(Pvs));
        Seek(Sints, FileSize(Sints));
        Seek(Enfs, FileSize(Enfs));
        Seek(Pacs, FileSize(Pacs));
        Seek(His, FileSize(His));

        if (FilePos(Pvs) <> 0) and (FilePos(Sints) <> 0) and (FilePos(Enfs) <> 0) and (FilePos(Pacs) <> 0) and (FilePos(His) <> 0) then
          begin
            repeat
              clrscr;

              //MOSTRAR MENU
              textColor(green);
              WriteLn('------------------==Menu de Estadisticas==------------------');
              WriteLn('|                                                          |');
              WriteLn('|  1 - Sintomas                                            |');
              WriteLn('|  2 - Promedio de edades por enfermedad                   |');
              WriteLn('|  3 - Pacientes atendidos y curados por enfermedad        |');
              WriteLn('|  4 - Paciente mayor                                      |');
              WriteLn('|  5 - Provincia con mas enfermos atendidos                |');
              WriteLn('|  6 - Historias clinicas por fecha                        |');
              WriteLn('|  7 - Personas fallecidas por enfermedad                  |');
              WriteLn('|  8 - Pacientes atendidos por efector                     |');
              WriteLn('|  0 - Volver al menu                                      |');
              WriteLn('|                                                          |');
              WriteLn('------------------==Menu de Estadisticas==------------------');
              //INGRESAR OPCION
              repeat
                  textColor(yellow);
                  ReadLn(OP1);
              until (OP1 <= 8) or (OP1 >= 0);

              clrscr;

              case OP1 of
                  1: Estadistica1();
                  2: Estadistica2();
                  3: Estadistica3();
                  4: Estadistica4();
                  5: Estadistica5();
                  6: Estadistica6();
                  7: Estadistica7();
                  8: Estadistica8();
              end;
            until (OP1 = 0);
          end
        else
          begin
            textColor(red);
            WriteLn('Para mostrar las estadisticas primero debe completar las demas opciones.');
            textColor(yellow);
            ReadLn();
          end;
      end;

    clrscr;
  end;

//PRINCIPAL
BEGIN
  Asignabre();

  repeat
    //MOSTRAR MENU
    textColor(green);
    WriteLn('----------==Menu de Opciones==----------');
    WriteLn('|                                      |');
    WriteLn('|  1 - Provincias                      |');
    WriteLn('|  2 - Sintomas                        |');
    WriteLn('|  3 - Enfermedades                    |');
    WriteLn('|  4 - Pacientes                       |');
    WriteLn('|  5 - Historias Clinicas              |');
    WriteLn('|  6 - Estadisticas                    |');
    WriteLn('|  0 - Fin de programa                 |');
    WriteLn('|                                      |');
    WriteLn('----------==Menu de Opciones==----------');
    //INGRESAR OPCION
    repeat
        textColor(yellow);
        ReadLn(OP);
    until (OP <= 6) or (OP >= 0);

    clrscr;

    case OP of
        1: Opcion1();
        2: Opcion2();
        3: Opcion3();
        4: Opcion4();
        5: Opcion5();
        6: Opcion6();
    end;
  until (OP = 0);

  CerrarArchivos();
END.

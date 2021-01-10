unit UModelFuzzyExcel;

interface

uses ComObj;

Procedure OpenExcelPersonFuzzySet;
Procedure CloseExcelPersonFuzzySet(NameFile:string);
Procedure AddExcelPersonFuzzySet(var NomRow,NomCol:Longword; typeVivod:byte);
Procedure AddExcelTaskFuzzySet(var NomRow,NomCol:Longword; typeVivod:byte);

var
  Excel: Variant;
  CurrentDir:string;

implementation

uses UModelFuzzy;

Procedure OpenExcelPersonFuzzySet;
begin
Excel := CreateOleObject('Excel.Application');
Excel.Workbooks.add;
end;

Procedure CloseExcelPersonFuzzySet(NameFile:string);
begin
Excel.Workbooks[1].saveas(NameFile);
Excel.Workbooks.Close;
end;

Procedure AddExcelPersonFuzzySet(var NomRow,NomCol:Longword; typeVivod:byte);
var
  NomPerson,NomFuzzyZn:longword;
  NomRowNat,NomColNat,NomColMax:Longword;
begin
  Excel.Cells[NomRow,NomCol]:='Работники/Задачи/Множества';
  NomRowNat:=NomRow;
  NomColNat:=NomCol;
  NomColMax:=NomCol;
  inc(NomRow);
  NomPerson:=0;
  while NomPerson<Length(ArrFuzzyElPerson) do
    begin
    NomCol:=NomColNat;
    Excel.Cells[NomRow,NomCol]:=ArrFuzzyElPerson[NomPerson].Person;
    Excel.Cells[NomRow+1,NomCol]:=ArrFuzzyElPerson[NomPerson].Task;
    if (typeVivod=0) or (typeVivod=1) then
      begin
      NomCol:=NomColNat+2;
      NomFuzzyZn:=0;
      while NomFuzzyZn<Length(ArrFuzzyElPerson[NomPerson].FuzzySetTime) do
        begin
        Excel.Cells[NomRow,NomCol]:=ArrFuzzyElPerson[NomPerson].FuzzySetTime[NomFuzzyZn].Zn;
        Excel.Cells[NomRow+1,NomCol]:=ArrFuzzyElPerson[NomPerson].FuzzySetTime[NomFuzzyZn].FP;
        inc(NomCol);
        inc(NomFuzzyZn);
        end;
      end;
    if (typeVivod=0) or (typeVivod=2) then
      begin
      NomCol:=NomColNat+2;
      if (typeVivod=0) then
        begin
        NomRow:=NomRow+3;
        end;
      NomFuzzyZn:=0;
      while NomFuzzyZn<Length(ArrFuzzyElPerson[NomPerson].FuzzySetPr) do
        begin
        Excel.Cells[NomRow,NomCol]:=ArrFuzzyElPerson[NomPerson].FuzzySetPr[NomFuzzyZn].Zn;
        Excel.Cells[NomRow+1,NomCol]:=ArrFuzzyElPerson[NomPerson].FuzzySetPr[NomFuzzyZn].FP;
        inc(NomCol);
        inc(NomFuzzyZn);
        end;
      end;
    if NomCol>NomColMax then
      NomColMax:=NomCol;
    inc(NomPerson);
    NomRow:=NomRow+3;
    end;
  NomCol:=NomColMax;
end;

Procedure AddExcelTaskFuzzySet(var NomRow,NomCol:Longword; typeVivod:byte);
var
  NomTask,NomPerson,NomFuzzyZn:longword;
  NomRowNat,NomColNat,NomColMax:Longword;
  SumKrit:Double;
begin
  Excel.Cells[NomRow,NomCol]:='Параметры';
  Excel.Cells[NomRow,NomCol]:='TypeTopPerson='; Excel.Cells[NomRow,NomCol+1]:=TypeTopPerson;
  Excel.Cells[NomRow,NomCol+2]:='TypeInteraction='; Excel.Cells[NomRow,NomCol+3]:=TypeInteraction;
  Excel.Cells[NomRow,NomCol+4]:='KoefInteraction='; Excel.Cells[NomRow,NomCol+5]:=KoefInteraction;
  Excel.Cells[NomRow,NomCol+6]:='TypeKritDefazificatcion='; Excel.Cells[NomRow,NomCol+7]:=TypeKritDefazificatcion;
  Excel.Cells[NomRow,NomCol+8]:='ParKritDefazification='; Excel.Cells[NomRow,NomCol+9]:=ParKritDefazification;
  inc(NomRow);
  SumKrit:=0;
  NomTask:=0;
  while NomTask<Length(ArrFuzzyTask) do
    begin
    SumKrit:=SumKrit+ArrFuzzyTask[NomTask].KritDefazification;
    inc(NomTask);
    end;
  Excel.Cells[NomRow,NomCol]:='krit='; Excel.Cells[NomRow,NomCol+1]:=SumKrit;
  inc(NomRow);
  Excel.Cells[NomRow,NomCol]:='Задачи/Назначеные работники/Множества';
  NomRowNat:=NomRow;
  NomColNat:=NomCol;
  NomColMax:=NomCol;
  inc(NomRow);
  NomTask:=0;
  while NomTask<Length(ArrFuzzyTask) do
    begin
    NomCol:=NomColNat;
    Excel.Cells[NomRow,NomCol]:=ArrFuzzyTask[NomTask].Task;
    Excel.Cells[NomRow,NomCol+1]:=ArrFuzzyTask[NomTask].NomPersonMinTime;
    Excel.Cells[NomRow,NomCol+2]:=ArrFuzzyTask[NomTask].ParPersonMinTime;
    Excel.Cells[NomRow+2,NomCol]:=ArrFuzzyTask[NomTask].KritDefazification;
    Excel.Cells[NomRow+3,NomCol]:=ArrFuzzyTask[NomTask].SumTimeToInteraction;
    NomCol:=NomCol+4;

    NomPerson:=0;
    while NomPerson<Length(ArrFuzzyTask[NomTask].ArrPerson) do
      begin
      Excel.Cells[NomRow,NomCol]:=ArrFuzzyTask[NomTask].ArrPerson[NomPerson];
      inc(NomCol);
      inc(NomPerson);
      end;
    if NomCol>NomColMax then
      NomColMax:=NomCol;

    NomRow:=NomRow+2;

    if (typeVivod=0) or (typeVivod=1) then
      begin
      NomFuzzyZn:=0;
      NomCol:=NomColNat+2;
      while NomFuzzyZn<Length(ArrFuzzyTask[NomTask].FuzzySetTime) do
        begin
        Excel.Cells[NomRow,NomCol]:=ArrFuzzyTask[NomTask].FuzzySetTime[NomFuzzyZn].Zn;
        Excel.Cells[NomRow+1,NomCol]:=ArrFuzzyTask[NomTask].FuzzySetTime[NomFuzzyZn].FP;
        inc(NomCol);
        inc(NomFuzzyZn);
        end;
      end;
    if (typeVivod=0) or (typeVivod=2) then
      begin
      NomCol:=NomColNat+2;
      if (typeVivod=0) then
        begin
        NomRow:=NomRow+3;
        end;
      NomFuzzyZn:=0;
      while NomFuzzyZn<Length(ArrFuzzyTask[NomTask].FuzzySetPr) do
        begin
        Excel.Cells[NomRow,NomCol]:=ArrFuzzyTask[NomTask].FuzzySetPr[NomFuzzyZn].Zn;
        Excel.Cells[NomRow+1,NomCol]:=ArrFuzzyTask[NomTask].FuzzySetPr[NomFuzzyZn].FP;
        inc(NomCol);
        inc(NomFuzzyZn);
        end;
      end;
    if NomCol>NomColMax then
      NomColMax:=NomCol;
    inc(NomTask);
    NomRow:=NomRow+3;
    end;
  NomCol:=NomColMax;
end;

end.

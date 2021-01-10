unit UCPM;

interface

type

  TPrevTask = record
    NomTask,TaskTime:Longword;
  end;
  TaskCPM = record
            ID:Longword;
            Mode:byte;
            Level:byte;
            Name:string;
            Duration:Longword;
            DurationSetting:byte;
 //           FrizzyDuration
            Start,Finish:TDateTime;
            RS,RF,PS,PF:TDateTime;
            Prev:array of TPrevTask;
            Person:string;
            LaborCosts:Double;
            end;

Procedure GoCPM(FirstDate:TDateTime);
Procedure LoadCPMAtExcel(FileNameCPM:string);
Procedure LoadCPMPersonAtExcel(FileNameCPMPerson:string);

Var
KolTaskCPM:Longword;
ArrTaskCPM:array of TaskCPM;

implementation

uses UMain,ComObj, SysUtils;

Procedure GoCPM(FirstDate:TDateTime);
var
TaskNotCPM,TaskPrev,TaskPrevTime:array of Longword;
LenTaskPrev:Longword;
CurrentDate,MaxRSDate:TDateTime;
NomTaskCPM,i,j:Longword;
BTask:boolean;

procedure GoRSRF(StartDate:TDateTime; NomTask:Longword);
var
i,j:Longword;
begin
ArrTaskCPM[TaskNotCPM[NomTask]].RS:=StartDate; //Вычисляем ранний старт .
i:=1;
j:=ArrTaskCPM[TaskNotCPM[NomTask]].Duration;
while i<=j do
  begin
  if (DayOfWeek(CurrentDate+i)=6) then j:=j+2;     //Учет выходных
  inc(i);
  end;
ArrTaskCPM[TaskNotCPM[NomTask]].RF:=StartDate+i-1;  //Вычисляем ранний финиш
end;

begin

CurrentDate:=FirstDate;
//Создать массив TASK
SetLength(TaskNotCPM,KolTaskCPM);
for NomTaskCPM := 0 to KolTaskCPM-1 do
  TaskNotCPM[NomTaskCPM]:=NomTaskCPM;

//Вычисление Ранний Старт и Ранний Финиш
//Пока не рассмотрены все задачи
NomTaskCPM:=0;
while (NomTaskCPM<KolTaskCPM) do
  begin
  //Проверка есть ли зависимости
  if Length(ArrTaskCPM[TaskNotCPM[NomTaskCPM]].Prev)<>0 then
    begin  //Если есть, то
    LenTaskPrev:=Length(ArrTaskCPM[TaskNotCPM[NomTaskCPM]].Prev);
    SetLength(TaskPrev,LenTaskPrev); //Создать массив всех зависимостей
    SetLength(TaskPrevTime,LenTaskPrev);
    for I := 0 to LenTaskPrev-1 do
      begin
      TaskPrev[i]:=ArrTaskCPM[TaskNotCPM[NomTaskCPM]].Prev[i].NomTask-1;
      TaskPrevTime[i]:=ArrTaskCPM[TaskNotCPM[NomTaskCPM]].Prev[i].TaskTime;
      end;
    //Проверить выполнение зависимостей
    MaxRSDate:=0;
    i:=0;
    while i<LenTaskPrev do
      begin
      if ArrTaskCPM[TaskPrev[i]].RF<>0 then //Проверка на выполнение предыдущей задачи
        begin
        //Вычислить максимальный Ранний старт
        if (TaskPrevTime[i]=0) and (MaxRSDate<ArrTaskCPM[TaskPrev[i]].RF) then
          MaxRSDate:=ArrTaskCPM[TaskPrev[i]].RF;
        if (TaskPrevTime[i]<>0) and (MaxRSDate<ArrTaskCPM[TaskPrev[i]].RS+TaskPrevTime[i]) then
          MaxRSDate:=ArrTaskCPM[TaskPrev[i]].RS+TaskPrevTime[i];
        //Удалить эту задачу из списка
        for j := i+1 to LenTaskPrev-1 do
          begin
          TaskPrev[j-1]:=TaskPrev[j];
          TaskPrevTime[j-1]:=TaskPrevTime[j];
          end;
        dec(LenTaskPrev);
        SetLength(TaskPrev,LenTaskPrev);
        SetLength(TaskPrevTime,LenTaskPrev);
        end
      else
        inc(i);
      end;
    if Length(TaskPrev)=0 then
      begin //Если зависимости выполнены, то
      GoRSRF(MaxRSDate,NomTaskCPM);
      inc(NomTaskCPM);
      end
    else
      begin //Если зависимости НЕ выполнены, то
      //Переставить местами Task
      FMain.MeProt.Lines.Add('Модуль не дописан. Перестановка задач Task Ошибка на Task №'+IntToStr(NomTaskCPM));
      inc(NomTaskCPM);
      end;

    end
  else
    begin  //Если зависимостей нет, то
    GoRSRF(CurrentDate,NomTaskCPM);
    inc(NomTaskCPM);
    end;
  end;
//Вычисление Поздний Старт и Поздний Финиш
//Пока не рассмотрены все задачи
NomTaskCPM:=KolTaskCPM;
while (NomTaskCPM>0) do
  begin
  Dec(NomTaskCPM);
  end;
end;

Function SearchTaskPLMName(NameTask:string):Longword;
var
NomSearch:Longword;
  begin
  NomSearch:=0;
  while (NomSearch<Length(ArrTaskCPM)) and (ArrTaskCPM[NomSearch].Name<>NameTask) do
    inc(NomSearch);
  If NomSearch<Length(ArrTaskCPM) then
  Result:=NomSearch
  else
  Result:=Maxint;
  end;

Function GoToDateTime(st:string):TDateTime;
var
st1:string;
begin
if st<>'' then
begin
st1:=copy(st,1,2)+'.';
Delete(st,1,Pos(' ',st));
if Pos('Январь',st)<>0 then  st1:=st1+'01.'
else if Pos('Февраль',st)<>0 then  st1:=st1+'02.'
else if Pos('Март',st)<>0 then  st1:=st1+'03.'
else if Pos('Апрель',st)<>0 then  st1:=st1+'04.'
else if Pos('Май',st)<>0 then  st1:=st1+'05.'
else if Pos('Июнь',st)<>0 then  st1:=st1+'06.'
else if Pos('Июль',st)<>0 then  st1:=st1+'07.'
else if Pos('Август',st)<>0 then  st1:=st1+'08.'
else if Pos('Сентябрь',st)<>0 then  st1:=st1+'09.'
else if Pos('Октябрь',st)<>0 then  st1:=st1+'10.'
else if Pos('Ноябрь',st)<>0 then  st1:=st1+'11.'
else if Pos('Декабрь',st)<>0 then  st1:=st1+'12.';
Delete(st,1,Pos(' ',st));
st1:=st1+copy(st,1,Pos(' ',st)-1);
Result:=StrToDateTime(st1);
end
else
Result:=0;
end;

Procedure LoadCPMAtExcel(FileNameCPM:string);
var
NomRow:Longword;
st,st1,st2:string;
KolPrevTask:longword;
Drt:Longword;
k:integer;
  begin
  Excel := CreateOleObject('Excel.Application');
  Excel.Workbooks.open(FileNameCPM);
  SetLength(ArrTaskCPM,0);
  KolTaskCPM:=0;
  NomRow:=2;
  st:=Excel.Cells[NomRow,1];
  while st<>'' do
    begin
    SetLength(ArrTaskCPM,KolTaskCPM+1);
    ArrTaskCPM[KolTaskCPM].ID:=StrToInt(st);
    st:=Excel.Cells[NomRow,3];
    If st='Планирование вручную' then ArrTaskCPM[KolTaskCPM].Mode:=1 else ArrTaskCPM[KolTaskCPM].Mode:=0;
    ArrTaskCPM[KolTaskCPM].Name:=Excel.Cells[NomRow,4];
    st:=Excel.Cells[NomRow,5];
    if Pos('?',st)<>0 then ArrTaskCPM[KolTaskCPM].DurationSetting:=1 else ArrTaskCPM[KolTaskCPM].DurationSetting:=0;
    val(st,Drt,k);
    ArrTaskCPM[KolTaskCPM].Duration:=Drt;
    ArrTaskCPM[KolTaskCPM].Start:=GoToDateTime(Excel.Cells[NomRow,6]);
    ArrTaskCPM[KolTaskCPM].Finish:=GoToDateTime(Excel.Cells[NomRow,7]);
    ArrTaskCPM[KolTaskCPM].RS:=0; ArrTaskCPM[KolTaskCPM].RF:=0;
    ArrTaskCPM[KolTaskCPM].PS:=0; ArrTaskCPM[KolTaskCPM].PF:=0;
    st:=Excel.Cells[NomRow,8];
    KolPrevTask:=0;
    while st<>'' do
      begin
      if Pos(';',st)<>0 then
        begin
        st1:=copy(st,1,Pos(';',st)-1);
        Delete(st,1,Pos(';',st));
        end
      else
        begin
        st1:=st;
        st:='';
        end;
      SetLength(ArrTaskCPM[KolTaskCPM].Prev,KolPrevTask+1);
      if Pos('ОН-',st1)<>0 then
        begin
        st2:=copy(st1,Pos('-',st1)+1,Pos('д',st1)-Pos('-',st1)-1);
        Delete(st1,Pos('О',st1),Length(st1)-Pos('О',st1)+1);
        end
      else st2:='0';

      ArrTaskCPM[KolTaskCPM].Prev[KolPrevTask].NomTask:=StrToInt(st1);
      ArrTaskCPM[KolTaskCPM].Prev[KolPrevTask].TaskTime:=StrToInt(st2);
      inc(KolPrevTask);
      end;
    ArrTaskCPM[KolTaskCPM].Level:=Excel.Cells[NomRow,9];
    inc(KolTaskCPM);
    inc(NomRow);
    st:=Excel.Cells[NomRow,1];
    end;
  Excel.Workbooks.Close;
  Excel.Quit;
  end;

Procedure LoadCPMPersonAtExcel(FileNameCPMPerson:string);
var
NomRow:Longword;
st:string;
NomTaskCPM:Longword;
  begin
  Excel := CreateOleObject('Excel.Application');
  Excel.Workbooks.open(FileNameCPMPerson);
  NomRow:=2;
  st:=Excel.Cells[NomRow,1];
  while st<>'' do
    begin
    NomTaskCPM:=SearchTaskPLMName(st);
    if NomTaskCPM<>Maxint then
      begin

      ArrTaskCPM[NomTaskCPM].Person:=Excel.Cells[NomRow,2];
      st:=Excel.Cells[NomRow,4];
      while (Pos(' ',st)<>0)  do
        delete(st,Pos(' ',st),1);
      while (Pos('ч',st)<>0)  do
        delete(st,Pos('ч',st),1);
      ArrTaskCPM[NomTaskCPM].LaborCosts:=StrToFloat(st);
      end;
    inc(NomRow);
    st:=Excel.Cells[NomRow,1];
    end;
  Excel.Workbooks.Close;
  Excel.Quit;
  end;

end.

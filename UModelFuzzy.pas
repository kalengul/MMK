unit UModelFuzzy;

interface

uses SysUtils;

type

TMemberFEl = record
            FP,Zn:Double;
end;

TFuzzyElement = record
  FuzzySetPr,FuzzySetTime:array of TMemberFEl;
  Person,Task:Longword;
end;

TFuzzyTask = record
  FuzzySetPr,FuzzySetTime:array [0..255] of TMemberFEl;
  KolFuzzySet,KolPersonOnTask:Word;
  NomPersonMinTime:Longword;
  ParPersonMinTime:double;
  SumTimeToInteraction:double;
  Task:Longword;
  ArrPerson:array [0..100] of Longword;
  KritDefazification,TimeTiInteraction:double;
end;

Procedure GoStartFuzzy;
Procedure AllPersonOneTaskFuzzy;
Procedure GoFuzzyTask;
Procedure LoadFuzzyElTextFile(NameFile:String);
Procedure CreateArrFuzzyTask(KolTask:Longword);
Procedure AddPersonTask(NomPerson,NomTask:Longword);
Procedure TimeToPrAllFuzzyElement;
Procedure TimeToPrFuzzyElement(NomElement:Longword);
Function SearchFuzzyElPerson(NomPerson,NomTask:Longword):Longword;
Procedure CreateSetting;
Procedure ClearAllTask;
Procedure ClearAllPersonTask;

Procedure CreateFuzzySet(NomTask:Longword);
Procedure GoInteractionPerson(NomTask:Longword);
Procedure PrToTime(NomTask:Longword);
Procedure CalcKritDefazification(NomTask:Longword);
procedure Clear(NomTask:Longword);

Var
ArrFuzzyElPerson:array of  TFuzzyElement;
ArrFuzzyTask:array of TFuzzyTask;
KolTask,KolPerson:Longword;
TypeTopPerson:byte;  //0-Наименьшее время точного выполнения работы 1-Наименьшее время возможного выполнения работы 2-Наименьшее математическое ожидание времени выполнения работы
TypeInteraction:byte; //0-Разница точного времени работы 1- Разница возможного времени работы 2-Разница математических ожиданий 3-???
KoefInteraction:double;
TypeKritDefazificatcion:byte;
ParKritDefazification:double;

implementation

Procedure CreateSetting;
 begin
 TypeTopPerson:=1;  //0-Наименьшее время точного выполнения работы 1-Наименьшее время возможного выполнения работы 2-Наименьшее математическое ожидание времени выполнения работы
 TypeInteraction:=1; //0-Разница точного времени работы 1- Разница возможного времени работы 2-Разница математических ожиданий 3-???
 KoefInteraction:=0.001;
 TypeKritDefazificatcion:=1;
 ParKritDefazification:=0.75;
 end;

Procedure CreateFuzzySet(NomTask:Longword);
var
AllFP:array [1..255] of Double;
n,i,j,NomFS,
imax,
NomPerson,NomArrPerson,
NomPersonFp:Longword;
MaxTime,max,SumAtMaxTime:Double;
k,b:Double;
begin
//Создание множества всех точек функции принадлежности
MaxTime:=0;
n:=0;
if ArrFuzzyTask[NomTask].KolPersonOnTask<>0 then
for NomPerson := 0 to ArrFuzzyTask[NomTask].KolPersonOnTask-1 do
  begin
  NomArrPerson:=SearchFuzzyElPerson(ArrFuzzyTask[NomTask].ArrPerson[NomPerson],ArrFuzzyTask[NomTask].Task);
  if NomArrPerson<Length(ArrFuzzyElPerson) then
  begin
  if Length(ArrFuzzyElPerson[NomArrPerson].FuzzySetPr)>0 then
  for NomPersonFp := 0 to Length(ArrFuzzyElPerson[NomArrPerson].FuzzySetPr)-1 do
    begin
    //Поиск самого профессионального работника из комманды
      case TypeTopPerson of
      0: if (ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[NomPersonFp].FP=0) and (ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[NomPersonFp].Zn>MaxTime) then
        begin
        MaxTime:=ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[NomPersonFp].Zn;
        ArrFuzzyTask[NomTask].NomPersonMinTime:=NomArrPerson;
        ArrFuzzyTask[NomTask].ParPersonMinTime:=MaxTime;
        end;
      1: if (ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[NomPersonFp].FP=1) and (ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[NomPersonFp].Zn>MaxTime) then
        begin
        MaxTime:=ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[NomPersonFp].Zn;
        ArrFuzzyTask[NomTask].NomPersonMinTime:=NomArrPerson;
        ArrFuzzyTask[NomTask].ParPersonMinTime:=MaxTime;
        end;
      end;
    i:=0;
//    if n>0 then
    While (i<n) and (AllFp[i]<>ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[NomPersonFp].FP) do
      inc(i);
    if i=n then
      begin
      inc(n);
      AllFp[n-1]:=ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[NomPersonFp].FP;
      end;
    end;
    if (TypeTopPerson=2) and (ArrFuzzyTask[NomTask].KolFuzzySet>0) then
    begin
    SumAtMaxTime:=0;
    for NomPersonFp := 0 to ArrFuzzyTask[NomTask].KolFuzzySet-1 do
       SumAtMaxTime:=SumAtMaxTime+ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[NomPersonFp].FP*ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[NomPersonFp].Zn;
    if (SumAtMaxTime>MaxTime) then
      begin
      MaxTime:=SumAtMaxTime;
      ArrFuzzyTask[NomTask].NomPersonMinTime:=NomArrPerson;
      ArrFuzzyTask[NomTask].ParPersonMinTime:=SumAtMaxTime;
      end;
    end;
  end;
  end;
//Сортировка множества
ArrFuzzyTask[NomTask].KolFuzzySet:=n;
if n>0 then
for i := 0 to n-1 do
  begin
  max:=AllFp[i];
  imax:=i;
  for j := i+1 to n-1 do
    if AllFp[j]>max then
      begin
      max:=AllFp[j];
      imax:=j;
      end;
  //Запомнить значение функции принадлежности в итоговом множестве задачи
  ArrFuzzyTask[NomTask].FuzzySetPr[i].FP:=max;
  ArrFuzzyTask[NomTask].FuzzySetPr[i].Zn:=0;
  if imax<>i then
    begin
    AllFp[imax]:=AllFp[i];
    AllFp[i]:=max;
    end;
  end;
//Посик значений х для каждой точки функции принадлежности
if n>0 then
for NomFS := 0 to n-1 do   //Пройти по всем точкам функции принадлежности
  begin
  if ArrFuzzyTask[NomTask].KolPersonOnTask<>0 then
  for NomPerson := 0 to ArrFuzzyTask[NomTask].KolPersonOnTask-1 do  //Для каждого значения пройти по всем работникам
    begin
    NomArrPerson:=SearchFuzzyElPerson(ArrFuzzyTask[NomTask].ArrPerson[NomPerson],ArrFuzzyTask[NomTask].Task);  //Поиск работника в общем множестве
    if NomArrPerson<Length(ArrFuzzyElPerson) then
      begin
      i:=0;                  //Поиск у работника ближайшего значения функции принадлежности
      while (i<ArrFuzzyTask[NomTask].KolFuzzySet) and (ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[i].FP>ArrFuzzyTask[NomTask].FuzzySetPr[NomFS].FP) do
        inc(i);
      //Проверка на точное совпадение
      if (i<ArrFuzzyTask[NomTask].KolFuzzySet) and (ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[i].FP=ArrFuzzyTask[NomTask].FuzzySetPr[NomFS].FP) then
        ArrFuzzyTask[NomTask].FuzzySetPr[NomFS].Zn:=ArrFuzzyTask[NomTask].FuzzySetPr[NomFS].Zn+ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[i].Zn
      else  //Если нет поиск линейной зависимости
      if (i<ArrFuzzyTask[NomTask].KolFuzzySet) then
        begin
        k:=(ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[i].Zn-ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[i-1].Zn)/(ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[i].FP-ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[i-1].FP);
        b:=ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[i].Zn-k*ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[i].FP;
        ArrFuzzyTask[NomTask].FuzzySetPr[NomFS].Zn:=ArrFuzzyTask[NomTask].FuzzySetPr[NomFS].Zn+ArrFuzzyTask[NomTask].FuzzySetPr[NomFS].FP*k+b;
        end;
      end;
    end;
  end;
end;

Procedure GoInteractionPerson(NomTask:Longword);
var
  NomPerson,NomArrPerson,NomPersonFp,NomTaskTime,NomPersonFpMinTime:Longword;
  SumAtMaxTime,MaxDelta:double;
begin
ArrFuzzyTask[NomTask].SumTimeToInteraction:=0;
if ArrFuzzyTask[NomTask].KolPersonOnTask<>0 then
for NomPerson := 0 to ArrFuzzyTask[NomTask].KolPersonOnTask-1 do
  begin
  NomArrPerson:=SearchFuzzyElPerson(ArrFuzzyTask[NomTask].ArrPerson[NomPerson],ArrFuzzyTask[NomTask].Task);
  if NomArrPerson<Length(ArrFuzzyElPerson) then
    begin
    SumAtMaxTime:=0;
    MaxDelta:=0;
    if Length(ArrFuzzyElPerson[NomArrPerson].FuzzySetTime)>0 then
    for NomPersonFp := 0 to Length(ArrFuzzyElPerson[NomArrPerson].FuzzySetTime)-1 do
    if NomPersonFp<>ArrFuzzyTask[NomTask].NomPersonMinTime then
      begin
      //Тут проходим по всем значения функции принадлежности ТЕКУЩЕГО работника
      If (TypeInteraction=2) then
       SumAtMaxTime:=SumAtMaxTime+ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[NomPersonFp].FP*ArrFuzzyElPerson[NomArrPerson].FuzzySetPr[NomPersonFp].Zn;
      if (Length(ArrFuzzyElPerson[ArrFuzzyTask[NomTask].NomPersonMinTime].FuzzySetTime)>0) and
         ((TypeInteraction=0) or (TypeInteraction=1) or (TypeInteraction=3)) then
      for NomPersonFpMinTime := 0 to Length(ArrFuzzyElPerson[ArrFuzzyTask[NomTask].NomPersonMinTime].FuzzySetTime)-1 do
        begin
        //Тут проходим по всем значения функции принадлежности ЛУЧШЕГО работника
          If (TypeInteraction=0) and
          (ArrFuzzyElPerson[NomArrPerson].FuzzySetTime[NomPersonFp].FP=1) and
          (ArrFuzzyElPerson[ArrFuzzyTask[NomTask].NomPersonMinTime].FuzzySetTime[NomPersonFpMinTime].FP=1) then
            ArrFuzzyTask[NomTask].SumTimeToInteraction:=ArrFuzzyTask[NomTask].SumTimeToInteraction+abs(ArrFuzzyElPerson[ArrFuzzyTask[NomTask].NomPersonMinTime].FuzzySetTime[NomPersonFpMinTime].Zn-ArrFuzzyElPerson[NomArrPerson].FuzzySetTime[NomPersonFp].Zn);
          If (TypeInteraction=1) and
          (ArrFuzzyElPerson[NomArrPerson].FuzzySetTime[NomPersonFp].FP=0) and
          (ArrFuzzyElPerson[ArrFuzzyTask[NomTask].NomPersonMinTime].FuzzySetTime[NomPersonFpMinTime].FP=0) then
            ArrFuzzyTask[NomTask].SumTimeToInteraction:=ArrFuzzyTask[NomTask].SumTimeToInteraction+abs(ArrFuzzyElPerson[ArrFuzzyTask[NomTask].NomPersonMinTime].FuzzySetTime[NomPersonFpMinTime].Zn-ArrFuzzyElPerson[NomArrPerson].FuzzySetTime[NomPersonFp].Zn);
          If (TypeInteraction=3) and
          (MaxDelta<abs(ArrFuzzyElPerson[ArrFuzzyTask[NomTask].NomPersonMinTime].FuzzySetTime[NomPersonFpMinTime].Zn-ArrFuzzyElPerson[NomArrPerson].FuzzySetTime[NomPersonFp].Zn)) then
            MaxDelta:=abs(ArrFuzzyElPerson[ArrFuzzyTask[NomTask].NomPersonMinTime].FuzzySetTime[NomPersonFpMinTime].Zn-ArrFuzzyElPerson[NomArrPerson].FuzzySetTime[NomPersonFp].Zn);
        end;
      end;
    If (TypeInteraction=2) then
      ArrFuzzyTask[NomTask].SumTimeToInteraction:=ArrFuzzyTask[NomTask].SumTimeToInteraction+abs(ArrFuzzyTask[NomTask].ParPersonMinTime-SumAtMaxTime);
    If (TypeInteraction=3) then
      ArrFuzzyTask[NomTask].SumTimeToInteraction:=ArrFuzzyTask[NomTask].SumTimeToInteraction+MaxDelta;
    end;
  end;
//Учет полученного времени взаимодействия для времени выполнения задачи.
if (TypeInteraction<4) then
if Length(ArrFuzzyTask[NomTask].FuzzySetTime)<>0 then
for NomTaskTime := 0 to Length(ArrFuzzyTask[NomTask].FuzzySetTime)-1 do
  ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime].Zn:=ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime].Zn+KoefInteraction*ArrFuzzyTask[NomTask].SumTimeToInteraction;
ArrFuzzyTask[NomTask].TimeTiInteraction:=KoefInteraction*ArrFuzzyTask[NomTask].SumTimeToInteraction;
end;

Procedure PrToTime(NomTask:Longword);
var
NomElementFuzzy,n:Longword;
begin
n:=ArrFuzzyTask[NomTask].KolFuzzySet;
if n>0 then
for NomElementFuzzy := 0 to n-1 do
  begin
  ArrFuzzyTask[NomTask].FuzzySetTime[NomElementFuzzy].FP:=1-ArrFuzzyTask[NomTask].FuzzySetPr[NomElementFuzzy].FP;
//  If ArrFuzzyTask[NomTask].FuzzySetPr[NomElementFuzzy].Zn<>0 then
  ArrFuzzyTask[NomTask].FuzzySetTime[NomElementFuzzy].Zn:=1/ArrFuzzyTask[NomTask].FuzzySetPr[NomElementFuzzy].Zn;
  end;
end;

Procedure CalcKritDefazification(NomTask:Longword);
var
  NomTaskTime:Longword;
  MOParDefazification,LA2ParDefazification:double;
  k,b:Double;
begin
if Length(ArrFuzzyTask[NomTask].FuzzySetTime)<>0 then begin
case TypeKritDefazificatcion of
  0:ArrFuzzyTask[NomTask].KritDefazification:=ArrFuzzyTask[NomTask].FuzzySetTime[Length(ArrFuzzyTask[NomTask].FuzzySetTime)-1].Zn;
  1:ArrFuzzyTask[NomTask].KritDefazification:=ArrFuzzyTask[NomTask].FuzzySetTime[0].Zn;
else
  begin
  NomTaskTime:=0;
  MOParDefazification:=0;
  LA2ParDefazification:=0;
  while (NomTaskTime<length(ArrFuzzyTask[NomTask].FuzzySetTime)) and
        (not ((TypeKritDefazificatcion=2) and (ParKritDefazification>ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime].FP))) do
    begin
    if (TypeKritDefazificatcion=3) or (TypeKritDefazificatcion=4) then
      begin
      MOParDefazification:=MOParDefazification+ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime].FP*ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime].Zn;
      LA2ParDefazification:=LA2ParDefazification+ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime].FP*sqr(ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime].Zn);
      end;
    inc(NomTaskTime);
    end;
  case TypeKritDefazificatcion of
  2:begin
    k:=(ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime].Zn-ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime-1].Zn)/(ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime].FP-ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime-1].FP);
    b:=ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime].Zn-k*ArrFuzzyTask[NomTask].FuzzySetTime[NomTaskTime].FP;
    ArrFuzzyTask[NomTask].KritDefazification:=ParKritDefazification*k+b;
    end;
  3: ArrFuzzyTask[NomTask].KritDefazification:=MOParDefazification;
  4: ArrFuzzyTask[NomTask].KritDefazification:=LA2ParDefazification-sqr(MOParDefazification);
  end;
  end;
end;
end
else
  ArrFuzzyTask[NomTask].KritDefazification:=MaxInt;
end;

procedure Clear(NomTask:Longword);
begin
ArrFuzzyTask[NomTask].KolFuzzySet:=0;
ArrFuzzyTask[NomTask].KolPersonOnTask:=0;
ArrFuzzyTask[NomTask].NomPersonMinTime:=0;
ArrFuzzyTask[NomTask].ParPersonMinTime:=0;
ArrFuzzyTask[NomTask].KritDefazification:=0;
end;

Procedure ClearAllTask;
var
NomTask:longword;
begin
NomTask:=0;
while NomTask<Length(ArrFuzzyTask) do
  begin
  Clear(NomTask);
  inc(NomTask);
  end;
end;

Procedure TimeToPrFuzzyElement(NomElement:Longword);
var
NomElementFuzzy,n:Longword;
begin
if NomElement<Length(ArrFuzzyElPerson) then
begin
n:=Length(ArrFuzzyElPerson[NomElement].FuzzySetTime);
SetLength(ArrFuzzyElPerson[NomElement].FuzzySetPr,n);
for NomElementFuzzy := 0 to n-1 do
  begin
  ArrFuzzyElPerson[NomElement].FuzzySetPr[NomElementFuzzy].FP:=1-ArrFuzzyElPerson[NomElement].FuzzySetTime[NomElementFuzzy].FP;
  ArrFuzzyElPerson[NomElement].FuzzySetPr[NomElementFuzzy].Zn:=1/ArrFuzzyElPerson[NomElement].FuzzySetTime[NomElementFuzzy].Zn;
  end;
end;
end;

Procedure TimeToPrAllFuzzyElement;
var
NomElement:Longword;
begin
if Length(ArrFuzzyElPerson)<>0 then
for NomElement := 0 to Length(ArrFuzzyElPerson)-1 do
  TimeToPrFuzzyElement(NomElement);
end;

Function SearchFuzzyElPerson(NomPerson,NomTask:Longword):Longword;
var
i:Longword;
begin
i:=0;
While (i<Length(ArrFuzzyElPerson)) and not ((ArrFuzzyElPerson[i].Person=NomPerson) and (ArrFuzzyElPerson[i].Task=NomTask)) do
  inc(i);
Result:=i;
end;

Procedure ClearAllPersonTask;
var
NomTask:Longword;
begin
NomTask:=0;
While NomTask<Length(ArrFuzzyTask) do
  begin
  ArrFuzzyTask[NomTask].KolPersonOnTask:=0;
  inc(NomTask);
  end;
end;

Procedure AddPersonTask(NomPerson,NomTask:Longword);
var
n:Longword;
begin
if NomTask<Length(ArrFuzzyTask) then
  begin
  Inc(ArrFuzzyTask[NomTask].KolPersonOnTask);
  ArrFuzzyTask[NomTask].ArrPerson[ArrFuzzyTask[NomTask].KolPersonOnTask-1]:=NomPerson;
  end;
end;

Procedure CreateArrFuzzyTask(KolTask:Longword);
var
i:Longword;
begin
SetLength(ArrFuzzyTask,KolTask);
for I := 0 to KolTask-1 do
  begin
  ArrFuzzyTask[i].Task:=i;
  end;
end;

Procedure LoadFuzzyElTextFile(NameFile:String);
  var
  f:TextFile;
  st,st1:String;
  n,m:Longword;
  begin
  AssignFile(f,NameFile);
  Reset(f);
  Readln(f,st);
  KolTask:=StrToInt(st);
  Readln(f,st);
  KolPerson:=StrToInt(st);
  n:=0;
  SetLength(ArrFuzzyElPerson,n);
  while not EOF(f) do
    begin
    readln(f,st);
    inc(n);
    SetLength(ArrFuzzyElPerson,n);
    ArrFuzzyElPerson[n-1].Person:=StrToInt(st);
    Readln(f,st);
    ArrFuzzyElPerson[n-1].Task:=StrToInt(st);
    m:=0;
    SetLength(ArrFuzzyElPerson[n-1].FuzzySetTime,m);
    Readln(f,st);
    while Pos(';',st)<>0 do
      begin
      st1:=Copy(st,1,Pos(';',st)-1);
      Delete(st,1,Pos(';',st));
      inc(m);
      SetLength(ArrFuzzyElPerson[n-1].FuzzySetTime,m);
      ArrFuzzyElPerson[n-1].FuzzySetTime[m-1].Zn:=StrToFloat(st1);
      end;
    Readln(f,st);
    m:=0;
    while Pos(';',st)<>0 do
      begin
      st1:=Copy(st,1,Pos(';',st)-1);
      Delete(st,1,Pos(';',st));
      inc(m);
      ArrFuzzyElPerson[n-1].FuzzySetTime[m-1].FP:=StrToFloat(st1);
      end;
    end;
  CloseFile(f);
  end;

Procedure GoStartFuzzy;
begin
CreateArrFuzzyTask(KolTask);
TimeToPrAllFuzzyElement;
end;

Procedure AllPersonOneTaskFuzzy;
var
NomPerson:Longword;
begin
if Length(ArrFuzzyElPerson)<>0 then
for NomPerson := 0 to Length(ArrFuzzyElPerson)-1 do
  AddPersonTask(NomPerson,0);
end;

Procedure GoFuzzyTask;
var
NomTask:Longword;
begin
if Length(ArrFuzzyTask)<>0 then
for NomTask := 0 to Length(ArrFuzzyTask)-1 do
  begin
  CreateFuzzySet(NomTask);
  PrToTime(NomTask);
  GoInteractionPerson(NomTask);
  CalcKritDefazification(NomTask);
  end;
end;

end.

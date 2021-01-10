program MMK_DSS;

uses
  Forms,
  UMain in 'UMain.pas' {FMain},
  UAntGraph in 'UAntGraph.pas',
  UAnt in 'UAnt.pas',
  USolutionNew in 'USolutionNew.pas',
  UModelFuzzy in 'UModelFuzzy.pas',
  UModelFuzzyExcel in 'UModelFuzzyExcel.pas',
  UAntFuzzy in 'UAntFuzzy.pas',
  UModelDepend in 'UModelDepend.pas',
  UCPM in 'UCPM.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.

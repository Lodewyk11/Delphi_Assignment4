unit Assiggnment4_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ComCtrls, Spin, Buttons, ExtCtrls;

type

  { Tfrm2016Assignment4 }

  Tfrm2016Assignment4 = class(TForm)
    bmbReset: TBitBtn;
    btnTotalForTheDay: TButton;
    btnDisplayWarning: TButton;
    btnDisplaySummary: TButton;
    btnGenerateRemark: TButton;
    btnDisplayMiddayReport: TButton;
    dtpDateToday: TDateTimePicker;
    edtDate: TEdit;
    grpBreakFast: TGroupBox;
    grpLunch: TGroupBox;
    grpDinner: TGroupBox;
    CalorieImage: TImage;
    lblMyHeading: TLabel;
    lstReport: TListBox;
    sedBreakfast: TSpinEdit;
    sedLunch: TSpinEdit;
    sedDinner: TSpinEdit;
    procedure bmbResetClick(Sender: TObject);
    procedure btnDisplayMiddayReportClick(Sender: TObject);
    procedure btnDisplaySummaryClick(Sender: TObject);
    procedure btnDisplayWarningClick(Sender: TObject);
    procedure btnGenerateRemarkClick(Sender: TObject);
    procedure btnTotalForTheDayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frm2016Assignment4: Tfrm2016Assignment4;

implementation

{$R *.lfm}

{ Tfrm2016Assignment4 }

procedure Tfrm2016Assignment4.bmbResetClick(Sender: TObject);
begin
    sedBreakfast.Value := 0;
    sedLunch.Value := 0;
    sedDinner.Value := 0;
    lstReport.Clear();

    sedBreakfast.Enabled := TRUE;
    sedLunch.Enabled := TRUE;
    sedDinner.Enabled := TRUE;
end;

procedure Tfrm2016Assignment4.btnDisplayMiddayReportClick(Sender: TObject);
   var middayTotal : Integer;
begin
    middayTotal := sedBreakfast.Value + sedLunch.Value;
    lstReport.Items.Add('Display Midday Report for: ' + formatdatetime('yyyy/mm/dd', StrToDate(edtDate.Text)));
    lstReport.Items.Add('Total thus far: ' + IntToStr(middayTotal) + ' calories');
    lstReport.Items.Add(' *** End of Midday Report for: ' + formatdatetime('yyyy/mm/dd', StrToDate(edtDate.Text)));
    lstReport.Items.Add('');
end;

procedure Tfrm2016Assignment4.btnDisplaySummaryClick(Sender: TObject);
  var mostCaloriesMeal : String;
  var mostLunch : Boolean;
  var mostDinner : Boolean;
  var allEqual : Boolean;
begin
  mostCaloriesMeal := 'Breakfast';
  mostLunch := (sedLunch.Value > sedBreakfast.Value) AND (sedLunch.Value > sedDinner.Value);
  mostDinner := (sedDinner.Value > sedBreakfast.Value) AND (sedDinner.Value > sedLunch.Value);
  allEqual := (sedBreakfast.Value = sedLunch.Value) AND (sedLunch.Value = sedDinner.Value);

  if mostLunch then  mostCaloriesMeal := 'Lunch';
  if mostDinner then  mostCaloriesMeal := 'Dinner';

  lstReport.Items.Add('Display Summary for: ' + formatdatetime('yyyy/mm/dd', StrToDate(edtDate.Text)));
  lstReport.Items.Add('Breakfast count: ' + IntToStr(sedBreakfast.Value) + ' calories');
  lstReport.Items.Add('Lunch count: ' + IntToStr(sedLunch.Value) + ' calories');
  lstReport.Items.Add('Dinner count: ' + IntToStr(sedDinner.Value) + ' calories');

  if allEqual then
    lstReport.Items.Add('equal amount of calories consumed in all meals')
  else
     lstReport.Items.Add('more calories consumed at ' + mostCaloriesMeal);
  lstReport.Items.Add('* End of Summary *');
  lstReport.Items.Add('');
end;

procedure Tfrm2016Assignment4.btnDisplayWarningClick(Sender: TObject);
   var missedMeal : Boolean;
begin
    missedMeal :=  (sedBreakfast.Value = 0) OR (sedLunch.Value = 0) OR (sedDinner.Value = 0);
    if missedMeal then
    begin
       lstReport.Items.Add('Display Warning for: ' + formatdatetime('yyyy/mm/dd', StrToDate(edtDate.Text)));
       lstReport.Items.Add('WARNING: missing a meal?');
       lstReport.Items.Add('* End of Warning *');
       lstReport.Items.Add('');
    end;
end;

procedure Tfrm2016Assignment4.btnGenerateRemarkClick(Sender: TObject);
   var allMeals : Boolean;
   var noMeals : Boolean;
   var sRemark : String;
begin
    allMeals := (sedBreakfast.Value > 0) AND (sedLunch.Value > 0) AND (sedDinner.Value > 0);
    noMeals :=  (sedBreakfast.Value = 0) AND (sedLunch.Value = 0) AND (sedDinner.Value = 0);
    Case allMeals of
      True  :
        sRemark := 'Daily entry complete!';
      False :
        sRemark := 'Be careful not to skip another meal'
    end;
    Case noMeals of
      True  :
        sRemark := 'No calories consumed'
    end;
    lstReport.Items.Add('Generate Remark for: ' + formatdatetime('yyyy/mm/dd', StrToDate(edtDate.Text)));
    lstReport.Items.Add(sRemark);
    lstReport.Items.Add('*** End of Remark ***');
    lstReport.Items.Add('');
end;

procedure Tfrm2016Assignment4.btnTotalForTheDayClick(Sender: TObject);
begin
     sedBreakfast.Enabled := FALSE;
     sedLunch.Enabled := FALSE;
     sedDinner.Enabled := FALSE;
     btnDisplaySummary.Enabled := TRUE;
     btnGenerateRemark.Enabled := TRUE;
     btnDisplayWarning.Enabled := TRUE;
end;

procedure Tfrm2016Assignment4.FormCreate(Sender: TObject);
  var dDate : TDate;
begin
  //Set the date to the current date
  dDate := Date();
  edtDate.Text := DateToStr(dDate);
  edtDate.ReadOnly := TRUE;
  dtpDateToday.Date := Date();
end;

end.


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
    //Reset all spinner values back to 0,
    sedBreakfast.Value := 0;
    sedLunch.Value := 0;
    sedDinner.Value := 0;

    //Clear the report contents
    lstReport.Clear();

    //Enable any spinners that might have been disabled.
    sedBreakfast.Enabled := TRUE;
    sedLunch.Enabled := TRUE;
    sedDinner.Enabled := TRUE;
end;

procedure Tfrm2016Assignment4.btnDisplayMiddayReportClick(Sender: TObject);
  //Will hold the sum of the breakfast and lunch calorie count.
  var middayTotal : Integer;
begin
    //Calculate the midday total thus far.
    middayTotal := sedBreakfast.Value + sedLunch.Value;

    //Create and add the report enties.
    lstReport.Items.Add('Display Midday Report for: ' + formatdatetime('yyyy/mm/dd', StrToDate(edtDate.Text)));
    lstReport.Items.Add('Total thus far: ' + IntToStr(middayTotal) + ' calories');
    lstReport.Items.Add(' *** End of Midday Report for: ' + formatdatetime('yyyy/mm/dd', StrToDate(edtDate.Text)));
    lstReport.Items.Add('');
end;

procedure Tfrm2016Assignment4.btnDisplaySummaryClick(Sender: TObject);
  //Will indicate in which meal the most calories were consumed (Breakfast, Lunch or Dinner)
  var mostCaloriesMeal : String;
  //TRUE if the most calories were consumed during Lunch.
  var mostLunch : Boolean;
  //TRUE if the most calories were consumed during Dinner.
  var mostDinner : Boolean;
  //Equal calories consumed in all meals.
  var allEqual : Boolean;
begin
  //Assume the most calories were consumed during Breakfast. We will overwrite this of otherwise.
  mostCaloriesMeal := 'Breakfast';
  //Check if the most calories were consumed during Lunch.
  mostLunch := (sedLunch.Value > sedBreakfast.Value) AND (sedLunch.Value > sedDinner.Value);
  //Check if the most calories were consumed during Dinner.
  mostDinner := (sedDinner.Value > sedBreakfast.Value) AND (sedDinner.Value > sedLunch.Value);
  //Check if all meals had an equal amount of calories.
  allEqual := (sedBreakfast.Value = sedLunch.Value) AND (sedLunch.Value = sedDinner.Value);

  //Overwrite the meal in which the most calories were consumed if it is true.
  if mostLunch then  mostCaloriesMeal := 'Lunch';
  if mostDinner then  mostCaloriesMeal := 'Dinner';

  //Create and add the report entries.
  lstReport.Items.Add('Display Summary for: ' + formatdatetime('yyyy/mm/dd', StrToDate(edtDate.Text)));
  lstReport.Items.Add('Breakfast count: ' + IntToStr(sedBreakfast.Value) + ' calories');
  lstReport.Items.Add('Lunch count: ' + IntToStr(sedLunch.Value) + ' calories');
  lstReport.Items.Add('Dinner count: ' + IntToStr(sedDinner.Value) + ' calories');

  //Only display in which meal the most calories were consumed if not all are equal.
  if allEqual then
    lstReport.Items.Add('equal amount of calories consumed in all meals')
  else
     lstReport.Items.Add('more calories consumed at ' + mostCaloriesMeal);
  lstReport.Items.Add('* End of Summary *');
  lstReport.Items.Add('');
end;

procedure Tfrm2016Assignment4.btnDisplayWarningClick(Sender: TObject);
  //TRUE if a meal was missed, i.e. a calorie count of 0 is recorded for a meal
  var missedMeal : Boolean;
begin
    //Check if a meal has been missed.
    missedMeal :=  (sedBreakfast.Value = 0) OR (sedLunch.Value = 0) OR (sedDinner.Value = 0);

  //Only create and add the report entry if a meal has been missed.
  if missedMeal then
    begin
       lstReport.Items.Add('Display Warning for: ' + formatdatetime('yyyy/mm/dd', StrToDate(edtDate.Text)));
       lstReport.Items.Add('WARNING: missing a meal?');
       lstReport.Items.Add('* End of Warning *');
       lstReport.Items.Add('');
    end;
end;

procedure Tfrm2016Assignment4.btnGenerateRemarkClick(Sender: TObject);
   //TRUE if all meals have been recorded, i.e. no 0 calorie amount has been entered.
   var allMeals : Boolean;
   //TRUE is no meals have been recorded, i.e. all calorie amounts are 0.
   var noMeals : Boolean;
   //Will hold the value of the remark.
   var sRemark : String;
begin
    //Check if all meals have been recorded.
    allMeals := (sedBreakfast.Value > 0) AND (sedLunch.Value > 0) AND (sedDinner.Value > 0);
    //Check if no meals have been recoded.
    noMeals :=  (sedBreakfast.Value = 0) AND (sedLunch.Value = 0) AND (sedDinner.Value = 0);

    //Create the remark based on the whether all meals, only some of the meals or none of the meals have been recorded.
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

    //Create and add the report items.
    lstReport.Items.Add('Generate Remark for: ' + formatdatetime('yyyy/mm/dd', StrToDate(edtDate.Text)));
    lstReport.Items.Add(sRemark);
    lstReport.Items.Add('*** End of Remark ***');
    lstReport.Items.Add('');
end;

procedure Tfrm2016Assignment4.btnTotalForTheDayClick(Sender: TObject);
begin
     //Disables the spin edit boxes and ensure that the buttons are enabled.
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


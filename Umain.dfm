object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Monitor'
  ClientHeight = 251
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SHChangeNotify1: TSHChangeNotify
    OnDriveAdd = SHChangeNotify1DriveAdd
    OnDriveRemoved = SHChangeNotify1DriveRemoved
    Left = 384
    Top = 32
  end
  object RVAudioPlayer1: TRVAudioPlayer
    VolumeMultiplier = 1.000000000000000000
    NoiseReduction = True
    Left = 232
    Top = 104
  end
end

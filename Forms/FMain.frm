VERSION 5.00
Begin VB.Form FMain 
   Caption         =   "CryptHash"
   ClientHeight    =   6180
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   10335
   BeginProperty Font 
      Name            =   "Segoe UI"
      Size            =   9.75
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "FMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   6180
   ScaleWidth      =   10335
   StartUpPosition =   3  'Windows-Standard
   Begin VB.CommandButton BtnSHA256 
      Caption         =   "SHA256"
      BeginProperty Font 
         Name            =   "Segoe UI"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   6
      Top             =   3120
      Width           =   1455
   End
   Begin VB.CommandButton BtnCRC32 
      Caption         =   "CRC-32"
      BeginProperty Font 
         Name            =   "Segoe UI"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   480
      Width           =   1455
   End
   Begin VB.TextBox TxtMD5 
      Height          =   975
      Left            =   120
      TabIndex        =   1
      Text            =   "The Quick Brown Fox Jumps Over The Lazy Dog"
      Top             =   1200
      Width           =   10095
   End
   Begin VB.CommandButton BtnMD5 
      Caption         =   "MD5"
      BeginProperty Font 
         Name            =   "Segoe UI"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   2280
      Width           =   1455
   End
   Begin VB.Label LblSHA256 
      AutoSize        =   -1  'True
      Caption         =   "SHA256:"
      BeginProperty Font 
         Name            =   "Consolas"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Left            =   1800
      TabIndex        =   7
      Top             =   3240
      Width           =   735
   End
   Begin VB.Label LBLDragDropFileCRC32 
      Caption         =   "Drag'n'drop file here, checksum will be calculated! The Quick Brown Fox Jumps Over The Lazy Dog"
      BeginProperty Font 
         Name            =   "Segoe UI"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   5
      Top             =   120
      Width           =   10095
   End
   Begin VB.Label LblCRC32 
      AutoSize        =   -1  'True
      Caption         =   "CRC32:"
      BeginProperty Font 
         Name            =   "Consolas"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Left            =   1800
      TabIndex        =   4
      Top             =   600
      Width           =   630
   End
   Begin VB.Label LBLMD5 
      AutoSize        =   -1  'True
      Caption         =   "MD5:"
      BeginProperty Font 
         Name            =   "Consolas"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Left            =   1800
      TabIndex        =   2
      Top             =   2400
      Width           =   420
   End
End
Attribute VB_Name = "FMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    TxtMD5.Text = "The Quick Brown Fox Jumps Over The Lazy Dog"
    'Label1.Caption = "&&H07606BB6"
    Me.Caption = Me.Caption & " v" & App.Major & "." & App.Minor & "." & App.Revision
End Sub

Private Sub BtnCRC32_Click()
    Dim s As String: s = TxtMD5.Text '"The Quick Brown Fox Jumps Over The Lazy Dog"
    Dim crc32_check As Long
    If MCRC32.String_TryCheckCRC32(s, crc32_check) Then
        LblCRC32.Caption = "CRC32: &&H" & Hex(crc32_check)
        Debug.Print MCRC32.CRC32LUTableTypToStr & ": &&H" & Hex(crc32_check)
    End If
End Sub

Private Sub Form_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Not Data.GetFormat(ClipBoardConstants.vbCFFiles) Then Exit Sub
    Dim PFN As String: PFN = Data.Files(1)
    Dim s As String: s = GetFileContent(PFN)
    Dim crc32_chksum As Long
    If MCRC32.String_TryCheckCRC32(s, crc32_chksum) Then
        LblCRC32.Caption = "CRC32-CheckSum: &H" & Hex(crc32_chksum)
    End If
End Sub

Function GetFileContent(PFN As String) As String
Try: On Error GoTo Catch
    Dim FNr As Integer: FNr = FreeFile
    Open PFN For Binary Access Read As FNr
    Dim sContent As String: sContent = Space(LOF(FNr))
    Get FNr, , sContent
    GetFileContent = sContent
    GoTo Finally
Catch:
Finally:
    Close FNr
End Function

Private Sub BtnMD5_Click()
    Dim s As String: s = TxtMD5.Text
    Dim c As New MSCrypt
    s = c.GetPasswordHash(s)
    Dim b() As Byte: b = s
    LBLMD5.Caption = s
End Sub

Private Sub BtnSHA256_Click()
    Dim b() As Byte: b = TxtMD5.Text
    b = MBCrypt.TryGetHash(b)
    LblSHA256.Caption = b
End Sub


VERSION 5.00
Begin VB.Form FMain 
   Caption         =   "CryptHash"
   ClientHeight    =   5535
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   10455
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
   ScaleHeight     =   5535
   ScaleWidth      =   10455
   StartUpPosition =   3  'Windows-Standard
   Begin VB.TextBox TxtBCryptSHA512 
      BeginProperty Font 
         Name            =   "Consolas"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   450
      Left            =   3720
      MultiLine       =   -1  'True
      TabIndex        =   25
      Text            =   "FMain.frx":1782
      Top             =   5040
      Width           =   6615
   End
   Begin VB.TextBox TxtBCryptSHA384 
      BeginProperty Font 
         Name            =   "Consolas"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   450
      Left            =   3720
      MultiLine       =   -1  'True
      TabIndex        =   22
      Text            =   "FMain.frx":1786
      Top             =   4560
      Width           =   6615
   End
   Begin VB.TextBox TxtBCryptSHA256 
      BeginProperty Font 
         Name            =   "Consolas"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   450
      Left            =   3720
      MultiLine       =   -1  'True
      TabIndex        =   19
      Text            =   "FMain.frx":178A
      Top             =   4080
      Width           =   6615
   End
   Begin VB.TextBox TxtMSCryptSHA 
      BeginProperty Font 
         Name            =   "Consolas"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   450
      Left            =   3720
      MultiLine       =   -1  'True
      TabIndex        =   16
      Text            =   "FMain.frx":178E
      Top             =   3600
      Width           =   6615
   End
   Begin VB.TextBox TxtMSCryptMD5 
      BeginProperty Font 
         Name            =   "Consolas"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   450
      Left            =   3720
      MultiLine       =   -1  'True
      TabIndex        =   13
      Text            =   "FMain.frx":1792
      Top             =   3120
      Width           =   6615
   End
   Begin VB.TextBox TxtMSCryptRC4 
      BeginProperty Font 
         Name            =   "Consolas"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   450
      Left            =   3720
      MultiLine       =   -1  'True
      TabIndex        =   10
      Text            =   "FMain.frx":1796
      Top             =   2640
      Width           =   6615
   End
   Begin VB.TextBox TxtCRC32MEF 
      BeginProperty Font 
         Name            =   "Consolas"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   450
      Left            =   3720
      MultiLine       =   -1  'True
      TabIndex        =   7
      Text            =   "FMain.frx":179A
      Top             =   2160
      Width           =   6615
   End
   Begin VB.TextBox TxtCRC32JAM 
      BeginProperty Font 
         Name            =   "Consolas"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   450
      Left            =   3720
      MultiLine       =   -1  'True
      TabIndex        =   4
      Text            =   "FMain.frx":179E
      Top             =   1680
      Width           =   6615
   End
   Begin VB.CommandButton BtnBCryptSHA512 
      Caption         =   "BCrypt.SHA512"
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
      TabIndex        =   23
      Top             =   5040
      Width           =   1935
   End
   Begin VB.CommandButton BtnBCryptSHA384 
      Caption         =   "BCrypt.SHA384"
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
      TabIndex        =   20
      Top             =   4560
      Width           =   1935
   End
   Begin VB.CommandButton BtnCRC32MEF 
      Caption         =   "CRC-32/MEF"
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
      Top             =   2160
      Width           =   1935
   End
   Begin VB.CommandButton BtnMSCryptSHA 
      Caption         =   "MSCrypt.SHA"
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
      TabIndex        =   14
      Top             =   3600
      Width           =   1935
   End
   Begin VB.CommandButton BtnMSCryptRC4 
      Caption         =   "MSCrypt.RC4"
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
      TabIndex        =   8
      Top             =   2640
      Width           =   1935
   End
   Begin VB.CommandButton BtnBCryptSHA256 
      Caption         =   "BCrypt.SHA256"
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
      TabIndex        =   17
      Top             =   4080
      Width           =   1935
   End
   Begin VB.CommandButton BtnCRC32JAM 
      Caption         =   "CRC-32/JAM"
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
      TabIndex        =   2
      Top             =   1680
      Width           =   1935
   End
   Begin VB.TextBox TxtUserText 
      Height          =   975
      Left            =   120
      TabIndex        =   1
      Top             =   600
      Width           =   10215
   End
   Begin VB.CommandButton BtnMSCryptMD5 
      Caption         =   "MSCrypt.MD5"
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
      TabIndex        =   11
      Top             =   3120
      Width           =   1935
   End
   Begin VB.Label LblBCrypt3 
      AutoSize        =   -1  'True
      Caption         =   "BCrypt.SHA512:"
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
      Left            =   2160
      TabIndex        =   24
      Top             =   5040
      Width           =   1470
   End
   Begin VB.Label LblBCrypt2 
      AutoSize        =   -1  'True
      Caption         =   "BCrypt.SHA384:"
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
      Left            =   2160
      TabIndex        =   21
      Top             =   4560
      Width           =   1470
   End
   Begin VB.Label LblCRC322 
      AutoSize        =   -1  'True
      Caption         =   "CRC-32/MEF:"
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
      Left            =   2160
      TabIndex        =   6
      Top             =   2160
      Width           =   1155
   End
   Begin VB.Label LblMSCrypt3 
      AutoSize        =   -1  'True
      Caption         =   "MSCrypt.SHA:"
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
      Left            =   2160
      TabIndex        =   15
      Top             =   3600
      Width           =   1260
   End
   Begin VB.Label LblMSCrypt1 
      AutoSize        =   -1  'True
      Caption         =   "MSCrypt.RC4:"
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
      Left            =   2160
      TabIndex        =   9
      Top             =   2640
      Width           =   1260
   End
   Begin VB.Label LblBCrypt1 
      AutoSize        =   -1  'True
      Caption         =   "BCrypt.SHA256:"
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
      Left            =   2160
      TabIndex        =   18
      Top             =   4080
      Width           =   1470
   End
   Begin VB.Label LBLDragDropFileCRC32 
      Alignment       =   2  'Zentriert
      Caption         =   "Drag'n'drop file here, checksum-hash will be calculated!"
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
      Top             =   120
      Width           =   10215
   End
   Begin VB.Label LblCRC321 
      AutoSize        =   -1  'True
      Caption         =   "CRC-32/JAM:"
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
      Left            =   2160
      TabIndex        =   3
      Top             =   1680
      Width           =   1155
   End
   Begin VB.Label LblMSCrypt2 
      AutoSize        =   -1  'True
      Caption         =   "MSCrypt.MD5:"
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
      Left            =   2160
      TabIndex        =   12
      Top             =   3120
      Width           =   1260
   End
End
Attribute VB_Name = "FMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    TxtUserText.Text = "The Quick Brown Fox Jumps Over The Lazy Dog"
    Me.Caption = Me.Caption & " v" & App.Major & "." & App.Minor & "." & App.Revision
End Sub

Private Sub LBLDragDropFileCRC32_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
    OnOLEDragDrop Data, Effect, Button, Shift, x, Y
End Sub
Private Sub Form_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
    OnOLEDragDrop Data, Effect, Button, Shift, x, Y
End Sub

Private Sub OnOLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
    If Not Data.GetFormat(ClipBoardConstants.vbCFFiles) Then Exit Sub
    Dim PFN As String: PFN = Data.Files(1)
    Dim s As String: s = GetFileContent(PFN)
    'Dim crc32_chksum As Long
    'MCRC32.InitLUTable ECRC32LUTable.CRC32_JAMCRC
    'If MCRC32.String_TryCheckCRC32(s, crc32_chksum) Then
    '    TxtCRC32JAM.Text = "&H" & Hex(crc32_chksum)
    'End If
End Sub

Function GetFileContent(PFN As String) As Byte()
Try: On Error GoTo Catch
    Dim FNr As Integer: FNr = FreeFile
    Open PFN For Binary Access Read As FNr
    ReDim FileContent(0 To LOF(FNr) - 1) As Byte ': sContent = Space(LOF(FNr))
    Get FNr, , FileContent
    GetFileContent = FileContent
    GoTo Finally
Catch:
    MsgBox "Error in FMain.GetFileContent"
Finally: Close FNr
End Function

'"The Quick Brown Fox Jumps Over The Lazy Dog" = &HF89F9449
Private Sub BtnCRC32JAM_Click()
    TxtCRC32JAM.Text = GetHash(MNew.CRC32(ECRC32Algo.CRC32_JAMCRC))
End Sub

'"The Quick Brown Fox Jumps Over The Lazy Dog" = &HA26BF73F
Private Sub BtnCRC32MEF_Click()
    TxtCRC32MEF.Text = GetHash(MNew.CRC32(ECRC32Algo.CRC32_MEF))
End Sub

'"The Quick Brown Fox Jumps Over The Lazy Dog" = &H3E9B65EFC2EADA94C501D9DF83719322
Private Sub BtnMSCryptRC4_Click()
    TxtMSCryptRC4.Text = GetHash(MNew.MSCrypt(EHashAlgo.ha_RC4))
End Sub

'"The Quick Brown Fox Jumps Over The Lazy Dog" = &H58826469C2606F4791B9F75880DFBE2A
Private Sub BtnMSCryptMD5_Click()
    TxtMSCryptMD5.Text = GetHash(MNew.MSCrypt(EHashAlgo.ha_MD5))
End Sub

'SHA = Secure Hash Algorithm
'"The Quick Brown Fox Jumps Over The Lazy Dog" = &H645218467886DD414EA66A09B6CCEEA806127FB5
Private Sub BtnMSCryptSHA_Click()
    TxtMSCryptSHA.Text = GetHash(MNew.MSCrypt(EHashAlgo.ha_SHA))
End Sub

Private Function GetHash(hasher As IHasher) As String
Try: On Error GoTo Catch
    Dim s As String: s = TxtUserText.Text
    If Len(s) = 0 Then
        MsgBox "Please give a valid string in edittextbox"
        Exit Function
    End If
    Dim b() As Byte: b = StrConv(s, vbFromUnicode)
    Dim hash() As Byte: hash = hasher.GetHash(b)
    GetHash = Hex_ToStr(hash)
    'GetHash = Hex_ToStr(hasher.GetHash(StrConv(TxtUserText.Text, vbFromUnicode)))
    Exit Function
Catch:
    MsgBox "Error in FMain.GetHash maybe text is empty"
End Function

'Private Function GetMSCryptHash(hasher As MSCrypt) As String
'    Dim s As String: s = TxtUserTextToCrypt.Text
'    Dim b() As Byte: b = StrConv(s, vbFromUnicode)
'    Dim hash() As Byte: hash = hasher.GetHash(b)
'    GetMSCryptHash = Hex_ToStr(hash)
'End Function



'The Quick Brown Fox Jumps Over The Lazy Dog
'c6e68384699d2e81c02d4c3eec53cede3ea420c1ae8a227dac495aa00666fd13
Private Sub BtnBCryptSHA256_Click()
    Dim b() As Byte: b = TxtUserText.Text
    b = MBCrypt.TryGetHash(b)
    TxtBCryptSHA256.Text = b
End Sub

'The Quick Brown Fox Jumps Over The Lazy Dog
'29713f65a24e97e66da57499723359374326dd1498c9a26fda84396a7a7d0a24c56a50343f5e0228778ea7bd53f9a179
Private Sub BtnBCryptSHA384_Click()
    '
End Sub

'The Quick Brown Fox Jumps Over The Lazy Dog
'12a98085e307959d5d6e6d0ed361845b604a33f9b66d025f30cc0414d2fa374ea129e6e80a838dffc07e2334e9936119d5bb18443d3ecde58a2f1ec4306e6fb2
Private Sub BtnBCryptSHA512_Click()
    '
End Sub

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MSCrypt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'Dieser Source stammt von http://www.activevb.de
'und kann frei verwendet werden. Für eventuelle Schäden
'wird nicht gehaftet.
'
'Um Fehler oder Fragen zu klären, nutzen Sie bitte unser Forum.
'Ansonsten viel Spaß und Erfolg mit diesem Source !
'
'Autor: Tim Braun
'E-Mail: zork@tipsntricks.de

'http://www.activevb.de/tutorials/tut_cryptoapi/cryptoapi.html
'the name of the class by Wolfgang Uhr was clsCryptPassword
'I renamed it to MSCrypt, because
'1. I do not like the "cls"-prefix and
'2. imho the addition "Password" misses its general purpose


Private Declare Function CryptAcquireContextA Lib "advapi32" (ByRef hProv_out As Long, ByVal pszContainer As String, ByVal pszProvider As String, ByVal dwProvType As Long, ByVal dwFlags As Long) As Long
Private Declare Function CryptReleaseContext Lib "advapi32" (ByVal hProv As Long, ByVal dwFlags As Long) As Long

Private Declare Function CryptCreateHash Lib "advapi32" (ByVal hProv As Long, ByVal Algid As Long, ByVal hSessionKey As Long, ByVal dwFlags As Long, ByRef phHash As Long) As Long
Private Declare Function CryptDestroyHash Lib "advapi32" (ByVal hHash As Long) As Long

Private Declare Function CryptHashData Lib "advapi32" (ByVal hHash As Long, ByVal pbData As String, ByVal dwDataLen As Long, ByVal dwFlags As Long) As Long
Private Declare Function CryptGetHashParam Lib "advapi32" (ByVal hHash As Long, ByVal dwParam As Long, ByVal pbData As String, ByRef pdwDataLen As Long, ByVal dwFlags As Long) As Long

Private Declare Function CryptDeriveKey Lib "advapi32" (ByVal hProv As Long, ByVal Algid As Long, ByVal hBaseData As Long, ByVal dwFlags As Long, ByRef hSessionKey As Long) As Long
Private Declare Function CryptDestroyKey Lib "advapi32" (ByVal hSessionKey As Long) As Long



Private Const SERVICE_PROVIDER As String = "Microsoft Base Cryptographic Provider v1.0" & vbNullChar

Private Const ERROR_SUCCESS          As Long = 0
Private Const KEY_CONTAINER          As String = "MyHashKey" & vbNullChar
Private Const PROV_RSA_FULL          As Long = 1

Private Const CRYPT_EXPORTABLE       As Long = 1
Private Const CRYPT_CREATE_SALT      As Long = 4
Private Const CRYPT_NEWKEYSET        As Long = 8
Private Const CRYPT_DELETEKEYSET     As Long = 16

Private Const KP_SALT                As Long = 2

Private Const ALG_CLASS_DATA_ENCRYPT As Long = 24576
Private Const ALG_CLASS_HASH         As Long = 32768
Private Const ALG_TYPE_ANY           As Long = 0
Private Const ALG_TYPE_STREAM        As Long = 2048
Private Const ALG_SID_RC4            As Long = 1
Private Const ALG_SID_MD5            As Long = 3
Private Const ALG_SID_SHA            As Long = 4
'Private Const CALG_RC4               As Long = ((ALG_CLASS_DATA_ENCRYPT Or ALG_TYPE_STREAM) Or ALG_SID_RC4)
'Private Const CALG_RC4               As Long = ((ALG_CLASS_HASH Or ALG_TYPE_ANY) Or ALG_SID_RC4)
Private Const CALG_RC4               As Long = (ALG_CLASS_HASH Or ALG_SID_RC4)
'Private Const CALG_MD5               As Long = ((ALG_CLASS_HASH Or ALG_TYPE_ANY) Or ALG_SID_MD5)
Private Const CALG_MD5               As Long = (ALG_CLASS_HASH Or ALG_SID_MD5)
'Private Const CALG_SHA               As Long = ((ALG_CLASS_HASH Or ALG_TYPE_ANY) Or ALG_SID_SHA)
Private Const CALG_SHA               As Long = (ALG_CLASS_HASH Or ALG_SID_SHA)

Private Const AT_KEYEXCHANGE         As Long = 1
Private Const AT_SIGNATURE           As Long = 2

Private Const HP_HASHVAL             As Long = 2
Private Const SIMPLEBLOB             As Long = 1
Private Const PUBLICKEYBLOB          As Long = 6
Private Const PRIVATEKEYBLOB         As Long = 7
Private Const CRYPT_NO_SALT          As Long = 16
Private Const NTE_BAD_SIGNATURE      As Long = &H80090006 '-2146893818

Public Enum EHashAlgo
    ha_RC4 = 1
    ha_MD5 = 3
    ha_SHA = 4
End Enum

Private m_HashAlgo           As EHashAlgo
Private m_hCryptoProv        As Long
Private m_hSessionKey        As Long
Private m_hHash              As Long
Private m_sSALT              As String
Private m_sHash              As String
Private hKeyPair             As Long
Private strPublicPrivateBlob As String
Private strPublicBlob        As String
Private strSessionBlob       As String
Private lngType              As Long
Private strSig               As String

Private Sub Class_Initialize()
    Dim hr As Long
    ' Handle erstellen
    hr = CryptAcquireContextA(m_hCryptoProv, KEY_CONTAINER, SERVICE_PROVIDER, PROV_RSA_FULL, CRYPT_NEWKEYSET)
    If hr = 0 Then
        ' Versuchen ein bereits erstelltes Handle zu nutzen, wenn nicht dann...
        hr = CryptAcquireContextA(m_hCryptoProv, KEY_CONTAINER, SERVICE_PROVIDER, PROV_RSA_FULL, 0)
        If hr = 0 Then
            Err.Raise Err.LastDllError, , "DLL gab Fehler zurück.  Fehler." & vbCrLf & "Fehler Beim erstellen des Handles"
        End If
    End If
End Sub

Private Sub Class_Terminate()
    If m_hSessionKey Then CryptDestroyKey m_hSessionKey   ' Key der Session zerstören
    If m_hCryptoProv Then CryptReleaseContext m_hCryptoProv, 0
End Sub

Friend Sub New_(aHashAlgo As EHashAlgo)
    m_HashAlgo = aHashAlgo
End Sub

Public Property Get HashAlgo() As EHashAlgo
    HashAlgo = m_HashAlgo
End Property

Public Function TryGetHash(ByVal Key As String) As String
    
    'Dim lngParams As Long
    Dim hr As Long
    'Dim sHash As String
    'Dim lngHashLen As Long
    'Dim hHash As Long
    
    
    'Hash erstellen
    'hr = CryptCreateHash(m_hCryptoProv, CALG_SHA, 0, 0, hHash)
    Dim c As Long
    Select Case m_HashAlgo
    Case EHashAlgo.ha_RC4: c = CALG_RC4
    Case EHashAlgo.ha_MD5: c = CALG_MD5
    Case EHashAlgo.ha_SHA: c = CALG_SHA
    End Select
    
    hr = CryptCreateHash(m_hCryptoProv, c, 0, 0, m_hHash)
    If hr = 0 Then Err.Raise Err.LastDllError, , "DLL gab Error aus. Hash-Objekt kann nicht erstellt werden! " & "(CryptCreateHash API)"
    
    'Key in den Hash schreiben
    hr = CryptHashData(m_hHash, Key, Len(Key), 0)
    If hr = 0 Then Err.Raise Err.LastDllError, , "DLL-Fehler: Daten konnten nicht in den Hash geschrieben werden " & "(CryptHashData API)"
    
    'Länge des Hash ermitteln
    Dim hashlen As Long
    hr = CryptGetHashParam(m_hHash, HP_HASHVAL, vbNull, hashlen, 0)
    'String auf ermittelte Länge setzen
    'm_sHash = String(hashlen + 1, vbNullChar)
    m_sHash = String(hashlen, vbNullChar)
    'Key auslesen
    hr = CryptGetHashParam(m_hHash, HP_HASHVAL, m_sHash, hashlen, 0)
    
    If hr = 0 Then Err.Raise Err.LastDllError, , "DLL gab Fehler aus. Hash-Value ungültig!"
    
    TryGetHash = m_sHash
    
    If m_hSessionKey <> 0 Then CryptDestroyKey m_hSessionKey
    
    If m_hHash <> 0 Then CryptDestroyHash m_hHash
    
End Function



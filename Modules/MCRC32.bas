Attribute VB_Name = "MCRC32"
Option Explicit
'According to this page:
'https://crccalc.com/?crc=The%20Quick%20Brown%20Fox%20Jumps%20Over%20The%20Lazy%20Dog&method=CRC-32&datatype=0&outtype=0
'this CRC is known as
'* CRC-32/JAMCRC
'Patrick Nohe at this page
'https://www.thesslstore.com/blog/difference-sha-1-sha-2-sha-256-hash-algorithms/
'uses the
'* CRC-32/ISO-HDLC
'also MEF seems to work the same with different lu-table


'CRC-32/AIXM:     &H12D09791
'CRC-32/AUTOSAR:  &HCC00319
'CRC-32/BASE91D:  &HD856E033
'CRC-32/BZIP2:    &HAB85B2A7
'CRC-32/CDROMEDC: &H6A909315
'CRC-32/CKSUM:    &HAB85B2A7
'CRC-32/ISCSI:    &HDFB43161
'CRC-32/ISOHDLC:  &HF89F9449
'CRC-32/JAMCRC:   &HF89F9449
'CRC-32/MEF:      &HA26BF73F
'CRC-32/MPEG2:    &HAB85B2A7
'CRC-32/XFER:     &H5004

Public Enum ECRC32LUTable
    CRC32_AIXM
    CRC32_AUTOSAR
    CRC32_BASE91D
    CRC32_BZIP2
    CRC32_CDROMEDC
    CRC32_CKSUM
    CRC32_ISCSI
    CRC32_ISOHDLC
    CRC32_JAMCRC
    CRC32_MEF
    CRC32_MPEG2
    CRC32_XFER
End Enum
Private Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

Private m_CRC32          As Long
Private m_CRC32Asm()     As Byte
Private m_isInitialized  As Boolean
Private m_eCRC32LUTable  As ECRC32LUTable
Private m_CRC32LUTable() As Long '0 To 255) As Long
'----------------------------------------------------

Public Function String_TryCheckCRC32(Text As String, CheckSum_out As Long) As Boolean
Try: On Error GoTo Catch
    If Len(Text) = 0 Then Exit Function
    CheckSum_out = CalculateString(Text)
    String_TryCheckCRC32 = True
Catch:
End Function

Private Function CalculateString(Text As String) As Variant
    CalculateString = CalculateBytes(StrConv(Text, vbFromUnicode))
End Function

Private Function CalculateBytes(bArray() As Byte) As Variant
    Clear
    CalculateBytes = AddBytes(bArray)
End Function

Public Sub Clear()
    m_CRC32 = &HFFFFFFFF
End Sub

Private Function AddBytes(bArray() As Byte) As Variant
Try: On Local Error GoTo Catch
    Dim ByteSize As Long
        
    'If Not m_isInitialized Then
    Init
    
    ByteSize = UBound(bArray) - LBound(bArray) + 1
    'On Local Error GoTo 0
    
    CallWindowProc VarPtr(m_CRC32Asm(0)), VarPtr(m_CRC32), VarPtr(bArray(LBound(bArray))), VarPtr(m_CRC32LUTable(0)), ByteSize
    AddBytes = m_CRC32
    Exit Function
Catch:
    AddBytes = Not m_CRC32
End Function

Private Function AddString(Text As String) As Variant
    AddString = AddBytes(StrConv(Text, vbFromUnicode))
End Function

Private Sub Init()
    InitAsm
    'InitLUTable ECRC32LUTable.CRC32_JAMCRC
End Sub

Public Sub InitAsm()
    If m_isInitialized Then Exit Sub
    Dim sASM As String: sASM = "5589E557565053518B45088B008B750C8B7D108B4D1431DB8A1E30C3C1E80833049F464975F28B4D088901595B585E5F89EC5DC21000"
    ReDim m_CRC32Asm(0 To Len(sASM) \ 2 - 1)
    Dim i As Long
    For i = 1 To Len(sASM) Step 2
        m_CRC32Asm(i \ 2) = Val("&H" & Mid$(sASM, i, 2))
    Next
    m_isInitialized = True
End Sub

Public Property Get CRC32LUTableTypToStr() As String
    CRC32LUTableTypToStr = ECRC32LUTable_ToStr(m_eCRC32LUTable)
End Property

Public Function ECRC32LUTable_ToStr(e As ECRC32LUTable) As String
    Dim s As String
    Select Case e
    Case ECRC32LUTable.CRC32_AIXM:     s = "CRC-32/AIXM"
    Case ECRC32LUTable.CRC32_AUTOSAR:  s = "CRC-32/AUTOSAR"
    Case ECRC32LUTable.CRC32_BASE91D:  s = "CRC-32/BASE91D"
    Case ECRC32LUTable.CRC32_BZIP2:    s = "CRC-32/BZIP2"
    Case ECRC32LUTable.CRC32_CDROMEDC: s = "CRC-32/CDROMEDC"
    Case ECRC32LUTable.CRC32_CKSUM:    s = "CRC-32/CKSUM"
    Case ECRC32LUTable.CRC32_ISCSI:    s = "CRC-32/ISCSI"
    Case ECRC32LUTable.CRC32_ISOHDLC:  s = "CRC-32/ISOHDLC"
    Case ECRC32LUTable.CRC32_JAMCRC:   s = "CRC-32/JAMCRC"
    Case ECRC32LUTable.CRC32_MEF:      s = "CRC-32/MEF"
    Case ECRC32LUTable.CRC32_MPEG2:    s = "CRC-32/MPEG2"
    Case ECRC32LUTable.CRC32_XFER:     s = "CRC-32/XFER"
    End Select
    ECRC32LUTable_ToStr = s
End Function
Public Sub InitLUTable(Optional ByVal e As ECRC32LUTable = ECRC32LUTable.CRC32_JAMCRC)
    ReDim c(0 To 255) As Long
    m_eCRC32LUTable = e
    Select Case m_eCRC32LUTable
    Case ECRC32LUTable.CRC32_AIXM
          c(0) = &H0:                 c(1) = &H814141AB:          c(2) = &H83C3C2FD:          c(3) = &H2828356:           c(4) = &H86C6C451:          c(5) = &H78785FA:           c(6) = &H50506AC:           c(7) = &H84444707
          c(8) = &H8CCCC909:          c(9) = &HD8D88A2:          c(10) = &HF0F0BF4:          c(11) = &H8E4E4A5F:         c(12) = &HA0A0D58:          c(13) = &H8B4B4CF3:         c(14) = &H89C9CFA5:         c(15) = &H8888E0E
         c(16) = &H98D8D3B9:         c(17) = &H19999212:         c(18) = &H1B1B1144:         c(19) = &H9A5A50EF:         c(20) = &H1E1E17E8:         c(21) = &H9F5F5643:         c(22) = &H9DDDD515:         c(23) = &H1C9C94BE
         c(24) = &H14141AB0:         c(25) = &H95555B1B:         c(26) = &H97D7D84D:         c(27) = &H169699E6:         c(28) = &H92D2DEE1:         c(29) = &H13939F4A:         c(30) = &H11111C1C:         c(31) = &H90505DB7
         c(32) = &HB0F0E6D9:         c(33) = &H31B1A772:         c(34) = &H33332424:         c(35) = &HB272658F:         c(36) = &H36362288:         c(37) = &HB7776323:         c(38) = &HB5F5E075:         c(39) = &H34B4A1DE
         c(40) = &H3C3C2FD0:         c(41) = &HBD7D6E7B:         c(42) = &HBFFFED2D:         c(43) = &H3EBEAC86:         c(44) = &HBAFAEB81:         c(45) = &H3BBBAA2A:         c(46) = &H3939297C:         c(47) = &HB87868D7
         c(48) = &H28283560:         c(49) = &HA96974CB:         c(50) = &HABEBF79D:         c(51) = &H2AAAB636:         c(52) = &HAEEEF131:         c(53) = &H2FAFB09A:         c(54) = &H2D2D33CC:         c(55) = &HAC6C7267
         c(56) = &HA4E4FC69:         c(57) = &H25A5BDC2:         c(58) = &H27273E94:         c(59) = &HA6667F3F:         c(60) = &H22223838:         c(61) = &HA3637993:         c(62) = &HA1E1FAC5:         c(63) = &H20A0BB6E
         c(64) = &HE0A08C19:         c(65) = &H61E1CDB2:         c(66) = &H63634EE4:         c(67) = &HE2220F4F:         c(68) = &H66664848:         c(69) = &HE72709E3:         c(70) = &HE5A58AB5:         c(71) = &H64E4CB1E
         c(72) = &H6C6C4510:         c(73) = &HED2D04BB:         c(74) = &HEFAF87ED:         c(75) = &H6EEEC646:         c(76) = &HEAAA8141:         c(77) = &H6BEBC0EA:         c(78) = &H696943BC:         c(79) = &HE8280217
         c(80) = &H78785FA0:         c(81) = &HF9391E0B:         c(82) = &HFBBB9D5D:         c(83) = &H7AFADCF6:         c(84) = &HFEBE9BF1:         c(85) = &H7FFFDA5A:         c(86) = &H7D7D590C:         c(87) = &HFC3C18A7
         c(88) = &HF4B496A9:         c(89) = &H75F5D702:         c(90) = &H77775454:         c(91) = &HF63615FF:         c(92) = &H727252F8:         c(93) = &HF3331353:         c(94) = &HF1B19005:         c(95) = &H70F0D1AE
         c(96) = &H50506AC0:         c(97) = &HD1112B6B:         c(98) = &HD393A83D:         c(99) = &H52D2E996:        c(100) = &HD696AE91:        c(101) = &H57D7EF3A:        c(102) = &H55556C6C:        c(103) = &HD4142DC7
        c(104) = &HDC9CA3C9:        c(105) = &H5DDDE262:        c(106) = &H5F5F6134:        c(107) = &HDE1E209F:        c(108) = &H5A5A6798:        c(109) = &HDB1B2633:        c(110) = &HD999A565:        c(111) = &H58D8E4CE
        c(112) = &HC888B979:        c(113) = &H49C9F8D2:        c(114) = &H4B4B7B84:        c(115) = &HCA0A3A2F:        c(116) = &H4E4E7D28:        c(117) = &HCF0F3C83:        c(118) = &HCD8DBFD5:        c(119) = &H4CCCFE7E
        c(120) = &H44447070:        c(121) = &HC50531DB:        c(122) = &HC787B28D:        c(123) = &H46C6F326:        c(124) = &HC282B421:        c(125) = &H43C3F58A:        c(126) = &H414176DC:        c(127) = &HC0003777
        c(128) = &H40005999:        c(129) = &HC1411832:        c(130) = &HC3C39B64:        c(131) = &H4282DACF:        c(132) = &HC6C69DC8:        c(133) = &H4787DC63:        c(134) = &H45055F35:        c(135) = &HC4441E9E
        c(136) = &HCCCC9090:        c(137) = &H4D8DD13B:        c(138) = &H4F0F526D:        c(139) = &HCE4E13C6:        c(140) = &H4A0A54C1:        c(141) = &HCB4B156A:        c(142) = &HC9C9963C:        c(143) = &H4888D797
        c(144) = &HD8D88A20:        c(145) = &H5999CB8B:        c(146) = &H5B1B48DD:        c(147) = &HDA5A0976:        c(148) = &H5E1E4E71:        c(149) = &HDF5F0FDA:        c(150) = &HDDDD8C8C:        c(151) = &H5C9CCD27
        c(152) = &H54144329:        c(153) = &HD5550282:        c(154) = &HD7D781D4:        c(155) = &H5696C07F:        c(156) = &HD2D28778:        c(157) = &H5393C6D3:        c(158) = &H51114585:        c(159) = &HD050042E
        c(160) = &HF0F0BF40:        c(161) = &H71B1FEEB:        c(162) = &H73337DBD:        c(163) = &HF2723C16:        c(164) = &H76367B11:        c(165) = &HF7773ABA:        c(166) = &HF5F5B9EC:        c(167) = &H74B4F847
        c(168) = &H7C3C7649:        c(169) = &HFD7D37E2:        c(170) = &HFFFFB4B4:        c(171) = &H7EBEF51F:        c(172) = &HFAFAB218:        c(173) = &H7BBBF3B3:        c(174) = &H793970E5:        c(175) = &HF878314E
        c(176) = &H68286CF9:        c(177) = &HE9692D52:        c(178) = &HEBEBAE04:        c(179) = &H6AAAEFAF:        c(180) = &HEEEEA8A8:        c(181) = &H6FAFE903:        c(182) = &H6D2D6A55:        c(183) = &HEC6C2BFE
        c(184) = &HE4E4A5F0:        c(185) = &H65A5E45B:        c(186) = &H6727670D:        c(187) = &HE66626A6:        c(188) = &H622261A1:        c(189) = &HE363200A:        c(190) = &HE1E1A35C:        c(191) = &H60A0E2F7
        c(192) = &HA0A0D580:        c(193) = &H21E1942B:        c(194) = &H2363177D:        c(195) = &HA22256D6:        c(196) = &H266611D1:        c(197) = &HA727507A:        c(198) = &HA5A5D32C:        c(199) = &H24E49287
        c(200) = &H2C6C1C89:        c(201) = &HAD2D5D22:        c(202) = &HAFAFDE74:        c(203) = &H2EEE9FDF:        c(204) = &HAAAAD8D8:        c(205) = &H2BEB9973:        c(206) = &H29691A25:        c(207) = &HA8285B8E
        c(208) = &H38780639:        c(209) = &HB9394792:        c(210) = &HBBBBC4C4:        c(211) = &H3AFA856F:        c(212) = &HBEBEC268:        c(213) = &H3FFF83C3:        c(214) = &H3D7D0095:        c(215) = &HBC3C413E
        c(216) = &HB4B4CF30:        c(217) = &H35F58E9B:        c(218) = &H37770DCD:        c(219) = &HB6364C66:        c(220) = &H32720B61:        c(221) = &HB3334ACA:        c(222) = &HB1B1C99C:        c(223) = &H30F08837
        c(224) = &H10503359:        c(225) = &H911172F2:        c(226) = &H9393F1A4:        c(227) = &H12D2B00F:        c(228) = &H9696F708:        c(229) = &H17D7B6A3:        c(230) = &H155535F5:        c(231) = &H9414745E
        c(232) = &H9C9CFA50:        c(233) = &H1DDDBBFB:        c(234) = &H1F5F38AD:        c(235) = &H9E1E7906:        c(236) = &H1A5A3E01:        c(237) = &H9B1B7FAA:        c(238) = &H9999FCFC:        c(239) = &H18D8BD57
        c(240) = &H8888E0E0:        c(241) = &H9C9A14B:         c(242) = &HB4B221D:         c(243) = &H8A0A63B6:        c(244) = &HE4E24B1:         c(245) = &H8F0F651A:        c(246) = &H8D8DE64C:        c(247) = &HCCCA7E7
        c(248) = &H44429E9:         c(249) = &H85056842:        c(250) = &H8787EB14:        c(251) = &H6C6AABF:         c(252) = &H8282EDB8:        c(253) = &H3C3AC13:         c(254) = &H1412F45:         c(255) = &H80006EEE
    Case ECRC32LUTable.CRC32_AUTOSAR
          c(0) = &H0:                 c(1) = &H30850FF5:          c(2) = &H610A1FEA:          c(3) = &H518F101F:          c(4) = &HC2143FD4:          c(5) = &HF2913021:          c(6) = &HA31E203E:          c(7) = &H939B2FCB
          c(8) = &H159615F7:          c(9) = &H25131A02:         c(10) = &H749C0A1D:         c(11) = &H441905E8:         c(12) = &HD7822A23:         c(13) = &HE70725D6:         c(14) = &HB68835C9:         c(15) = &H860D3A3C
         c(16) = &H2B2C2BEE:         c(17) = &H1BA9241B:         c(18) = &H4A263404:         c(19) = &H7AA33BF1:         c(20) = &HE938143A:         c(21) = &HD9BD1BCF:         c(22) = &H88320BD0:         c(23) = &HB8B70425
         c(24) = &H3EBA3E19:         c(25) = &HE3F31EC:          c(26) = &H5FB021F3:         c(27) = &H6F352E06:         c(28) = &HFCAE01CD:         c(29) = &HCC2B0E38:         c(30) = &H9DA41E27:         c(31) = &HAD2111D2
         c(32) = &H565857DC:         c(33) = &H66DD5829:         c(34) = &H37524836:         c(35) = &H7D747C3:          c(36) = &H944C6808:         c(37) = &HA4C967FD:         c(38) = &HF54677E2:         c(39) = &HC5C37817
         c(40) = &H43CE422B:         c(41) = &H734B4DDE:         c(42) = &H22C45DC1:         c(43) = &H12415234:         c(44) = &H81DA7DFF:         c(45) = &HB15F720A:         c(46) = &HE0D06215:         c(47) = &HD0556DE0
         c(48) = &H7D747C32:         c(49) = &H4DF173C7:         c(50) = &H1C7E63D8:         c(51) = &H2CFB6C2D:         c(52) = &HBF6043E6:         c(53) = &H8FE54C13:         c(54) = &HDE6A5C0C:         c(55) = &HEEEF53F9
         c(56) = &H68E269C5:         c(57) = &H58676630:         c(58) = &H9E8762F:          c(59) = &H396D79DA:         c(60) = &HAAF65611:         c(61) = &H9A7359E4:         c(62) = &HCBFC49FB:         c(63) = &HFB79460E
         c(64) = &HACB0AFB8:         c(65) = &H9C35A04D:         c(66) = &HCDBAB052:         c(67) = &HFD3FBFA7:         c(68) = &H6EA4906C:         c(69) = &H5E219F99:         c(70) = &HFAE8F86:          c(71) = &H3F2B8073
         c(72) = &HB926BA4F:         c(73) = &H89A3B5BA:         c(74) = &HD82CA5A5:         c(75) = &HE8A9AA50:         c(76) = &H7B32859B:         c(77) = &H4BB78A6E:         c(78) = &H1A389A71:         c(79) = &H2ABD9584
         c(80) = &H879C8456:         c(81) = &HB7198BA3:         c(82) = &HE6969BBC:         c(83) = &HD6139449:         c(84) = &H4588BB82:         c(85) = &H750DB477:         c(86) = &H2482A468:         c(87) = &H1407AB9D
         c(88) = &H920A91A1:         c(89) = &HA28F9E54:         c(90) = &HF3008E4B:         c(91) = &HC38581BE:         c(92) = &H501EAE75:         c(93) = &H609BA180:         c(94) = &H3114B19F:         c(95) = &H191BE6A
         c(96) = &HFAE8F864:         c(97) = &HCA6DF791:         c(98) = &H9BE2E78E:         c(99) = &HAB67E87B:        c(100) = &H38FCC7B0:        c(101) = &H879C845:         c(102) = &H59F6D85A:        c(103) = &H6973D7AF
        c(104) = &HEF7EED93:        c(105) = &HDFFBE266:        c(106) = &H8E74F279:        c(107) = &HBEF1FD8C:        c(108) = &H2D6AD247:        c(109) = &H1DEFDDB2:        c(110) = &H4C60CDAD:        c(111) = &H7CE5C258
        c(112) = &HD1C4D38A:        c(113) = &HE141DC7F:        c(114) = &HB0CECC60:        c(115) = &H804BC395:        c(116) = &H13D0EC5E:        c(117) = &H2355E3AB:        c(118) = &H72DAF3B4:        c(119) = &H425FFC41
        c(120) = &HC452C67D:        c(121) = &HF4D7C988:        c(122) = &HA558D997:        c(123) = &H95DDD662:        c(124) = &H646F9A9:         c(125) = &H36C3F65C:        c(126) = &H674CE643:        c(127) = &H57C9E9B6
        c(128) = &HC8DF352F:        c(129) = &HF85A3ADA:        c(130) = &HA9D52AC5:        c(131) = &H99502530:        c(132) = &HACB0AFB:         c(133) = &H3A4E050E:        c(134) = &H6BC11511:        c(135) = &H5B441AE4
        c(136) = &HDD4920D8:        c(137) = &HEDCC2F2D:        c(138) = &HBC433F32:        c(139) = &H8CC630C7:        c(140) = &H1F5D1F0C:        c(141) = &H2FD810F9:        c(142) = &H7E5700E6:        c(143) = &H4ED20F13
        c(144) = &HE3F31EC1:        c(145) = &HD3761134:        c(146) = &H82F9012B:        c(147) = &HB27C0EDE:        c(148) = &H21E72115:        c(149) = &H11622EE0:        c(150) = &H40ED3EFF:        c(151) = &H7068310A
        c(152) = &HF6650B36:        c(153) = &HC6E004C3:        c(154) = &H976F14DC:        c(155) = &HA7EA1B29:        c(156) = &H347134E2:        c(157) = &H4F43B17:         c(158) = &H557B2B08:        c(159) = &H65FE24FD
        c(160) = &H9E8762F3:        c(161) = &HAE026D06:        c(162) = &HFF8D7D19:        c(163) = &HCF0872EC:        c(164) = &H5C935D27:        c(165) = &H6C1652D2:        c(166) = &H3D9942CD:        c(167) = &HD1C4D38
        c(168) = &H8B117704:        c(169) = &HBB9478F1:        c(170) = &HEA1B68EE:        c(171) = &HDA9E671B:        c(172) = &H490548D0:        c(173) = &H79804725:        c(174) = &H280F573A:        c(175) = &H188A58CF
        c(176) = &HB5AB491D:        c(177) = &H852E46E8:        c(178) = &HD4A156F7:        c(179) = &HE4245902:        c(180) = &H77BF76C9:        c(181) = &H473A793C:        c(182) = &H16B56923:        c(183) = &H263066D6
        c(184) = &HA03D5CEA:        c(185) = &H90B8531F:        c(186) = &HC1374300:        c(187) = &HF1B24CF5:        c(188) = &H6229633E:        c(189) = &H52AC6CCB:        c(190) = &H3237CD4:         c(191) = &H33A67321
        c(192) = &H646F9A97:        c(193) = &H54EA9562:        c(194) = &H565857D:         c(195) = &H35E08A88:        c(196) = &HA67BA543:        c(197) = &H96FEAAB6:        c(198) = &HC771BAA9:        c(199) = &HF7F4B55C
        c(200) = &H71F98F60:        c(201) = &H417C8095:        c(202) = &H10F3908A:        c(203) = &H20769F7F:        c(204) = &HB3EDB0B4:        c(205) = &H8368BF41:        c(206) = &HD2E7AF5E:        c(207) = &HE262A0AB
        c(208) = &H4F43B179:        c(209) = &H7FC6BE8C:        c(210) = &H2E49AE93:        c(211) = &H1ECCA166:        c(212) = &H8D578EAD:        c(213) = &HBDD28158:        c(214) = &HEC5D9147:        c(215) = &HDCD89EB2
        c(216) = &H5AD5A48E:        c(217) = &H6A50AB7B:        c(218) = &H3BDFBB64:        c(219) = &HB5AB491:         c(220) = &H98C19B5A:        c(221) = &HA84494AF:        c(222) = &HF9CB84B0:        c(223) = &HC94E8B45
        c(224) = &H3237CD4B:        c(225) = &H2B2C2BE:         c(226) = &H533DD2A1:        c(227) = &H63B8DD54:        c(228) = &HF023F29F:        c(229) = &HC0A6FD6A:        c(230) = &H9129ED75:        c(231) = &HA1ACE280
        c(232) = &H27A1D8BC:        c(233) = &H1724D749:        c(234) = &H46ABC756:        c(235) = &H762EC8A3:        c(236) = &HE5B5E768:        c(237) = &HD530E89D:        c(238) = &H84BFF882:        c(239) = &HB43AF777
        c(240) = &H191BE6A5:        c(241) = &H299EE950:        c(242) = &H7811F94F:        c(243) = &H4894F6BA:        c(244) = &HDB0FD971:        c(245) = &HEB8AD684:        c(246) = &HBA05C69B:        c(247) = &H8A80C96E
        c(248) = &HC8DF352:         c(249) = &H3C08FCA7:        c(250) = &H6D87ECB8:        c(251) = &H5D02E34D:        c(252) = &HCE99CC86:        c(253) = &HFE1CC373:        c(254) = &HAF93D36C:        c(255) = &H9F16DC99
    Case ECRC32LUTable.CRC32_BASE91D
          c(0) = &H0:                 c(1) = &H2BDDD04F:          c(2) = &H57BBA09E:          c(3) = &H7C6670D1:          c(4) = &HAF77413C:          c(5) = &H84AA9173:          c(6) = &HF8CCE1A2:          c(7) = &HD31131ED
          c(8) = &HF6DD1A53:          c(9) = &HDD00CA1C:         c(10) = &HA166BACD:         c(11) = &H8ABB6A82:         c(12) = &H59AA5B6F:         c(13) = &H72778B20:         c(14) = &HE11FBF1:          c(15) = &H25CC2BBE
         c(16) = &H4589AC8D:         c(17) = &H6E547CC2:         c(18) = &H12320C13:         c(19) = &H39EFDC5C:         c(20) = &HEAFEEDB1:         c(21) = &HC1233DFE:         c(22) = &HBD454D2F:         c(23) = &H96989D60
         c(24) = &HB354B6DE:         c(25) = &H98896691:         c(26) = &HE4EF1640:         c(27) = &HCF32C60F:         c(28) = &H1C23F7E2:         c(29) = &H37FE27AD:         c(30) = &H4B98577C:         c(31) = &H60458733
         c(32) = &H8B13591A:         c(33) = &HA0CE8955:         c(34) = &HDCA8F984:         c(35) = &HF77529CB:         c(36) = &H24641826:         c(37) = &HFB9C869:          c(38) = &H73DFB8B8:         c(39) = &H580268F7
         c(40) = &H7DCE4349:         c(41) = &H56139306:         c(42) = &H2A75E3D7:         c(43) = &H1A83398:          c(44) = &HD2B90275:         c(45) = &HF964D23A:         c(46) = &H8502A2EB:         c(47) = &HAEDF72A4
         c(48) = &HCE9AF597:         c(49) = &HE54725D8:         c(50) = &H99215509:         c(51) = &HB2FC8546:         c(52) = &H61EDB4AB:         c(53) = &H4A3064E4:         c(54) = &H36561435:         c(55) = &H1D8BC47A
         c(56) = &H3847EFC4:         c(57) = &H139A3F8B:         c(58) = &H6FFC4F5A:         c(59) = &H44219F15:         c(60) = &H9730AEF8:         c(61) = &HBCED7EB7:         c(62) = &HC08B0E66:         c(63) = &HEB56DE29
         c(64) = &HBE152A1F:         c(65) = &H95C8FA50:         c(66) = &HE9AE8A81:         c(67) = &HC2735ACE:         c(68) = &H11626B23:         c(69) = &H3ABFBB6C:         c(70) = &H46D9CBBD:         c(71) = &H6D041BF2
         c(72) = &H48C8304C:         c(73) = &H6315E003:         c(74) = &H1F7390D2:         c(75) = &H34AE409D:         c(76) = &HE7BF7170:         c(77) = &HCC62A13F:         c(78) = &HB004D1EE:         c(79) = &H9BD901A1
         c(80) = &HFB9C8692:         c(81) = &HD04156DD:         c(82) = &HAC27260C:         c(83) = &H87FAF643:         c(84) = &H54EBC7AE:         c(85) = &H7F3617E1:         c(86) = &H3506730:          c(87) = &H288DB77F
         c(88) = &HD419CC1:          c(89) = &H269C4C8E:         c(90) = &H5AFA3C5F:         c(91) = &H7127EC10:         c(92) = &HA236DDFD:         c(93) = &H89EB0DB2:         c(94) = &HF58D7D63:         c(95) = &HDE50AD2C
         c(96) = &H35067305:         c(97) = &H1EDBA34A:         c(98) = &H62BDD39B:         c(99) = &H496003D4:        c(100) = &H9A713239:        c(101) = &HB1ACE276:        c(102) = &HCDCA92A7:        c(103) = &HE61742E8
        c(104) = &HC3DB6956:        c(105) = &HE806B919:        c(106) = &H9460C9C8:        c(107) = &HBFBD1987:        c(108) = &H6CAC286A:        c(109) = &H4771F825:        c(110) = &H3B1788F4:        c(111) = &H10CA58BB
        c(112) = &H708FDF88:        c(113) = &H5B520FC7:        c(114) = &H27347F16:        c(115) = &HCE9AF59:         c(116) = &HDFF89EB4:        c(117) = &HF4254EFB:        c(118) = &H88433E2A:        c(119) = &HA39EEE65
        c(120) = &H8652C5DB:        c(121) = &HAD8F1594:        c(122) = &HD1E96545:        c(123) = &HFA34B50A:        c(124) = &H292584E7:        c(125) = &H2F854A8:         c(126) = &H7E9E2479:        c(127) = &H5543F436
        c(128) = &HD419CC15:        c(129) = &HFFC41C5A:        c(130) = &H83A26C8B:        c(131) = &HA87FBCC4:        c(132) = &H7B6E8D29:        c(133) = &H50B35D66:        c(134) = &H2CD52DB7:        c(135) = &H708FDF8
        c(136) = &H22C4D646:        c(137) = &H9190609:         c(138) = &H757F76D8:        c(139) = &H5EA2A697:        c(140) = &H8DB3977A:        c(141) = &HA66E4735:        c(142) = &HDA0837E4:        c(143) = &HF1D5E7AB
        c(144) = &H91906098:        c(145) = &HBA4DB0D7:        c(146) = &HC62BC006:        c(147) = &HEDF61049:        c(148) = &H3EE721A4:        c(149) = &H153AF1EB:        c(150) = &H695C813A:        c(151) = &H42815175
        c(152) = &H674D7ACB:        c(153) = &H4C90AA84:        c(154) = &H30F6DA55:        c(155) = &H1B2B0A1A:        c(156) = &HC83A3BF7:        c(157) = &HE3E7EBB8:        c(158) = &H9F819B69:        c(159) = &HB45C4B26
        c(160) = &H5F0A950F:        c(161) = &H74D74540:        c(162) = &H8B13591:         c(163) = &H236CE5DE:        c(164) = &HF07DD433:        c(165) = &HDBA0047C:        c(166) = &HA7C674AD:        c(167) = &H8C1BA4E2
        c(168) = &HA9D78F5C:        c(169) = &H820A5F13:        c(170) = &HFE6C2FC2:        c(171) = &HD5B1FF8D:        c(172) = &H6A0CE60:         c(173) = &H2D7D1E2F:        c(174) = &H511B6EFE:        c(175) = &H7AC6BEB1
        c(176) = &H1A833982:        c(177) = &H315EE9CD:        c(178) = &H4D38991C:        c(179) = &H66E54953:        c(180) = &HB5F478BE:        c(181) = &H9E29A8F1:        c(182) = &HE24FD820:        c(183) = &HC992086F
        c(184) = &HEC5E23D1:        c(185) = &HC783F39E:        c(186) = &HBBE5834F:        c(187) = &H90385300:        c(188) = &H432962ED:        c(189) = &H68F4B2A2:        c(190) = &H1492C273:        c(191) = &H3F4F123C
        c(192) = &H6A0CE60A:        c(193) = &H41D13645:        c(194) = &H3DB74694:        c(195) = &H166A96DB:        c(196) = &HC57BA736:        c(197) = &HEEA67779:        c(198) = &H92C007A8:        c(199) = &HB91DD7E7
        c(200) = &H9CD1FC59:        c(201) = &HB70C2C16:        c(202) = &HCB6A5CC7:        c(203) = &HE0B78C88:        c(204) = &H33A6BD65:        c(205) = &H187B6D2A:        c(206) = &H641D1DFB:        c(207) = &H4FC0CDB4
        c(208) = &H2F854A87:        c(209) = &H4589AC8:         c(210) = &H783EEA19:        c(211) = &H53E33A56:        c(212) = &H80F20BBB:        c(213) = &HAB2FDBF4:        c(214) = &HD749AB25:        c(215) = &HFC947B6A
        c(216) = &HD95850D4:        c(217) = &HF285809B:        c(218) = &H8EE3F04A:        c(219) = &HA53E2005:        c(220) = &H762F11E8:        c(221) = &H5DF2C1A7:        c(222) = &H2194B176:        c(223) = &HA496139
        c(224) = &HE11FBF10:        c(225) = &HCAC26F5F:        c(226) = &HB6A41F8E:        c(227) = &H9D79CFC1:        c(228) = &H4E68FE2C:        c(229) = &H65B52E63:        c(230) = &H19D35EB2:        c(231) = &H320E8EFD
        c(232) = &H17C2A543:        c(233) = &H3C1F750C:        c(234) = &H407905DD:        c(235) = &H6BA4D592:        c(236) = &HB8B5E47F:        c(237) = &H93683430:        c(238) = &HEF0E44E1:        c(239) = &HC4D394AE
        c(240) = &HA496139D:        c(241) = &H8F4BC3D2:        c(242) = &HF32DB303:        c(243) = &HD8F0634C:        c(244) = &HBE152A1:         c(245) = &H203C82EE:        c(246) = &H5C5AF23F:        c(247) = &H77872270
        c(248) = &H524B09CE:        c(249) = &H7996D981:        c(250) = &H5F0A950:         c(251) = &H2E2D791F:        c(252) = &HFD3C48F2:        c(253) = &HD6E198BD:        c(254) = &HAA87E86C:        c(255) = &H815A3823
    Case ECRC32LUTable.CRC32_BZIP2
          c(0) = &H0:                 c(1) = &H4C11DB7:           c(2) = &H9823B6E:           c(3) = &HD4326D9:           c(4) = &H130476DC:          c(5) = &H17C56B6B:          c(6) = &H1A864DB2:          c(7) = &H1E475005
          c(8) = &H2608EDB8:          c(9) = &H22C9F00F:         c(10) = &H2F8AD6D6:         c(11) = &H2B4BCB61:         c(12) = &H350C9B64:         c(13) = &H31CD86D3:         c(14) = &H3C8EA00A:         c(15) = &H384FBDBD
         c(16) = &H4C11DB70:         c(17) = &H48D0C6C7:         c(18) = &H4593E01E:         c(19) = &H4152FDA9:         c(20) = &H5F15ADAC:         c(21) = &H5BD4B01B:         c(22) = &H569796C2:         c(23) = &H52568B75
         c(24) = &H6A1936C8:         c(25) = &H6ED82B7F:         c(26) = &H639B0DA6:         c(27) = &H675A1011:         c(28) = &H791D4014:         c(29) = &H7DDC5DA3:         c(30) = &H709F7B7A:         c(31) = &H745E66CD
         c(32) = &H9823B6E0:         c(33) = &H9CE2AB57:         c(34) = &H91A18D8E:         c(35) = &H95609039:         c(36) = &H8B27C03C:         c(37) = &H8FE6DD8B:         c(38) = &H82A5FB52:         c(39) = &H8664E6E5
         c(40) = &HBE2B5B58:         c(41) = &HBAEA46EF:         c(42) = &HB7A96036:         c(43) = &HB3687D81:         c(44) = &HAD2F2D84:         c(45) = &HA9EE3033:         c(46) = &HA4AD16EA:         c(47) = &HA06C0B5D
         c(48) = &HD4326D90:         c(49) = &HD0F37027:         c(50) = &HDDB056FE:         c(51) = &HD9714B49:         c(52) = &HC7361B4C:         c(53) = &HC3F706FB:         c(54) = &HCEB42022:         c(55) = &HCA753D95
         c(56) = &HF23A8028:         c(57) = &HF6FB9D9F:         c(58) = &HFBB8BB46:         c(59) = &HFF79A6F1:         c(60) = &HE13EF6F4:         c(61) = &HE5FFEB43:         c(62) = &HE8BCCD9A:         c(63) = &HEC7DD02D
         c(64) = &H34867077:         c(65) = &H30476DC0:         c(66) = &H3D044B19:         c(67) = &H39C556AE:         c(68) = &H278206AB:         c(69) = &H23431B1C:         c(70) = &H2E003DC5:         c(71) = &H2AC12072
         c(72) = &H128E9DCF:         c(73) = &H164F8078:         c(74) = &H1B0CA6A1:         c(75) = &H1FCDBB16:         c(76) = &H18AEB13:          c(77) = &H54BF6A4:          c(78) = &H808D07D:          c(79) = &HCC9CDCA
         c(80) = &H7897AB07:         c(81) = &H7C56B6B0:         c(82) = &H71159069:         c(83) = &H75D48DDE:         c(84) = &H6B93DDDB:         c(85) = &H6F52C06C:         c(86) = &H6211E6B5:         c(87) = &H66D0FB02
         c(88) = &H5E9F46BF:         c(89) = &H5A5E5B08:         c(90) = &H571D7DD1:         c(91) = &H53DC6066:         c(92) = &H4D9B3063:         c(93) = &H495A2DD4:         c(94) = &H44190B0D:         c(95) = &H40D816BA
         c(96) = &HACA5C697:         c(97) = &HA864DB20:         c(98) = &HA527FDF9:         c(99) = &HA1E6E04E:        c(100) = &HBFA1B04B:        c(101) = &HBB60ADFC:        c(102) = &HB6238B25:        c(103) = &HB2E29692
        c(104) = &H8AAD2B2F:        c(105) = &H8E6C3698:        c(106) = &H832F1041:        c(107) = &H87EE0DF6:        c(108) = &H99A95DF3:        c(109) = &H9D684044:        c(110) = &H902B669D:        c(111) = &H94EA7B2A
        c(112) = &HE0B41DE7:        c(113) = &HE4750050:        c(114) = &HE9362689:        c(115) = &HEDF73B3E:        c(116) = &HF3B06B3B:        c(117) = &HF771768C:        c(118) = &HFA325055:        c(119) = &HFEF34DE2
        c(120) = &HC6BCF05F:        c(121) = &HC27DEDE8:        c(122) = &HCF3ECB31:        c(123) = &HCBFFD686:        c(124) = &HD5B88683:        c(125) = &HD1799B34:        c(126) = &HDC3ABDED:        c(127) = &HD8FBA05A
        c(128) = &H690CE0EE:        c(129) = &H6DCDFD59:        c(130) = &H608EDB80:        c(131) = &H644FC637:        c(132) = &H7A089632:        c(133) = &H7EC98B85:        c(134) = &H738AAD5C:        c(135) = &H774BB0EB
        c(136) = &H4F040D56:        c(137) = &H4BC510E1:        c(138) = &H46863638:        c(139) = &H42472B8F:        c(140) = &H5C007B8A:        c(141) = &H58C1663D:        c(142) = &H558240E4:        c(143) = &H51435D53
        c(144) = &H251D3B9E:        c(145) = &H21DC2629:        c(146) = &H2C9F00F0:        c(147) = &H285E1D47:        c(148) = &H36194D42:        c(149) = &H32D850F5:        c(150) = &H3F9B762C:        c(151) = &H3B5A6B9B
        c(152) = &H315D626:         c(153) = &H7D4CB91:         c(154) = &HA97ED48:         c(155) = &HE56F0FF:         c(156) = &H1011A0FA:        c(157) = &H14D0BD4D:        c(158) = &H19939B94:        c(159) = &H1D528623
        c(160) = &HF12F560E:        c(161) = &HF5EE4BB9:        c(162) = &HF8AD6D60:        c(163) = &HFC6C70D7:        c(164) = &HE22B20D2:        c(165) = &HE6EA3D65:        c(166) = &HEBA91BBC:        c(167) = &HEF68060B
        c(168) = &HD727BBB6:        c(169) = &HD3E6A601:        c(170) = &HDEA580D8:        c(171) = &HDA649D6F:        c(172) = &HC423CD6A:        c(173) = &HC0E2D0DD:        c(174) = &HCDA1F604:        c(175) = &HC960EBB3
        c(176) = &HBD3E8D7E:        c(177) = &HB9FF90C9:        c(178) = &HB4BCB610:        c(179) = &HB07DABA7:        c(180) = &HAE3AFBA2:        c(181) = &HAAFBE615:        c(182) = &HA7B8C0CC:        c(183) = &HA379DD7B
        c(184) = &H9B3660C6:        c(185) = &H9FF77D71:        c(186) = &H92B45BA8:        c(187) = &H9675461F:        c(188) = &H8832161A:        c(189) = &H8CF30BAD:        c(190) = &H81B02D74:        c(191) = &H857130C3
        c(192) = &H5D8A9099:        c(193) = &H594B8D2E:        c(194) = &H5408ABF7:        c(195) = &H50C9B640:        c(196) = &H4E8EE645:        c(197) = &H4A4FFBF2:        c(198) = &H470CDD2B:        c(199) = &H43CDC09C
        c(200) = &H7B827D21:        c(201) = &H7F436096:        c(202) = &H7200464F:        c(203) = &H76C15BF8:        c(204) = &H68860BFD:        c(205) = &H6C47164A:        c(206) = &H61043093:        c(207) = &H65C52D24
        c(208) = &H119B4BE9:        c(209) = &H155A565E:        c(210) = &H18197087:        c(211) = &H1CD86D30:        c(212) = &H29F3D35:         c(213) = &H65E2082:         c(214) = &HB1D065B:         c(215) = &HFDC1BEC
        c(216) = &H3793A651:        c(217) = &H3352BBE6:        c(218) = &H3E119D3F:        c(219) = &H3AD08088:        c(220) = &H2497D08D:        c(221) = &H2056CD3A:        c(222) = &H2D15EBE3:        c(223) = &H29D4F654
        c(224) = &HC5A92679:        c(225) = &HC1683BCE:        c(226) = &HCC2B1D17:        c(227) = &HC8EA00A0:        c(228) = &HD6AD50A5:        c(229) = &HD26C4D12:        c(230) = &HDF2F6BCB:        c(231) = &HDBEE767C
        c(232) = &HE3A1CBC1:        c(233) = &HE760D676:        c(234) = &HEA23F0AF:        c(235) = &HEEE2ED18:        c(236) = &HF0A5BD1D:        c(237) = &HF464A0AA:        c(238) = &HF9278673:        c(239) = &HFDE69BC4
        c(240) = &H89B8FD09:        c(241) = &H8D79E0BE:        c(242) = &H803AC667:        c(243) = &H84FBDBD0:        c(244) = &H9ABC8BD5:        c(245) = &H9E7D9662:        c(246) = &H933EB0BB:        c(247) = &H97FFAD0C
        c(248) = &HAFB010B1:        c(249) = &HAB710D06:        c(250) = &HA6322BDF:        c(251) = &HA2F33668:        c(252) = &HBCB4666D:        c(253) = &HB8757BDA:        c(254) = &HB5365D03:        c(255) = &HB1F740B4
        
    Case ECRC32LUTable.CRC32_CDROMEDC
          c(0) = &H0:                 c(1) = &H90910101:          c(2) = &H91210201:      c(3) = &H1B00300:               c(4) = &H92410401:          c(5) = &H2D00500:           c(6) = &H3600600:           c(7) = &H93F10701
          c(8) = &H94810801:          c(9) = &H4100900:          c(10) = &H5A00A00:          c(11) = &H95310B01:         c(12) = &H6C00C00:          c(13) = &H96510D01:         c(14) = &H97E10E01:         c(15) = &H7700F00
         c(16) = &H99011001:         c(17) = &H9901100:          c(18) = &H8201200:          c(19) = &H98B11301:         c(20) = &HB401400:          c(21) = &H9BD11501:         c(22) = &H9A611601:         c(23) = &HAF01700
         c(24) = &HD801800:          c(25) = &H9D111901:         c(26) = &H9CA11A01:         c(27) = &HC301B00:          c(28) = &H9FC11C01:         c(29) = &HF501D00:          c(30) = &HEE01E00:          c(31) = &H9E711F01
         c(32) = &H82012001:         c(33) = &H12902100:         c(34) = &H13202200:         c(35) = &H83B12301:         c(36) = &H10402400:         c(37) = &H80D12501:         c(38) = &H81612601:         c(39) = &H11F02700
         c(40) = &H16802800:         c(41) = &H86112901:         c(42) = &H87A12A01:         c(43) = &H17302B00:         c(44) = &H84C12C01:         c(45) = &H14502D00:         c(46) = &H15E02E00:         c(47) = &H85712F01
         c(48) = &H1B003000:         c(49) = &H8B913101:         c(50) = &H8A213201:         c(51) = &H1AB03300:         c(52) = &H89413401:         c(53) = &H19D03500:         c(54) = &H18603600:         c(55) = &H88F13701
         c(56) = &H8F813801:         c(57) = &H1F103900:         c(58) = &H1EA03A00:         c(59) = &H8E313B01:         c(60) = &H1DC03C00:         c(61) = &H8D513D01:         c(62) = &H8CE13E01:         c(63) = &H1C703F00
         c(64) = &HB4014001:         c(65) = &H24904100:         c(66) = &H25204200:         c(67) = &HB5B14301:         c(68) = &H26404400:         c(69) = &HB6D14501:         c(70) = &HB7614601:         c(71) = &H27F04700
         c(72) = &H20804800:         c(73) = &HB0114901:         c(74) = &HB1A14A01:         c(75) = &H21304B00:         c(76) = &HB2C14C01:         c(77) = &H22504D00:         c(78) = &H23E04E00:         c(79) = &HB3714F01
         c(80) = &H2D005000:         c(81) = &HBD915101:         c(82) = &HBC215201:         c(83) = &H2CB05300:         c(84) = &HBF415401:         c(85) = &H2FD05500:         c(86) = &H2E605600:         c(87) = &HBEF15701
         c(88) = &HB9815801:         c(89) = &H29105900:         c(90) = &H28A05A00:         c(91) = &HB8315B01:         c(92) = &H2BC05C00:         c(93) = &HBB515D01:         c(94) = &HBAE15E01:         c(95) = &H2A705F00
         c(96) = &H36006000:         c(97) = &HA6916101:         c(98) = &HA7216201:         c(99) = &H37B06300:        c(100) = &HA4416401:        c(101) = &H34D06500:        c(102) = &H35606600:        c(103) = &HA5F16701
        c(104) = &HA2816801:        c(105) = &H32106900:        c(106) = &H33A06A00:        c(107) = &HA3316B01:        c(108) = &H30C06C00:        c(109) = &HA0516D01:        c(110) = &HA1E16E01:        c(111) = &H31706F00
        c(112) = &HAF017001:        c(113) = &H3F907100:        c(114) = &H3E207200:        c(115) = &HAEB17301:        c(116) = &H3D407400:        c(117) = &HADD17501:        c(118) = &HAC617601:        c(119) = &H3CF07700
        c(120) = &H3B807800:        c(121) = &HAB117901:        c(122) = &HAAA17A01:        c(123) = &H3A307B00:        c(124) = &HA9C17C01:        c(125) = &H39507D00:        c(126) = &H38E07E00:        c(127) = &HA8717F01
        c(128) = &HD8018001:        c(129) = &H48908100:        c(130) = &H49208200:        c(131) = &HD9B18301:        c(132) = &H4A408400:        c(133) = &HDAD18501:        c(134) = &HDB618601:        c(135) = &H4BF08700
        c(136) = &H4C808800:        c(137) = &HDC118901:        c(138) = &HDDA18A01:        c(139) = &H4D308B00:        c(140) = &HDEC18C01:        c(141) = &H4E508D00:        c(142) = &H4FE08E00:        c(143) = &HDF718F01
        c(144) = &H41009000:        c(145) = &HD1919101:        c(146) = &HD0219201:        c(147) = &H40B09300:        c(148) = &HD3419401:        c(149) = &H43D09500:        c(150) = &H42609600:        c(151) = &HD2F19701
        c(152) = &HD5819801:        c(153) = &H45109900:        c(154) = &H44A09A00:        c(155) = &HD4319B01:        c(156) = &H47C09C00:        c(157) = &HD7519D01:        c(158) = &HD6E19E01:        c(159) = &H46709F00
        c(160) = &H5A00A000:        c(161) = &HCA91A101:        c(162) = &HCB21A201:        c(163) = &H5BB0A300:        c(164) = &HC841A401:        c(165) = &H58D0A500:        c(166) = &H5960A600:        c(167) = &HC9F1A701
        c(168) = &HCE81A801:        c(169) = &H5E10A900:        c(170) = &H5FA0AA00:        c(171) = &HCF31AB01:        c(172) = &H5CC0AC00:        c(173) = &HCC51AD01:        c(174) = &HCDE1AE01:        c(175) = &H5D70AF00
        c(176) = &HC301B001:        c(177) = &H5390B100:        c(178) = &H5220B200:        c(179) = &HC2B1B301:        c(180) = &H5140B400:        c(181) = &HC1D1B501:        c(182) = &HC061B601:        c(183) = &H50F0B700
        c(184) = &H5780B800:        c(185) = &HC711B901:        c(186) = &HC6A1BA01:        c(187) = &H5630BB00:        c(188) = &HC5C1BC01:        c(189) = &H5550BD00:        c(190) = &H54E0BE00:        c(191) = &HC471BF01
        c(192) = &H6C00C000:        c(193) = &HFC91C101:        c(194) = &HFD21C201:        c(195) = &H6DB0C300:        c(196) = &HFE41C401:        c(197) = &H6ED0C500:        c(198) = &H6F60C600:        c(199) = &HFFF1C701
        c(200) = &HF881C801:        c(201) = &H6810C900:        c(202) = &H69A0CA00:        c(203) = &HF931CB01:        c(204) = &H6AC0CC00:        c(205) = &HFA51CD01:        c(206) = &HFBE1CE01:        c(207) = &H6B70CF00
        c(208) = &HF501D001:        c(209) = &H6590D100:        c(210) = &H6420D200:        c(211) = &HF4B1D301:        c(212) = &H6740D400:        c(213) = &HF7D1D501:        c(214) = &HF661D601:        c(215) = &H66F0D700
        c(216) = &H6180D800:        c(217) = &HF111D901:        c(218) = &HF0A1DA01:        c(219) = &H6030DB00:        c(220) = &HF3C1DC01:        c(221) = &H6350DD00:        c(222) = &H62E0DE00:        c(223) = &HF271DF01
        c(224) = &HEE01E001:        c(225) = &H7E90E100:        c(226) = &H7F20E200:        c(227) = &HEFB1E301:        c(228) = &H7C40E400:        c(229) = &HECD1E501:        c(230) = &HED61E601:        c(231) = &H7DF0E700
        c(232) = &H7A80E800:        c(233) = &HEA11E901:        c(234) = &HEBA1EA01:        c(235) = &H7B30EB00:        c(236) = &HE8C1EC01:        c(237) = &H7850ED00:        c(238) = &H79E0EE00:        c(239) = &HE971EF01
        c(240) = &H7700F000:        c(241) = &HE791F101:        c(242) = &HE621F201:        c(243) = &H76B0F300:        c(244) = &HE541F401:        c(245) = &H75D0F500:        c(246) = &H7460F600:        c(247) = &HE4F1F701
        c(248) = &HE381F801:        c(249) = &H7310F900:        c(250) = &H72A0FA00:        c(251) = &HE231FB01:        c(252) = &H71C0FC00:        c(253) = &HE151FD01:        c(254) = &HE0E1FE01:        c(255) = &H7070FF00
        
    Case ECRC32LUTable.CRC32_CKSUM
          c(0) = &H0:                 c(1) = &H4C11DB7:           c(2) = &H9823B6E:           c(3) = &HD4326D9:           c(4) = &H130476DC:          c(5) = &H17C56B6B:          c(6) = &H1A864DB2:          c(7) = &H1E475005
          c(8) = &H2608EDB8:          c(9) = &H22C9F00F:         c(10) = &H2F8AD6D6:         c(11) = &H2B4BCB61:         c(12) = &H350C9B64:         c(13) = &H31CD86D3:         c(14) = &H3C8EA00A:         c(15) = &H384FBDBD
         c(16) = &H4C11DB70:         c(17) = &H48D0C6C7:         c(18) = &H4593E01E:         c(19) = &H4152FDA9:         c(20) = &H5F15ADAC:         c(21) = &H5BD4B01B:         c(22) = &H569796C2:         c(23) = &H52568B75
         c(24) = &H6A1936C8:         c(25) = &H6ED82B7F:         c(26) = &H639B0DA6:         c(27) = &H675A1011:         c(28) = &H791D4014:         c(29) = &H7DDC5DA3:         c(30) = &H709F7B7A:         c(31) = &H745E66CD
         c(32) = &H9823B6E0:         c(33) = &H9CE2AB57:         c(34) = &H91A18D8E:         c(35) = &H95609039:         c(36) = &H8B27C03C:         c(37) = &H8FE6DD8B:         c(38) = &H82A5FB52:         c(39) = &H8664E6E5
         c(40) = &HBE2B5B58:         c(41) = &HBAEA46EF:         c(42) = &HB7A96036:         c(43) = &HB3687D81:         c(44) = &HAD2F2D84:         c(45) = &HA9EE3033:         c(46) = &HA4AD16EA:         c(47) = &HA06C0B5D
         c(48) = &HD4326D90:         c(49) = &HD0F37027:         c(50) = &HDDB056FE:         c(51) = &HD9714B49:         c(52) = &HC7361B4C:         c(53) = &HC3F706FB:         c(54) = &HCEB42022:         c(55) = &HCA753D95
         c(56) = &HF23A8028:         c(57) = &HF6FB9D9F:         c(58) = &HFBB8BB46:         c(59) = &HFF79A6F1:         c(60) = &HE13EF6F4:         c(61) = &HE5FFEB43:         c(62) = &HE8BCCD9A:         c(63) = &HEC7DD02D
         c(64) = &H34867077:         c(65) = &H30476DC0:         c(66) = &H3D044B19:         c(67) = &H39C556AE:         c(68) = &H278206AB:         c(69) = &H23431B1C:         c(70) = &H2E003DC5:         c(71) = &H2AC12072
         c(72) = &H128E9DCF:         c(73) = &H164F8078:         c(74) = &H1B0CA6A1:         c(75) = &H1FCDBB16:         c(76) = &H18AEB13:          c(77) = &H54BF6A4:          c(78) = &H808D07D:          c(79) = &HCC9CDCA
         c(80) = &H7897AB07:         c(81) = &H7C56B6B0:         c(82) = &H71159069:         c(83) = &H75D48DDE:         c(84) = &H6B93DDDB:         c(85) = &H6F52C06C:         c(86) = &H6211E6B5:         c(87) = &H66D0FB02
         c(88) = &H5E9F46BF:         c(89) = &H5A5E5B08:         c(90) = &H571D7DD1:         c(91) = &H53DC6066:         c(92) = &H4D9B3063:         c(93) = &H495A2DD4:         c(94) = &H44190B0D:         c(95) = &H40D816BA
         c(96) = &HACA5C697:         c(97) = &HA864DB20:         c(98) = &HA527FDF9:         c(99) = &HA1E6E04E:        c(100) = &HBFA1B04B:        c(101) = &HBB60ADFC:        c(102) = &HB6238B25:        c(103) = &HB2E29692
        c(104) = &H8AAD2B2F:        c(105) = &H8E6C3698:        c(106) = &H832F1041:        c(107) = &H87EE0DF6:        c(108) = &H99A95DF3:        c(109) = &H9D684044:        c(110) = &H902B669D:        c(111) = &H94EA7B2A
        c(112) = &HE0B41DE7:        c(113) = &HE4750050:        c(114) = &HE9362689:        c(115) = &HEDF73B3E:        c(116) = &HF3B06B3B:        c(117) = &HF771768C:        c(118) = &HFA325055:        c(119) = &HFEF34DE2
        c(120) = &HC6BCF05F:        c(121) = &HC27DEDE8:        c(122) = &HCF3ECB31:        c(123) = &HCBFFD686:        c(124) = &HD5B88683:        c(125) = &HD1799B34:        c(126) = &HDC3ABDED:        c(127) = &HD8FBA05A
        c(128) = &H690CE0EE:        c(129) = &H6DCDFD59:        c(130) = &H608EDB80:        c(131) = &H644FC637:        c(132) = &H7A089632:        c(133) = &H7EC98B85:        c(134) = &H738AAD5C:        c(135) = &H774BB0EB
        c(136) = &H4F040D56:        c(137) = &H4BC510E1:        c(138) = &H46863638:        c(139) = &H42472B8F:        c(140) = &H5C007B8A:        c(141) = &H58C1663D:        c(142) = &H558240E4:        c(143) = &H51435D53
        c(144) = &H251D3B9E:        c(145) = &H21DC2629:        c(146) = &H2C9F00F0:        c(147) = &H285E1D47:        c(148) = &H36194D42:        c(149) = &H32D850F5:        c(150) = &H3F9B762C:        c(151) = &H3B5A6B9B
        c(152) = &H315D626:         c(153) = &H7D4CB91:         c(154) = &HA97ED48:         c(155) = &HE56F0FF:         c(156) = &H1011A0FA:        c(157) = &H14D0BD4D:        c(158) = &H19939B94:        c(159) = &H1D528623
        c(160) = &HF12F560E:        c(161) = &HF5EE4BB9:        c(162) = &HF8AD6D60:        c(163) = &HFC6C70D7:        c(164) = &HE22B20D2:        c(165) = &HE6EA3D65:        c(166) = &HEBA91BBC:        c(167) = &HEF68060B
        c(168) = &HD727BBB6:        c(169) = &HD3E6A601:        c(170) = &HDEA580D8:        c(171) = &HDA649D6F:        c(172) = &HC423CD6A:        c(173) = &HC0E2D0DD:        c(174) = &HCDA1F604:        c(175) = &HC960EBB3
        c(176) = &HBD3E8D7E:        c(177) = &HB9FF90C9:        c(178) = &HB4BCB610:        c(179) = &HB07DABA7:        c(180) = &HAE3AFBA2:        c(181) = &HAAFBE615:        c(182) = &HA7B8C0CC:        c(183) = &HA379DD7B
        c(184) = &H9B3660C6:        c(185) = &H9FF77D71:        c(186) = &H92B45BA8:        c(187) = &H9675461F:        c(188) = &H8832161A:        c(189) = &H8CF30BAD:        c(190) = &H81B02D74:        c(191) = &H857130C3
        c(192) = &H5D8A9099:        c(193) = &H594B8D2E:        c(194) = &H5408ABF7:        c(195) = &H50C9B640:        c(196) = &H4E8EE645:        c(197) = &H4A4FFBF2:        c(198) = &H470CDD2B:        c(199) = &H43CDC09C
        c(200) = &H7B827D21:        c(201) = &H7F436096:        c(202) = &H7200464F:        c(203) = &H76C15BF8:        c(204) = &H68860BFD:        c(205) = &H6C47164A:        c(206) = &H61043093:        c(207) = &H65C52D24
        c(208) = &H119B4BE9:        c(209) = &H155A565E:        c(210) = &H18197087:        c(211) = &H1CD86D30:        c(212) = &H29F3D35:         c(213) = &H65E2082:         c(214) = &HB1D065B:         c(215) = &HFDC1BEC
        c(216) = &H3793A651:        c(217) = &H3352BBE6:        c(218) = &H3E119D3F:        c(219) = &H3AD08088:        c(220) = &H2497D08D:        c(221) = &H2056CD3A:        c(222) = &H2D15EBE3:        c(223) = &H29D4F654
        c(224) = &HC5A92679:        c(225) = &HC1683BCE:        c(226) = &HCC2B1D17:        c(227) = &HC8EA00A0:        c(228) = &HD6AD50A5:        c(229) = &HD26C4D12:        c(230) = &HDF2F6BCB:        c(231) = &HDBEE767C
        c(232) = &HE3A1CBC1:        c(233) = &HE760D676:        c(234) = &HEA23F0AF:        c(235) = &HEEE2ED18:        c(236) = &HF0A5BD1D:        c(237) = &HF464A0AA:        c(238) = &HF9278673:        c(239) = &HFDE69BC4
        c(240) = &H89B8FD09:        c(241) = &H8D79E0BE:        c(242) = &H803AC667:        c(243) = &H84FBDBD0:        c(244) = &H9ABC8BD5:        c(245) = &H9E7D9662:        c(246) = &H933EB0BB:        c(247) = &H97FFAD0C
        c(248) = &HAFB010B1:        c(249) = &HAB710D06:        c(250) = &HA6322BDF:        c(251) = &HA2F33668:        c(252) = &HBCB4666D:        c(253) = &HB8757BDA:        c(254) = &HB5365D03:        c(255) = &HB1F740B4
    Case ECRC32LUTable.CRC32_ISCSI
          c(0) = &H0:                 c(1) = &HF26B8303:          c(2) = &HE13B70F7:          c(3) = &H1350F3F4:          c(4) = &HC79A971F:          c(5) = &H35F1141C:          c(6) = &H26A1E7E8:          c(7) = &HD4CA64EB
          c(8) = &H8AD958CF:          c(9) = &H78B2DBCC:         c(10) = &H6BE22838:         c(11) = &H9989AB3B:         c(12) = &H4D43CFD0:         c(13) = &HBF284CD3:         c(14) = &HAC78BF27:         c(15) = &H5E133C24
         c(16) = &H105EC76F:         c(17) = &HE235446C:         c(18) = &HF165B798:         c(19) = &H30E349B:          c(20) = &HD7C45070:         c(21) = &H25AFD373:         c(22) = &H36FF2087:         c(23) = &HC494A384
         c(24) = &H9A879FA0:         c(25) = &H68EC1CA3:         c(26) = &H7BBCEF57:         c(27) = &H89D76C54:         c(28) = &H5D1D08BF:         c(29) = &HAF768BBC:         c(30) = &HBC267848:         c(31) = &H4E4DFB4B
         c(32) = &H20BD8EDE:         c(33) = &HD2D60DDD:         c(34) = &HC186FE29:         c(35) = &H33ED7D2A:         c(36) = &HE72719C1:         c(37) = &H154C9AC2:         c(38) = &H61C6936:          c(39) = &HF477EA35
         c(40) = &HAA64D611:         c(41) = &H580F5512:         c(42) = &H4B5FA6E6:         c(43) = &HB93425E5:         c(44) = &H6DFE410E:         c(45) = &H9F95C20D:         c(46) = &H8CC531F9:         c(47) = &H7EAEB2FA
         c(48) = &H30E349B1:         c(49) = &HC288CAB2:         c(50) = &HD1D83946:         c(51) = &H23B3BA45:         c(52) = &HF779DEAE:         c(53) = &H5125DAD:          c(54) = &H1642AE59:         c(55) = &HE4292D5A
         c(56) = &HBA3A117E:         c(57) = &H4851927D:         c(58) = &H5B016189:         c(59) = &HA96AE28A:         c(60) = &H7DA08661:         c(61) = &H8FCB0562:         c(62) = &H9C9BF696:         c(63) = &H6EF07595
         c(64) = &H417B1DBC:         c(65) = &HB3109EBF:         c(66) = &HA0406D4B:         c(67) = &H522BEE48:         c(68) = &H86E18AA3:         c(69) = &H748A09A0:         c(70) = &H67DAFA54:         c(71) = &H95B17957
         c(72) = &HCBA24573:         c(73) = &H39C9C670:         c(74) = &H2A993584:         c(75) = &HD8F2B687:         c(76) = &HC38D26C:          c(77) = &HFE53516F:         c(78) = &HED03A29B:         c(79) = &H1F682198
         c(80) = &H5125DAD3:         c(81) = &HA34E59D0:         c(82) = &HB01EAA24:         c(83) = &H42752927:         c(84) = &H96BF4DCC:         c(85) = &H64D4CECF:         c(86) = &H77843D3B:         c(87) = &H85EFBE38
         c(88) = &HDBFC821C:         c(89) = &H2997011F:         c(90) = &H3AC7F2EB:         c(91) = &HC8AC71E8:         c(92) = &H1C661503:         c(93) = &HEE0D9600:         c(94) = &HFD5D65F4:         c(95) = &HF36E6F7
         c(96) = &H61C69362:         c(97) = &H93AD1061:         c(98) = &H80FDE395:         c(99) = &H72966096:        c(100) = &HA65C047D:        c(101) = &H5437877E:        c(102) = &H4767748A:        c(103) = &HB50CF789
        c(104) = &HEB1FCBAD:        c(105) = &H197448AE:        c(106) = &HA24BB5A:         c(107) = &HF84F3859:        c(108) = &H2C855CB2:        c(109) = &HDEEEDFB1:        c(110) = &HCDBE2C45:        c(111) = &H3FD5AF46
        c(112) = &H7198540D:        c(113) = &H83F3D70E:        c(114) = &H90A324FA:        c(115) = &H62C8A7F9:        c(116) = &HB602C312:        c(117) = &H44694011:        c(118) = &H5739B3E5:        c(119) = &HA55230E6
        c(120) = &HFB410CC2:        c(121) = &H92A8FC1:         c(122) = &H1A7A7C35:        c(123) = &HE811FF36:        c(124) = &H3CDB9BDD:        c(125) = &HCEB018DE:        c(126) = &HDDE0EB2A:        c(127) = &H2F8B6829
        c(128) = &H82F63B78:        c(129) = &H709DB87B:        c(130) = &H63CD4B8F:        c(131) = &H91A6C88C:        c(132) = &H456CAC67:        c(133) = &HB7072F64:        c(134) = &HA457DC90:        c(135) = &H563C5F93
        c(136) = &H82F63B7:         c(137) = &HFA44E0B4:        c(138) = &HE9141340:        c(139) = &H1B7F9043:        c(140) = &HCFB5F4A8:        c(141) = &H3DDE77AB:        c(142) = &H2E8E845F:        c(143) = &HDCE5075C
        c(144) = &H92A8FC17:        c(145) = &H60C37F14:        c(146) = &H73938CE0:        c(147) = &H81F80FE3:        c(148) = &H55326B08:        c(149) = &HA759E80B:        c(150) = &HB4091BFF:        c(151) = &H466298FC
        c(152) = &H1871A4D8:        c(153) = &HEA1A27DB:        c(154) = &HF94AD42F:        c(155) = &HB21572C:         c(156) = &HDFEB33C7:        c(157) = &H2D80B0C4:        c(158) = &H3ED04330:        c(159) = &HCCBBC033
        c(160) = &HA24BB5A6:        c(161) = &H502036A5:        c(162) = &H4370C551:        c(163) = &HB11B4652:        c(164) = &H65D122B9:        c(165) = &H97BAA1BA:        c(166) = &H84EA524E:        c(167) = &H7681D14D
        c(168) = &H2892ED69:        c(169) = &HDAF96E6A:        c(170) = &HC9A99D9E:        c(171) = &H3BC21E9D:        c(172) = &HEF087A76:        c(173) = &H1D63F975:        c(174) = &HE330A81:         c(175) = &HFC588982
        c(176) = &HB21572C9:        c(177) = &H407EF1CA:        c(178) = &H532E023E:        c(179) = &HA145813D:        c(180) = &H758FE5D6:        c(181) = &H87E466D5:        c(182) = &H94B49521:        c(183) = &H66DF1622
        c(184) = &H38CC2A06:        c(185) = &HCAA7A905:        c(186) = &HD9F75AF1:        c(187) = &H2B9CD9F2:        c(188) = &HFF56BD19:        c(189) = &HD3D3E1A:         c(190) = &H1E6DCDEE:        c(191) = &HEC064EED
        c(192) = &HC38D26C4:        c(193) = &H31E6A5C7:        c(194) = &H22B65633:        c(195) = &HD0DDD530:        c(196) = &H417B1DB:         c(197) = &HF67C32D8:        c(198) = &HE52CC12C:        c(199) = &H1747422F
        c(200) = &H49547E0B:        c(201) = &HBB3FFD08:        c(202) = &HA86F0EFC:        c(203) = &H5A048DFF:        c(204) = &H8ECEE914:        c(205) = &H7CA56A17:        c(206) = &H6FF599E3:        c(207) = &H9D9E1AE0
        c(208) = &HD3D3E1AB:        c(209) = &H21B862A8:        c(210) = &H32E8915C:        c(211) = &HC083125F:        c(212) = &H144976B4:        c(213) = &HE622F5B7:        c(214) = &HF5720643:        c(215) = &H7198540
        c(216) = &H590AB964:        c(217) = &HAB613A67:        c(218) = &HB831C993:        c(219) = &H4A5A4A90:        c(220) = &H9E902E7B:        c(221) = &H6CFBAD78:        c(222) = &H7FAB5E8C:        c(223) = &H8DC0DD8F
        c(224) = &HE330A81A:        c(225) = &H115B2B19:        c(226) = &H20BD8ED:         c(227) = &HF0605BEE:        c(228) = &H24AA3F05:        c(229) = &HD6C1BC06:        c(230) = &HC5914FF2:        c(231) = &H37FACCF1
        c(232) = &H69E9F0D5:        c(233) = &H9B8273D6:        c(234) = &H88D28022:        c(235) = &H7AB90321:        c(236) = &HAE7367CA:        c(237) = &H5C18E4C9:        c(238) = &H4F48173D:        c(239) = &HBD23943E
        c(240) = &HF36E6F75:        c(241) = &H105EC76:         c(242) = &H12551F82:        c(243) = &HE03E9C81:        c(244) = &H34F4F86A:        c(245) = &HC69F7B69:        c(246) = &HD5CF889D:        c(247) = &H27A40B9E
        c(248) = &H79B737BA:        c(249) = &H8BDCB4B9:        c(250) = &H988C474D:        c(251) = &H6AE7C44E:        c(252) = &HBE2DA0A5:        c(253) = &H4C4623A6:        c(254) = &H5F16D052:        c(255) = &HAD7D5351
    
    Case ECRC32LUTable.CRC32_ISOHDLC, ECRC32LUTable.CRC32_JAMCRC
          c(0) = &H0:                 c(1) = &H77073096:          c(2) = &HEE0E612C:          c(3) = &H990951BA:          c(4) = &H76DC419:           c(5) = &H706AF48F:          c(6) = &HE963A535:          c(7) = &H9E6495A3
          c(8) = &HEDB8832:           c(9) = &H79DCB8A4:         c(10) = &HE0D5E91E:         c(11) = &H97D2D988:         c(12) = &H9B64C2B:          c(13) = &H7EB17CBD:         c(14) = &HE7B82D07:         c(15) = &H90BF1D91
         c(16) = &H1DB71064:         c(17) = &H6AB020F2:         c(18) = &HF3B97148:         c(19) = &H84BE41DE:         c(20) = &H1ADAD47D:         c(21) = &H6DDDE4EB:         c(22) = &HF4D4B551:         c(23) = &H83D385C7
         c(24) = &H136C9856:         c(25) = &H646BA8C0:         c(26) = &HFD62F97A:         c(27) = &H8A65C9EC:         c(28) = &H14015C4F:         c(29) = &H63066CD9:         c(30) = &HFA0F3D63:         c(31) = &H8D080DF5
         c(32) = &H3B6E20C8:         c(33) = &H4C69105E:         c(34) = &HD56041E4:         c(35) = &HA2677172:         c(36) = &H3C03E4D1:         c(37) = &H4B04D447:         c(38) = &HD20D85FD:         c(39) = &HA50AB56B
         c(40) = &H35B5A8FA:         c(41) = &H42B2986C:         c(42) = &HDBBBC9D6:         c(43) = &HACBCF940:         c(44) = &H32D86CE3:         c(45) = &H45DF5C75:         c(46) = &HDCD60DCF:         c(47) = &HABD13D59
         c(48) = &H26D930AC:         c(49) = &H51DE003A:         c(50) = &HC8D75180:         c(51) = &HBFD06116:         c(52) = &H21B4F4B5:         c(53) = &H56B3C423:         c(54) = &HCFBA9599:         c(55) = &HB8BDA50F
         c(56) = &H2802B89E:         c(57) = &H5F058808:         c(58) = &HC60CD9B2:         c(59) = &HB10BE924:         c(60) = &H2F6F7C87:         c(61) = &H58684C11:         c(62) = &HC1611DAB:         c(63) = &HB6662D3D
         c(64) = &H76DC4190:         c(65) = &H1DB7106:          c(66) = &H98D220BC:         c(67) = &HEFD5102A:         c(68) = &H71B18589:         c(69) = &H6B6B51F:          c(70) = &H9FBFE4A5:         c(71) = &HE8B8D433
         c(72) = &H7807C9A2:         c(73) = &HF00F934:          c(74) = &H9609A88E:         c(75) = &HE10E9818:         c(76) = &H7F6A0DBB:         c(77) = &H86D3D2D:          c(78) = &H91646C97:         c(79) = &HE6635C01
         c(80) = &H6B6B51F4:         c(81) = &H1C6C6162:         c(82) = &H856530D8:         c(83) = &HF262004E:         c(84) = &H6C0695ED:         c(85) = &H1B01A57B:         c(86) = &H8208F4C1:         c(87) = &HF50FC457
         c(88) = &H65B0D9C6:         c(89) = &H12B7E950:         c(90) = &H8BBEB8EA:         c(91) = &HFCB9887C:         c(92) = &H62DD1DDF:         c(93) = &H15DA2D49:         c(94) = &H8CD37CF3:         c(95) = &HFBD44C65
         c(96) = &H4DB26158:         c(97) = &H3AB551CE:         c(98) = &HA3BC0074:         c(99) = &HD4BB30E2:        c(100) = &H4ADFA541:        c(101) = &H3DD895D7:        c(102) = &HA4D1C46D:        c(103) = &HD3D6F4FB
        c(104) = &H4369E96A:        c(105) = &H346ED9FC:        c(106) = &HAD678846:        c(107) = &HDA60B8D0:        c(108) = &H44042D73:        c(109) = &H33031DE5:        c(110) = &HAA0A4C5F:        c(111) = &HDD0D7CC9
        c(112) = &H5005713C:        c(113) = &H270241AA:        c(114) = &HBE0B1010:        c(115) = &HC90C2086:        c(116) = &H5768B525:        c(117) = &H206F85B3:        c(118) = &HB966D409:        c(119) = &HCE61E49F
        c(120) = &H5EDEF90E:        c(121) = &H29D9C998:        c(122) = &HB0D09822:        c(123) = &HC7D7A8B4:        c(124) = &H59B33D17:        c(125) = &H2EB40D81:        c(126) = &HB7BD5C3B:        c(127) = &HC0BA6CAD
        c(128) = &HEDB88320:        c(129) = &H9ABFB3B6:        c(130) = &H3B6E20C:         c(131) = &H74B1D29A:        c(132) = &HEAD54739:        c(133) = &H9DD277AF:        c(134) = &H4DB2615:         c(135) = &H73DC1683
        c(136) = &HE3630B12:        c(137) = &H94643B84:        c(138) = &HD6D6A3E:         c(139) = &H7A6A5AA8:        c(140) = &HE40ECF0B:        c(141) = &H9309FF9D:        c(142) = &HA00AE27:         c(143) = &H7D079EB1
        c(144) = &HF00F9344:        c(145) = &H8708A3D2:        c(146) = &H1E01F268:        c(147) = &H6906C2FE:        c(148) = &HF762575D:        c(149) = &H806567CB:        c(150) = &H196C3671:        c(151) = &H6E6B06E7
        c(152) = &HFED41B76:        c(153) = &H89D32BE0:        c(154) = &H10DA7A5A:        c(155) = &H67DD4ACC:        c(156) = &HF9B9DF6F:        c(157) = &H8EBEEFF9:        c(158) = &H17B7BE43:        c(159) = &H60B08ED5
        c(160) = &HD6D6A3E8:        c(161) = &HA1D1937E:        c(162) = &H38D8C2C4:        c(163) = &H4FDFF252:        c(164) = &HD1BB67F1:        c(165) = &HA6BC5767:        c(166) = &H3FB506DD:        c(167) = &H48B2364B
        c(168) = &HD80D2BDA:        c(169) = &HAF0A1B4C:        c(170) = &H36034AF6:        c(171) = &H41047A60:        c(172) = &HDF60EFC3:        c(173) = &HA867DF55:        c(174) = &H316E8EEF:        c(175) = &H4669BE79
        c(176) = &HCB61B38C:        c(177) = &HBC66831A:        c(178) = &H256FD2A0:        c(179) = &H5268E236:        c(180) = &HCC0C7795:        c(181) = &HBB0B4703:        c(182) = &H220216B9:        c(183) = &H5505262F
        c(184) = &HC5BA3BBE:        c(185) = &HB2BD0B28:        c(186) = &H2BB45A92:        c(187) = &H5CB36A04:        c(188) = &HC2D7FFA7:        c(189) = &HB5D0CF31:        c(190) = &H2CD99E8B:        c(191) = &H5BDEAE1D
        c(192) = &H9B64C2B0:        c(193) = &HEC63F226:        c(194) = &H756AA39C:        c(195) = &H26D930A:         c(196) = &H9C0906A9:        c(197) = &HEB0E363F:        c(198) = &H72076785:        c(199) = &H5005713
        c(200) = &H95BF4A82:        c(201) = &HE2B87A14:        c(202) = &H7BB12BAE:        c(203) = &HCB61B38:         c(204) = &H92D28E9B:        c(205) = &HE5D5BE0D:        c(206) = &H7CDCEFB7:        c(207) = &HBDBDF21
        c(208) = &H86D3D2D4:        c(209) = &HF1D4E242:        c(210) = &H68DDB3F8:        c(211) = &H1FDA836E:        c(212) = &H81BE16CD:        c(213) = &HF6B9265B:        c(214) = &H6FB077E1:        c(215) = &H18B74777
        c(216) = &H88085AE6:        c(217) = &HFF0F6A70:        c(218) = &H66063BCA:        c(219) = &H11010B5C:        c(220) = &H8F659EFF:        c(221) = &HF862AE69:        c(222) = &H616BFFD3:        c(223) = &H166CCF45
        c(224) = &HA00AE278:        c(225) = &HD70DD2EE:        c(226) = &H4E048354:        c(227) = &H3903B3C2:        c(228) = &HA7672661:        c(229) = &HD06016F7:        c(230) = &H4969474D:        c(231) = &H3E6E77DB
        c(232) = &HAED16A4A:        c(233) = &HD9D65ADC:        c(234) = &H40DF0B66:        c(235) = &H37D83BF0:        c(236) = &HA9BCAE53:        c(237) = &HDEBB9EC5:        c(238) = &H47B2CF7F:        c(239) = &H30B5FFE9
        c(240) = &HBDBDF21C:        c(241) = &HCABAC28A:        c(242) = &H53B39330:        c(243) = &H24B4A3A6:        c(244) = &HBAD03605:        c(245) = &HCDD70693:        c(246) = &H54DE5729:        c(247) = &H23D967BF
        c(248) = &HB3667A2E:        c(249) = &HC4614AB8:        c(250) = &H5D681B02:        c(251) = &H2A6F2B94:        c(252) = &HB40BBE37:        c(253) = &HC30C8EA1:        c(254) = &H5A05DF1B:        c(255) = &H2D02EF8D
    Case ECRC32LUTable.CRC32_MEF
          c(0) = &H0:                 c(1) = &H9695C4CA:          c(2) = &HFB4839C9:          c(3) = &H6DDDFD03:          c(4) = &H20F3C3CF:          c(5) = &HB6660705:          c(6) = &HDBBBFA06:          c(7) = &H4D2E3ECC
          c(8) = &H41E7879E:          c(9) = &HD7724354:         c(10) = &HBAAFBE57:         c(11) = &H2C3A7A9D:         c(12) = &H61144451:         c(13) = &HF781809B:         c(14) = &H9A5C7D98:         c(15) = &HCC9B952
         c(16) = &H83CF0F3C:         c(17) = &H155ACBF6:         c(18) = &H788736F5:         c(19) = &HEE12F23F:         c(20) = &HA33CCCF3:         c(21) = &H35A90839:         c(22) = &H5874F53A:         c(23) = &HCEE131F0
         c(24) = &HC22888A2:         c(25) = &H54BD4C68:         c(26) = &H3960B16B:         c(27) = &HAFF575A1:         c(28) = &HE2DB4B6D:         c(29) = &H744E8FA7:         c(30) = &H199372A4:         c(31) = &H8F06B66E
         c(32) = &HD1FDAE25:         c(33) = &H47686AEF:         c(34) = &H2AB597EC:         c(35) = &HBC205326:         c(36) = &HF10E6DEA:         c(37) = &H679BA920:         c(38) = &HA465423:          c(39) = &H9CD390E9
         c(40) = &H901A29BB:         c(41) = &H68FED71:          c(42) = &H6B521072:         c(43) = &HFDC7D4B8:         c(44) = &HB0E9EA74:         c(45) = &H267C2EBE:         c(46) = &H4BA1D3BD:         c(47) = &HDD341777
         c(48) = &H5232A119:         c(49) = &HC4A765D3:         c(50) = &HA97A98D0:         c(51) = &H3FEF5C1A:         c(52) = &H72C162D6:         c(53) = &HE454A61C:         c(54) = &H89895B1F:         c(55) = &H1F1C9FD5
         c(56) = &H13D52687:         c(57) = &H8540E24D:         c(58) = &HE89D1F4E:         c(59) = &H7E08DB84:         c(60) = &H3326E548:         c(61) = &HA5B32182:         c(62) = &HC86EDC81:         c(63) = &H5EFB184B
         c(64) = &H7598EC17:         c(65) = &HE30D28DD:         c(66) = &H8ED0D5DE:         c(67) = &H18451114:         c(68) = &H556B2FD8:         c(69) = &HC3FEEB12:         c(70) = &HAE231611:         c(71) = &H38B6D2DB
         c(72) = &H347F6B89:         c(73) = &HA2EAAF43:         c(74) = &HCF375240:         c(75) = &H59A2968A:         c(76) = &H148CA846:         c(77) = &H82196C8C:         c(78) = &HEFC4918F:         c(79) = &H79515545
         c(80) = &HF657E32B:         c(81) = &H60C227E1:         c(82) = &HD1FDAE2:          c(83) = &H9B8A1E28:         c(84) = &HD6A420E4:         c(85) = &H4031E42E:         c(86) = &H2DEC192D:         c(87) = &HBB79DDE7
         c(88) = &HB7B064B5:         c(89) = &H2125A07F:         c(90) = &H4CF85D7C:         c(91) = &HDA6D99B6:         c(92) = &H9743A77A:         c(93) = &H1D663B0:          c(94) = &H6C0B9EB3:         c(95) = &HFA9E5A79
         c(96) = &HA4654232:         c(97) = &H32F086F8:         c(98) = &H5F2D7BFB:         c(99) = &HC9B8BF31:        c(100) = &H849681FD:        c(101) = &H12034537:        c(102) = &H7FDEB834:        c(103) = &HE94B7CFE
        c(104) = &HE582C5AC:        c(105) = &H73170166:        c(106) = &H1ECAFC65:        c(107) = &H885F38AF:        c(108) = &HC5710663:        c(109) = &H53E4C2A9:        c(110) = &H3E393FAA:        c(111) = &HA8ACFB60
        c(112) = &H27AA4D0E:        c(113) = &HB13F89C4:        c(114) = &HDCE274C7:        c(115) = &H4A77B00D:        c(116) = &H7598EC1:         c(117) = &H91CC4A0B:        c(118) = &HFC11B708:        c(119) = &H6A8473C2
        c(120) = &H664DCA90:        c(121) = &HF0D80E5A:        c(122) = &H9D05F359:        c(123) = &HB903793:         c(124) = &H46BE095F:        c(125) = &HD02BCD95:        c(126) = &HBDF63096:        c(127) = &H2B63F45C
        c(128) = &HEB31D82E:        c(129) = &H7DA41CE4:        c(130) = &H1079E1E7:        c(131) = &H86EC252D:        c(132) = &HCBC21BE1:        c(133) = &H5D57DF2B:        c(134) = &H308A2228:        c(135) = &HA61FE6E2
        c(136) = &HAAD65FB0:        c(137) = &H3C439B7A:        c(138) = &H519E6679:        c(139) = &HC70BA2B3:        c(140) = &H8A259C7F:        c(141) = &H1CB058B5:        c(142) = &H716DA5B6:        c(143) = &HE7F8617C
        c(144) = &H68FED712:        c(145) = &HFE6B13D8:        c(146) = &H93B6EEDB:        c(147) = &H5232A11:         c(148) = &H480D14DD:        c(149) = &HDE98D017:        c(150) = &HB3452D14:        c(151) = &H25D0E9DE
        c(152) = &H2919508C:        c(153) = &HBF8C9446:        c(154) = &HD2516945:        c(155) = &H44C4AD8F:        c(156) = &H9EA9343:         c(157) = &H9F7F5789:        c(158) = &HF2A2AA8A:        c(159) = &H64376E40
        c(160) = &H3ACC760B:        c(161) = &HAC59B2C1:        c(162) = &HC1844FC2:        c(163) = &H57118B08:        c(164) = &H1A3FB5C4:        c(165) = &H8CAA710E:        c(166) = &HE1778C0D:        c(167) = &H77E248C7
        c(168) = &H7B2BF195:        c(169) = &HEDBE355F:        c(170) = &H8063C85C:        c(171) = &H16F60C96:        c(172) = &H5BD8325A:        c(173) = &HCD4DF690:        c(174) = &HA0900B93:        c(175) = &H3605CF59
        c(176) = &HB9037937:        c(177) = &H2F96BDFD:        c(178) = &H424B40FE:        c(179) = &HD4DE8434:        c(180) = &H99F0BAF8:        c(181) = &HF657E32:         c(182) = &H62B88331:        c(183) = &HF42D47FB
        c(184) = &HF8E4FEA9:        c(185) = &H6E713A63:        c(186) = &H3ACC760:         c(187) = &H953903AA:        c(188) = &HD8173D66:        c(189) = &H4E82F9AC:        c(190) = &H235F04AF:        c(191) = &HB5CAC065
        c(192) = &H9EA93439:        c(193) = &H83CF0F3:         c(194) = &H65E10DF0:        c(195) = &HF374C93A:        c(196) = &HBE5AF7F6:        c(197) = &H28CF333C:        c(198) = &H4512CE3F:        c(199) = &HD3870AF5
        c(200) = &HDF4EB3A7:        c(201) = &H49DB776D:        c(202) = &H24068A6E:        c(203) = &HB2934EA4:        c(204) = &HFFBD7068:        c(205) = &H6928B4A2:        c(206) = &H4F549A1:         c(207) = &H92608D6B
        c(208) = &H1D663B05:        c(209) = &H8BF3FFCF:        c(210) = &HE62E02CC:        c(211) = &H70BBC606:        c(212) = &H3D95F8CA:        c(213) = &HAB003C00:        c(214) = &HC6DDC103:        c(215) = &H504805C9
        c(216) = &H5C81BC9B:        c(217) = &HCA147851:        c(218) = &HA7C98552:        c(219) = &H315C4198:        c(220) = &H7C727F54:        c(221) = &HEAE7BB9E:        c(222) = &H873A469D:        c(223) = &H11AF8257
        c(224) = &H4F549A1C:        c(225) = &HD9C15ED6:        c(226) = &HB41CA3D5:        c(227) = &H2289671F:        c(228) = &H6FA759D3:        c(229) = &HF9329D19:        c(230) = &H94EF601A:        c(231) = &H27AA4D0
        c(232) = &HEB31D82:         c(233) = &H9826D948:        c(234) = &HF5FB244B:        c(235) = &H636EE081:        c(236) = &H2E40DE4D:        c(237) = &HB8D51A87:        c(238) = &HD508E784:        c(239) = &H439D234E
        c(240) = &HCC9B9520:        c(241) = &H5A0E51EA:        c(242) = &H37D3ACE9:        c(243) = &HA1466823:        c(244) = &HEC6856EF:        c(245) = &H7AFD9225:        c(246) = &H17206F26:        c(247) = &H81B5ABEC
        c(248) = &H8D7C12BE:        c(249) = &H1BE9D674:        c(250) = &H76342B77:        c(251) = &HE0A1EFBD:        c(252) = &HAD8FD171:        c(253) = &H3B1A15BB:        c(254) = &H56C7E8B8:        c(255) = &HC0522C72
        
    Case ECRC32LUTable.CRC32_MPEG2
          c(0) = &H0:                 c(1) = &H4C11DB7:           c(2) = &H9823B6E:           c(3) = &HD4326D9:           c(4) = &H130476DC:          c(5) = &H17C56B6B:          c(6) = &H1A864DB2:          c(7) = &H1E475005
          c(8) = &H2608EDB8:          c(9) = &H22C9F00F:         c(10) = &H2F8AD6D6:         c(11) = &H2B4BCB61:         c(12) = &H350C9B64:         c(13) = &H31CD86D3:         c(14) = &H3C8EA00A:         c(15) = &H384FBDBD
         c(16) = &H4C11DB70:         c(17) = &H48D0C6C7:         c(18) = &H4593E01E:         c(19) = &H4152FDA9:         c(20) = &H5F15ADAC:         c(21) = &H5BD4B01B:         c(22) = &H569796C2:         c(23) = &H52568B75
         c(24) = &H6A1936C8:         c(25) = &H6ED82B7F:         c(26) = &H639B0DA6:         c(27) = &H675A1011:         c(28) = &H791D4014:         c(29) = &H7DDC5DA3:         c(30) = &H709F7B7A:         c(31) = &H745E66CD
         c(32) = &H9823B6E0:         c(33) = &H9CE2AB57:         c(34) = &H91A18D8E:         c(35) = &H95609039:         c(36) = &H8B27C03C:         c(37) = &H8FE6DD8B:         c(38) = &H82A5FB52:         c(39) = &H8664E6E5
         c(40) = &HBE2B5B58:         c(41) = &HBAEA46EF:         c(42) = &HB7A96036:         c(43) = &HB3687D81:         c(44) = &HAD2F2D84:         c(45) = &HA9EE3033:         c(46) = &HA4AD16EA:         c(47) = &HA06C0B5D
         c(48) = &HD4326D90:         c(49) = &HD0F37027:         c(50) = &HDDB056FE:         c(51) = &HD9714B49:         c(52) = &HC7361B4C:         c(53) = &HC3F706FB:         c(54) = &HCEB42022:         c(55) = &HCA753D95
         c(56) = &HF23A8028:         c(57) = &HF6FB9D9F:         c(58) = &HFBB8BB46:         c(59) = &HFF79A6F1:         c(60) = &HE13EF6F4:         c(61) = &HE5FFEB43:         c(62) = &HE8BCCD9A:         c(63) = &HEC7DD02D
         c(64) = &H34867077:         c(65) = &H30476DC0:         c(66) = &H3D044B19:         c(67) = &H39C556AE:         c(68) = &H278206AB:         c(69) = &H23431B1C:         c(70) = &H2E003DC5:         c(71) = &H2AC12072
         c(72) = &H128E9DCF:         c(73) = &H164F8078:         c(74) = &H1B0CA6A1:         c(75) = &H1FCDBB16:         c(76) = &H18AEB13:          c(77) = &H54BF6A4:          c(78) = &H808D07D:          c(79) = &HCC9CDCA
         c(80) = &H7897AB07:         c(81) = &H7C56B6B0:         c(82) = &H71159069:         c(83) = &H75D48DDE:         c(84) = &H6B93DDDB:         c(85) = &H6F52C06C:         c(86) = &H6211E6B5:         c(87) = &H66D0FB02
         c(88) = &H5E9F46BF:         c(89) = &H5A5E5B08:         c(90) = &H571D7DD1:         c(91) = &H53DC6066:         c(92) = &H4D9B3063:         c(93) = &H495A2DD4:         c(94) = &H44190B0D:         c(95) = &H40D816BA
         c(96) = &HACA5C697:         c(97) = &HA864DB20:         c(98) = &HA527FDF9:         c(99) = &HA1E6E04E:        c(100) = &HBFA1B04B:        c(101) = &HBB60ADFC:        c(102) = &HB6238B25:        c(103) = &HB2E29692
        c(104) = &H8AAD2B2F:        c(105) = &H8E6C3698:        c(106) = &H832F1041:        c(107) = &H87EE0DF6:        c(108) = &H99A95DF3:        c(109) = &H9D684044:        c(110) = &H902B669D:        c(111) = &H94EA7B2A
        c(112) = &HE0B41DE7:        c(113) = &HE4750050:        c(114) = &HE9362689:        c(115) = &HEDF73B3E:        c(116) = &HF3B06B3B:        c(117) = &HF771768C:        c(118) = &HFA325055:        c(119) = &HFEF34DE2
        c(120) = &HC6BCF05F:        c(121) = &HC27DEDE8:        c(122) = &HCF3ECB31:        c(123) = &HCBFFD686:        c(124) = &HD5B88683:        c(125) = &HD1799B34:        c(126) = &HDC3ABDED:        c(127) = &HD8FBA05A
        c(128) = &H690CE0EE:        c(129) = &H6DCDFD59:        c(130) = &H608EDB80:        c(131) = &H644FC637:        c(132) = &H7A089632:        c(133) = &H7EC98B85:        c(134) = &H738AAD5C:        c(135) = &H774BB0EB
        c(136) = &H4F040D56:        c(137) = &H4BC510E1:        c(138) = &H46863638:        c(139) = &H42472B8F:        c(140) = &H5C007B8A:        c(141) = &H58C1663D:        c(142) = &H558240E4:        c(143) = &H51435D53
        c(144) = &H251D3B9E:        c(145) = &H21DC2629:        c(146) = &H2C9F00F0:        c(147) = &H285E1D47:        c(148) = &H36194D42:        c(149) = &H32D850F5:        c(150) = &H3F9B762C:        c(151) = &H3B5A6B9B
        c(152) = &H315D626:         c(153) = &H7D4CB91:         c(154) = &HA97ED48:         c(155) = &HE56F0FF:         c(156) = &H1011A0FA:        c(157) = &H14D0BD4D:        c(158) = &H19939B94:        c(159) = &H1D528623
        c(160) = &HF12F560E:        c(161) = &HF5EE4BB9:        c(162) = &HF8AD6D60:        c(163) = &HFC6C70D7:        c(164) = &HE22B20D2:        c(165) = &HE6EA3D65:        c(166) = &HEBA91BBC:        c(167) = &HEF68060B
        c(168) = &HD727BBB6:        c(169) = &HD3E6A601:        c(170) = &HDEA580D8:        c(171) = &HDA649D6F:        c(172) = &HC423CD6A:        c(173) = &HC0E2D0DD:        c(174) = &HCDA1F604:        c(175) = &HC960EBB3
        c(176) = &HBD3E8D7E:        c(177) = &HB9FF90C9:        c(178) = &HB4BCB610:        c(179) = &HB07DABA7:        c(180) = &HAE3AFBA2:        c(181) = &HAAFBE615:        c(182) = &HA7B8C0CC:        c(183) = &HA379DD7B
        c(184) = &H9B3660C6:        c(185) = &H9FF77D71:        c(186) = &H92B45BA8:        c(187) = &H9675461F:        c(188) = &H8832161A:        c(189) = &H8CF30BAD:        c(190) = &H81B02D74:        c(191) = &H857130C3
        c(192) = &H5D8A9099:        c(193) = &H594B8D2E:        c(194) = &H5408ABF7:        c(195) = &H50C9B640:        c(196) = &H4E8EE645:        c(197) = &H4A4FFBF2:        c(198) = &H470CDD2B:        c(199) = &H43CDC09C
        c(200) = &H7B827D21:        c(201) = &H7F436096:        c(202) = &H7200464F:        c(203) = &H76C15BF8:        c(204) = &H68860BFD:        c(205) = &H6C47164A:        c(206) = &H61043093:        c(207) = &H65C52D24
        c(208) = &H119B4BE9:        c(209) = &H155A565E:        c(210) = &H18197087:        c(211) = &H1CD86D30:        c(212) = &H29F3D35:         c(213) = &H65E2082:         c(214) = &HB1D065B:         c(215) = &HFDC1BEC
        c(216) = &H3793A651:        c(217) = &H3352BBE6:        c(218) = &H3E119D3F:        c(219) = &H3AD08088:        c(220) = &H2497D08D:        c(221) = &H2056CD3A:        c(222) = &H2D15EBE3:        c(223) = &H29D4F654
        c(224) = &HC5A92679:        c(225) = &HC1683BCE:        c(226) = &HCC2B1D17:        c(227) = &HC8EA00A0:        c(228) = &HD6AD50A5:        c(229) = &HD26C4D12:        c(230) = &HDF2F6BCB:        c(231) = &HDBEE767C
        c(232) = &HE3A1CBC1:        c(233) = &HE760D676:        c(234) = &HEA23F0AF:        c(235) = &HEEE2ED18:        c(236) = &HF0A5BD1D:        c(237) = &HF464A0AA:        c(238) = &HF9278673:        c(239) = &HFDE69BC4
        c(240) = &H89B8FD09:        c(241) = &H8D79E0BE:        c(242) = &H803AC667:        c(243) = &H84FBDBD0:        c(244) = &H9ABC8BD5:        c(245) = &H9E7D9662:        c(246) = &H933EB0BB:        c(247) = &H97FFAD0C
        c(248) = &HAFB010B1:        c(249) = &HAB710D06:        c(250) = &HA6322BDF:        c(251) = &HA2F33668:        c(252) = &HBCB4666D:        c(253) = &HB8757BDA:        c(254) = &HB5365D03:        c(255) = &HB1F740B4
        
    Case ECRC32LUTable.CRC32_XFER
          c(0) = &H0&:                c(1) = &HAF&:               c(2) = &H15E&:              c(3) = &H1F1&:              c(4) = &H2BC&:              c(5) = &H213&:              c(6) = &H3E2&:              c(7) = &H34D&
          c(8) = &H578&:              c(9) = &H5D7&:             c(10) = &H426&:             c(11) = &H489&:             c(12) = &H7C4&:             c(13) = &H76B&:             c(14) = &H69A&:             c(15) = &H635&
         c(16) = &HAF0&:             c(17) = &HA5F&:             c(18) = &HBAE&:             c(19) = &HB01&:             c(20) = &H84C&:             c(21) = &H8E3&:             c(22) = &H912&:             c(23) = &H9BD&
         c(24) = &HF88&:             c(25) = &HF27&:             c(26) = &HED6&:             c(27) = &HE79&:             c(28) = &HD34&:             c(29) = &HD9B&:             c(30) = &HC6A&:             c(31) = &HCC5&
         c(32) = &H15E0&:            c(33) = &H154F&:            c(34) = &H14BE&:            c(35) = &H1411&:            c(36) = &H175C&:            c(37) = &H17F3&:            c(38) = &H1602&:            c(39) = &H16AD&
         c(40) = &H1098&:            c(41) = &H1037&:            c(42) = &H11C6&:            c(43) = &H1169&:            c(44) = &H1224&:            c(45) = &H128B&:            c(46) = &H137A&:            c(47) = &H13D5&
         c(48) = &H1F10&:            c(49) = &H1FBF&:            c(50) = &H1E4E&:            c(51) = &H1EE1&:            c(52) = &H1DAC&:            c(53) = &H1D03&:            c(54) = &H1CF2&:            c(55) = &H1C5D&
         c(56) = &H1A68&:            c(57) = &H1AC7&:            c(58) = &H1B36&:            c(59) = &H1B99&:            c(60) = &H18D4&:            c(61) = &H187B&:            c(62) = &H198A&:            c(63) = &H1925&
         c(64) = &H2BC0&:            c(65) = &H2B6F&:            c(66) = &H2A9E&:            c(67) = &H2A31&:            c(68) = &H297C&:            c(69) = &H29D3&:            c(70) = &H2822&:            c(71) = &H288D&
         c(72) = &H2EB8&:            c(73) = &H2E17&:            c(74) = &H2FE6&:            c(75) = &H2F49&:            c(76) = &H2C04&:            c(77) = &H2CAB&:            c(78) = &H2D5A&:            c(79) = &H2DF5&
         c(80) = &H2130&:            c(81) = &H219F&:            c(82) = &H206E&:            c(83) = &H20C1&:            c(84) = &H238C&:            c(85) = &H2323&:            c(86) = &H22D2&:            c(87) = &H227D&
         c(88) = &H2448&:            c(89) = &H24E7&:            c(90) = &H2516&:            c(91) = &H25B9&:            c(92) = &H26F4&:            c(93) = &H265B&:            c(94) = &H27AA&:            c(95) = &H2705&
         c(96) = &H3E20&:            c(97) = &H3E8F&:            c(98) = &H3F7E&:            c(99) = &H3FD1&:           c(100) = &H3C9C&:           c(101) = &H3C33&:           c(102) = &H3DC2&:           c(103) = &H3D6D&
        c(104) = &H3B58&:           c(105) = &H3BF7&:           c(106) = &H3A06&:           c(107) = &H3AA9&:           c(108) = &H39E4&:           c(109) = &H394B&:           c(110) = &H38BA&:           c(111) = &H3815&
        c(112) = &H34D0&:           c(113) = &H347F&:           c(114) = &H358E&:           c(115) = &H3521&:           c(116) = &H366C&:           c(117) = &H36C3&:           c(118) = &H3732&:           c(119) = &H379D&
        c(120) = &H31A8&:           c(121) = &H3107&:           c(122) = &H30F6&:           c(123) = &H3059&:           c(124) = &H3314&:           c(125) = &H33BB&:           c(126) = &H324A&:           c(127) = &H32E5&
        c(128) = &H5780&:           c(129) = &H572F&:           c(130) = &H56DE&:           c(131) = &H5671&:           c(132) = &H553C&:           c(133) = &H5593&:           c(134) = &H5462&:           c(135) = &H54CD&
        c(136) = &H52F8&:           c(137) = &H5257&:           c(138) = &H53A6&:           c(139) = &H5309&:           c(140) = &H5044&:           c(141) = &H50EB&:           c(142) = &H511A&:           c(143) = &H51B5&
        c(144) = &H5D70&:           c(145) = &H5DDF&:           c(146) = &H5C2E&:           c(147) = &H5C81&:           c(148) = &H5FCC&:           c(149) = &H5F63&:           c(150) = &H5E92&:           c(151) = &H5E3D&
        c(152) = &H5808&:           c(153) = &H58A7&:           c(154) = &H5956&:           c(155) = &H59F9&:           c(156) = &H5AB4&:           c(157) = &H5A1B&:           c(158) = &H5BEA&:           c(159) = &H5B45&
        c(160) = &H4260&:           c(161) = &H42CF&:           c(162) = &H433E&:           c(163) = &H4391&:           c(164) = &H40DC&:           c(165) = &H4073&:           c(166) = &H4182&:           c(167) = &H412D&
        c(168) = &H4718&:           c(169) = &H47B7&:           c(170) = &H4646&:           c(171) = &H46E9&:           c(172) = &H45A4&:           c(173) = &H450B&:           c(174) = &H44FA&:           c(175) = &H4455&
        c(176) = &H4890&:           c(177) = &H483F&:           c(178) = &H49CE&:           c(179) = &H4961&:           c(180) = &H4A2C&:           c(181) = &H4A83&:           c(182) = &H4B72&:           c(183) = &H4BDD&
        c(184) = &H4DE8&:           c(185) = &H4D47&:           c(186) = &H4CB6&:           c(187) = &H4C19&:           c(188) = &H4F54&:           c(189) = &H4FFB&:           c(190) = &H4E0A&:           c(191) = &H4EA5&
        c(192) = &H7C40&:           c(193) = &H7CEF&:           c(194) = &H7D1E&:           c(195) = &H7DB1&:           c(196) = &H7EFC&:           c(197) = &H7E53&:           c(198) = &H7FA2&:           c(199) = &H7F0D&
        c(200) = &H7938&:           c(201) = &H7997&:           c(202) = &H7866&:           c(203) = &H78C9&:           c(204) = &H7B84&:           c(205) = &H7B2B&:           c(206) = &H7ADA&:           c(207) = &H7A75&
        c(208) = &H76B0&:           c(209) = &H761F&:           c(210) = &H77EE&:           c(211) = &H7741&:           c(212) = &H740C&:           c(213) = &H74A3&:           c(214) = &H7552&:           c(215) = &H75FD&
        c(216) = &H73C8&:           c(217) = &H7367&:           c(218) = &H7296&:           c(219) = &H7239&:           c(220) = &H7174&:           c(221) = &H71DB&:           c(222) = &H702A&:           c(223) = &H7085&
        c(224) = &H69A0&:           c(225) = &H690F&:           c(226) = &H68FE&:           c(227) = &H6851&:           c(228) = &H6B1C&:           c(229) = &H6BB3&:           c(230) = &H6A42&:           c(231) = &H6AED&
        c(232) = &H6CD8&:           c(233) = &H6C77&:           c(234) = &H6D86&:           c(235) = &H6D29&:           c(236) = &H6E64&:           c(237) = &H6ECB&:           c(238) = &H6F3A&:           c(239) = &H6F95&
        c(240) = &H6350&:           c(241) = &H63FF&:           c(242) = &H620E&:           c(243) = &H62A1&:           c(244) = &H61EC&:           c(245) = &H6143&:           c(246) = &H60B2&:           c(247) = &H601D&
        c(248) = &H6628&:           c(249) = &H6687&:           c(250) = &H6776&:           c(251) = &H67D9&:           c(252) = &H6494&:           c(253) = &H643B&:           c(254) = &H65CA&:           c(255) = &H6565&
        
    End Select

    m_CRC32LUTable = c
    
End Sub

' =====================================================
'  Xdebug��DLL�t�@�C�����w��t�H���_�Ƀ_�E�����[�h
' =====================================================
' �_�E�����[�h����t�@�C����URL
Dim url
url = "https://github.com/room202/xampp-xdebug/raw/main/php_xdebug.dll"

' �ۑ���̃p�X
Dim savePath
savePath = "C:\xampp\php\ext\php_xdebug.dll"

' HTTP�I�u�W�F�N�g�̍쐬
Dim http
Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")

' URL�ɐڑ�
http.Open "GET", url, False
http.Send

' ���X�|���X�̎擾
If http.Status = 200 Then
    ' �o�C�i���f�[�^���擾
    Dim stream
    Set stream = CreateObject("ADODB.Stream")
    stream.Type = 1 ' �o�C�i���f�[�^
    stream.Open
    stream.Write http.responseBody
    stream.SaveToFile savePath, 2 ' �t�@�C���ɕۑ�
    stream.Close
    ' WScript.Echo "�t�@�C��������Ƀ_�E�����[�h����A�ۑ�����܂����B"
Else
    WScript.Echo "�t�@�C���̃_�E�����[�h�Ɏ��s���܂����B�X�e�[�^�X�R�[�h: " & http.Status
End If

' �I�u�W�F�N�g�̉��
Set http = Nothing
Set stream = Nothing

' =====================================================
'  Xdebug�̐ݒ�
' =====================================================
' �t�@�C���p�X�̐ݒ�
Dim filePath
filePath = "C:\xampp\php\php.ini"

' �ǉ�����ݒ�
Dim newSettings
newSettings = vbNewLine & _
              "[xdebug]" & vbNewLine & _
              "zend_extension = ""C:\xampp\php\ext\php_xdebug.dll""" & vbNewLine & _
              "xdebug.mode = debug" & vbNewLine & _
              "xdebug.start_with_request = yes" & vbNewLine

' �t�@�C���V�X�e���I�u�W�F�N�g�̍쐬
Set fso = CreateObject("Scripting.FileSystemObject")

' �t�@�C����ǂݍ���
Set file = fso.OpenTextFile(filePath, 1)
content = file.ReadAll()
file.Close

' �s�𕪊�
lines = Split(content, vbNewLine)

' 966�s�ڂ̌�ɐV�����ݒ��}��
If UBound(lines) >= 965 Then
    ReDim Preserve lines(UBound(lines) + 5)
    For i = UBound(lines) To 966 Step -1
        lines(i) = lines(i - 5)
    Next
    newSettingsLines = Split(newSettings, vbNewLine)
    For i = 0 To UBound(newSettingsLines)
        lines(965 + i) = newSettingsLines(i)
    Next
End If

' �ύX�������e����������
Set file = fso.OpenTextFile(filePath, 2)
file.Write Join(lines, vbNewLine)
file.Close

' =====================================================
' VSCode��PHP Extension Pack��ǉ�
' =====================================================
' VSCode�̃R�}���h���C���C���^�[�t�F�[�X�iCLI�j�̃p�X��ݒ�
Dim vscodePath
vscodePath = "C:\Users\lightbox\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd"

' �C���X�g�[������PHP Extension Pack�̖��O
Dim extensionName
extensionName = "felixfbecker.php-pack"

' �R�}���h���\�z
Dim command
command = """" & vscodePath & """ --install-extension " & extensionName

' �V�F���I�u�W�F�N�g���쐬
Set shell = CreateObject("WScript.Shell")

' �R�}���h�����s
shell.Run command, 1, True

' �������b�Z�[�W��\��
WScript.Echo "�ݒ肪�������܂����B"
' =====================================================
'  XdebugのDLLファイルを指定フォルダにダウンロード
' =====================================================
' ダウンロードするファイルのURL
Dim url
url = "https://github.com/room202/xampp-xdebug/raw/main/php_xdebug.dll"

' 保存先のパス
Dim savePath
savePath = "C:\xampp\php\ext\php_xdebug.dll"

' HTTPオブジェクトの作成
Dim http
Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")

' URLに接続
http.Open "GET", url, False
http.Send

' レスポンスの取得
If http.Status = 200 Then
    ' バイナリデータを取得
    Dim stream
    Set stream = CreateObject("ADODB.Stream")
    stream.Type = 1 ' バイナリデータ
    stream.Open
    stream.Write http.responseBody
    stream.SaveToFile savePath, 2 ' ファイルに保存
    stream.Close
    ' WScript.Echo "ファイルが正常にダウンロードされ、保存されました。"
Else
    WScript.Echo "ファイルのダウンロードに失敗しました。ステータスコード: " & http.Status
End If

' オブジェクトの解放
Set http = Nothing
Set stream = Nothing

' =====================================================
'  Xdebugの設定
' =====================================================
' ファイルパスの設定
Dim filePath
filePath = "C:\xampp\php\php.ini"

' 追加する設定
Dim newSettings
newSettings = vbNewLine & _
              "[xdebug]" & vbNewLine & _
              "zend_extension = ""C:\xampp\php\ext\php_xdebug.dll""" & vbNewLine & _
              "xdebug.mode = debug" & vbNewLine & _
              "xdebug.start_with_request = yes" & vbNewLine

' ファイルシステムオブジェクトの作成
Set fso = CreateObject("Scripting.FileSystemObject")

' ファイルを読み込む
Set file = fso.OpenTextFile(filePath, 1)
content = file.ReadAll()
file.Close

' 行を分割
lines = Split(content, vbNewLine)

' 966行目の後に新しい設定を挿入
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

' 変更した内容を書き込む
Set file = fso.OpenTextFile(filePath, 2)
file.Write Join(lines, vbNewLine)
file.Close

' =====================================================
' VSCodeにPHP Extension Packを追加
' =====================================================
' VSCodeのコマンドラインインターフェース（CLI）のパスを設定
Dim vscodePath
vscodePath = "C:\Users\lightbox\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd"

' インストールするPHP Extension Packの名前
Dim extensionName
extensionName = "felixfbecker.php-pack"

' コマンドを構築
Dim command
command = """" & vscodePath & """ --install-extension " & extensionName

' シェルオブジェクトを作成
Set shell = CreateObject("WScript.Shell")

' コマンドを実行
shell.Run command, 1, True

' 完了メッセージを表示
WScript.Echo "設定が完了しました。"
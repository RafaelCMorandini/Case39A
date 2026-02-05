# Case 39A - Solução de Automação de Energia
curl.exe -X POST -F "data=@input_data.zip;type=application/zip;filename=input_data.zip" http://localhost:5678/webhook-test/upload-zip
curl -X POST http://localhost:5678/webhook-test/processar-dados

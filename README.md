# Case 39A - Automação de Energia Solar

Este repositório contém a solução para o **Desafio Técnico 39A**, focado na automação de processos, modelagem de dados e integração de sistemas para uma empresa de energia solar.

## 🚀 Objetivo
Simular uma automação de dados que realiza a ingestão de registros de consumo, calcula médias de consumo por cliente ativo nos últimos 3 meses, identifica outliers e gera um relatório executivo utilizando IA (OpenAI).

---

## 🛠️ Tecnologias Utilizadas
- **n8n**: Orquestrador de workflows.
- **PostgreSQL**: Banco de dados relacional.
- **Docker & Docker Compose**: Gerenciamento de containers.
- **OpenAI (GPT-4o-mini)**: Geração de relatórios automáticos.

---

## 📂 Estrutura do Projeto
- `docker-compose.yml`: Definição dos serviços Postgres e n8n.
- `init.sql`: Script de criação das tabelas e índices.
- `workflow_ingestion.json`: Workflow de importação de dados via ZIP.
- `workflow_processing.json`: Workflow de processamento, cálculo de outliers e geração de relatório.
- `data/`: Arquivos CSV de exemplo (`clientes.csv`, `contratos.csv`, `leituras.csv`).
- `input_data.zip`: Pacote comprimido para teste de ingestão.

---

## ⚙️ Configuração e Execução

### 1. Subir o Ambiente
Certifique-se de ter o Docker instalado e execute:
```bash
docker-compose up -d
```
Isso iniciará o Postgres (porta 5432) e o n8n (porta 5678).

### 2. Configurar o n8n
- Acesse `http://localhost:5678`.
- Importe os arquivos `.json` na pasta raiz para criar os workflows.
- Configure as credenciais do Postgres e da OpenAI no painel de credenciais do n8n.

### 3. Executar a Ingestão de Dados
Envie o arquivo `input_data.zip` para o webhook de ingestão:
```bash
curl.exe -X POST -F "data=@input_data.zip;type=application/zip;filename=input_data.zip" http://localhost:5678/webhook-test/upload-zip
```

### 4. Executar o Processamento
Chame o webhook de processamento para obter o relatório:
```bash
curl.exe -X POST http://localhost:5678/webhook-test/processar-dados
```
Ou insira o link no navegador. Após alguns segundos, o relatório será gerado e exibido na tela.

```http://localhost:5678/webhook-test/processar-dados```

---

## 📊 Modelagem de Dados (`init.sql`)
O banco de dados contém os seguintes objetos:
- **clientes**: Cadastro básico.
- **contratos**: Relacionado a clientes, inclui status `ativo` como padrão caso não seja informado.
- **leituras**: Registra o consumo (`valor_kwh`) associado a um contrato e data.
- **Índices**: Criados em `contrato_id` e `data_leitura` para otimizar as consultas de média móvel.

---

## 🔍 Detecção de Outliers
Para identificar comportamentos anômalos no consumo, a solução utiliza uma técnica robusta de **Interquartile Range (IQR)** aplicada sobre a **transformação logarítmica** dos dados.

**Por que Log + IQR?**
Os dados de consumo energético usados eram extremamente assimétricos (presença de poucos consumidores com valores muito altos). A transformação logarítmica normaliza essa distribuição, permitindo que o cálculo de outliers seja mais preciso e menos sensível a extremos naturais do dataset, focando em anomalias reais. Caso o IQR fosse calculado diretamente sobre os dados originais, o valor de corte para outliers baixos seria um numero negativo (aproximadamente -30kWh), o que não faz sentido no contexto de consumo de energia.

---

## 🤖 Integração com LLM
O resultado do processamento é enviado ao modelo `gpt-4o-mini` da OpenAI, que gera um relatório executivo de dois parágrafos analisando os padrões de consumo e os outliers identificados, retornando um arquivo formatado para o usuário.


# Seminário LDDM

```markdown
# 📱 Demonstração de Notificações Locais no Flutter

Este repositório contém o projeto prático e o material de suporte desenvolvidos para a disciplina de **Laboratório de Desenvolvimento de Dispositivos Móveis (LDDM)**. O objetivo principal é demonstrar de forma clara e didática os conceitos, configurações nativas e a implementação prática de **Notificações Locais** utilizando o ecossistema Flutter.

---

## 📁 Estrutura do Repositório

* `/lib` e `/android`: Código-fonte completo do aplicativo em Dart/Flutter.
* `Apresentação LDDM.pdf`: Slides e roteiro conceitual utilizados na apresentação técnica do trabalho.

---

## 💡 Conceito: Notificações Locais vs. Push (FCM)

Antes de ir para a implementação, é fundamental diferenciar as duas abordagens principais de engajamento mobile:

* **Notificações Locais:** São agendadas, gerenciadas e disparadas pelo **próprio aplicativo** rodando no dispositivo. Elas não dependem de conexão com a internet ou de um servidor externo. São perfeitas para alarmes, rotinas fixas e lembretes de curto prazo.
* **Notificações Push (ex: Firebase Cloud Messaging):** São enviadas por um **servidor na nuvem** para o dispositivo. São ideais para conteúdos dinâmicos, síncronos e dependentes de eventos externos, como mensagens de chat ou atualizações de entrega.

| Característica | Notificações Locais | Notificações Push (FCM) |
| :--- | :--- | :--- |
| **Origem** | Dispositivo do usuário (App) | Servidor Externo (Nuvem) |
| **Dependência de Internet** | Não | Sim |
| **Principais Casos de Uso** | Despertadores, rotinas de estudos, hábitos | Mensagens de chat, ofertas, notícias |

---

## 🛠️ Recursos Implementados

O projeto prático demonstra três cenários essenciais exigidos no escopo:

1.  **Notificação Imediata:** Exibida no exato momento da execução do código através do método `show()`, servindo como feedback instantâneo de ações do usuário.
2.  **Notificação Agendada (Lembrete de 1 Minuto):** Utiliza o método `zonedSchedule()` combinado à biblioteca `timezone` para disparar um alerta após um delay exato de 60 segundos, respeitando o fuso horário local.
3.  **Notificação com Ação e Payload:** Demonstra a criação de botões de ação na própria barra de notificação e o uso de streams de dados (`Payload`) para capturar o toque do usuário e redirecioná-lo automaticamente para uma tela específica (`/details`) sem depender do fluxo convencional de context.

---

## ⚙️ Configurações Nativas Relevantes

Para garantir o funcionamento multiplataforma moderno (com foco no ecossistema Android atual), o projeto cobre:

### Android (`android/app/build.gradle.kts`)
As versões mais recentes da API de fusos horários do Java demandam suporte ao processo de **Desugaring** para rodar em dispositivos Android legados. O arquivo de build em Kotlin DSL foi configurado da seguinte forma:

```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

```

### Manifest e Permissões (`AndroidManifest.xml`)

Inclusão das diretivas de segurança para o Android 13+ (`POST_NOTIFICATIONS`) e permissões explícitas para o agendamento de alarmes precisos introduzidas nas versões mais recentes do sistema:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />

```

---

## 🚀 Como Executar o Projeto

### Pré-requisitos

* Flutter SDK instalado (configurado para Java 17/Android SDK moderno).
* Um dispositivo físico Android ou Emulador configurado.

### Passos para execução

1. Clone este repositório para sua máquina local.
2. Abra o terminal na pasta raiz do projeto.
3. Instale as dependências executando:
```bash
flutter pub get

```


4. Certifique-se de limpar os caches de builds antigos caso mude de ambiente:
```bash
flutter clean

```


5. Inicie o aplicativo no dispositivo desejado:
```bash
flutter run

```



---

## ⚠️ Boas Práticas Observadas durante o Desenvolvimento

* **Economia de Bateria (Doze Mode):** O agendamento foi implementado utilizando a flag `AndroidScheduleMode.exactAllowWhileIdle`, assegurando que o sistema operacional entregue a notificação mesmo se o dispositivo entrar em estado de repouso profundo para economizar energia.
* **Gerenciamento de IDs:** Cada notificação utiliza identificadores inteiros únicos bem definidos para evitar colisões ou sobrescritas acidentais na barra de status do sistema.
* **Ambiente de Validação:** Como boa prática de engenharia de software mobile, as validações e testes finais de concorrência temporal e fuso horário foram realizados prioritariamente em um **dispositivo físico real**, mitigando inconsistências comuns encontradas em emuladores virtuais.

```

---

### 💡 Dica extra de organização:
Se você já configurou o Git no lugar certo do seu projeto (conforme fizemos no passo anterior), basta criar um arquivo chamado exatamente `README.md` na pasta principal do app, colar esse texto dentro dele e salvar. O GitHub/GitLab vai renderizar essa página de forma bem bonita assim que você enviar o código para a nuvem.

```

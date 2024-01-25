# Flutter Chatbot with Dialogflow Integration

<p float="left">
  <img src="https://github.com/fitriadyaa/Marbot-Chatbot/blob/main/assets/marbot1.png?raw=true" width="400" />
  <img src="https://github.com/fitriadyaa/Marbot-Chatbot/blob/main/assets/marbot2.png?raw=true" width="400" /> 
</p>


## 🌟 Features

- **Dynamic Flutter UI**: Enjoy a responsive, interactive chatbot experience, crafted with Flutter's robust framework.
- **Dialogflow Integration**: Tap into advanced natural language understanding with Dialogflow, ensuring intelligent, context-aware conversations.
- **Customizable Chat Interface**: Tailor the chat experience to your needs with our easy-to-use, adaptable interface.

## 🚀 Getting Started

Embark on your chatbot journey with these simple steps. Clone this repository and follow the instructions below to set up and launch your application.

### 📋 Prerequisites

- Ensure Flutter is installed on your device.
- Have an active Google Cloud account with Dialogflow API access.
- Obtain a Dialogflow service account key in JSON format.
- Add Dialog_flowwter depedencies https://github.com/Deimos-Applications/dialog_flowtter

## 🛠 Dialogflow Setup

- Initiate a Dialogflow agent through the Google Cloud Console.
- Produce a service account key in JSON format for your Dialogflow agent.
- Deposit the JSON key file in the assets directory of your Flutter project.

## 🔗 Integration

Seamlessly blend Dialogflow with Flutter using the `initDialogFlowtter` method in your Flutter app:

```dart
Future<void> initDialogFlowtter() async {
    DialogAuthCredentials credentials =
        await DialogAuthCredentials.fromFile('your json path');
    DialogFlowtter instance = DialogFlowtter(credentials: credentials);
    setState(() {
      dialogFlowtter = instance;
    });
}
```

## Support Me ☕

If you find MyGithubUser helpful or just want to support my work, you can buy me a coffee! ☕

[![Support Me on Saweria](https://img.shields.io/badge/Support%20Me%20on-Saweria-brightgreen)](https://saweria.co/fitriadyaa)

# @macaron/miniapp

Macaron Mini App Loader - A powerful webview component for React Native with Capacitor integration.

## Features

- 🚀 Full Capacitor bridge support
- 📱 Native iOS (WKWebView) and Android (WebView) implementation
- 🔌 Access to Capacitor plugins from your web content
- ⚡ Built as an Expo Module for seamless integration
- 🎯 Designed for loading mini-apps and web applications

## Installation

```bash
npm install @macaron/miniapp
# or
yarn add @macaron/miniapp
```

## Usage

```tsx
import { MacaronMiniappView } from '@macaron/miniapp';

function App() {
  return (
    <MacaronMiniappView
      url="https://your-web-app.com"
      style={{ flex: 1 }}
      onLoadEnd={() => console.log('Web app loaded')}
      onError={(e) => console.error('Error loading:', e.error)}
    />
  );
}
```

## Props

| Prop | Type | Description |
|------|------|-------------|
| `url` | `string` | URL to load in the webview |
| `html` | `string` | HTML content to load directly |
| `onLoadEnd` | `() => void` | Called when loading finishes |
| `onError` | `(event) => void` | Called on error |
| `onMessage` | `(event) => void` | Called when receiving messages from webview |

## Development

This package is part of the Macaron project and integrates Capacitor's native bridge for enhanced web-to-native communication.

## License

MIT


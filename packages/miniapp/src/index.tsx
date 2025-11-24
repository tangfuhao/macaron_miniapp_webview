import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';
import { ViewProps } from 'react-native';

export interface MacaronMiniappViewProps extends ViewProps {
  /**
   * URL to load in the webview
   */
  url?: string;
  
  /**
   * HTML content to load directly
   */
  html?: string;
  
  /**
   * Called when the webview finishes loading
   */
  onLoadEnd?: () => void;
  
  /**
   * Called when the webview encounters an error
   */
  onError?: (event: { error: string }) => void;
  
  /**
   * Called when receiving a message from the webview
   */
  onMessage?: (event: { data: string }) => void;
}

// This call tells the system to load the native module for this component
const NativeView = requireNativeViewManager('MacaronMiniapp');

/**
 * MacaronMiniappView - A webview component powered by Capacitor
 * 
 * This component provides a full-featured webview with Capacitor bridge support,
 * enabling native capabilities for web applications running inside the webview.
 * 
 * @example
 * ```tsx
 * import { MacaronMiniappView } from '@macaron/miniapp';
 * 
 * function MyApp() {
 *   return (
 *     <MacaronMiniappView
 *       url="https://example.com"
 *       onLoadEnd={() => console.log('Loaded!')}
 *       onError={(e) => console.error('Error:', e.error)}
 *     />
 *   );
 * }
 * ```
 */
export function MacaronMiniappView(props: MacaronMiniappViewProps) {
  return <NativeView {...props} />;
}

export default MacaronMiniappView;


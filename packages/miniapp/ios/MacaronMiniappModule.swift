import ExpoModulesCore

public class MacaronMiniappModule: Module {
  public func definition() -> ModuleDefinition {
    // Module name - 必须与 TypeScript 中的名称匹配
    Name("MacaronMiniapp")

    // Defines the view that will be created by React Native
    View(MacaronMiniappView.self) {
      // URL prop - loads a remote URL
      Prop("url") { (view: MacaronMiniappView, url: String?) in
        if let url = url, let nsUrl = URL(string: url) {
          view.loadURL(nsUrl)
        }
      }
      
      // HTML prop - loads HTML content directly
      Prop("html") { (view: MacaronMiniappView, html: String?) in
        if let html = html {
          view.loadHTML(html)
        }
      }
      
      // Events that can be sent to React Native
      Events("onLoadEnd", "onError", "onMessage")
    }
  }
}

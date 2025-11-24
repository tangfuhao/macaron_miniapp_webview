package com.macaron.miniapp

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class MacaronMiniappModule : Module() {
  override fun definition() = ModuleDefinition {
    // Module name - 必须与 TypeScript 中的名称匹配
    Name("MacaronMiniapp")

    // Define the view component
    View(MacaronMiniappView::class) {
      // URL prop - loads a remote URL
      Prop("url") { view: MacaronMiniappView, url: String? ->
        url?.let { view.loadURL(it) }
      }

      // HTML prop - loads HTML content directly
      Prop("html") { view: MacaronMiniappView, html: String? ->
        html?.let { view.loadHTML(it) }
      }

      // Events that can be sent to React Native
      Events("onLoadEnd", "onError", "onMessage")
    }
  }
}

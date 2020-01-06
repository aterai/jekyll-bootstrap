---
layout: post
category: swing
folder: WindowStateListener
title: JFrameの最大化、最小化イベントを取得する
tags: [JFrame, WindowStateListener, WindowListener]
author: aterai
pubdate: 2020-01-06T14:51:22+09:00
description: JFrameの最大化、最小(アイコン)化イベントを取得します。
image: https://drive.google.com/uc?id=13h_n-O0YyO15qpFv76ZEomH-8uWykdNI
comments: true
---
## 概要
`JFrame`の最大化、最小(アイコン)化イベントを取得します。

{% download https://drive.google.com/uc?id=13h_n-O0YyO15qpFv76ZEomH-8uWykdNI %}

## サンプルコード
<pre class="prettyprint"><code>((JFrame) c).addWindowStateListener(e -&gt; {
  String ws;
  switch (e.getNewState()) {
    case Frame.NORMAL:
      ws = "NORMAL";
      break;
    case Frame.ICONIFIED:
      ws = "ICONIFIED";
      break;
    case Frame.MAXIMIZED_HORIZ:
      ws = "MAXIMIZED_HORIZ";
      break;
    case Frame.MAXIMIZED_VERT:
      ws = "MAXIMIZED_VERT";
      break;
    case Frame.MAXIMIZED_BOTH:
      ws = "MAXIMIZED_BOTH";
      break;
    default:
      ws = "ERROR";
      break;
  }
  log.append(String.format("WindowStateListener: %s%n", ws));
});
</code></pre>

## 解説
上記のサンプルでは、`JFrame`に`WindowListener`と`WindowStateListener`を追加して`WindowEvent`を取得するテストを実行しています。

`WindowListener`で通常状態から最小化状態(`windowIconified(WindowEvent)`)、最小化状態から通常状態(`windowDeiconified(WindowEvent)`)は取得可能ですが、最大化イベントは`WindowStateListener`を使用して`id`が`WINDOW_STATE_CHANGED`の`WindowEvent`から取得する必要があります。

- - - -
- `Windows 10`環境で最大化状態は`Frame.MAXIMIZED_BOTH`のみサポートされているので、例えば垂直方向にフレームを画面端までリサイズして垂直最大化しても、`WindowEvent`は発生しない
    - [Toolkit#isFrameStateSupported(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Toolkit.html#isFrameStateSupported-int-)
    - `Frame.MAXIMIZED_HORIZ`: サポートしていない
    - `Frame.MAXIMIZED_VERT`: サポートしていない
    - `Frame.MAXIMIZED_BOTH`: サポートしている

<!-- dummy comment line for breaking list -->

## 参考リンク
- [How to Write Window Listeners (The Java™ Tutorials > Creating a GUI With JFC/Swing > Writing Event Listeners)](https://docs.oracle.com/javase/tutorial/uiswing/events/windowlistener.html)
- [WindowStateListener (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/event/WindowStateListener.html)
- [WindowEvent#getNewState() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/event/WindowEvent.html#getNewState--)
- [JInternalFrameの最大化、最大化からの復元イベントを取得する](https://ateraimemo.com/Swing/InternalFrameMaximizedListener.html)
    - `JInternalFrame`も最大化イベントを`InternalFrameListener`からの直接取得は不可

<!-- dummy comment line for breaking list -->

## コメント

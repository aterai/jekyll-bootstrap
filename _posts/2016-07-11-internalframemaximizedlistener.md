---
layout: post
category: swing
folder: InternalFrameMaximizedListener
title: JInternalFrameの最大化、最大化からの復元イベントを取得する
tags: [JInternalFrame, JDesktopPane, PropertyChangeListener]
author: aterai
pubdate: 2016-07-11T00:34:23+09:00
description: JInternalFrameの最大化ボタン、最大化からの復元ボタンをクリックした場合のイベントを取得します。
image: https://lh3.googleusercontent.com/-CxgwsouF5Cw/V4JonwQumzI/AAAAAAAAOdc/-F66XgbHf28_pt-Rc-zgv8f47E--2hvqgCCo/s800/InternalFrameMaximizedListener.png
comments: true
---
## 概要
`JInternalFrame`の最大化ボタン、最大化からの復元ボタンをクリックした場合のイベントを取得します。

{% download https://lh3.googleusercontent.com/-CxgwsouF5Cw/V4JonwQumzI/AAAAAAAAOdc/-F66XgbHf28_pt-Rc-zgv8f47E--2hvqgCCo/s800/InternalFrameMaximizedListener.png %}

## サンプルコード
<pre class="prettyprint"><code>iframe.addPropertyChangeListener(e -&gt; {
  String prop = e.getPropertyName();
  if (Objects.equals(JInternalFrame.IS_MAXIMUM_PROPERTY, prop)) {
    if (e.getNewValue() == Boolean.TRUE) {
      displayMessage("* Internal frame maximized", e);
    } else {
      displayMessage("* Internal frame minimized", e);
    }
  }
});
</code></pre>

## 解説
`InternalFrameListener`で、閉じるボタン、最小化(アイコン化)ボタン、最小化(アイコン化)からの復元などのイベントを取得できますが、最大化ボタン、最大化からの復元ボタンをクリックした場合などのイベントは取得できないので、`PropertyChangeListener`を利用して、このイベントを取得します。

- 最大化ボタンをクリック
    - プロパティ名: `JInternalFrame.IS_MAXIMUM_PROPERTY`で値が`Boolean.TRUE`のイベントが発生
- 最大化からの復元ボタンをクリック
    - プロパティ名: `JInternalFrame.IS_MAXIMUM_PROPERTY`で値が`Boolean.FALSE`のイベントが発生

<!-- dummy comment line for breaking list -->

## 参考リンク
- [How to Write an Internal Frame Listener (The Java™ Tutorials > Creating a GUI With JFC/Swing > Writing Event Listeners)](https://docs.oracle.com/javase/tutorial/uiswing/events/internalframelistener.html)
- [InternalFrameListener (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/event/InternalFrameListener.html)
- [java - Capture maximise/restore event in JInternalFrame - Stack Overflow](https://stackoverflow.com/questions/38219219/capture-maximise-restore-event-in-jinternalframe/38220378#38220378)

<!-- dummy comment line for breaking list -->

## コメント

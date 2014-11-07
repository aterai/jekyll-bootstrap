---
layout: post
category: swing
folder: FullScreen
title: Windowのフルスクリーン化
tags: [GraphicsEnvironment, JFrame, JDialog]
author: aterai
pubdate: 2008-04-28T10:19:14+09:00
description: JDialogやJFrameなどを、フルスクリーン表示に切り替えます。
comments: true
---
## 概要
`JDialog`や`JFrame`などを、フルスクリーン表示に切り替えます。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTNRUUD2xI/AAAAAAAAAag/G7fNPgecnss/s800/FullScreen.png %}

## サンプルコード
<pre class="prettyprint"><code>private void toggleFullScreenWindow() {
  GraphicsEnvironment graphicsEnvironment
    = GraphicsEnvironment.getLocalGraphicsEnvironment();
  GraphicsDevice graphicsDevice
    = graphicsEnvironment.getDefaultScreenDevice();
  if (graphicsDevice.getFullScreenWindow() == null) {
    dialog.dispose(); //destroy the native resources
    dialog.setUndecorated(true);
    dialog.setVisible(true); //rebuilding the native resources
    graphicsDevice.setFullScreenWindow(dialog);
  } else {
    graphicsDevice.setFullScreenWindow(null);
    dialog.dispose();
    dialog.setUndecorated(false);
    dialog.setVisible(true);
    dialog.repaint();
  }
  requestFocusInWindow();
}
</code></pre>

## 解説
上記のサンプルは、`JDialog`をフルスクリーン表示とウィンドウ表示に切り替えることが出来ます。

- <kbd>F11</kbd>キー、ダブルクリック
    - フルスクリーン表示、ウィンドウ表示の切り替え
- <kbd>Esc</kbd>キー
    - アプリケーション終了

<!-- dummy comment line for breaking list -->

- - - -
フルスクリーン表示とウィンドウ表示を切り替える前に、タイトルバーの非表示、表示も`setUndecorated`メソッドで切り替えていますが、このメソッドを使用する前に一旦`dispose`してウィンドウのネイティブリソースを開放しておく必要があります。

- `setUndecorated(boolean undecorated)`は、ダイアログが表示されていないときにだけ呼び出すことができますが、この「表示されていない」は `isVisible()`ではなく、`isDisplayable()`が`false`の意味なので、`dialog.setVisible(false);`としただけでは、 `Exception in thread "AWT-EventQueue-0" java.awt.IllegalComponentStateException: The dialog is **displayable**.` が発生します。
    - [Window#dispose()](http://docs.oracle.com/javase/jp/6/api/java/awt/Window.html#dispose%28%29)
    - [Dialog#setUndecorated(boolean)](http://docs.oracle.com/javase/jp/6/api/java/awt/Dialog.html#setUndecorated%28boolean%29)
    - [Component#isDisplayable()](http://docs.oracle.com/javase/jp/6/api/java/awt/Component.html#isDisplayable%28%29)

<!-- dummy comment line for breaking list -->

- - - -
~~`WebStart`(署名無し)から実行した場合、タスクバー(`Windows`)などを消してフルスクリーン化は出来ないようです。~~

## 参考リンク
- [Full-Screen Exclusive Mode (The Java™ Tutorials > Bonus > Full-Screen Exclusive Mode API)](http://docs.oracle.com/javase/tutorial/extra/fullscreen/exclusivemode.html)

<!-- dummy comment line for breaking list -->

## コメント

---
layout: post
category: swing
folder: DefaultFocus
title: Windowを開いたときのフォーカスを指定
tags: [JFrame, JDialog, Focus, FocusTraversalPolicy, WindowListener, ComponentListener, KeyboardFocusManager]
author: aterai
pubdate: 2004-10-11T07:41:37+09:00
description: JFrameやJDialogなどのWindowを開いたときに、デフォルトでフォーカスを持つコンポーネントを指定します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKp09XXEI/AAAAAAAAAWU/p3YhSijyS90/s800/DefaultFocus.png
comments: true
---
## 概要
`JFrame`や`JDialog`などの`Window`を開いたときに、デフォルトでフォーカスを持つコンポーネントを指定します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTKp09XXEI/AAAAAAAAAWU/p3YhSijyS90/s800/DefaultFocus.png %}

## サンプルコード
<pre class="prettyprint"><code>EventQueue.invokeLater(new Runnable() {
  @Override public void run() {
    field.requestFocusInWindow();
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JTextField`がデフォルトのフォーカスを持つように、`JComponent#requestFocusInWindow()`メソッドを使用しています。

`JComponent#requestFocusInWindow()`メソッドは、チュートリアル([How to Use the Focus Subsystem](https://docs.oracle.com/javase/tutorial/uiswing/misc/focus.html))にあるように、`JFrame#pack()`、もしくは`JFrame#setSize(...)`などでリサイズされた後(フォーカスを取得するコンポーネントのサイズが決まった後)で実行する必要があります。このため、このサンプルでは`EventQueue.invokeLater(...)`を使って、待ち状態のすべてのイベントが処理された後で実行するようにしています。

- - - -
以下のように、`FocusTraversalPolicy`や`WindowListener`を使う方法でも、同様にデフォルトのフォーカスを持つコンポーネントを指定できます。

- `FocusTraversalPolicy`を使用
    - `FocusTraversalPolicy`を設定して、最初にフォーカスの当たるコンポーネントを指定(`JDK 1.4.0`以降)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>frame.setFocusTraversalPolicy(new LayoutFocusTraversalPolicy() {
  @Override public Component getInitialComponent(Window w) {
    return field;
  }
});
</code></pre>

- `WindowListener#windowOpened(...)`で、`requestFocusInWindow()`
    - フレームに`WindowListener`を設定して、`windowOpened(...)`が呼び出されたときに、`requestFocusInWindow()`を実行

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>frame.addWindowListener(new WindowAdapter() {
  @Override public void windowOpened(WindowEvent e) {
    field.requestFocusInWindow();
  }
});
</code></pre>

- `ComponentListener#componentShown(...)`で、`requestFocusInWindow()`
    - フレームに`ComponentListener`を設定して、`componentShown(...)`が呼び出されたとき(=フレームが`setVisible(true)`されたとき)に、`requestFocusInWindow()`を実行

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>frame.addComponentListener(new ComponentAdapter() {
  @Override public void componentShown(ComponentEvent e) {
    field.requestFocusInWindow();
  }
});
</code></pre>

- `KeyboardFocusManager#addPropertyChangeListener(...)`で、`requestFocusInWindow()`
    - `KeyboardFocusManager`に`PropertyChangeListener`を設定して、`propertyChange(...)`が呼び出され、`PropertyName`が、`activeWindow`、かつ`PropertyChangeEvent#getNewValue()`が`null`でないときに、`requestFocusInWindow()`を実行

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>KeyboardFocusManager kfm = KeyboardFocusManager.getCurrentKeyboardFocusManager();
kfm.addPropertyChangeListener(new PropertyChangeListener() {
  @Override public void propertyChange(PropertyChangeEvent e) {
    String prop = e.getPropertyName();
    if ("activeWindow".equals(prop) &amp;&amp; e.getNewValue() != null) {
      System.out.println("activeWindow");
      field.requestFocusInWindow();
    }
  }
});
</code></pre>

## 参考リンク
- [Focusの移動](https://ateraimemo.com/Swing/FocusTraversal.html)
- [Swing - When does requestFocusInWindow() fail](https://community.oracle.com/thread/1367389)
- [JOptionPaneのデフォルトフォーカス](https://ateraimemo.com/Swing/OptionPaneDefaultFocus.html)

<!-- dummy comment line for breaking list -->

## コメント
- `JFrame#getRootPane()#setDefaultButton()`は使用方法がよくわからない… -- [aterai](https://ateraimemo.com/aterai.html)
- `setDefaultButton`って、<kbd>Enter</kbd>したときに押されたとみなすボタンだったかな…… --  2004-10-14 (木) 23:21:53
    - ありがとうございます。おかげでようやく理解できました。`JTextField`などにフォーカスがある状態で<kbd>Enter</kbd>キーを入力すると`setDefaultButton`したボタンが押されるのですね。 -- *aterai* 2004-10-18 (月) 12:14:15
    - というわけで、`frame.getRootPane().setDefaultButton(eb);`を追加してみました。上記のサンプルでは、中央の`JTextField`にフォーカスがある状態で、<kbd>Enter</kbd>キーを押すと、`EAST`ボタンが押されたことになります。 -- *aterai* 2004-10-18 (月) 12:20:58
    - ~~いつか、`DefaultButton`のページを別に作成すること。 -- *aterai* 2008-05-07 (水) 19:19:44~~
    - [DefaultButtonの設定](https://ateraimemo.com/Swing/DefaultButton.html)に移動。 -- *aterai* 2008-05-12 (月) 14:40:15
- `HierarchyListener`を使用する場合のテスト -- *aterai* 2009-03-19 (木) 14:51:30
    - [JOptionPaneのデフォルトフォーカス](https://ateraimemo.com/Swing/OptionPaneDefaultFocus.html)に移動

<!-- dummy comment line for breaking list -->

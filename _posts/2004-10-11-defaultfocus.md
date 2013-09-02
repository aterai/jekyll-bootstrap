---
layout: post
title: Windowを開いたときのフォーカスを指定
category: swing
folder: DefaultFocus
tags: [JFrame, JDialog, Focus, FocusTraversalPolicy, WindowListener, ComponentListener, KeyboardFocusManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-10-11

## Windowを開いたときのフォーカスを指定
`JFrame`や`JDialog`などの`Window`を開いたときに、デフォルトでフォーカスを持つコンポーネントを指定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTKp09XXEI/AAAAAAAAAWU/p3YhSijyS90/s800/DefaultFocus.png)

### サンプルコード
<pre class="prettyprint"><code>EventQueue.invokeLater(new Runnable() {
  @Override public void run() {
    field.requestFocusInWindow();
  }
});
</code></pre>

### 解説
上記のサンプルでは、`JTextField`がデフォルトのフォーカスを持つように、`JComponent#requestFocusInWindow`メソッドを使用しています。

`requestFocusInWindow`メソッドは、チュートリアル([How to Use the Focus Subsystem](http://docs.oracle.com/javase/tutorial/uiswing/misc/focus.html))にあるように、`frame.pack();`した後で実行する必要があります。このため、このサンプルでは`EventQueue.invokeLater`を使って、待ち状態のすべてのイベントが処理されたあとで実行するようにしています。

- - - -
以下のように、`FocusTraversalPolicy`や`WindowListener`を使う方法でも、同様にデフォルトのフォーカスを持つコンポーネントを指定することが出来ます。

- `FocusTraversalPolicy`を使用
    - `FocusTraversalPolicy`を設定して、最初にフォーカスの当たるコンポーネントを指定(`JDK 1.4.0`以降)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>frame.setFocusTraversalPolicy(new LayoutFocusTraversalPolicy() {
  @Override public Component getInitialComponent(Window w) {
    return field;
  }
});
</code></pre>

- `WindowListener#windowOpened`で、`requestFocusInWindow`
    - フレームに`WindowListener`を設定して、`windowOpened`が呼び出されたときに、`requestFocusInWindow`

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>frame.addWindowListener(new WindowAdapter() {
  @Override public void windowOpened(WindowEvent e) {
    field.requestFocusInWindow();
  }
});
</code></pre>

- `ComponentListener#componentShown`で、`requestFocusInWindow`
    - フレームに`ComponentListener`を設定して、`componentShown`が呼び出されたとき(=フレームが`setVisible(true)`されたとき)に、`requestFocusInWindow`

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>frame.addComponentListener(new ComponentAdapter() {
  @Override public void componentShown(ComponentEvent e) {
    field.requestFocusInWindow();
  }
});
</code></pre>

- `KeyboardFocusManager#addPropertyChangeListener`で、`requestFocusInWindow`
    - `KeyboardFocusManager`に`PropertyChangeListener`を設定して、`propertyChange`が呼び出され、`PropertyName`が、`activeWindow`、かつ`PropertyChangeEvent#getNewValue`が`null`でないときに、`requestFocusInWindow`

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>KeyboardFocusManager kfm = KeyboardFocusManager.getCurrentKeyboardFocusManager();
kfm.addPropertyChangeListener(new PropertyChangeListener() {
  @Override public void propertyChange(PropertyChangeEvent e) {
    String prop = e.getPropertyName();
    if("activeWindow".equals(prop) &amp;&amp; e.getNewValue()!=null) {
      System.out.println("activeWindow");
      field.requestFocusInWindow();
    }
  }
});
</code></pre>

### 参考リンク
- [Focusの移動](http://terai.xrea.jp/Swing/FocusTraversal.html)
- [When does requestFocusInWindow() fail | Oracle Forums](https://forums.oracle.com/message/5774979)
- [JOptionPaneのデフォルトフォーカス](http://terai.xrea.jp/Swing/OptionPaneDefaultFocus.html)

<!-- dummy comment line for breaking list -->

### コメント
- `JFrame#getRootPane()#setDefaultButton()`は使用方法がよくわからない… -- [aterai](http://terai.xrea.jp/aterai.html)
- `setDefaultButton`って、<kbd>Enter</kbd>したときに押されたとみなすボタンだったかな…… --  2004-10-14 (木) 23:21:53
    - ありがとうございます。おかげでようやく理解できました。`JTextField`などにフォーカスがある状態で<kbd>Enter</kbd>キーを入力すると`setDefaultButton`したボタンが押されるのですね。 -- [aterai](http://terai.xrea.jp/aterai.html) 2004-10-18 (月) 12:14:15
    - というわけで、`frame.getRootPane().setDefaultButton(eb);`を追加してみました。上記のサンプルでは、中央の`JTextField`にフォーカスがある状態で、<kbd>Enter</kbd>キーを押すと、`EAST`ボタンが押されたことになります。 -- [aterai](http://terai.xrea.jp/aterai.html) 2004-10-18 (月) 12:20:58
    - ~~いつか、`DefaultButton`のページを別に作成すること。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-05-07 (水) 19:19:44~~
    - [DefaultButtonの設定](http://terai.xrea.jp/Swing/DefaultButton.html)に移動。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-05-12 (月) 14:40:15
- `HierarchyListener`を使用する場合のテスト -- [aterai](http://terai.xrea.jp/aterai.html) 2009-03-19 (木) 14:51:30
    - [JOptionPaneのデフォルトフォーカス](http://terai.xrea.jp/Swing/OptionPaneDefaultFocus.html)に移動

<!-- dummy comment line for breaking list -->


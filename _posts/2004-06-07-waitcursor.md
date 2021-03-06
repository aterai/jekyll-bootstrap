---
layout: post
category: swing
folder: WaitCursor
title: Cursorを砂時計に変更
tags: [Cursor, GlassPane, FocusTraversalPolicy, SwingWorker]
author: aterai
pubdate: 2004-06-07T13:57:16+09:00
description: バックグラウンドで処理が実行されている間は、Cursorに砂時計が設定されたGlassPaneを有効にします。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTWfYWDbsI/AAAAAAAAApU/rldJwQuVm-8/s800/WaitCursor.png
comments: true
---
## 概要
バックグラウンドで処理が実行されている間は、`Cursor`に砂時計が設定された`GlassPane`を有効にします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTWfYWDbsI/AAAAAAAAApU/rldJwQuVm-8/s800/WaitCursor.png %}

## サンプルコード
<pre class="prettyprint"><code>frame.setGlassPane(new LockingGlassPane());
frame.getGlassPane().setVisible(false);
button.addActionListener(new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    frame.getGlassPane().setVisible(true);
    button.setEnabled(false);
    new SwingWorker() {
      @Override public Object doInBackground() {
        dummyLongTask();
        return "Done";
      }
      @Override public void done() {
        frame.getGlassPane().setVisible(false);
        button.setEnabled(true);
      }
    }.execute();
  }
});
</code></pre>

<pre class="prettyprint"><code>class LockingGlassPane extends JComponent {
  public LockingGlassPane() {
    setOpaque(false);
    setFocusTraversalPolicy(new DefaultFocusTraversalPolicy() {
      @Override public boolean accept(Component c) {
        return false;
      }
    });
    addKeyListener(new KeyAdapter() {});
    addMouseListener(new MouseAdapter() {});
    requestFocusInWindow();
    setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
  }
  @Override public void setVisible(boolean flag) {
    super.setVisible(flag);
    setFocusTraversalPolicyProvider(flag);
  }
}
</code></pre>

## 解説
上記のサンプルでは、カーソルを砂時計に変更し、なにもしないマウスリスナーなどを設定した`GlassPane`を`JFrame#setGlassPane()`メソッドでフレームに追加しています。

スタートボタンがクリックされて処理が継続している間はこの`GlassPane`が有効になり、マウス、キー、フォーカス移動などのイベントがすべて`GlassPane`に奪われるため、フレーム内のコンポーネントがアクセス不可状態になります。

このため、サンプルにある`setEnabled(true)`な`JTextField`の上にマウスポインタを移動しても、処理中はカーソルアイコンは砂時計のまま変化しません。

- - - -
<kbd>Tab</kbd>キーなどによるフォーカス移動を禁止する場合は、`GlassPane`に以下のような設定を行います。

- どのコンポーネントにもフォーカス移動できない`FocusTraversalPolicy`を設定する

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>setFocusTraversalPolicy(new DefaultFocusTraversalPolicy() {
  @Override public boolean accept(Component c) {
    return false;
  }
});
</code></pre>

- または、`TraversalKeys`を空にする
    - 参考: [Swing - How to display "Loading data..." to the user](https://community.oracle.com/thread/1375257)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>Set&lt;AWTKeyStroke&gt; s = Collections.emptySet();
setFocusTraversalKeys(KeyboardFocusManager.FORWARD_TRAVERSAL_KEYS, s);
setFocusTraversalKeys(KeyboardFocusManager.BACKWARD_TRAVERSAL_KEYS, s);
</code></pre>

- - - -
`Mnemonic`なども禁止したい場合は、以下のような`GlassPane`を使用する方法があります(参考: [Disabling Swing Containers, the final solution?](http://weblogs.java.net/blog/alexfromsun/archive/2008/01/))。

<pre class="prettyprint"><code>class LockingGlassPane extends JComponent {
  public LockingGlassPane() {
    setOpaque(false);
    super.setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
  }
  @Override public void setVisible(boolean isVisible) {
    boolean oldVisible = isVisible();
    super.setVisible(isVisible);
    JRootPane rootPane = SwingUtilities.getRootPane(this);
    if (rootPane != null &amp;&amp; isVisible() != oldVisible) {
      rootPane.getLayeredPane().setVisible(!isVisible);
    }
  }
  @Override protected void paintComponent(Graphics g) {
    JRootPane rootPane = SwingUtilities.getRootPane(this);
    if (rootPane != null) {
      // http://weblogs.java.net/blog/alexfromsun/archive/2008/01/
      // it is important to call print() instead of paint() here
      // because print() doesn't affect the frame's double buffer
      rootPane.getLayeredPane().print(g);
    }
    super.paintComponent(g);
  }
}
</code></pre>

- - - -
- `JDK 1.6.0`の場合、[Disabled Glass Pane « Java Tips Weblog](https://tips4java.wordpress.com/2008/11/07/disabled-glass-pane/)のようにキー入力を無効にするキーリスナーを追加する方法もある
    - この方法は、`JDK 1.5.0`などの場合、`WindowsLookAndFeel`で、<kbd>Alt</kbd>キーを押すとメニューバーにフォーカスが移動する場合がある

<!-- dummy comment line for breaking list -->

- - - -
- `JDK 1.7.0`の場合、`JLayer`を使用して特定のコンポーネントだけ入力不可、かつカーソルを砂時計に変更するなどの設定が可能になった
    - [JLayerで指定したコンポーネントへの入力を禁止](https://ateraimemo.com/Swing/DisableInputLayer.html) に移動

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Swing - How to display "Loading data..." to the user](https://community.oracle.com/thread/1375257)
- [Disabling Swing Containers, the final solution?](http://weblogs.java.net/blog/alexfromsun/archive/2008/01/)
    - [JInternalFrameをModalにする](https://ateraimemo.com/Swing/ModalInternalFrame.html)
- [Disabled Glass Pane « Java Tips Weblog](https://tips4java.wordpress.com/2008/11/07/disabled-glass-pane/)

<!-- dummy comment line for breaking list -->

## コメント
- <kbd>Tab</kbd>キーで状態遷移しないようにするため、なにもしない`FocusTraversalPolicy`を追加しました。 -- *aterai* 2005-04-18 (月) 10:51:25
- 相当悩みました。`JDialog`だと同じことができないのは何でなんでしょうねぇ。。。 -- *おれ* 2006-05-17 (水) 16:33:12
    - カーソルが変わらないのでしょうか? それともコンパイルエラーが出るとかでしょうか? -- *aterai* 2006-05-17 (水) 17:59:14
- 申し訳ない。カーソルが変わらないのだけれど、`1.5`系でコンパイルするとだめみたい。同じソースでも`1.4`系でコンパイルするとちゃんと変わる。`1.5`でのバグかな。。。 -- *おれ* 2006-05-18 (木) 12:58:11
    - 追記。`JDialog`のコンストラクタに`null`を指定しているとこうなるようです。オーナフレームを指定してあげたら、`1.5`でもきちんと出ました。お騒がせしました。 -- *おれ*
    - なるほど、`new JDialog((Frame)null);`で試してみるとカーソルが変わらないですね。情報どうもでした。 -- *aterai* 2006-05-18 (木) 21:45:15
- `DefaultFocusTraversalPolicy`を使うように変更しました。 -- *aterai* 2007-07-03 (火) 16:39:12
- `GlassPane`で、`FocusTraversalPolicy`を使わず、`print`を使って`Mnemonic`などをブロックするように変更しました。 -- *aterai* 2008-04-15 (火) 17:14:09
- `SwingWorker`を使うように変更。 -- *aterai* 2011-03-26 (土) 23:21:11
- 入力抑制であれば`AWTEventListener`を追加して`InputEvent`を`consume`しちゃえば良いのでは・・・？ -- *sawshun* 2014-01-14 (火) 08:32:09
    - `AWTEventListener`を使うのは便利な方法だと思いますが、セキュリティマネージャの設定によっては`SecurityException`が発生したり、ドキュメントには「[アクセシビリティー、イベントの記録と再生、および診断トレースなどの特別な機能をサポートすることを主な目的としているので、アプリケーションの使用では推奨されません。](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Toolkit.html#addAWTEventListener-java.awt.event.AWTEventListener-long-)」的な注意事項があるので、使い所を考慮する必要がありそうです。このサンプルのような場合で`InputEvent#consume()`を使うなら`1.7`以上で`JLayer`を使用する方が無難かもしれません。 -- *aterai* 2014-01-14 (火) 14:13:39

<!-- dummy comment line for breaking list -->

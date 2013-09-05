---
layout: post
title: JLayerで子コンポーネントへの入力を制限する
category: swing
folder: PopupMenuBlockLayer
tags: [JLayer, GlassPane, JScrollPane, JComponent]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-11-28

## JLayerで子コンポーネントへの入力を制限する
`JLayer`を使って、子コンポーネントへのすべての入力を制限します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/-Svne2X0djJ8/TtJGGlPU-OI/AAAAAAAABFM/xjZfqHHbkJ0/s800/PopupMenuBlockLayer.png)

### サンプルコード
<pre class="prettyprint"><code>class DisableInputLayerUI extends LayerUI&lt;JComponent&gt; {
  private static final MouseAdapter dummyMouseListener = new MouseAdapter() {};
  private boolean isBlocking = false;
  @Override public void installUI(JComponent c) {
    super.installUI(c);
    JLayer jlayer = (JLayer)c;
    jlayer.getGlassPane().addMouseListener(dummyMouseListener);
    jlayer.setLayerEventMask(
      AWTEvent.MOUSE_EVENT_MASK | AWTEvent.MOUSE_MOTION_EVENT_MASK |
      AWTEvent.MOUSE_WHEEL_EVENT_MASK | AWTEvent.KEY_EVENT_MASK);
  }
  @Override public void uninstallUI(JComponent c) {
    JLayer jlayer = (JLayer)c;
    jlayer.setLayerEventMask(0);
    jlayer.getGlassPane().removeMouseListener(dummyMouseListener);
    super.uninstallUI(c);
  }
  @Override public void eventDispatched(AWTEvent e, JLayer l) {
    if(isBlocking &amp;&amp; e instanceof InputEvent) {
      ((InputEvent)e).consume();
    }
  }
  private static final String CMD_REPAINT = "lock";
  public void setLocked(boolean flag) {
    firePropertyChange(CMD_REPAINT,isBlocking,flag);
    isBlocking = flag;
  }
  @Override public void applyPropertyChange(PropertyChangeEvent pce, JLayer l) {
    String cmd = pce.getPropertyName();
    if(CMD_REPAINT.equals(cmd)) {
      l.getGlassPane().setVisible((Boolean)pce.getNewValue());
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JLayer`を使って、`JScrollPane(JScrollBar)`のスクロール、`JTable`のセル選択、`JToolTip`、`JTableHeader`の移動など、子コンポーネントへのすべての入力をまとめて制限しています。

- [JScrollPaneのスクロールを禁止](http://terai.xrea.jp/Swing/DisableScrolling.html)のように、`JScrollPane`、`JTable`などを個別に入力禁止にする必要がない
- [JLayerで指定したコンポーネントへの入力を禁止](http://terai.xrea.jp/Swing/DisableInputLayer.html)と、ほとんど同じだが、その場合、`setComponentPopupMenu(...)`で設定した`JPopupMenu`が制限できない
    - `JLayer#setLayerEventMask(...)`でポップアップメニュー表示の入力イベントが取得できない？(`Windows7`, `JDK 1.7.0_01`)
    - [Cursorを砂時計に変更](http://terai.xrea.jp/Swing/WaitCursor.html)のように、`GlassPane`にダミーのマウスリスナーを追加してポップアップメニューの表示トリガーを無視する

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JLayerで指定したコンポーネントへの入力を禁止](http://terai.xrea.jp/Swing/DisableInputLayer.html)
- [JScrollPaneのスクロールを禁止](http://terai.xrea.jp/Swing/DisableScrolling.html)
- [Cursorを砂時計に変更](http://terai.xrea.jp/Swing/WaitCursor.html)

<!-- dummy comment line for breaking list -->

### コメント
- また`src.zip`などを上げ忘れていたので修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-11-29 (火) 17:16:11

<!-- dummy comment line for breaking list -->

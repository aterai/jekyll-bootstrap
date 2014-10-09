---
layout: post
category: swing
folder: JLayerDisabledText
title: JLayerを使用して無効時のコンポーネントの文字色を変更する
tags: [JLayer, GlassPane, Focus, Mnemonic, JPopupMenu, JToolTip]
author: aterai
pubdate: 2012-02-13T14:58:04+09:00
description: JLayerを使用して、JButtonなどのコンポーネントを無効にしたときの文字色を変更します。
comments: true
---
## 概要
`JLayer`を使用して、`JButton`などのコンポーネントを無効にしたときの文字色を変更します。

{% download https://lh5.googleusercontent.com/-_2bogxiuOec/TzilFn0ms8I/AAAAAAAABJI/oMz_T6SqCwE/s800/JLayerDisabledText.png %}

## サンプルコード
<pre class="prettyprint"><code>class DisableInputLayerUI extends LayerUI&lt;JComponent&gt; {
  private static final boolean DEBUG_POPUP_BLOCK = true;
  private static final MouseAdapter dummyMouseListener = new MouseAdapter() {};
  private static final KeyAdapter dummyKeyListener = new KeyAdapter() {};
  private boolean isBlocking = false;
  @Override public void installUI(JComponent c) {
    super.installUI(c);
    JLayer jlayer = (JLayer)c;
    if(DEBUG_POPUP_BLOCK) {
      jlayer.getGlassPane().addMouseListener(dummyMouseListener);
      jlayer.getGlassPane().addKeyListener(dummyKeyListener);
    }
    jlayer.setLayerEventMask(
      AWTEvent.MOUSE_EVENT_MASK | AWTEvent.MOUSE_MOTION_EVENT_MASK |
      AWTEvent.MOUSE_WHEEL_EVENT_MASK | AWTEvent.KEY_EVENT_MASK |
      AWTEvent.FOCUS_EVENT_MASK | AWTEvent.COMPONENT_EVENT_MASK);
  }
  @Override public void uninstallUI(JComponent c) {
    JLayer jlayer = (JLayer)c;
    jlayer.setLayerEventMask(0);
    if(DEBUG_POPUP_BLOCK) {
      jlayer.getGlassPane().removeMouseListener(dummyMouseListener);
      jlayer.getGlassPane().removeKeyListener(dummyKeyListener);
    }
    super.uninstallUI(c);
  }
  @Override protected void processComponentEvent(
      ComponentEvent e, JLayer&lt;? extends JComponent&gt; l) {
    System.out.println("processComponentEvent");
  }
  @Override protected void processKeyEvent(
      KeyEvent e, JLayer&lt;? extends JComponent&gt; l) {
    System.out.println("processKeyEvent");
  }
  @Override protected void processFocusEvent(
      FocusEvent e, JLayer&lt;? extends JComponent&gt; l) {
    System.out.println("processFocusEvent");
  }
  @Override public void eventDispatched(
      AWTEvent e, JLayer&lt;? extends JComponent&gt; l) {
    if(isBlocking &amp;&amp; e instanceof InputEvent) {
      ((InputEvent)e).consume();
    }
  }
  private static final String CMD_BLOCKING = "lock";
  public void setLocked(boolean flag) {
    boolean oldv = isBlocking;
    isBlocking = flag;
    firePropertyChange(CMD_BLOCKING,oldv,isBlocking);
  }
  @Override public void applyPropertyChange(
      PropertyChangeEvent pce, JLayer&lt;? extends JComponent&gt; l) {
    String cmd = pce.getPropertyName();
    if(CMD_BLOCKING.equals(cmd)) {
      JButton b = (JButton)l.getView();
      b.setFocusable(!isBlocking);
      b.setMnemonic(isBlocking?0:b.getText().charAt(0));
      b.setForeground(isBlocking?Color.RED:Color.BLACK);
      l.getGlassPane().setVisible((Boolean)pce.getNewValue());
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`LayerUI#applyPropertyChange(...)`をオーバーライドして、コンポーネントを無効にした場合の文字色、`Focus`移動の禁止、`Mnemonic`、`PopupMenu`、`ToolTip`の非表示を行なっています。

`JLayer`の場合、無効時の文字色は、[JCheckBoxなどが無効な状態での文字色を変更](http://terai.xrea.jp/Swing/DisabledTextColor.html)のように、`LookAndFeel`によっては反映されないといったことがありません。

## 参考リンク
- [JCheckBoxなどが無効な状態での文字色を変更](http://terai.xrea.jp/Swing/DisabledTextColor.html)
- [JLayerで指定したコンポーネントへの入力を禁止](http://terai.xrea.jp/Swing/DisableInputLayer.html)

<!-- dummy comment line for breaking list -->

## コメント

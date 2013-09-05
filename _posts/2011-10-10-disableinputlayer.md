---
layout: post
title: JLayerで指定したコンポーネントへの入力を禁止
category: swing
folder: DisableInputLayer
tags: [JLayer, GlassPane, InputEvent, JComponent]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-10-10

## JLayerで指定したコンポーネントへの入力を禁止
`JDK 7`で導入された、`JLayer`を利用して、指定したコンポーネントへの入力を禁止します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/-fJbneWE3WB4/TpLGoNbk1TI/AAAAAAAABDk/GJWfhRR4UB0/s800/DisableInputLayer.png)

### サンプルコード
<pre class="prettyprint"><code>class DisableInputLayerUI extends LayerUI&lt;JPanel&gt; {
  private boolean isRunning = false;
  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    if(!isRunning) return;
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, .5f));
    g2.setPaint(Color.GRAY);
    g2.fillRect(0, 0, c.getWidth(), c.getHeight());
    g2.dispose();
  }
  @Override public void installUI(JComponent c) {
    super.installUI(c);
    JLayer jlayer = (JLayer)c;
    jlayer.getGlassPane().setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
    jlayer.setLayerEventMask(
      AWTEvent.MOUSE_EVENT_MASK |
      AWTEvent.MOUSE_MOTION_EVENT_MASK |
      AWTEvent.KEY_EVENT_MASK);
  }
  @Override public void uninstallUI(JComponent c) {
    JLayer jlayer = (JLayer)c;
    jlayer.setLayerEventMask(0);
    super.uninstallUI(c);
  }
  @Override public void eventDispatched(AWTEvent e, JLayer l) {
    if(isRunning &amp;&amp; e instanceof InputEvent) {
        ((InputEvent)e).consume();
    }
  }
  private static final String CMD_REPAINT = "repaint";
  public void start() {
    if (isRunning) return;
    isRunning = true;
    firePropertyChange(CMD_REPAINT,false,true);
  }
  public void stop() {
    isRunning = false;
    firePropertyChange(CMD_REPAINT,true,false);
  }
  @Override public void applyPropertyChange(PropertyChangeEvent pce, JLayer l) {
    String cmd = pce.getPropertyName();
    if(CMD_REPAINT.equals(cmd)) {
      l.getGlassPane().setVisible((Boolean)pce.getNewValue());
      l.repaint();
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JLayer`を設定した任意のコンポーネントへの入力可不可を切り替えることができるようになっています。

- 入力禁止中の半透明グレイ表示
    - `LayerUI<JPanel>#paint(...)`をオーバーライドして表示を変更
- マウス、キー入力の禁止
    - `LayerUI<JPanel>#eventDispatched(...)`をオーバーライドして、`((InputEvent)e).consume()`を使用し、イベントを消費
- マウスカーソルを砂時計に変更
    - `Cursor.WAIT_CURSOR`を設定した`GlassPane`の表示を切り替える

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Cursorを砂時計に変更](http://terai.xrea.jp/Swing/WaitCursor.html)

<!-- dummy comment line for breaking list -->

### コメント
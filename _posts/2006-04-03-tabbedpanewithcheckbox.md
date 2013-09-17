---
layout: post
title: JTabbedPaneの余白にJCheckBoxを配置
category: swing
folder: TabbedPaneWithCheckBox
tags: [JTabbedPane, JCheckBox, Border]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-04-03

## JTabbedPaneの余白にJCheckBoxを配置
`JTabbedPane`の余白に`JCheckBox`を配置して特定のタブの開閉を行います。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTUQ8ALIWI/AAAAAAAAAlw/7jfCbNrxWK8/s800/TabbedPaneWithCheckBox.png)

### サンプルコード
<pre class="prettyprint"><code>class TabbedPaneWithCompBorder implements Border, MouseListener, SwingConstants {
  private final JComponent  dummy = new JPanel();
  private final JCheckBox   cbox;
  private final JTabbedPane tab;
  private Rectangle rect;
  public TabbedPaneWithCompBorder(JCheckBox cbox, JTabbedPane tab) {
    this.cbox = cbox;
    this.tab  = tab;
    tab.addMouseListener(this);
    cbox.setFocusPainted(false);
    cbox.addMouseListener(new MouseAdapter() {
      @Override public void mouseClicked(MouseEvent me) {
        JCheckBox cb = (JCheckBox)me.getSource();
        cb.setSelected(!cb.isSelected());
      }
    });
  }
  @Override public void paintBorder(Component c, Graphics g, int x, int y, int w, int h) {
    Dimension size = cbox.getPreferredSize();
    int xx = tab.getSize().width - size.width;
    Rectangle lastTab = tab.getUI().getTabBounds(tab, tab.getTabCount()-1);
    int tabEnd = lastTab.x + lastTab.width;
    if(xx&lt;tabEnd) xx = tabEnd;
    rect = new Rectangle(xx, -2, size.width, size.height);
    SwingUtilities.paintComponent(g, cbox, dummy, rect);
  }
  @Override public Insets getBorderInsets(Component c) {
    return new Insets(0,0,0,0);
  }
  @Override public boolean isBorderOpaque() {
    return true;
  }
  private void dispatchEvent(MouseEvent me) {
    if(rect==null || !rect.contains(me.getX(), me.getY())) return;
    cbox.setBounds(rect);
    cbox.dispatchEvent(SwingUtilities.convertMouseEvent(tab,me,cbox));
  }
  @Override public void mouseClicked(MouseEvent me)  { dispatchEvent(me); }
  @Override public void mouseEntered(MouseEvent me)  { dispatchEvent(me); }
  @Override public void mouseExited(MouseEvent me)   { dispatchEvent(me); }
  @Override public void mousePressed(MouseEvent me)  { dispatchEvent(me); }
  @Override public void mouseReleased(MouseEvent me) { dispatchEvent(me); }
}
</code></pre>

### 解説
`JTabbedPane`の`Border`に`SwingUtilities.paintComponent`メソッドを使って`JCheckBox`を描画しています。`JCheckBox`が`JTabbedPane`の子になってタブが増えないように、ダミーパネルを中間コンテナに指定しています。

`JTabbedPane`で受け取ったマウスイベントを、`SwingUtilities.convertMouseEvent`メソッドを利用し、チェックボックス用に座標などを変換して送り出しています。

- - - -
タブとチェックボックスが重ならないように、フレームの最小サイズを設定しています。

<pre class="prettyprint"><code>frame.setMinimumSize(new Dimension(240, 80));
</code></pre>

- - - -
他にも、レイアウトマネージャーを利用して同様のことを行う方法があります。

- [Swing - Any layout suggestions for this?](https://forums.oracle.com/thread/1389350)
    - レイアウトマネージャーを自作するweebibさんの投稿 (reply 1)
    - `OverlayLayout`を利用するcamickrさんの投稿 (reply 2)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTabbedPaneの余白に文字列を表示](http://terai.xrea.jp/Swing/TabbedPaneWithText.html)
- [JTabbedPaneの余白にJButtonを配置](http://terai.xrea.jp/Swing/TabbedPaneWithButton.html)

<!-- dummy comment line for breaking list -->

### コメント

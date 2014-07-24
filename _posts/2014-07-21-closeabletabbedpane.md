---
layout: post
title: JTabbedPaneの各タブにJButtonを右寄せで追加する
category: swing
folder: CloseableTabbedPane
tags: [JTabbedPane, JButton, JLayer]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-07-21

## JTabbedPaneの各タブにJButtonを右寄せで追加する
JTabbedPaneのタブ上にそれを閉じるためのJButtonをJLayerを使用して右寄せで描画します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/-slZiu9Gyq8I/U8wH6A1byMI/AAAAAAAACJ0/-aLfrJeKX4Y/s800/CloseableTabbedPane.png)

### サンプルコード
<pre class="prettyprint"><code>class CloseableTabbedPaneLayerUI extends LayerUI&lt;JTabbedPane&gt; {
  private final JComponent rubberStamp = new JPanel();
  private final Point pt = new Point(-100, -100);
  private final JButton button = new JButton(new CloseTabIcon());
  public CloseableTabbedPaneLayerUI() {
    super();
    button.setBorder(BorderFactory.createEmptyBorder());
    button.setFocusPainted(false);
    button.setBorderPainted(false);
    button.setContentAreaFilled(false);
    button.setRolloverEnabled(false);
  }
  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    if (c instanceof JLayer) {
      JLayer jlayer = (JLayer) c;
      JTabbedPane tabPane = (JTabbedPane) jlayer.getView();
      for (int i = 0; i &lt; tabPane.getTabCount(); i++) {
        Rectangle rect = tabPane.getBoundsAt(i);
        Dimension d = button.getPreferredSize();
        int x = rect.x + rect.width - d.width - 2;
        int y = rect.y + (rect.height - d.height) / 2;
        Rectangle r = new Rectangle(x, y, d.width, d.height);
        button.getModel().setRollover(r.contains(pt));
        SwingUtilities.paintComponent(g, button, rubberStamp, r);
      }
    }
  }
  @Override public void installUI(JComponent c) {
    super.installUI(c);
    if (c instanceof JLayer) {
      ((JLayer) c).setLayerEventMask(
          AWTEvent.MOUSE_EVENT_MASK |
          AWTEvent.MOUSE_MOTION_EVENT_MASK);
    }
  }
  @Override public void uninstallUI(JComponent c) {
    if (c instanceof JLayer) {
      ((JLayer) c).setLayerEventMask(0);
    }
    super.uninstallUI(c);
  }
  @Override protected void processMouseEvent(
      MouseEvent e, JLayer&lt;? extends JTabbedPane&gt; l) {
    if (e.getID() == MouseEvent.MOUSE_CLICKED) {
      pt.setLocation(e.getPoint());
      JTabbedPane tabbedPane = (JTabbedPane) l.getView();
      int index = tabbedPane.indexAtLocation(pt.x, pt.y);
      if (index &gt;= 0) {
        Rectangle rect = tabbedPane.getBoundsAt(index);
        Dimension d = button.getPreferredSize();
        int x = rect.x + rect.width - d.width - 2;
        int y = rect.y + (rect.height - d.height) / 2;
        Rectangle r = new Rectangle(x, y, d.width, d.height);
        if (r.contains(pt)) {
          tabbedPane.removeTabAt(index);
        }
      }
    }
  }
  @Override protected void processMouseMotionEvent(
      MouseEvent e, JLayer&lt;? extends JTabbedPane&gt; l) {
    pt.setLocation(e.getPoint());
    JTabbedPane tabbedPane = (JTabbedPane) l.getView();
    int index = tabbedPane.indexAtLocation(pt.x, pt.y);
    if (index &gt;= 0) {
      Point loc = e.getPoint();
      loc.translate(-16, -16);
      l.repaint(new Rectangle(loc, new Dimension(32, 32)));
    }
  }
}
</code></pre>

### 解説
- 上
    - [JTabbedPaneにタブを閉じるボタンを追加](http://terai.xrea.jp/Swing/TabWithCloseButton.html)
    - タブに追加したコンポーネントは、中央揃えで配置される(`BasicTabbedPaneUI`などのデフォルト)
- 下
    - `JLayer`を使用して、タブの余白にそれを閉じるための`JButton`を描画
        - `TabbedPaneUI`をオーバーライドする必要がない
        - [JTabbedPaneにタブを閉じるアイコンを追加](http://terai.xrea.jp/Swing/TabWithCloseIcon.html)では、`BasicTabbedPaneUI#createLayoutManager()`をオーバーライドして、独自の`TabbedPaneLayout`で右端に☓アイコンを描画
    - タブの余白は`UIManager.put("TabbedPane.tabInsets", new Insets(2, 18, 2, 18));`で設定
        - この余白は、`NimbusLookAndFeel`などでは無効
        - 余白が取れないほどタブが短くなったら、ボタンがタイトルに重なってしまう

<!-- dummy comment line for breaking list -->

### 参考リンク
- [java - Closeable JTabbedPane - alignment of the close button - Stack Overflow](http://stackoverflow.com/questions/24634047/closeable-jtabbedpane-alignment-of-the-close-button)
- [JTabbedPaneにタブを閉じるボタンを追加](http://terai.xrea.jp/Swing/TabWithCloseButton.html)
- [JTabbedPaneにタブを閉じるアイコンを追加](http://terai.xrea.jp/Swing/TabWithCloseIcon.html)

<!-- dummy comment line for breaking list -->

### コメント

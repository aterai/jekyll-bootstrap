---
layout: post
category: swing
folder: TranslucentThumbDivider
title: JSplitPaneのDividerを円形半透明のつまみに変更して中央に配置する
tags: [JSplitPane, Divider, JLayer]
author: aterai
pubdate: 2018-11-12T16:03:00+09:00
description: JSplitPaneの元のDividerを非表示に設定し、代わりにJLayerを使って半透明の円形つまみを作成して中央に配置します。
image: https://drive.google.com/uc?id=1a-kjbBV4L-gJzGRMBijfxYxSJhiZBppZHg
hreflang:
    href: https://java-swing-tips.blogspot.com/2018/10/create-image-comparison-slider-with.html
    lang: en
comments: true
---
## 概要
`JSplitPane`の元の`Divider`を非表示に設定し、代わりに`JLayer`を使って半透明の円形つまみを作成して中央に配置します。

{% download https://drive.google.com/uc?id=1a-kjbBV4L-gJzGRMBijfxYxSJhiZBppZHg %}

## サンプルコード
<pre class="prettyprint"><code>class DividerLocationDragLayerUI extends LayerUI&lt;JSplitPane&gt; {
  private static final int R = 25;
  private final Point startPt = new Point();
  private final Cursor dc = Cursor.getDefaultCursor();
  private final Cursor wc = Cursor.getPredefinedCursor(Cursor.W_RESIZE_CURSOR);
  private final Ellipse2D thumb = new Ellipse2D.Double();
  private int dividerLocation;
  private boolean isDragging;
  private boolean isEnter;

  @Override public void installUI(JComponent c) {
    super.installUI(c);
    if (c instanceof JLayer) {
      ((JLayer&lt;?&gt;) c).setLayerEventMask(AWTEvent.MOUSE_EVENT_MASK
          | AWTEvent.MOUSE_MOTION_EVENT_MASK);
    }
  }
  @Override public void uninstallUI(JComponent c) {
    if (c instanceof JLayer) {
      ((JLayer&lt;?&gt;) c).setLayerEventMask(0);
    }
    super.uninstallUI(c);
  }
  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    if ((isEnter || isDragging) &amp;&amp; c instanceof JLayer) {
      updateThumbLocation(((JLayer&lt;?&gt;) c).getView(), thumb);
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                          RenderingHints.VALUE_ANTIALIAS_ON);
      g2.setPaint(new Color(255, 100, 100, 100));
      g2.fill(thumb);
      g2.dispose();
    }
  }
  @Override protected void processMouseEvent(
      MouseEvent e, JLayer&lt;? extends JSplitPane&gt; l) {
    JSplitPane splitPane = l.getView();
    switch (e.getID()) {
    case MouseEvent.MOUSE_ENTERED:
      isEnter = true;
      break;
    case MouseEvent.MOUSE_EXITED:
      isEnter = false;
      break;
    case MouseEvent.MOUSE_RELEASED:
      isDragging = false;
      break;
    case MouseEvent.MOUSE_PRESSED:
      Component c = e.getComponent();
      if (isDraggableComponent(splitPane, c)) {
        Point pt = SwingUtilities.convertPoint(c, e.getPoint(), splitPane);
        isDragging = thumb.contains(pt);
        startPt.setLocation(SwingUtilities.convertPoint(c, e.getPoint(), splitPane));
        dividerLocation = splitPane.getDividerLocation();
      }
      break;
    default:
      break;
    }
    splitPane.repaint();
  }
  @Override protected void processMouseMotionEvent(
      MouseEvent e, JLayer&lt;? extends JSplitPane&gt; l) {
    JSplitPane splitPane = l.getView();
    Component c = e.getComponent();
    Point pt = SwingUtilities.convertPoint(c, e.getPoint(), splitPane);
    if (e.getID() == MouseEvent.MOUSE_MOVED) {
      splitPane.setCursor(thumb.contains(e.getPoint()) ? wc : dc);
    } else if (isDragging &amp;&amp; isDraggableComponent(splitPane, c)
               &amp;&amp; e.getID() == MouseEvent.MOUSE_DRAGGED) {
      int delta = splitPane.getOrientation() == JSplitPane.HORIZONTAL_SPLIT
          ? pt.x - startPt.x : pt.y - startPt.y;
      splitPane.setDividerLocation(Math.max(0, dividerLocation + delta));
    }
  }
  private static boolean isDraggableComponent(JSplitPane splitPane, Component c) {
    return Objects.equals(splitPane, c)
      || Objects.equals(splitPane, SwingUtilities.getUnwrappedParent(c));
  }
  private static void updateThumbLocation(Component c, Ellipse2D thumb) {
    if (c instanceof JSplitPane) {
      JSplitPane splitPane = (JSplitPane) c;
      int pos = splitPane.getDividerLocation();
      if (splitPane.getOrientation() == JSplitPane.HORIZONTAL_SPLIT) {
        thumb.setFrame(pos - R, splitPane.getHeight() / 2 - R, R + R, R + R);
      } else {
        thumb.setFrame(splitPane.getWidth() / 2 - R, pos - R, R + R, R + R);
      }
    }
  }
}
</code></pre>

## 解説
- `JSplitPane#setDividerSize(0)`で`Divider`を非表示に設定
    - [JSplitPaneのDividerをマウスで移動できないように設定する](https://ateraimemo.com/Swing/FixedDividerSplitPane.html)
- `JLayer`を使用して、半透明の円形つまみを作成して`Divider`の中央に配置
    - [JSplitPaneでドラッグ中のDividerの背景色を設定する](https://ateraimemo.com/Swing/DividerDraggingColor.html)でも`Divider`の色を半透明などに変更可能だが、`JSplitPane#setContinuousLayout(false)`の場合のみ有効なので、このサンプルでは使用できない

<!-- dummy comment line for breaking list -->

- - - -
- 画像を左上([JSplitPaneで画像を差分を比較表示する](https://ateraimemo.com/Swing/ImageComparisonSplitPane.html))ではなく、`JSplitPane`の中央に表示するよう変更

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>Component beforeCanvas = new JComponent() {
  @Override protected void paintComponent(Graphics g) {
    super.paintComponent(g);

    int iw = icon.getIconWidth();
    int ih = icon.getIconHeight();
    Dimension dim = split.getSize();
    int x = (dim.width - iw) / 2;
    int y = (dim.height - ih) / 2;
    g.drawImage(icon.getImage(), x, y, iw, ih, this);
  }
};
split.setLeftComponent(beforeCanvas);

Component afterCanvas = new JComponent() {
  @Override protected void paintComponent(Graphics g) {
    super.paintComponent(g);
    Graphics2D g2 = (Graphics2D) g.create();
    g2.translate(-getLocation().x + split.getInsets().left, 0);

    int iw = destination.getWidth(this);
    int ih = destination.getHeight(this);
    Dimension dim = split.getSize();
    int x = (dim.width - iw) / 2;
    int y = (dim.height - ih) / 2;
    g2.drawImage(destination, x, y, iw, ih, this);
    g2.dispose();
  }
};
split.setRightComponent(afterCanvas);
</code></pre>

## 参考リンク
- [JSplitPaneで画像を差分を比較表示する](https://ateraimemo.com/Swing/ImageComparisonSplitPane.html)

<!-- dummy comment line for breaking list -->

## コメント

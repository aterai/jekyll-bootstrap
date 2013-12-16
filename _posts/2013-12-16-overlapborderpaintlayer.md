---
layout: post
title: JLayerで隣接する別コンポーネント上に縁を描画
category: swing
folder: OverlapBorderPaintLayer
tags: [JLayer, JRadioButton, JPanel, Icon]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-12-16

## JLayerで隣接する別コンポーネント上に縁を描画
`JLayer`を使用して隣接する別コンポーネント上にも縁や影を描画します。

{% download %}

![screenshot](https://lh5.googleusercontent.com/-VshDpoewqBc/Uq2wDsedThI/AAAAAAAAB8g/TFMskJO7jys/s800/OverlapBorderPaintLayer.png)

### サンプルコード
<pre class="prettyprint"><code>class BreadcrumbLayerUI extends LayerUI&lt;JPanel&gt; {
  private Shape shape;
  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    if(shape!=null) {
      Graphics2D g2 = (Graphics2D)g.create();
      g2.setRenderingHint(
          RenderingHints.KEY_ANTIALIASING,
          RenderingHints.VALUE_ANTIALIAS_ON);

      Rectangle r = new Rectangle(0,0,c.getWidth(),c.getHeight());
      Area area = new Area(r);
      area.subtract(new Area(shape));
      g2.setClip(area);

      g2.setPaint(new Color(0x55666666, true));
      g2.setStroke(new BasicStroke(3f));
      g2.draw(shape);
      g2.setStroke(new BasicStroke(2f));
      g2.draw(shape);

      g2.setStroke(new BasicStroke(1f));
      g2.setClip(r);
      g2.setPaint(Color.WHITE);
      g2.draw(shape);

      g2.dispose();
    }
  }
  @Override public void installUI(JComponent c) {
    super.installUI(c);
    ((JLayer)c).setLayerEventMask(
        AWTEvent.MOUSE_EVENT_MASK | AWTEvent.MOUSE_MOTION_EVENT_MASK);
  }
  @Override public void uninstallUI(JComponent c) {
    ((JLayer)c).setLayerEventMask(0);
    super.uninstallUI(c);
  }
  private void update(MouseEvent e, JLayer&lt;? extends JPanel&gt; l) {
    int id = e.getID();
    Shape s = null;
    if(id==MouseEvent.MOUSE_ENTERED || id==MouseEvent.MOUSE_MOVED) {
      Component c = e.getComponent();
      if(c instanceof AbstractButton) {
        AbstractButton b = (AbstractButton)c;
        if(b.getIcon() instanceof ToggleButtonBarCellIcon) {
          ToggleButtonBarCellIcon icon = (ToggleButtonBarCellIcon)b.getIcon();
          Rectangle r = c.getBounds();
          AffineTransform at = AffineTransform.getTranslateInstance(r.x, r.y);
          s = at.createTransformedShape(icon.area);
        }
      }
    }
    if(s!=shape) {
      shape = s;
      l.getView().repaint();
    }
  }
  @Override protected void processMouseEvent(
      MouseEvent e, JLayer&lt;? extends JPanel&gt; l) {
    update(e, l);
  }
  @Override protected void processMouseMotionEvent(
      MouseEvent e, JLayer&lt;? extends JPanel&gt; l) {
    update(e, l);
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JLayer#processMouseEvent(...)`, `JLayer#processMouseMotionEvent(...)`をオーバーライドして、カーソルの下にある`JRadioButton`を取得し、その周辺に`JLayer#paint(...)`メソッドを使って影と縁を描画しています。これらは一番手前の別レイヤに描画されるので、隣接したり奥に重なったりしているコンポーネントなどの上に描画することができます。

### 参考リンク
- [FlowLayoutでボタンを重ねてパンくずリストを作成する](http://terai.xrea.jp/Swing/BreadcrumbList.html)
- [JMenuItemの内部にJButtonを配置する](http://terai.xrea.jp/Swing/ButtonsInMenuItem.html)

<!-- dummy comment line for breaking list -->

### コメント
---
layout: post
title: Separatorを波線で表示
category: swing
folder: WavyLineSeparator
tags: [JSeparator, Icon]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-06-19

## Separatorを波線で表示
波線を使った`Separator`を作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTWkeY23gI/AAAAAAAAApc/r6W1VFeeAYA/s800/WavyLineSeparator.png)

### サンプルコード
<pre class="prettyprint"><code>class WavyLineSeparator extends JSeparator {
  private static final int ICONWIDTH = 3;
  private static final Icon WAVY_HLINE = new WavyLineIcon();
  private static final Icon WAVY_VLINE = new WavyLineIcon(VERTICAL);
  public WavyLineSeparator() {
    this(HORIZONTAL);
  }
  public WavyLineSeparator(int orientation) {
    super(orientation);
    if(orientation==HORIZONTAL) {
      setBorder(BorderFactory.createEmptyBorder(2,1,2,1));
    }else{
      setBorder(BorderFactory.createEmptyBorder(1,2,1,2));
    }
  }
  @Override public void paintComponent(Graphics g) {
    //super.paintComponent(g);
    //g.setClip(0, 0, getWidth(), getHeight());
    int pos;
    Insets i = getInsets();
    if(getOrientation()==HORIZONTAL) {
      for(pos=i.left;getWidth()-pos&gt;0;pos+=WAVY_HLINE.getIconWidth()) {
        WAVY_HLINE.paintIcon(this, g, pos, i.top);
      }
    }else{
      for(pos=i.top;getHeight()-pos&gt;0;pos+=WAVY_VLINE.getIconHeight()) {
        WAVY_VLINE.paintIcon(this, g, i.left, pos);
      }
    }
  }
  @Override public Dimension getPreferredSize() {
    Insets i = getInsets();
    if(getOrientation()==HORIZONTAL) {
      return new Dimension(30, ICONWIDTH+i.top+i.bottom);
    }else{
      return new Dimension(ICONWIDTH+i.left+i.right, 30);
    }
  }
  static class WavyLineIcon implements Icon {
    private final Color sfc = UIManager.getColor("Separator.foreground");
    private final int orientation;
    public WavyLineIcon() {
      this.orientation = HORIZONTAL;
    }
    public WavyLineIcon(int orientation) {
      this.orientation = orientation;
    }
    @Override public void paintIcon(Component c, Graphics g, int x, int y) {
      Graphics2D g2 = (Graphics2D)g;
      AffineTransform oldTransform = g2.getTransform();
      g2.setPaint(sfc);
      if(orientation==VERTICAL) {
        g2.translate(x+getIconWidth(), y);
        g2.rotate(Math.PI/2);
      }else{
        g2.translate(x,y);
      }
      g2.drawLine( 0, 2, 0, 2 );
      g2.drawLine( 1, 1, 1, 1 );
      g2.drawLine( 2, 0, 3, 0 );
      g2.drawLine( 4, 1, 4, 1 );
      g2.drawLine( 5, 2, 5, 2 );
      g2.setTransform(oldTransform);
    }
    @Override public int getIconWidth()  {
      return (orientation==HORIZONTAL)?ICONWIDTH*2:ICONWIDTH;
    }
    @Override public int getIconHeight() {
      return (orientation==HORIZONTAL)?ICONWIDTH:ICONWIDTH*2;
    }
  }
}
</code></pre>

### 解説
水平用の波パターン`Icon`を作成して、これを順番に並べてセパレータとして描画しています。垂直用のパターンは水平用を回転して生成しています。

### コメント
- `SwingConstants.VERTICAL`に対応しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-06-19 (月) 14:39:49

<!-- dummy comment line for breaking list -->

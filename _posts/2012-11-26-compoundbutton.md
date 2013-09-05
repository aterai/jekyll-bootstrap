---
layout: post
title: OverlayLayoutで複数のJButtonを重ねて複合ボタンを作成
category: swing
folder: CompoundButton
tags: [OverlayLayout, JButton, Icon]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-11-26

## OverlayLayoutで複数のJButtonを重ねて複合ボタンを作成
`4`つの扇形ボタンと円形ボタンを、`OverlayLayout`を設定した`JPanel`に配置して、複合ボタンを作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/-0bLp9wWHHOw/ULIxE5DUtzI/AAAAAAAABX4/pRUF7k-l4D0/s800/CompoundButton.png)

### サンプルコード
<pre class="prettyprint"><code>private static JComponent makeCompoundButton(final Dimension d) {
  JPanel p = new JPanel() {
    @Override public Dimension getPreferredSize() {
      return d;
    }
  };
  p.setLayout(new OverlayLayout(p));
  p.add(new CompoundButton(d, ButtonLocation.NOTH));
  p.add(new CompoundButton(d, ButtonLocation.SOUTH));
  p.add(new CompoundButton(d, ButtonLocation.EAST));
  p.add(new CompoundButton(d, ButtonLocation.WEST));
  p.add(new CompoundButton(d, ButtonLocation.CENTER));
  return p;
}

class CompoundButton extends JButton {
  protected final Color fc = new Color(100,150,255,200);
  protected final Color ac = new Color(230,230,230);
  protected final Color rc = Color.ORANGE;
  protected Shape shape;
  protected Shape base = null;
  private final ButtonLocation bl;
  private final Dimension dim;
  public CompoundButton(Dimension d, ButtonLocation bl) {
    super();
    this.dim = d;
    this.bl = bl;
    setIcon(new Icon() {
      @Override public void paintIcon(Component c, Graphics g, int x, int y) {
        Graphics2D g2 = (Graphics2D)g.create();
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                  RenderingHints.VALUE_ANTIALIAS_ON);
        if(getModel().isArmed()) {
          g2.setColor(ac);
          g2.fill(shape);
        }else if(isRolloverEnabled() &amp;&amp; getModel().isRollover()) {
          paintFocusAndRollover(g2, rc);
        }else if(hasFocus()) {
          paintFocusAndRollover(g2, fc);
        }else{
          g2.setColor(getBackground());
          g2.fill(shape);
        }
        g2.dispose();
      }
      @Override public int getIconWidth()  {
        return dim.width;
      }
      @Override public int getIconHeight() {
        return dim.height;
      }
    });
    setFocusPainted(false);
    setContentAreaFilled(false);
    setBackground(new Color(250, 250, 250));
    initShape();
  }
  @Override public Dimension getPreferredSize() {
    return dim;
  }
  protected void initShape() {
    if(!getBounds().equals(base)) {
      base = getBounds();
      float ww = getWidth() * 0.5f;
      float xx = ww * 0.5f;
      Shape inner = new Ellipse2D.Float(xx, xx, ww, ww);
      if(ButtonLocation.CENTER==bl) {
        shape = inner;
      }else{
        Shape outer = new Arc2D.Float(
          1, 1, getWidth()-2, getHeight()-2,
          bl.getStartDegree(), 90f, Arc2D.PIE);
        Area area = new Area(outer);
        area.subtract(new Area(inner));
        shape = area;
      }
    }
  }
  private void paintFocusAndRollover(Graphics2D g2, Color color) {
    g2.setPaint(new GradientPaint(0, 0, color,
                    getWidth()-1, getHeight()-1, color.brighter(), true));
    g2.fill(shape);
    g2.setColor(getBackground());
  }
  @Override protected void paintComponent(Graphics g) {
    initShape();
    super.paintComponent(g);
  }
  @Override protected void paintBorder(Graphics g) {
    Graphics2D g2 = (Graphics2D)g;
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
              RenderingHints.VALUE_ANTIALIAS_ON);
    g2.setColor(getForeground());
    g2.draw(shape);
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
              RenderingHints.VALUE_ANTIALIAS_OFF);
  }
  @Override public boolean contains(int x, int y) {
    //initShape();
    return shape.contains(x, y);
  }
}
</code></pre>

### 解説
- 円形ボタン
    - [JButtonの形を変更](http://terai.xrea.jp/Swing/RoundButton.html)を使って、幅高さの半分の直径をもつ円ボタンを作成
    - `JButton#contains(...)`をオーバーライドして、図形内のみマウスカーソルが反応するように変更
- 扇形ボタン
    - 東西南北に`4`つ配置するので、角の大きさは`90`度、始角はそれぞれ、`45`、`135`、`225`、`-45`度で`Arc2D`を作成
    - これらの`Arc2D`から上記の円形ボタンの領域を取り去って扇形に変形(`Area#subtract(Area)`を使用)
        - [Mouseで画像を移動、回転](http://terai.xrea.jp/Swing/MouseDrivenImageRotation.html)
    - `JButton#contains(...)`をオーバーライドして、図形内のみマウスカーソルが反応するように変更
- 複合ボタン
    - `5`つのボタンを、`OverlayLayout`を設定した`JPanel`に配置
    - `JPanel#getPreferredSize()`をオーバーライドして、サイズが`5`つのボタンと同じになるように設定
        - [OverlayLayoutの使用](http://terai.xrea.jp/Swing/OverlayLayout.html)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [OverlayLayoutの使用](http://terai.xrea.jp/Swing/OverlayLayout.html)
- [JButtonの形を変更](http://terai.xrea.jp/Swing/RoundButton.html)
- [Mouseで画像を移動、回転](http://terai.xrea.jp/Swing/MouseDrivenImageRotation.html)

<!-- dummy comment line for breaking list -->

### コメント
---
layout: post
title: ImageIconの形でJButtonを作成
category: swing
folder: RoundImageButton
tags: [JButton, Shape, ImageIcon]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-07-21

## ImageIconの形でJButtonを作成
任意の`Shape`とその形に透過色を設定した画像を使って`JButton`を作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTSO4fquKI/AAAAAAAAAic/UdMAZSREN1U/s800/RoundImageButton.png)

### サンプルコード
<pre class="prettyprint"><code>class RoundButton extends JButton {
  public RoundButton() {
    this(null, null);
  }
  public RoundButton(Icon icon) {
    this(null, icon);
  }
  public RoundButton(String text) {
    this(text, null);
  }
  public RoundButton(Action a) {
    this();
    setAction(a);
  }
  public RoundButton(String text, Icon icon) {
    setModel(new DefaultButtonModel());
    init(text, icon);
    if(icon==null) {
      return;
    }
    setBorder(BorderFactory.createEmptyBorder(1,1,1,1));
    setBackground(Color.BLACK);
    setContentAreaFilled(false);
    setFocusPainted(false);
    //setVerticalAlignment(SwingConstants.TOP);
    setAlignmentY(Component.TOP_ALIGNMENT);
    initShape();
  }
  protected Shape shape, base;
  protected void initShape() {
    if(!getBounds().equals(base)) {
      Dimension s = getPreferredSize();
      base = getBounds();
      shape = new Ellipse2D.Float(0, 0, s.width-1, s.height-1);
    }
  }
  @Override public Dimension getPreferredSize() {
    Icon icon = getIcon();
    Insets i = getInsets();
    int iw = Math.max(icon.getIconWidth(), icon.getIconHeight());
    return new Dimension(iw+i.right+i.left, iw+i.top+i.bottom);
  }
  @Override protected void paintBorder(Graphics g) {
    initShape();
    Graphics2D g2 = (Graphics2D)g;
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    g2.setColor(getBackground());
    //g2.setStroke(new BasicStroke(1.0f));
    g2.draw(shape);
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_OFF);
  }
  @Override public boolean contains(int x, int y) {
    initShape();
    return shape.contains(x, y);
    //以下、透過色が0でクリック不可にする場合の例
    //or return super.contains(x, y) &amp;&amp; ((image.getRGB(x, y) &gt;&gt; 24) &amp; 0xff) &gt; 0;
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JButton`に円形の画像を貼り付けてボタンを作成しています。

- 円形、同サイズの`PNG`画像(円の外側が透過色)を三種類用意して`JButton`に設定
    - `setIcon`
    - `setPressedIcon`
    - `setRolloverIcon`
- `setContentAreaFilled(false)`などを設定して、ボタン自体の描画はしない
- 推奨、最小、最大サイズを画像のサイズに合わせる
    - ただし、縁の線を描画するため、画像サイズより上下左右`1px`大きくなるよう`EmptyBorder`を設定している
- `contains`をオーバーライドして、円の外側をクリックしてもボタンが反応しないようにする
    - このサンプルでは、画像の透過色から円を生成している訳ではなく、画像のサイズから円図形を別途作成している
    - 画像の透過色から、クリック可能な領域を設定する場合は、[JComponentの形状定義を変更する](http://terai.xrea.jp/Swing/MoveNonRectangularImage.html)を参照
- `paintBorder`をオーバーライドして、元の縁は描画せずにその幅の線で独自に円を描画する
    - `contains`で使用した図形を利用

<!-- dummy comment line for breaking list -->

- - - -
ボタンの揃えを変更するために、`JPanel`ではなく、`Box`を利用しているので、`JDK 5`でも`JDK 6`と同じように描画するために、`Box#paintComponent`を以下のようにオーバーライドしています。
- [Bug ID: 4907674 Box disregards setBackground() even when set Opaque(true)](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4907674)

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTSRb592NI/AAAAAAAAAig/4HrfRUSkPxc/s800/RoundImageButton1.png)

<pre class="prettyprint"><code>private final Box box = // JDK 6 Box.createHorizontalBox();
  // JDK 5
  new Box(BoxLayout.X_AXIS) {
    protected void paintComponent(Graphics g) {
      if(ui != null) {
        super.paintComponent(g);
      }else if(isOpaque()) {
        g.setColor(getBackground());
        g.fillRect(0, 0, getWidth(), getHeight());
      }
    }
  };
</code></pre>

### 参考リンク
- [アクア風の球体の描き方（GIMPチュートリアル) > ロゴ・ボタン | GIMP思い込みチュートリアル（GIMPの使い方）](http://gimp.blog.shinobi.jp/Entry/18/)
- [JButtonの形を変更](http://terai.xrea.jp/Swing/RoundButton.html)
- [JComponentの形状定義を変更する](http://terai.xrea.jp/Swing/MoveNonRectangularImage.html)

<!-- dummy comment line for breaking list -->

### コメント

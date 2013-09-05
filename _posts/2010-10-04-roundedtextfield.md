---
layout: post
title: JTextFieldの角を丸める
category: swing
folder: RoundedTextField
tags: [JTextField, Border, Shape]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-10-04

## JTextFieldの角を丸める
角丸の`JTextField`を作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.ggpht.com/_9Z4BYR88imo/TQTSMYm3vgI/AAAAAAAAAiY/37FVcZLSXI0/s800/RoundedTextField.png)

### サンプルコード
<pre class="prettyprint"><code>JTextField textField01 = new JTextField(20) {
  //Unleash Your Creativity with Swing and the Java 2D API!
  //http://java.sun.com/products/jfc/tsc/articles/swing2d/index.html
  @Override protected void paintComponent(Graphics g) {
    if(!isOpaque()) {
      int w = getWidth();
      int h = getHeight();
      Graphics2D g2 = (Graphics2D)g.create();
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                          RenderingHints.VALUE_ANTIALIAS_ON);
      g2.setColor(UIManager.getColor("TextField.background"));
      g2.fillRoundRect(0, 0, w-1, h-1, h, h);
      g2.setColor(Color.GRAY);
      g2.drawRoundRect(0, 0, w-1, h-1, h, h);
      g2.dispose();
    }
    super.paintComponent(g);
  }
};
textField01.setOpaque(false);
textField01.setBackground(new Color(0,0,0,0)); //Nimbus
textField01.setBorder(BorderFactory.createEmptyBorder(4, 8, 4, 8));
textField01.setText("aaaaaaaaaaa");
</code></pre>

### 解説
- 上
    - `JTextField#paintComponent(...)`をオーバーライド、`BorderをEmptyBorder`、`JTextField#setOpaque(false);`
    - 参考: [Unleash Your Creativity with Swing and the Java 2D API!](http://java.sun.com/products/jfc/tsc/articles/swing2d/index.html)

<!-- dummy comment line for breaking list -->

- 下
    - `RoundedCornerBorder`を設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class RoundedCornerBorder extends AbstractBorder {
  @Override public void paintBorder(Component c, Graphics g, int x, int y, int width, int height) {
    Graphics2D g2 = (Graphics2D)g.create();
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    int r = height-1;
    RoundRectangle2D round = new RoundRectangle2D.Float(x, y, width-1, height-1, r, r);
    Container parent = c.getParent();
    if(parent!=null) {
      g2.setColor(parent.getBackground());
      Area corner = new Area(new Rectangle2D.Float(x, y, width, height));
      corner.subtract(new Area(round));
      g2.fill(corner);
    }
    g2.setColor(Color.GRAY);
    g2.draw(round);
    g2.dispose();
  }
  @Override public Insets getBorderInsets(Component c) {
    return new Insets(4, 8, 4, 8);
  }
  @Override public Insets getBorderInsets(Component c, Insets insets) {
    insets.left = insets.right = 8;
    insets.top = insets.bottom = 4;
    return insets;
  }
}
</code></pre>

### 参考リンク
- [Unleash Your Creativity with Swing and the Java 2D API!](http://java.sun.com/products/jfc/tsc/articles/swing2d/index.html)
- [Border on an rounded JTextField? (Swing / AWT / SWT / JFace forum at JavaRanch)](http://www.coderanch.com/t/336048/GUI/java/Border-rounded-JTextField)
- [java - how i remove unneeded background under roundedborder? - Stack Overflow](http://stackoverflow.com/questions/9785911/how-i-remove-unneeded-background-under-roundedborder)

<!-- dummy comment line for breaking list -->

### コメント
- `TextUI#paintSafely(...)`をオーバーライドして、`JTextField`内を上書きする方法はやめて、`Area#subtract`で切り抜いた図形を親の背景色で描画する方法に変更。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-03-21 (水) 02:37:10

<!-- dummy comment line for breaking list -->

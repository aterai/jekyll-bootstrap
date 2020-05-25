---
layout: post
category: swing
folder: RoundedComboBox
title: JComboBoxの角を丸める
tags: [JComboBox, Border, Path2D, ArrowButton]
author: aterai
pubdate: 2012-04-23T11:59:28+09:00
description: JComboBoxの左上、右上の角を丸めるBorderを設定します。
image: https://lh6.googleusercontent.com/-0VloXBzelwQ/T5TD3KZRIzI/AAAAAAAABLs/siwBGiic6Tw/s800/RoundedComboBox.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2012/07/rounded-corner-jcombobox-border.html
    lang: en
comments: true
---
## 概要
`JComboBox`の左上、右上の角を丸める`Border`を設定します。

{% download https://lh6.googleusercontent.com/-0VloXBzelwQ/T5TD3KZRIzI/AAAAAAAABLs/siwBGiic6Tw/s800/RoundedComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>class RoundedCornerBorder extends AbstractBorder {
  @Override public void paintBorder(
      Component c, Graphics g, int x, int y, int width, int height) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    int r = 12;
    int w = width  - 1;
    int h = height - 1;
    Area round = new Area(new RoundRectangle2D.Float(x, y, w, h, r, r));
    Container parent = c.getParent();
    if (parent != null) {
      g2.setColor(parent.getBackground());
      Area corner = new Area(new Rectangle2D.Float(x, y, width, height));
      corner.subtract(round);
      g2.fill(corner);
    }
    g2.setPaint(c.getForeground());
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

class KamabokoBorder extends RoundedCornerBorder {
  @Override public void paintBorder(
      Component c, Graphics g, int x, int y, int width, int height) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    int r = 12;
    int w = width  - 1;
    int h = height - 1;
    Path2D p = new Path2D.Float();
    p.moveTo(x, y + h);
    p.lineTo(x, y + r);
    p.quadTo(x, y, x + r, y);
    p.lineTo(x + w - r, y);
    p.quadTo(x + w, y, x + w, y + r);
    p.lineTo(x + w, y + h);
    p.closePath();
    Area round = new Area(p);
    Container parent = c.getParent();
    if (parent != null) {
      g2.setColor(parent.getBackground());
      Area corner = new Area(new Rectangle2D.Float(x, y, width, height));
      corner.subtract(round);
      g2.fill(corner);
    }
    g2.setPaint(c.getForeground());
    g2.draw(round);
    g2.dispose();
  }
}
</code></pre>

## 解説
上記のサンプルでは、`Path2D#lineTo(...)`、`Path2D#quadTo(...)`メソッドを使用してかまぼこ型の図形を作成し、`JComboBox`の`Border`として設定しています。

- 上: `MetalComboBoxUI`
    - `BasicComboBoxUI`を設定
- 中: `BasicComboBoxUI`
    - `RoundRectangle2D`に、下の角を上書きするような矩形を追加して作成
    - `UIManager.put("ComboBox.foreground", color)`などで、`JComboBox`の色を変更しているが、`ArrowButton`の色がうまく変更できない
    - [JComboBoxのBorderを変更する](https://ateraimemo.com/Swing/ComboBoxBorder.html)
- 下: `BasicComboBoxUI#createArrowButton()`
    - `BasicComboBoxUI#createArrowButton()`をオーバーライドして、`ArrowButton`の背景色などを変更

<!-- dummy comment line for breaking list -->

- - - -
- 上記の方法で角丸の`JComboBox`が作成可能なのは、`BasicLookAndFeel`と`WindowsLookAndFeel`のみ？
- 以下のような方法でも、かまぼこ型の図形を作成可能
    
    <pre class="prettyprint"><code>Area round = new Area(
        new RoundRectangle2D.Float(x, y, width - 1, height - 1, r, r));
    Rectangle b = round.getBounds();
    b.setBounds(b.x, b.y + r, b.width, b.height - r);
    round.add(new Area(b));
</code></pre>
- * 参考リンク [#reference]
- [JComboBoxのBorderを変更する](https://ateraimemo.com/Swing/ComboBoxBorder.html)
- [JTextFieldの角を丸める](https://ateraimemo.com/Swing/RoundedTextField.html)

<!-- dummy comment line for breaking list -->

## コメント
- 編集可不可の切り替えと、`WindowsLookAndFeel`に適用したサンプルを追加 -- *aterai* 2012-06-30 (土) 04:07:30

<!-- dummy comment line for breaking list -->

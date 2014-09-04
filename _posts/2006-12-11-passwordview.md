---
layout: post
title: JPasswordFieldのエコー文字を変更
category: swing
folder: PasswordView
tags: [JPasswordField, Icon]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-12-11

## 概要
`JPasswordField`のエコー文字を独自の図形に変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQ8cs8ApI/AAAAAAAAAgY/gxUUdKI65yA/s800/PasswordView.png %}

## サンプルコード
<pre class="prettyprint"><code>class MyPasswordFieldUI extends BasicPasswordFieldUI {
  public View create(Element elem) {
    return new MyPasswordView(elem);
  }
  class MyPasswordView extends PasswordView{
    public MyPasswordView(Element element) {
      super(element);
    }
    @Override protected int drawEchoCharacter(Graphics g, int x, int y, char c) {
      Graphics2D g2d = (Graphics2D) g;
      FontMetrics fm = g2d.getFontMetrics();
      icon.paintIcon(null, g, x, y-fm.getAscent());
      return x + icon.getIconWidth();

      //g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
      //                                    RenderingHints.VALUE_ANTIALIAS_ON);
      //FontMetrics fm = g2d.getFontMetrics();
      //int r = fm.charWidth(c)-4;
      ////g2d.setPaint(Color.GRAY);
      //g2d.drawRect(x+2, y+4-fm.getAscent(), r, r);
      ////g2d.setPaint(Color.GRAY.brighter());
      //g2d.fillOval(x+2, y+4-fm.getAscent(), r, r);
      //return x + fm.charWidth(c);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、下の`JPasswordField`のエコー文字を独自の図形に変更しています。またこの図形のサイズを上の`JPasswordField`のエコー文字と幅を合わせるために同じ文字を`setEchoChar`しています。

## コメント

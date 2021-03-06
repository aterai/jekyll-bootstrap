---
layout: post
category: swing
folder: PasswordView
title: JPasswordFieldのエコー文字を変更
tags: [JPasswordField, Icon]
author: aterai
pubdate: 2006-12-11T14:51:59+09:00
description: JPasswordFieldのエコー文字を独自のIcon図形に変更します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQ8cs8ApI/AAAAAAAAAgY/gxUUdKI65yA/s800/PasswordView.png
comments: true
---
## 概要
`JPasswordField`のエコー文字を独自の`Icon`図形に変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQ8cs8ApI/AAAAAAAAAgY/gxUUdKI65yA/s800/PasswordView.png %}

## サンプルコード
<pre class="prettyprint"><code>class MyPasswordFieldUI extends BasicPasswordFieldUI {
  private static final StarIcon ICON = new StarIcon();
  public static MyPasswordFieldUI createUI(JPasswordField c) {
    c.setEchoChar('\u25A0'); //As wide as a CJK character cell (fullwidth)
    return new MyPasswordFieldUI();
  }

  @Override public View create(Element elem) {
    return new MyPasswordView(elem);
  }

  private static class MyPasswordView extends PasswordView {
    @Override protected int drawEchoCharacter(Graphics g, int x, int y, char c) {
      FontMetrics fm = g.getFontMetrics();
      ICON.paintIcon(null, g, x, y - fm.getAscent());
      return x + ICON.getIconWidth(); //fm.charWidth(c);
    }

    public MyPasswordView(Element element) {
      super(element);
    }
  }
}
</code></pre>

## 解説
- 上: `setEchoChar('\u2605')`
    - `JPasswordField#setEchoChar(...)`メソッドで任意の文字をエコー文字に設定
- 下: `drawEchoCharacter`
    - `PasswordView#drawEchoCharacter(...)`をオーバーライドして任意の図形をエコー文字として描画する`BasicPasswordFieldUI`を作成し、`JPasswordField`に設定
    - 上の`JPasswordField`のエコー文字と同じ文字を`setEchoChar`で設定し、図形のサイズを合わせる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JPasswordFieldでパスワードを可視化する](https://ateraimemo.com/Swing/ShowHidePasswordField.html)

<!-- dummy comment line for breaking list -->

## コメント

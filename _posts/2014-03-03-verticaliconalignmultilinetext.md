---
layout: post
category: swing
folder: VerticalIconAlignMultilineText
title: JCheckBoxのチェックアイコンを一行目中央に配置する
tags: [JCheckBox, Html, Icon]
author: aterai
pubdate: 2014-03-03T00:16:40+09:00
description: JCheckBoxのテキストが複数行の場合、チェックアイコンが一行目中央に配置されるよう設定します。
image: https://lh4.googleusercontent.com/-xEdb1NQpk3A/UxNGwOHM8dI/AAAAAAAACBE/GDPtPjFUuJs/s800/VerticalIconAlignMultilineText.png
comments: true
---
## 概要
`JCheckBox`のテキストが複数行の場合、チェックアイコンが一行目中央に配置されるよう設定します。

{% download https://lh4.googleusercontent.com/-xEdb1NQpk3A/UxNGwOHM8dI/AAAAAAAACBE/GDPtPjFUuJs/s800/VerticalIconAlignMultilineText.png %}

## サンプルコード
<pre class="prettyprint"><code>class WindowsVerticalAlignmentCheckBoxUI extends WindowsCheckBoxUI {
  @Override public synchronized void paint(Graphics g, JComponent c) {
    AbstractButton b = (AbstractButton) c;
    // ...
    // Paint the radio button
    int y = HtmlViewUtil.getFirstLineCenterY(text, b, iconRect);
    getDefaultIcon().paintIcon(c, g, iconRect.x, iconRect.y + y);
    // ...
  }

  public static int getFirstLineCenterY(String text, AbstractButton c, Rectangle iconRect) {
    int y = 0;
    if (text != null &amp;&amp; c.getVerticalTextPosition() == SwingConstants.TOP) {
      View v = (View) c.getClientProperty(BasicHTML.propertyKey);
      if (v != null) {
        try {
          Element e = v.getElement().getElement(0);
          Shape s = new Rectangle();
          Position.Bias b = Position.Bias.Forward;
          s = v.modelToView(e.getStartOffset(), b, e.getEndOffset(), b, s);
          // System.out.println("v.h: " + s.getBounds());
          y = (int) (.5 + Math.abs(s.getBounds().height - iconRect.height) * .5);
        } catch (BadLocationException ex) {
          ex.printStackTrace();
        }
      }
    }
    return y;
  }
}
</code></pre>

## 解説
- 左: `SwingConstants.TOP`
    - `JCheckBox#setVerticalTextPosition(SwingConstants.TOP)`を設定してチェックアイコンとテキストの上辺が揃うように設定
    - `JCheckBox`のフォントサイズが大きくなると、チェックアイコンが上にずれてしまう
- 右: `First line center`
    - `WindowsCheckBoxUI#paint(...)`などをオーバーライドし一行目の中央にチェックアイコンの中心が揃うように設定
    - `<html>aa<font size="+5">bb</font>cc...</html>`のような一部の文字サイズを大きくしたテキストを設定しても行の中央に揃えることが可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - JCheckBox: Vertical alignment for multi-line text - Stack Overflow](https://stackoverflow.com/questions/22121439/jcheckbox-vertical-alignment-for-multi-line-text)

<!-- dummy comment line for breaking list -->

## コメント

---
layout: post
category: swing
folder: ParticularyNonEditableSpinner
title: JSpinnerのテキストフィールド内に選択不可の文字を追加する
tags: [JSpinner, Border]
author: aterai
pubdate: 2010-01-04T15:04:02+09:00
description: JSpinnerのテキストフィールド内に選択や編集ができない文字列を追加します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQ5w9QfII/AAAAAAAAAgU/iBrVcxeaFS4/s800/ParticularyNonEditableSpinner.png
comments: true
---
## 概要
`JSpinner`のテキストフィールド内に選択や編集ができない文字列を追加します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQ5w9QfII/AAAAAAAAAgU/iBrVcxeaFS4/s800/ParticularyNonEditableSpinner.png %}

## サンプルコード
<pre class="prettyprint"><code>class StringBorder implements Border {
  private final JComponent parent;
  private final Insets insets;
  private final Rectangle rect;
  private final String str;
  public StringBorder(JComponent parent, String str) {
    this.parent = parent;
    this.str = str;
    FontRenderContext frc = new FontRenderContext(null, true, true);
    rect = parent.getFont().getStringBounds(str, frc).getBounds();
    insets = new Insets(0, 0, 0, rect.width);
  }
  @Override public Insets getBorderInsets(Component c) {
    return insets;
  }
  @Override public boolean isBorderOpaque() {
    return false;
  }
  @Override public void paintBorder(
      Component c, Graphics g, int x, int y, int width, int height) {
    Graphics2D g2 = (Graphics2D) g;
    float tx = x + width - rect.width;
    float ty = y - rect.y + (height - rect.height) / 2;
    //g2.setPaint(Color.RED);
    g2.drawString(str, tx, ty);
  }
}
</code></pre>

## 解説
- 上: `JSpinner.NumberEditor` + `DecimalFormat`
    - [JSpinnerの値をパーセントで指定](http://ateraimemo.com/Swing/NumberEditor.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JSpinner spinner1 = new JSpinner(new SpinnerNumberModel(0, 0, 1, 0.01));
JSpinner.NumberEditor editor1 = new JSpinner.NumberEditor(spinner1, "0%");
spinner1.setEditor(editor1);
</code></pre>

- 下: `JSpinner` + `StringBorder`
    - `JSpinner`のエディタに設定した余白内に文字列を描画

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JSpinner spinner2 = new JSpinner(new SpinnerNumberModel(0, 0, 100, 1));
JSpinner.NumberEditor editor2 = new JSpinner.NumberEditor(spinner2);
spinner2.setEditor(editor2);
editor2.setOpaque(true);
editor2.setBackground(Color.WHITE);
//Border b = new StringBorder(editor2, "percent");
Border b = new StringBorder(editor2, "%");
Border c = editor2.getBorder();
editor2.setBorder((c == null) ? b : BorderFactory.createCompoundBorder(c, b));
</code></pre>

- - - -
以下のように、[Component Border ≪ Java Tips Weblog](http://tips4java.wordpress.com/2009/09/27/component-border/)を利用して、`JLabel`を余白に描画する方法もあります。

<pre class="prettyprint"><code>JLabel label = new JLabel("%");
label.setBorder(BorderFactory.createEmptyBorder());
label.setOpaque(true);
label.setBackground(Color.WHITE);
ComponentBorder cb = new ComponentBorder(label);
cb.setGap(0);
cb.install(editor2);
</code></pre>

## 参考リンク
- [JSpinnerの値をパーセントで指定](http://ateraimemo.com/Swing/NumberEditor.html)
- [Component Border ≪ Java Tips Weblog](http://tips4java.wordpress.com/2009/09/27/component-border/)

<!-- dummy comment line for breaking list -->

## コメント
- `1.7.0`以上でないとコンパイルできなかったのを修正。 -- *aterai* 2012-10-15 (月) 18:30:23

<!-- dummy comment line for breaking list -->

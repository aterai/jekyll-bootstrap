---
layout: post
category: swing
folder: IconTextField
title: JTextField内にアイコンを追加
tags: [JTextField, ImageIcon, JLabel, Border]
author: aterai
pubdate: 2005-01-03T02:14:18+09:00
description: JTextFieldの内部に余白を生成し、そこにImageIconを設定したJLabelを配置します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTOSatpfJI/AAAAAAAAAcI/9Ghfvb82FsM/s800/IconTextField.png
comments: true
---
## 概要
`JTextField`の内部に余白を生成し、そこに`ImageIcon`を設定した`JLabel`を配置します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTOSatpfJI/AAAAAAAAAcI/9Ghfvb82FsM/s800/IconTextField.png %}

## サンプルコード
<pre class="prettyprint"><code>ImageIcon image = new ImageIcon(getClass().getResource("16x16.png"));
int w = image.getIconWidth();
int h = image.getIconHeight();

JTextField field = new JTextField("bbbbbbbbbb");
Insets m = field.getMargin();
field.setMargin(new Insets(m.top, m.left + w, m.bottom, m.right));

JLabel label = new JLabel(image);
label.setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
label.setBorder(null);
label.setBounds(m.left, m.top, w, h);

field.add(label);
</code></pre>

## 解説
サンプルでは`setMargin`で`JTextField`の左に余白を作り、そこに`JLabel`を配置することでアイコン(画像)を表示しています。

[JComboBoxにアイコンを追加](http://ateraimemo.com/Swing/IconComboBox.html)のように、`Border`を使っても同様のことができますが、`JTextComponent`を継承したコンポーネントでは、`setMargin`を使用するとカーソルの指定などが簡単に実現できます。

また、`JLabel`の代わりに、`JButton`などのコンポーネントを配置することも可能です。

- - - -
- メモ
    - `JComboBox`の`Editor`を取得して`Margin`を指定しても、反映されない
    - [JTextComponent#setMargin(Insets) (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/text/JTextComponent.html#setMargin%28java.awt.Insets%29)
        - via: [java - JTextField margin doesnt work with border - Stack Overflow](https://stackoverflow.com/questions/10496828/jtextfield-margin-doesnt-work-with-border)

<!-- dummy comment line for breaking list -->

<blockquote><p>
 ただし、デフォルト以外の境界が設定されている場合は、`Border`オブジェクトが適切なマージン空白を作成します(それ以外の場合、このプロパティーは事実上無視される)。
</p></blockquote>

- - - -
`JTextField`の右端に`JLabel`を置く場合は、以下のように`SpringLayout`を使用する方法があります。

- [JButtonなどの高さを変更せずに幅を指定](http://ateraimemo.com/Swing/ButtonWidth.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>final JLabel label2 = new JLabel(image);
label2.setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
label2.setBorder(BorderFactory.createEmptyBorder());
JTextField field2 = new JTextField("ccccccccccccccccccccccccccc") {
  @Override public void updateUI() {
    super.updateUI();
    removeAll();
    SpringLayout l = new SpringLayout();
    setLayout(l);
    Spring fw = l.getConstraint(SpringLayout.WIDTH,  this);
    Spring fh = l.getConstraint(SpringLayout.HEIGHT, this);
    SpringLayout.Constraints c = l.getConstraints(label2);
    c.setConstraint(SpringLayout.WEST,  fw);
    c.setConstraint(SpringLayout.SOUTH, fh);
    add(label2);
  }
};
m = field2.getMargin();
field2.setMargin(new Insets(m.top + 2, m.left, m.bottom, m.right + w));
</code></pre>

## 参考リンク
- [Swing (Archive) - Add a clickable icon to the left corner of a JTextField](https://community.oracle.com/thread/1489851)
- [JTextFieldのMarginを設定する](http://ateraimemo.com/Swing/TextFieldMargin.html)
- [JComboBoxにアイコンを追加](http://ateraimemo.com/Swing/IconComboBox.html)

<!-- dummy comment line for breaking list -->

## コメント

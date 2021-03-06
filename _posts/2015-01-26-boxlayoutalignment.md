---
layout: post
category: swing
folder: BoxLayoutAlignment
title: BoxLayoutでJLabelの中央揃えをテストする
tags: [BoxLayout, JLabel]
author: aterai
pubdate: 2015-01-26T00:15:23+09:00
description: BoxLayoutを設定したJPanelに、最小サイズを設定したJLabelを中央揃えで配置するテストを行います。
image: https://lh3.googleusercontent.com/-OKh2kmuDUus/VMUE-LLN_NI/AAAAAAAANvk/FtPEqk8f820/s800/BoxLayoutAlignment.png
comments: true
---
## 概要
`BoxLayout`を設定した`JPanel`に、最小サイズを設定した`JLabel`を中央揃えで配置するテストを行います。

{% download https://lh3.googleusercontent.com/-OKh2kmuDUus/VMUE-LLN_NI/AAAAAAAANvk/FtPEqk8f820/s800/BoxLayoutAlignment.png %}

## サンプルコード
<pre class="prettyprint"><code>JLabel l2 = new JLabel("abc") {
  @Override public Dimension getPreferredSize() {
    return new Dimension(50, 50);
  }

  @Override public Dimension getMinimumSize() {
    Dimension d = super.getMinimumSize();
    if (Objects.nonNull(d)) {
      int i = ((Integer) spinner.getValue()).intValue();
      d.setSize(i, i);
    }
    return d;
  }
};
l2.setOpaque(true);
l2.setBackground(Color.ORANGE);
l2.setFont(l.getFont().deriveFont(Font.PLAIN));
l2.setAlignmentX(Component.CENTER_ALIGNMENT);
l2.setAlignmentY(Component.CENTER_ALIGNMENT);
l2.setVerticalAlignment(SwingConstants.CENTER);
l2.setVerticalTextPosition(SwingConstants.CENTER);
l2.setHorizontalAlignment(SwingConstants.CENTER);
l2.setHorizontalTextPosition(SwingConstants.CENTER);

JPanel p2 = new TestPanel();
p2.setLayout(new BoxLayout(p2, BoxLayout.Y_AXIS));
p2.add(Box.createVerticalGlue());
p2.add(l2);
p2.add(Box.createVerticalGlue());
</code></pre>

## 解説
上記のサンプルは、[swing - Alignment of Single Characters in Java BoxLayout on Y-Axis Is Off-Center - Stack Overflow](https://stackoverflow.com/questions/27790417/alignment-of-single-characters-in-java-boxlayout-on-y-axis-is-off-center)を参考にして、`BoxLayout`の中央揃えのバグ？を検証するために作成しています。

- `setAlignmentX(Component.CENTER_ALIGNMENT)`、`setAlignmentY(Component.CENTER_ALIGNMENT)`を設定した`JLabel`を作成
- `BoxLayout.X_AXIS`の`Box`に、この`JLabel`が左右中央に配置されるよう、`Box.createHorizontalGlue()`で挟んで追加
- `BoxLayout.Y_AXIS`の`Box`に、この`JLabel`が上下中央に配置されるよう、`Box.createVerticalGlue()`で挟んで追加
- `JLabel#getMinimumSize()`の返す値を`JSpinner`で変更すると、値が奇数になる場合で揃えがずれてしまう

<!-- dummy comment line for breaking list -->

- - - -
- [JDK-8068374 setAlignmentX, setAlignmentY, getAlignmentX, getAlignmentY javadoc of JComponent - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8068374)
    - via: [OpenJDK Swing Development - <Swing Dev> 8u Typos in JComponent#setAlignment methods](http://openjdk.5641.n7.nabble.com/lt-Swing-Dev-gt-8u-Typos-in-JComponent-setAlignment-methods-td295805.html)
    - https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JComponent.html#setAlignmentY-float-
    - 「水平の配置方法を設定します。」はドキュメントの間違いで、実際の動作は「垂直の配置方法を設定します。」
    - `setAlignmentX`、`getAlignmentX`、`getAlignmentY`も同様に逆の説明になっている
    - `java 9`のドキュメントは修正済み

<!-- dummy comment line for breaking list -->

## 参考リンク
- [How to Use BoxLayout (The Java™ Tutorials > Creating a GUI With JFC/Swing > Laying Out Components Within a Container)](https://docs.oracle.com/javase/tutorial/uiswing/layout/box.html)
- [swing - Alignment of Single Characters in Java BoxLayout on Y-Axis Is Off-Center - Stack Overflow](https://stackoverflow.com/questions/27790417/alignment-of-single-characters-in-java-boxlayout-on-y-axis-is-off-center)

<!-- dummy comment line for breaking list -->

## コメント

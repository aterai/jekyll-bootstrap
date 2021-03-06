---
layout: post
category: swing
folder: IntercellSpacing
title: JTableの罫線の有無とセルの内余白を変更
tags: [JTable]
author: aterai
pubdate: 2011-05-30T16:37:49+09:00
description: JTableの罫線の表示非表示とセルの内余白を変更します。
image: https://lh3.googleusercontent.com/-zDg_KUxGwU4/TeNHkhhJYGI/AAAAAAAAA8M/G5R8rKLVzUg/s800/IntercellSpacing.png
comments: true
---
## 概要
`JTable`の罫線の表示非表示とセルの内余白を変更します。

{% download https://lh3.googleusercontent.com/-zDg_KUxGwU4/TeNHkhhJYGI/AAAAAAAAA8M/G5R8rKLVzUg/s800/IntercellSpacing.png %}

## サンプルコード
<pre class="prettyprint"><code>add(new JCheckBox(new AbstractAction("setShowVerticalLines") {
  @Override public void actionPerformed(ActionEvent e) {
    Dimension d = table.getIntercellSpacing();
    if (((JCheckBox) e.getSource()).isSelected()) {
      table.setShowVerticalLines(true);
      table.setIntercellSpacing(new Dimension(1, d.height));
    } else {
      table.setShowVerticalLines(false);
      table.setIntercellSpacing(new Dimension(0, d.height));
    }
  }
}));
add(new JCheckBox(new AbstractAction("setShowHorizontalLines") {
  @Override public void actionPerformed(ActionEvent e) {
    Dimension d = table.getIntercellSpacing();
    if (((JCheckBox) e.getSource()).isSelected()) {
      table.setShowHorizontalLines(true);
      table.setIntercellSpacing(new Dimension(d.width, 1));
    } else {
      table.setShowHorizontalLines(false);
      table.setIntercellSpacing(new Dimension(d.width, 0));
    }
  }
}));
</code></pre>

## 解説
`JTable`の罫線を非表示にしてもセルの内余白が`0`でない場合、セル選択でその内余白分の塗り残しが発生し、セルが分割されているような表示になります。上記のサンプルでは、`JTable#setShowVerticalLines(boolean)`メソッドなどと合わせて`JTable#setIntercellSpacing(Dimension)`メソッドを使用しセルの内余白を`0`に切り替えています。

- 罫線の設定
    - `JTable#setShowVerticalLines(boolean);`
    - `JTable#setShowHorizontalLines(boolean);`
- セル内余白の設定
    - `JTable#setIntercellSpacing(Dimension intercellSpacing);`
        - `JTable#setRowMargin(intercellSpacing.height);`
        - `JTable#getColumnModel().setColumnMargin(intercellSpacing.width);`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTable#setShowVerticalLines(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#setShowVerticalLines-boolean-)
- [JTable#setShowHorizontalLines(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#setShowHorizontalLines-boolean-)
- [JTable#setIntercellSpacing(Dimension) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#setIntercellSpacing-java.awt.Dimension-)

<!-- dummy comment line for breaking list -->

## コメント

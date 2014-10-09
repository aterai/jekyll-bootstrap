---
layout: post
category: swing
folder: ButtonPainted
title: JButtonの描画
tags: [JButton, Focus, Icon]
author: aterai
pubdate: 2009-08-24T12:58:07+09:00
description: JButtonの状態描画をテストします。
comments: true
---
## 概要
`JButton`の状態描画をテストします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTIWYXt9eI/AAAAAAAAASo/se2OKkQA83U/s800/ButtonPainted.png %}

## サンプルコード
<pre class="prettyprint"><code>java.util.List&lt;JCheckBox&gt; clist = Arrays.asList(
  new JCheckBox(new AbstractAction("setFocusPainted") {
    @Override public void actionPerformed(ActionEvent e) {
      boolean flg = ((JCheckBox)e.getSource()).isSelected();
      for(JButton b:list) b.setFocusPainted(flg);
      p.revalidate();
    }
  }),
  new JCheckBox(new AbstractAction("setBorderPainted") {
    @Override public void actionPerformed(ActionEvent e) {
      boolean flg = ((JCheckBox)e.getSource()).isSelected();
      for(JButton b:list) b.setBorderPainted(flg);
      p.revalidate();
    }
  }),
  new JCheckBox(new AbstractAction("setContentAreaFilled") {
    @Override public void actionPerformed(ActionEvent e) {
      boolean flg = ((JCheckBox)e.getSource()).isSelected();
      for(JButton b:list) b.setContentAreaFilled(flg);
      p.revalidate();
    }
  }),
  new JCheckBox(new AbstractAction("setRolloverEnabled") {
    @Override public void actionPerformed(ActionEvent e) {
      boolean flg = ((JCheckBox)e.getSource()).isSelected();
      for(JButton b:list) b.setRolloverEnabled(flg);
      p.revalidate();
    }
  })
);
</code></pre>

## 解説
上記のサンプルでは、`JButton`の状態(例えばフォーカスの有無を描画するか？など)をテストします。これらは`Look & Feel`によって効果が異なる場合があるようです。

- [setFocusPainted](http://docs.oracle.com/javase/jp/6/api/javax/swing/AbstractButton.html#setFocusPainted%28boolean%29)
- [setBorderPainted](http://docs.oracle.com/javase/jp/6/api/javax/swing/AbstractButton.html#setBorderPainted%28boolean%29)
- [setContentAreaFilled](http://docs.oracle.com/javase/jp/6/api/javax/swing/AbstractButton.html#setContentAreaFilled%28boolean%29)
- [setRolloverEnabled](http://docs.oracle.com/javase/jp/6/api/javax/swing/AbstractButton.html#setRolloverEnabled%28boolean%29)

<!-- dummy comment line for breaking list -->

## コメント

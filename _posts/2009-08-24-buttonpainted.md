---
layout: post
category: swing
folder: ButtonPainted
title: JButtonの描画
tags: [JButton, Focus, Icon]
author: aterai
pubdate: 2009-08-24T12:58:07+09:00
description: JButtonの設定を変更し、コンテンツ領域、フチ、フォーカスやロールオーバー状態がどう描画されるかをテストします。
comments: true
---
## 概要
`JButton`の設定を変更し、コンテンツ領域、フチ、フォーカスやロールオーバー状態がどう描画されるかをテストします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTIWYXt9eI/AAAAAAAAASo/se2OKkQA83U/s800/ButtonPainted.png %}

## サンプルコード
<pre class="prettyprint"><code>List&lt;JCheckBox&gt; clist = Arrays.asList(
  new JCheckBox(new AbstractAction("setFocusPainted") {
    @Override public void actionPerformed(ActionEvent e) {
      boolean flg = ((JCheckBox) e.getSource()).isSelected();
      for (JButton b: list) {
        b.setFocusPainted(flg);
      }
      p.revalidate();
    }
  }),
  new JCheckBox(new AbstractAction("setBorderPainted") {
    @Override public void actionPerformed(ActionEvent e) {
      boolean flg = ((JCheckBox) e.getSource()).isSelected();
      for (JButton b: list) {
        b.setBorderPainted(flg);
      }
      p.revalidate();
    }
  }),
  new JCheckBox(new AbstractAction("setContentAreaFilled") {
    @Override public void actionPerformed(ActionEvent e) {
      boolean flg = ((JCheckBox) e.getSource()).isSelected();
      for (JButton b: list) {
        b.setContentAreaFilled(flg);
      }
      p.revalidate();
    }
  }),
  new JCheckBox(new AbstractAction("setRolloverEnabled") {
    @Override public void actionPerformed(ActionEvent e) {
      boolean flg = ((JCheckBox) e.getSource()).isSelected();
      for (JButton b: list) {
        b.setRolloverEnabled(flg);
      }
      p.revalidate();
    }
  })
);
</code></pre>

## 解説
上記のサンプルでは、`JButton`の状態(例えばフォーカスの有無を描画するか？など)をテストします。これらは`Look & Feel`によって効果が異なる場合があります。

- [setFocusPainted](https://docs.oracle.com/javase/jp/8/api/javax/swing/AbstractButton.html#setFocusPainted-boolean-)
    - フォーカス状態を描画するか？
- [setBorderPainted](https://docs.oracle.com/javase/jp/8/api/javax/swing/AbstractButton.html#setBorderPainted-boolean-)
    - ボーダー(フチの装飾)を描画するか？
- [setContentAreaFilled](https://docs.oracle.com/javase/jp/8/api/javax/swing/AbstractButton.html#setContentAreaFilled-boolean-)
    - ボタンのコンテンツ領域(ボタンのテキストやアイコン以外の領域)を描画するか？
- [setRolloverEnabled](https://docs.oracle.com/javase/jp/8/api/javax/swing/AbstractButton.html#setRolloverEnabled-boolean-)
    - ロールオーバー効果を描画するか？

<!-- dummy comment line for breaking list -->

## コメント

---
layout: post
category: swing
folder: ProgressStringLayer
title: JProgressBarの文字列をJLayerを使って表示する
tags: [JProgressBar, JLayer]
author: aterai
pubdate: 2013-06-10T03:42:45+09:00
description: 垂直JProgressBarの文字列をJLayerを使って横組で表示します。
image: https://lh4.googleusercontent.com/-ATDPf7XMEzg/UbTLqsulmsI/AAAAAAAABt0/_0ZOg11jmXk/s800/ProgressStringLayer.png
comments: true
---
## 概要
垂直`JProgressBar`の文字列を`JLayer`を使って横組で表示します。

{% download https://lh4.googleusercontent.com/-ATDPf7XMEzg/UbTLqsulmsI/AAAAAAAABt0/_0ZOg11jmXk/s800/ProgressStringLayer.png %}

## サンプルコード
<pre class="prettyprint"><code>final JLabel label = new JLabel("000/100");
label.setBorder(BorderFactory.createEmptyBorder(4, 4, 4, 4));
LayerUI&lt;JProgressBar&gt; layerUI = new LayerUI&lt;JProgressBar&gt;() {
  private final JPanel rubberStamp = new JPanel();
  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    Dimension d = label.getPreferredSize();
    int x = (c.getWidth()  - d.width)  / 2;
    int y = (c.getHeight() - d.height) / 2;
    JLayer jlayer = (JLayer) c;
    JProgressBar progress = (JProgressBar) jlayer.getView();
    int iv = (int) (100 * progress.getPercentComplete());
    label.setText(String.format("%03d/100", iv));
    //label.setText(progress.getString());
    SwingUtilities.paintComponent(
      g, label, rubberStamp, x, y, d.width, d.height);
  }
};
JProgressBar progressBar = new JProgressBar(model) {
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    Insets i = label.getInsets();
    d.width = label.getPreferredSize().width + i.left + i.right;
    return d;
  }
};
progressBar.setOrientation(SwingConstants.VERTICAL);
progressBar.setStringPainted(false);
JComponent c = new JLayer&lt;JProgressBar&gt;(progressBar, layerUI);
</code></pre>

## 解説
- `1`番左
    - デフォルトの垂直`JProgressBar`
- 左から`2`番目
    - 文字列表示有りの垂直`JProgressBar`
- 右から`2`番目
    - 垂直`JProgressBar`に`BorderLayout`を設定して、中央に`JLabel`を配置
    - [JProgressBarの進捗文字列の字揃えを変更する](https://ateraimemo.com/Swing/ProgressStringAlignment.html)
    - `JLabel`の幅と任意の余白から、垂直`JProgressBar`の幅を決定するよう、`JProgressBar#getPreferredSize()`をオーバーライド
- `1`番右
    - `JLayer`を使って、垂直`JProgressBar`上に文字列を描画
    - `JLabel`の幅と任意の余白から、垂直`JProgressBar`の幅を決定するよう、`JProgressBar#getPreferredSize()`をオーバーライド

<!-- dummy comment line for breaking list -->

- - - -
- 一部の`OpenJDK 8`環境で、デフォルト垂直`JProgressBar`の進捗文字列が`90°`回転しなくなった？

<!-- dummy comment line for breaking list -->


- `8.0.212-amzn`、`8.0.212.hs-adpt`などは、回転しないため文字が重なっている
- `8.0.212-zulu`、`11.0.3-amzn`などは以前とおなじように回転するが、文字にアンチエイリアスが強く掛かっている？
- [&#91;JDK-8204929&#93; Fonts with embedded bitmaps are not always rotated - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8204929)
    - `Windows 10 April 2018 Update`の日本語環境でフォント依存で発生する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - Is it possible to save text horizontal in vertical JProgressbar - Stack Overflow](https://stackoverflow.com/questions/16934009/is-it-possible-to-save-text-horizontal-in-vertical-jprogressbar)
- [JProgressBarの進捗文字列の字揃えを変更する](https://ateraimemo.com/Swing/ProgressStringAlignment.html)

<!-- dummy comment line for breaking list -->

## コメント

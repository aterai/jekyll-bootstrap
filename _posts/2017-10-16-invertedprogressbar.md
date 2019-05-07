---
layout: post
category: swing
folder: InvertedProgressBar
title: JProgressBarの進捗方向を右から左に変更する
tags: [JProgressBar]
author: aterai
pubdate: 2017-10-16T14:31:34+09:00
description: JProgressBarのインジケータが通常とは逆方向に増加するよう変更します。
image: https://drive.google.com/uc?id=1XzVC-95p_4o-iBXzUkOONJ1lHT6qmjImDQ
comments: true
---
## 概要
`JProgressBar`のインジケータが通常とは逆方向に増加するよう変更します。

{% download https://drive.google.com/uc?id=1XzVC-95p_4o-iBXzUkOONJ1lHT6qmjImDQ %}

## サンプルコード
<pre class="prettyprint"><code>JProgressBar progress = new JProgressBar(m);
progress.setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT);
// progress.setStringPainted(true);
// progress.setOrientation(SwingConstants.VERTICAL);
</code></pre>

## 解説
- `Orientation`: `SwingConstants.HORIZONTAL`
    - 水平スクロールバーの場合、`JProgressBar#setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT)`で右から左に進捗方向を変更可能
    - `JProgressBar`には[JSlider#setInverted(boolean)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JSlider.html#setInverted-boolean-)のようなメソッドは用意されていない
    - `JProgressBar#setStringPainted(true)`で進捗文字列を表示した場合、`JProgressBar#setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT)`に設定していても、`%100`ではなく`100%`と表示される
- `Orientation`: `SwingConstants.VERTICAL`
    - 左から`1`番目: デフォルトの垂直スクロールバー
    - 左から`2`番目: デフォルトの進捗文字列を表示した垂直スクロールバー
    - 左から`3`番目: `JProgressBar#setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT)`を設定した垂直スクロールバー
        - 上から下には進捗方向を変更不可で、この設定は無視される
    - 右から`2`番目: `JProgressBar#paintComponent(...)`をオーバーライドして表示を上下反転した垂直スクロールバー
        - 進捗文字列も上下反転してしまう
            
            <pre class="prettyprint"><code>JProgressBar progress7 = new JProgressBar(m) {
              @Override protected void paintComponent(Graphics g) {
                Graphics2D g2 = (Graphics2D) g.create();
                g2.scale(1, -1);
                g2.translate(0, -getHeight());
                super.paintComponent(g2);
                g2.dispose();
              }
            };
            progress7.setOrientation(SwingConstants.VERTICAL);
            progress7.setStringPainted(true);
</code></pre>
    - 右から`1`番目: `JLayer`で表示を上下反転した垂直スクロールバー
        - `JProgressBar#paintComponent(...)`をオーバーライドした場合と同様に進捗文字列も上下反転してしまう
        - [JProgressBarの文字列をJLayerを使って表示する](https://ateraimemo.com/Swing/ProgressStringLayer.html)のように、別の`JLabel`などで進捗文字列を描画すれば回避可能
- その他
    - 以下のようにノブやメモリを非表示、かつ操作不可に設定し、`JSlider#setInverted(true)`で描画を反転した、`JSlider`で代用する方法もある
        - [JSliderのスタイルを変更する](https://ateraimemo.com/Swing/GradientTrackSlider.html)
        - [MouseListenerなどを削除してコンポーネントの入力操作を制限する](https://ateraimemo.com/Swing/UninstallListeners.html)
        - [JSliderの順序を反転](https://ateraimemo.com/Swing/InvertedSlider.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Component#setComponentOrientation(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Component.html#setComponentOrientation-java.awt.ComponentOrientation-)
- [JSliderの順序を反転](https://ateraimemo.com/Swing/InvertedSlider.html)

<!-- dummy comment line for breaking list -->

## コメント

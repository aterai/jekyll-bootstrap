---
layout: post
category: swing
folder: RestartAnimatedGif
title: ImageIconのリソースを開放してAnimatedGifを最初から再生する
tags: [ImageIcon, Animation, AnimatedGif, JButton, JLabel]
author: aterai
pubdate: 2013-08-19T00:06:01+09:00
description: JButtonなどのコンポーネントに設定したAnimatedGifのリソースを一旦解放して最初から再生します。
image: https://lh4.googleusercontent.com/-qShu8SKEKus/UhDUybKOCYI/AAAAAAAAByg/QRDcWyIqcmU/s800/RestartAnimatedGif.png
comments: true
---
## 概要
`JButton`などのコンポーネントに設定した`AnimatedGif`のリソースを一旦解放して最初から再生します。[java - Animated ImageIcon as Button - Stack Overflow](https://stackoverflow.com/questions/18270701/animated-imageicon-as-button)を参考にしています。

{% download https://lh4.googleusercontent.com/-qShu8SKEKus/UhDUybKOCYI/AAAAAAAAByg/QRDcWyIqcmU/s800/RestartAnimatedGif.png %}

## サンプルコード
<pre class="prettyprint"><code>final ImageIcon animatedIcon = new ImageIcon(url);
JButton button = new JButton(icon9) {
  @Override protected void fireStateChanged() {
    ButtonModel m = getModel();
    if (isRolloverEnabled() &amp;&amp; m.isRollover()) {
      animatedIcon.getImage().flush();
    }
    super.fireStateChanged();
  };
};
</code></pre>

## 解説
上記のサンプルでは、`Image#flush()`メソッドを使用して`Image`オブジェクトのリソースを解放することで、`Animated GIF`画像のアニメーションを初期状態までリセットしています。

- 左: `JButton`
    - `JButton#setRolloverIcon(...)`で`Animated GIF`を設定し、マウスによるロールオーバーが発生すると`Image#flush()`が実行され、カウントダウンアニメーションが最初からリスタート
    - `JButton#setIcon(...)`には先頭画像のアイコン、`JButton#setPressedIcon(...)`には、空アイコンを設定
- 右: `JLabel`
    - マウスリスナーを追加し、クリックで`Image#flush()`が呼ばれて、アニメーションが再開
    - `JButton`で、`Image#flush()`されると、同じ`Image`オブジェクトを使用しているのでアニメーションが止まる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - Animated ImageIcon as Button - Stack Overflow](https://stackoverflow.com/questions/18270701/animated-imageicon-as-button)
- [Image#flush() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Image.html#flush--)

<!-- dummy comment line for breaking list -->

## コメント

---
layout: post
category: swing
folder: DisableAnimatedGif
title: JLabelに表示したAnimated Gifのアニメーションを停止する
tags: [JLabel, Animation, ImageIcon]
author: aterai
pubdate: 2013-02-25T00:50:43+09:00
description: JLabelに表示したAnimated Gifのアニメーションを停止します。
comments: true
---
## 概要
`JLabel`に表示した`Animated Gif`のアニメーションを停止します。

{% download https://lh6.googleusercontent.com/-pYT15pLG7KY/USoyuJzLxUI/AAAAAAAABfo/JgO7-MbsL5U/s800/DisableAnimatedGif.png %}

## サンプルコード
<pre class="prettyprint"><code>JLabel label2 = new JLabel() {
  @Override public boolean imageUpdate(Image img, int infoflags, int x, int y, int w, int h) {
    if(!isEnabled()) {
      infoflags &amp;= ~FRAMEBITS;
    }
    return super.imageUpdate(img, infoflags, x, y, w, h);
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JLabel`が`Enabled`でない場合にアニメーションを停止するよう設定しています。

- `Default`
    - デフォルトの`JLabel`では、`JLabel#setEnabled(false);`としてもアニメーションは停止しない
- `Override imageUpdate(...)`
    - `JLabel#imageUpdate(...)`の`infoflags`から`FRAMEBITS`フラグを落とすことでアニメーションを停止
    - `JLabel`がリサイズされると？、コマが進んでしまう
- `setDisabledIcon`
    - 別途用意した静止画像を使って、`JLabel#setDisabledIcon(...)`を設定
    - `GrayFilter.createDisabledImage(Image)`でアイコンをグレースケール化

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Duke Images: iconSized](http://duke.kenai.com/iconSized/index.html)
- [ImageObserver (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/java/awt/image/ImageObserver.html)
- [ColorConvertOpで画像をグレースケールに変換](http://ateraimemo.com/Swing/ColorConvertOp.html)
- [Animated Gifからフレーム画像を抽出する](http://ateraimemo.com/Swing/ExtractFramesFromAnimatedGif.html)

<!-- dummy comment line for breaking list -->

## コメント

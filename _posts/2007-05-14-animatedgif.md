---
layout: post
category: swing
folder: AnimatedGif
title: Animated GIFでのコマ描画時処理
tags: [JLabel, Animation, AnimatedGif]
author: aterai
pubdate: 2007-05-14T19:32:29+09:00
description: JLabelなどで使用できるAnimated GIFファイルをテストします。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTHnR-lE1I/AAAAAAAAARc/gDDOKXhD7hQ/s800/AnimatedGif.png
comments: true
---
## 概要
`JLabel`などで使用できる`Animated GIF`ファイルをテストします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTHnR-lE1I/AAAAAAAAARc/gDDOKXhD7hQ/s800/AnimatedGif.png %}

## サンプルコード
<pre class="prettyprint"><code>JLabel label1 = new JLabel("何もしない",
  new ImageIcon(getClass().getResource("no_disposal_specified.gif")),
  SwingConstants.LEFT);
JLabel label2 = new JLabel("そのまま残す",
  new ImageIcon(getClass().getResource("do_not_dispose.gif")),
  SwingConstants.LEFT);
JLabel label3 = new JLabel("背景色で塗りつぶす",
  new ImageIcon(getClass().getResource("restore_to_background_color.gif")),
  SwingConstants.LEFT);
JLabel label4 = new JLabel("直前の画像に戻す",
  new ImageIcon(getClass().getResource("restore_to_previous.gif")),
  SwingConstants.LEFT);
</code></pre>

## 解説
`Animated GIF`で、次のコマを描画する時、直前の画像を異なる方法で消去する`Animated GIF`ファイルを作成し、これらを`JLabel`に貼り付けてアニメーションをテストしています。上記のように透過色を使用する場合、`Swing`では、`3`番目の「背景色で塗りつぶす」にしておかないと残像が出てしまうようです。

- 何もしない

<!-- dummy comment line for breaking list -->
<blockquote><p>
 No disposal specified. The decoder is not required to take any action.
</p></blockquote>

- そのまま残す

<!-- dummy comment line for breaking list -->
<blockquote><p>
 Do not dispose. The graphic is to be left in place.
</p></blockquote>

- 背景色で塗りつぶす

<!-- dummy comment line for breaking list -->
<blockquote><p>
 Restore to background color. The area used by the graphic must be restored to the background color.
</p></blockquote>

- 直前の画像に戻す

<!-- dummy comment line for breaking list -->
<blockquote><p>
 Restore to previous. The decoder is required to restore the area overwritten by the graphic with what was there prior to rendering the graphic.
</p></blockquote>

## 参考リンク
- [Cover Sheet for the GIF89a Specification](http://www.w3.org/Graphics/GIF/spec-gif89a.txt)
    - 「`23. Graphic Control Extension.`」の、「`iv) Disposal Method`」から説明を引用
- [Giam ダウンロードのページ](http://homepage3.nifty.com/furumizo/giamd.htm)
    - `Giam`を使って、各`Animated GIF`を生成

<!-- dummy comment line for breaking list -->

## コメント
- `Swing`のバージョンを入れておいてもらえますか？現バージョンでも背景色でつぶすにしないと残像が残るんでしょうか？ -- *とおりすがり* 2009-05-14 (木) 19:32:37
    - `Windows XP`で現バージョン(`1.5.0_18`, `1.6.0_14`, `1.7.0`)を実行してみましたが、同様だと思います。 -- *aterai* 2009-05-14 (木) 21:14:04

<!-- dummy comment line for breaking list -->

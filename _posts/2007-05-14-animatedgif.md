---
layout: post
title: Animated GIFでのコマ描画時処理
category: swing
folder: AnimatedGif
tags: [JLabel, Animation]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-05-14

## Animated GIFでのコマ描画時処理
`JLabel`などで使用できる`Animated GIF`ファイルをテストします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTHnR-lE1I/AAAAAAAAARc/gDDOKXhD7hQ/s800/AnimatedGif.png)

### サンプルコード
<pre class="prettyprint"><code>JLabel label1 = new JLabel("何もしない　　　",
  new ImageIcon(getClass().getResource("no_disposal_specified.gif")),
  JLabel.LEFT);
JLabel label2 = new JLabel("そのまま残す　　",
  new ImageIcon(getClass().getResource("do_not_dispose.gif")),
  JLabel.LEFT);
JLabel label3 = new JLabel("背景色でつぶす　",
  new ImageIcon(getClass().getResource("restore_to_background_color.gif")),
  JLabel.LEFT);
JLabel label4 = new JLabel("直前の画像に戻す",
  new ImageIcon(getClass().getResource("restore_to_previous.gif")),
  JLabel.LEFT);
</code></pre>

### 解説
`Animated GIF`で、次のコマを描画する時、直前の画像を異なる方法で消去する`Animated GIF`ファイルを作成し、これらを`JLabel`に貼り付けてアニメーションをテストしています。上記のように透過色を使用する場合、`Swing`では、`3`番目の「背景色でつぶす」にしておかないと残像が出てしまうようです。

- 何もしない
    - No disposal specified. The decoder is not required to take any action.
- そのまま残す
    - Do not dispose. The graphic is to be left in place.
- 背景色でつぶす
    - Restore to background color. The area used by the graphic must be restored to the background color.
- 直前の画像に戻す
    - Restore to previous. The decoder is required to restore the area overwritten by the graphic with what was there prior to rendering the graphic.

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Cover Sheet for the GIF89a Specification](http://www.w3.org/Graphics/GIF/spec-gif89a.txt)
    - 23. Graphic Control Extension. の、iv) Disposal Method から説明を引用しています。
- [Giam ダウンロードのページ](http://homepage3.nifty.com/furumizo/giamd.htm)
    - `Giam`を使って、各`Animated GIF`を生成しています。

<!-- dummy comment line for breaking list -->

### コメント
- `Swing`のバージョンを入れておいてもらえますか？現バージョンでも背景色でつぶすにしないと残像が残るんでしょうか？ -- [とおりすがり](http://terai.xrea.jp/とおりすがり.html) 2009-05-14 (木) 19:32:37
    - `Windows XP`で現バージョン(`1.5.0_18`, `1.6.0_14`, `1.7.0`)を実行してみましたが、同様だと思います。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-05-14 (木) 21:14:04

<!-- dummy comment line for breaking list -->
